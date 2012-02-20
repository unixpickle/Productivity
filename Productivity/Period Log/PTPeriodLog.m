//
//  PTPeriodLog.m
//  Productivity
//
//  Created by Alex Nichol on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTPeriodLog.h"

@implementation PTPeriodLog

- (id)initWithLogFile:(NSString *)file {
    if ((self = [super init])) {
        observers = [[NSMutableArray alloc] init];
        operationLock = [[NSLock alloc] init];
        database = [[PTLogDatabase alloc] initWithFile:file error:nil];
        entries = [[database entryDescriptors] mutableCopy];
        rowCache = [[NSCache alloc] init];
        [rowCache setCountLimit:100];
    }
    return self;
}

- (void)addLogObserver:(id<PTPeriodLogObserver>)observer {
    PTLogObserver * info = [[PTLogObserver alloc] initWithObserver:observer];
    [observers addObject:info];
}

- (void)removeLogObserver:(id<PTPeriodLogObserver>)observer {
    for (NSUInteger i = 0; i < [observers count]; i++) {
        PTLogObserver * info = [observers objectAtIndex:i];
        if ([info.observer isEqual:observer]) {
            [observers removeObjectAtIndex:i];
            i--;
            continue;
        }
    }
}

#pragma mark - Database -

#pragma mark Retrieving

- (NSArray *)periodIDs {
    [operationLock lock];
    
    NSMutableArray * mPeriodIDs = [[NSMutableArray alloc] initWithCapacity:[entries count]];
    for (PTLogEntry * entry in entries) {
        NSUInteger entryID = entry.uniqueID;
        NSNumber * idObj = [NSNumber numberWithUnsignedInteger:entryID];
        [mPeriodIDs addObject:idObj];
    }
    
    [operationLock unlock];
    return [NSArray arrayWithArray:mPeriodIDs];
}

- (PTPeriod *)periodForID:(NSUInteger)integer {
    [operationLock lock];
    
    NSNumber * idObj = [NSNumber numberWithUnsignedInteger:integer];
    if ([rowCache objectForKey:idObj]) {
        id obj = [rowCache objectForKey:idObj];
        [operationLock unlock];
        return obj;
    }
    
    PTPeriod * period = [database periodForID:integer];
    if (!period) {
        [operationLock unlock];
        return nil;
    }
    [rowCache setObject:period forKey:idObj];
    
    [operationLock unlock];
    return period;
}

#pragma mark Mutating

- (void)addPeriod:(PTPeriod *)aPeriod {    
    [operationLock lock];
    
    NSUInteger epoch = (NSUInteger)[[aPeriod startDate] timeIntervalSince1970];
    NSUInteger addedID = [database insertPeriod:aPeriod];
    PTLogEntry * logEntry = [[PTLogEntry alloc] initWithID:addedID time:epoch];
    
    NSUInteger insertIndex = 0;
    for (NSUInteger i = 0; i < [entries count]; i++) {
        if ([[entries objectAtIndex:i] compareToEntry:logEntry] != NSOrderedDescending) {
            insertIndex = i + 1;
        }
    }
    
    [entries insertObject:logEntry atIndex:insertIndex];
    
    [operationLock unlock];
    
    for (PTLogObserver * observer in observers) {
        [observer notifyLog:self addedAtIndex:insertIndex];
    }
}

- (void)removePeriodWithID:(NSUInteger)periodID {
    [operationLock lock];
    
    NSNumber * idObj = [NSNumber numberWithUnsignedInteger:periodID];
    PTPeriod * removedPeriod = nil;
    if ([rowCache objectForKey:idObj]) {
        removedPeriod = [rowCache objectForKey:idObj];
        [rowCache removeObjectForKey:idObj];
    } else {
        removedPeriod = [database periodForID:periodID];
    }
    
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < [entries count]; i++) {
        PTLogEntry * entry = [entries objectAtIndex:i];
        if (entry.uniqueID == periodID) {
            index = i;
            break;
        }
    }
    
    [database removePeriodForID:periodID];
    [entries removeObjectAtIndex:index];
    
    [operationLock unlock];
    
    for (PTLogObserver * observer in observers) {
        [observer notifyLog:self removed:removedPeriod atIndex:index];
    }
}

@end

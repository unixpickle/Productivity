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
    NSMutableArray * mPeriodIDs = [[NSMutableArray alloc] initWithCapacity:[entries count]];
    for (PTLogEntry * entry in entries) {
        NSUInteger entryID = entry.uniqueID;
        NSNumber * idObj = [NSNumber numberWithUnsignedInteger:entryID];
        [mPeriodIDs addObject:idObj];
    }
    return [NSArray arrayWithArray:mPeriodIDs];
}

- (PTPeriod *)periodWithID:(NSUInteger)integer {
    NSNumber * idObj = [NSNumber numberWithUnsignedInteger:integer];
    if ([rowCache objectForKey:idObj]) {
        return [rowCache objectForKey:idObj];
    }
    
    PTPeriod * period = [database periodForID:integer];
    [rowCache setObject:period forKey:idObj];
    return period;
}

#pragma mark Mutating

- (void)addPeriod:(PTPeriod *)aPeriod {
    NSUInteger epoch = (NSUInteger)[[aPeriod startDate] timeIntervalSince1970];
    NSUInteger addedID = [database insertPeriod:aPeriod];
    
    PTLogEntry * logEntry = [[PTLogEntry alloc] initWithID:addedID time:epoch];
    // TODO: add this to the list more efficiently
    [entries addObject:logEntry];
    [entries sortUsingSelector:@selector(compare:)];
    NSUInteger index = [entries indexOfObject:logEntry];
    for (PTLogObserver * observer in observers) {
        [observer notifyLog:self addedAtIndex:index];
    }
}

- (void)removePeriodWithID:(NSUInteger)periodID {
    NSUInteger index = 0;
    NSNumber * idObj = [NSNumber numberWithUnsignedInteger:periodID];
    if ([rowCache objectForKey:idObj]) [rowCache removeObjectForKey:idObj];
    [database removePeriodForID:periodID];
    for (NSUInteger i = 0; i < [entries count]; i++) {
        PTLogEntry * entry = [entries objectAtIndex:i];
        if (entry.uniqueID == periodID) {
            index = i;
            [entries removeObjectAtIndex:i];
            break;
        }
    }
    for (PTLogObserver * observer in observers) {
        [observer notifyLog:self removedAtIndex:index];
    }
}

@end

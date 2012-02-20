//
//  PTStatManager.m
//  Productivity
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTStatManager.h"

@interface PTStatManager (Private)

- (void)processThread;
- (void)processPeriod:(PTPeriod *)aPeriod;
- (void)unprocessPeriod:(PTPeriod *)aPeriod;
- (void)addTime:(NSTimeInterval)time keys:(NSInteger)prod forState:(id<PTState>)state adding:(BOOL)adding;
- (void)informDelegateChange;

@end

@implementation PTStatManager

@synthesize periodLog;

- (id)initWithPeriodLog:(PTPeriodLog *)aLog {
    if ((self = [super init])) {
        periodLog = aLog;
        observers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startObserving {
    periodIDs = [[periodLog periodIDs] mutableCopy];
    pendingIDs = [periodIDs mutableCopy];
    statistics = [[NSMutableArray alloc] init];
    
    processThread = [[NSThread alloc] initWithTarget:self selector:@selector(processThread) object:nil];
    [processThread start];
    [periodLog addLogObserver:self];
}

- (void)stopObserving {
    [periodLog removeLogObserver:self];
    [processThread cancel];
    processThread = nil;
}

- (void)addStatObserver:(id<PTStatManagerObserver>)observer {
    [observers addObject:[[PTSMObserver alloc] initWithObserver:observer]];
}

- (void)removeStatObserver:(id<PTStatManagerObserver>)observer {
    for (NSUInteger i = 0; i < [observers count]; i++) {
        if ([(PTSMObserver *)[observers objectAtIndex:i] observer] == observer) {
            [observers removeObjectAtIndex:i];
            return;
        }
    }
}

- (NSArray *)statisticsWithStateID:(NSString *)aStateID {
    NSMutableArray * statArray = [[NSMutableArray alloc] init];
    @synchronized (statistics) {
        for (PTStatistic * stat in statistics) {
            NSString * statStateID = [[[stat state] class] stateID];
            if ([statStateID isEqualToString:aStateID]) {
                [statArray addObject:[stat copy]];
            }
        }
    }
    [statArray sortUsingSelector:@selector(invertedCompareToStatistic:)];
    return [NSArray arrayWithArray:statArray];
}

#pragma mark - Log Observer -

- (void)periodLog:(PTPeriodLog *)log addedPeriodAtIndex:(NSUInteger)index {
    periodIDs = [[log periodIDs] mutableCopy];
    NSNumber * periodID = [periodIDs objectAtIndex:index];
    @synchronized (pendingIDs) {
        [pendingIDs addObject:periodID];
    }
}

- (void)periodLog:(PTPeriodLog *)log removedPeriod:(PTPeriod *)period atIndex:(NSUInteger)index {
    NSNumber * periodID = [periodIDs objectAtIndex:index];
    periodIDs = [[log periodIDs] mutableCopy];
    @synchronized (pendingIDs) {
        if ([pendingIDs containsObject:periodID]) {
            [pendingIDs removeObject:periodID];
        } else {
            [self unprocessPeriod:period];
        }
    }
}
                     
#pragma mark - Private -

- (void)processThread {
    @autoreleasepool {
        while (true) {
            @synchronized (pendingIDs) {
                if ([pendingIDs count] > 0) {
                    NSNumber * idObj = [pendingIDs objectAtIndex:0];
                    [pendingIDs removeObjectAtIndex:0];
                    PTPeriod * period = [periodLog periodForID:[idObj unsignedIntegerValue]];
                    if (!period) {
                        [pendingIDs addObject:idObj];
                    } else {
                        [self processPeriod:period];
                    }
                }
            }
            
            [NSThread sleepForTimeInterval:0.05];
            if ([[NSThread currentThread] isCancelled]) return;
        }
    }
}

- (void)processPeriod:(PTPeriod *)aPeriod {
    NSTimeInterval liveTime = aPeriod.periodDuration - aPeriod.idleDuration;
    NSInteger liveKeys = aPeriod.totalProductivity - aPeriod.idleProductivity;
    for (id<PTState> state in aPeriod.states) {
        [self addTime:liveTime keys:liveKeys forState:state adding:YES];
    }
}

- (void)unprocessPeriod:(PTPeriod *)aPeriod {
    NSTimeInterval liveTime = aPeriod.periodDuration - aPeriod.idleDuration;
    NSInteger liveKeys = aPeriod.totalProductivity - aPeriod.idleProductivity;
    for (id<PTState> state in aPeriod.states) {
        [self addTime:-liveTime keys:-liveKeys forState:state adding:NO];
    }
}

- (void)addTime:(NSTimeInterval)time keys:(NSInteger)prod forState:(id<PTState>)state adding:(BOOL)adding {
    PTStatistic * statistic = nil;
    @synchronized (statistics) {
        for (PTStatistic * stat in statistics) {
            if ([stat.state isEqualToState:state]) {
                statistic = stat;
                break;
            }
        }
        
        if (!statistic && adding) {
            statistic = [[PTStatistic alloc] initWithState:state];
            [statistics addObject:statistic];
        } else if (!statistic && !adding) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Cannot remove a statistic that does not exist."
                                         userInfo:nil];
        }
        
        statistic.totalKeys += prod;
        statistic.totalTime += time;
        
        if (adding) statistic.stateCount += 1;
        else statistic.stateCount -= 1;
        
        if (statistic.stateCount == 0) {
            [statistics removeObject:statistic];
        }
    }
    [self informDelegateChange];
}

- (void)informDelegateChange {
    if (![[NSThread currentThread] isMainThread]) {
        [self performSelectorOnMainThread:@selector(informDelegateChange) withObject:nil waitUntilDone:NO];
        return;
    }
    for (PTSMObserver * observer in observers) {
        [observer notifyObserverUpdated:self];
    }
}

@end

//
//  PTStatObserver.m
//  Productivity
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTStatObserver.h"

@interface PTStatObserver (Private)

- (void)processThread;
- (void)processPeriod:(PTPeriod *)aPeriod;
- (void)unprocessPeriod:(PTPeriod *)aPeriod;
- (void)addTime:(NSTimeInterval)time keys:(NSInteger)prod forState:(id<PTState>)state;
- (void)informDelegateChange;

@end

@implementation PTStatObserver

@synthesize delegate;
@synthesize periodLog;

- (id)initWithPeriodLog:(PTPeriodLog *)aLog {
    if ((self = [super init])) {
        periodLog = aLog;
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
                        // throw it to the back of the pending period IDs,
                        // assuming that it was removed and will shortly
                        // be removed from the queue by the main thread...
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
        [self addTime:liveTime keys:liveKeys forState:state];
    }
}

- (void)unprocessPeriod:(PTPeriod *)aPeriod {
    NSTimeInterval liveTime = aPeriod.periodDuration - aPeriod.idleDuration;
    NSInteger liveKeys = aPeriod.totalProductivity - aPeriod.idleProductivity;
    for (id<PTState> state in aPeriod.states) {
        [self addTime:-liveTime keys:-liveKeys forState:state];
    }
}

- (void)addTime:(NSTimeInterval)time keys:(NSInteger)prod forState:(id<PTState>)state {
    PTStatistic * statistic = nil;
    @synchronized (statistics) {
        for (PTStatistic * stat in statistics) {
            if ([stat.state isEqualToState:state]) {
                statistic = state;
                break;
            }
        }
        if (!statistic) {
            statistic = [[PTStatistic alloc] initWithState:state];
            [statistics addObject:statistic];
        }
        statistic.totalKeys += prod;
        statistic.totalTime += time;
    }
    [self informDelegateChange];
}

- (void)informDelegateChange {
    if (![[NSThread currentThread] isMainThread]) {
        [self performSelectorOnMainThread:@selector(informDelegateChange) withObject:nil waitUntilDone:NO];
        return;
    }
    if ([delegate respondsToSelector:@selector(statObserverUpdatedStatistics:)]) {
        [delegate statObserverUpdatedStatistics:self];
    }
}

@end

//
//  PTSession.m
//  Productivity
//
//  Created by Alex Nichol on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTSession.h"

@interface PTSession (Private)

- (void)addPeriod:(PTPeriod *)period;

@end

@implementation PTSession

- (id)initWithStateObservers:(NSArray *)observers {
    if ((self = [super init])) {
        keyboardMonitor = [[PTKeyboardMonitor alloc] init];
        periods = [[NSMutableArray alloc] init];
        stateObservers = observers;
        idle = NO;
        
        [keyboardMonitor setDelegate:self];
        for (id<PTStateObserver> observer in observers) {
            [observer setDelegate:self];
        }
    }
    return self;
}

- (PTPeriod *)currentPeriod {
    if ([periods count] == 0) return nil;
    return [periods lastObject];
}

- (void)beginSession {
    for (id<PTStateObserver> observer in stateObservers) {
        [observer startObserving];
    }
    PTPeriod * newPeriod = [[PTPeriod alloc] initWithStateObservers:stateObservers];
    [self addPeriod:newPeriod];
    [keyboardMonitor startMonitoring];
}

- (void)endSession {
    for (id<PTStateObserver> observer in stateObservers) {
        [observer stopObserving];
    }
    [self addPeriod:nil];
    [keyboardMonitor stopMonitoring];
}

#pragma mark - Period Management -

#pragma mark Idle Management

- (BOOL)isIdle {
    return idle;
}

- (void)setIdle:(BOOL)flag {
    if (idle == flag) return;
    
    NSDate * now = [NSDate date];
    NSTimeInterval sinceLast = [now timeIntervalSinceDate:lastUpdate];
    [self currentPeriod].periodDuration += sinceLast;
    if (idle) [self currentPeriod].idleDuration += sinceLast;
    lastUpdate = now;
    
    idle = flag;
}

#pragma mark New Periods

- (void)addPeriod:(PTPeriod *)period {
    NSDate * now = [NSDate date];
    NSTimeInterval sinceLast = [now timeIntervalSinceDate:lastUpdate];
    [self currentPeriod].periodDuration += sinceLast;
    if (idle) [self currentPeriod].idleDuration += sinceLast;
    lastUpdate = now;
    
    if (period) [periods addObject:period];
}

- (void)stateObserverChangedState:(id)sender {
    PTPeriod * newPeriod = [[PTPeriod alloc] initWithStateObservers:stateObservers];
    [self addPeriod:newPeriod];
}

#pragma mark Productivity Input

- (void)keyboardMonitor:(PTKeyboardMonitor *)monitor keyDown:(NSUInteger)keyCode {
    if (![self currentPeriod]) return;
    [self currentPeriod].totalProductivity += 1;
    if (idle) [self currentPeriod].idleProductivity += 1;
}

@end

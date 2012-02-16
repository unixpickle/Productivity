//
//  PTPeriodManager.m
//  Productivity
//
//  Created by Alex Nichol on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTPeriodManager.h"

@implementation PTPeriodManager

@synthesize delegate;
@synthesize currentPeriod;

- (id)initWithStateObservers:(NSArray *)observers {
    if ((self = [super init])) {
        stateObservers = observers;
        for (PTStateObserver * observer in observers) {
            [observer setDelegate:self];
        }
    }
    return self;
}

- (void)stateObserverStateChanged:(PTStateObserver *)sender {
    // TODO: post old period, create new one and replace the state
    NSArray * oldStates = [currentPeriod states];
}

- (void)beginManaging {
    
}

- (void)setPaused:(BOOL)flag {
    
}

@end

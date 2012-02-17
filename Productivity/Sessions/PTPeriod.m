//
//  PTPeriod.m
//  Productivity
//
//  Created by Alex Nichol on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTPeriod.h"

@implementation PTPeriod

@synthesize states;
@synthesize periodDuration;
@synthesize idleDuration;
@synthesize totalProductivity;
@synthesize idleProductivity;

- (id)initWithStateObservers:(NSArray *)observers {
    if ((self = [super init])) {
        NSMutableArray * mStates = [[NSMutableArray alloc] init];
        for (id<PTStateObserver> observer in observers) {
            [mStates addObject:[observer state]];
        }
        states = [[NSArray alloc] initWithArray:mStates];
    }
    return self;
}

@end

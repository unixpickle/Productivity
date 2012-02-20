//
//  PTStatistic.m
//  Productivity
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTStatistic.h"

@implementation PTStatistic

@synthesize state;
@synthesize totalKeys;
@synthesize totalTime;
@synthesize stateCount;

- (id)initWithState:(id<PTState>)aState {
    if ((self = [super init])) {
        state = aState;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    PTStatistic * stat = [[PTStatistic allocWithZone:zone] initWithState:state];
    stat.totalKeys = self.totalKeys;
    stat.totalTime = self.totalTime;
    return stat;
}

@end

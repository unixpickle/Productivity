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

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        states = [aDecoder decodeObjectForKey:@"states"];
        periodDuration = [aDecoder decodeDoubleForKey:@"duration"];
        idleDuration = [aDecoder decodeDoubleForKey:@"idleDuration"];
        totalProductivity = [aDecoder decodeIntegerForKey:@"productivity"];
        idleProductivity = [aDecoder decodeIntegerForKey:@"idleProductivity"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:states forKey:@"states"];
    [aCoder encodeDouble:periodDuration forKey:@"duration"];
    [aCoder encodeDouble:idleDuration forKey:@"idleDuration"];
    [aCoder encodeInteger:totalProductivity forKey:@"productivity"];
    [aCoder encodeInteger:idleProductivity forKey:@"idleProductivity"];
}

@end

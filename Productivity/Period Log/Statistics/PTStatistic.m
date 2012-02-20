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

- (double)keyRate {
    if (totalKeys == 0 || totalTime == 0) {
        return 0;
    } else {
        return totalKeys / totalTime;
    }
}

- (NSComparisonResult)compareToStatistic:(PTStatistic *)statistic {
    NSNumber * myNumber = [NSNumber numberWithDouble:[self keyRate]];
    NSNumber * aNumber = [NSNumber numberWithDouble:[statistic keyRate]];
    return [myNumber compare:aNumber];
}

- (NSComparisonResult)invertedCompareToStatistic:(PTStatistic *)statistic {
    return [statistic compareToStatistic:self];
}

- (id)copyWithZone:(NSZone *)zone {
    PTStatistic * stat = [[PTStatistic allocWithZone:zone] initWithState:state];
    stat.totalKeys = self.totalKeys;
    stat.totalTime = self.totalTime;
    return stat;
}

@end

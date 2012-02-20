//
//  PTLogObserver.m
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTLogObserver.h"

@implementation PTLogObserver

@synthesize observer;

- (id)initWithObserver:(id<PTPeriodLogObserver>)anObserver {
    if ((self = [super init])) {
        observer = anObserver;
    }
    return self;
}

- (void)notifyLog:(PTPeriodLog *)log removed:(PTPeriod *)period atIndex:(NSUInteger)index {
    if ([observer respondsToSelector:@selector(periodLog:removedPeriod:atIndex:)]) {
        [observer periodLog:log removedPeriod:period atIndex:index];
    }
}

- (void)notifyLog:(PTPeriodLog *)log addedAtIndex:(NSUInteger)index {
    if ([observer respondsToSelector:@selector(periodLog:addedPeriodAtIndex:)]) {
        [observer periodLog:log addedPeriodAtIndex:index];
    }
}

@end

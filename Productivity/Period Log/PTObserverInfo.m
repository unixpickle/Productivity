//
//  PTObserverInfo.m
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTObserverInfo.h"

@implementation PTObserverInfo

@synthesize observer;

- (id)initWithObserver:(id<PTPeriodLogObserver>)anObserver {
    if ((self = [super init])) {
        observer = anObserver;
    }
    return self;
}

- (void)notifyLog:(PTPeriodLog *)log removedAtIndex:(NSUInteger)index {
    if ([observer respondsToSelector:@selector(periodLog:removedPeriodAtIndex:)]) {
        [observer periodLog:log removedPeriodAtIndex:index];
    }
}

- (void)notifyLog:(PTPeriodLog *)log addedAtIndex:(NSUInteger)index {
    if ([observer respondsToSelector:@selector(periodLog:addedPeriodAtIndex:)]) {
        [observer periodLog:log addedPeriodAtIndex:index];
    }
}

@end

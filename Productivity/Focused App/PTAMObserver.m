//
//  PTAMObserver.m
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTAMObserver.h"

@implementation PTAMObserver

@synthesize observer;

- (id)initWithObserver:(id<PTAppMonitorObserver>)anObserver {
    if ((self = [super init])) {
        observer = anObserver;
    }
    return self;
}

- (void)notifyMonitor:(PTAppMonitor *)monitor appFocused:(NSUInteger)index {
    if ([observer respondsToSelector:@selector(appMonitor:appFocused:)]) {
        [observer appMonitor:monitor appFocused:index];
    }
}

- (void)notifyMonitor:(PTAppMonitor *)monitor appAdded:(NSUInteger)index {
    if ([observer respondsToSelector:@selector(appMonitor:appAdded:)]) {
        [observer appMonitor:monitor appAdded:index];
    }
}

- (void)notifyMonitor:(PTAppMonitor *)monitor enableChanged:(NSUInteger)index {
    if ([observer respondsToSelector:@selector(appMonitor:enableChanged:)]) {
        [observer appMonitor:monitor enableChanged:index];
    }
}

@end

//
//  PTSMObserver.m
//  Productivity
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTSMObserver.h"

@implementation PTSMObserver

@synthesize observer;

- (id)initWithObserver:(id<PTStatManagerObserver>)anObserver {
    if ((self = [super init])) {
        observer = anObserver;
    }
    return self;
}

- (void)notifyObserverUpdated:(PTStatManager *)sender {
    if ([observer respondsToSelector:@selector(statManagerUpdatedStatistics:)]) {
        [observer statManagerUpdatedStatistics:sender];
    }
}

@end

//
//  PTController.m
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTController.h"

@implementation PTController

@synthesize currentSession;
@synthesize periodLog;
@synthesize appMonitor;
@synthesize sessionStart;
@synthesize stateObservers;

- (id)initWithLogFile:(NSString *)logFile {
    if ((self = [super init])) {
        stateObservers = [[NSMutableArray alloc] init];
        periodLog = [[PTPeriodLog alloc] initWithLogFile:logFile];
        appMonitor = [[PTAppMonitor alloc] init];
        if (!periodLog) return nil;
        
        PTMusicObserver * musicObserver = [[PTMusicObserver alloc] init];
        [stateObservers addObject:musicObserver];
    }
    return self;
}

- (void)beginSession {
    if (currentSession) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Session already running."
                                     userInfo:nil];
    }
    
    [appMonitor addMonitorObserver:self];
    sessionIdle = ![appMonitor enabledForFrontmostApplication];
    [appMonitor startObserving];
    
    sessionStart = [NSDate date];
    NSArray * observers = [NSArray arrayWithArray:stateObservers];
    currentSession = [[PTSession alloc] initWithStateObservers:observers];
    [currentSession setDelegate:self];
    [currentSession beginSession];
    [currentSession setIdle:sessionIdle];
}

- (void)endSession {
    if (!currentSession) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Session not running."
                                     userInfo:nil];
    }
    
    [appMonitor removeMonitorObserver:self];
    [appMonitor stopObserving];
    
    [currentSession endSession];
    currentSession = nil;
    sessionStart = nil;
}

#pragma mark - Session Delegate -

- (void)session:(PTSession *)session finishedPeriod:(PTPeriod *)aPeriod {
    [periodLog addPeriod:aPeriod];
}

#pragma mark - App Monitor -

- (void)appMonitor:(PTAppMonitor *)monitor appFocused:(NSUInteger)index {
    sessionIdle = ![monitor enabledForFrontmostApplication];
    [currentSession setIdle:sessionIdle];
}

- (void)appMonitor:(PTAppMonitor *)monitor enableChanged:(NSUInteger)index {
    sessionIdle = ![appMonitor enabledForFrontmostApplication];
    [currentSession setIdle:sessionIdle];
}

@end

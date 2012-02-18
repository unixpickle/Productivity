//
//  PTSession.h
//  Productivity
//
//  Created by Alex Nichol on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTPeriod.h"
#import "PTKeyboardMonitor.h"

@class PTSession;

@protocol PTSessionDelegate <NSObject>

@optional
- (void)session:(PTSession *)session finishedPeriod:(PTPeriod *)aPeriod;

@end

@interface PTSession : NSObject <PTStateObserverDelegate, PTKeyboardMonitorDelegate> {
    NSArray * stateObservers;
    NSMutableArray * periods;
    
    PTKeyboardMonitor * keyboardMonitor;
    NSDate * lastUpdate;
    BOOL idle;
    
    __weak id<PTSessionDelegate> delegate;
}

@property (readwrite, getter = isIdle) BOOL idle;
@property (nonatomic, weak) id<PTSessionDelegate> delegate;

- (id)initWithStateObservers:(NSArray *)observers;
- (PTPeriod *)currentPeriod;

- (void)beginSession;
- (void)endSession;

@end

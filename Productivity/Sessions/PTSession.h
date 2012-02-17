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

@interface PTSession : NSObject <PTStateObserverDelegate, PTKeyboardMonitorDelegate> {
    NSArray * stateObservers;
    NSMutableArray * periods;
    
    PTKeyboardMonitor * keyboardMonitor;
    NSDate * lastUpdate;
    BOOL idle;
}

@property (readwrite, getter = isIdle) BOOL idle;

- (id)initWithStateObservers:(NSArray *)observers;
- (PTPeriod *)currentPeriod;

- (void)beginSession;
- (void)endSession;

@end

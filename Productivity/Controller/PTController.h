//
//  PTController.h
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTSession.h"
#import "PTAppMonitor.h"
#import "PTPeriodLog.h"
#import "PTStatObserver.h"
#import "PTMusicObserver.h"

@interface PTController : NSObject <PTSessionDelegate, PTAppMonitorObserver> {
    PTSession * currentSession;
    PTPeriodLog * periodLog;
    PTAppMonitor * appMonitor;
    PTStatObserver * statObserver;
    
    NSDate * sessionStart;
    NSMutableArray * stateObservers;
    BOOL sessionIdle;
}

@property (readonly) PTSession * currentSession;
@property (readonly) PTPeriodLog * periodLog;
@property (readonly) PTAppMonitor * appMonitor;
@property (readonly) PTStatObserver * statObserver;
@property (readonly) NSDate * sessionStart;
@property (readonly) NSMutableArray * stateObservers;

- (id)initWithLogFile:(NSString *)logFile;
- (void)beginSession;
- (void)endSession;

@end

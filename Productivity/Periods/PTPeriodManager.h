//
//  PTPeriodManager.h
//  Productivity
//
//  Created by Alex Nichol on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTPeriod.h"
#import "PTStateObserver.h"

@class PTPeriodManager;

@protocol PTPeriodManagerDelegate <NSObject>

@optional
- (void)periodManager:(PTPeriodManager *)manager periodEnded:(PTPeriod *)period;

@end

@interface PTPeriodManager : NSObject <PTStateObserverDelegate> {
    PTPeriod * currentPeriod;
    NSArray * stateObservers;
    
    BOOL paused;
    NSDate * pauseStart;
    
    __weak id<PTPeriodManagerDelegate> delegate;
}

@property (readonly) PTPeriod * currentPeriod;
@property (nonatomic, weak) id<PTPeriodManagerDelegate> delegate;

- (id)initWithStateObservers:(NSArray *)observers;

- (void)beginManaging;
- (void)setPaused:(BOOL)flag;

@end

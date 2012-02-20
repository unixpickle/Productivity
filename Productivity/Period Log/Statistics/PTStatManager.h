//
//  PTStatManager.h
//  Productivity
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTPeriodLog.h"
#import "PTStatistic.h"
#import "PTSMObserver.h"

@interface PTStatManager : NSObject <PTPeriodLogObserver> {
    NSMutableArray * statistics;
    NSMutableArray * pendingIDs;
    NSMutableArray * periodIDs;
    
    NSMutableArray * observers;
    
    __weak PTPeriodLog * periodLog;
    NSThread * processThread;
}

@property (readonly) PTPeriodLog * periodLog;

- (id)initWithPeriodLog:(PTPeriodLog *)aLog;
- (void)startObserving;
- (void)stopObserving;

- (void)addStatObserver:(id<PTStatManagerObserver>)observer;
- (void)removeStatObserver:(id<PTStatManagerObserver>)observer;

- (NSArray *)statisticsWithStateID:(NSString *)aStateID;

@end

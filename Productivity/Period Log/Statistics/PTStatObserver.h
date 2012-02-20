//
//  PTStatObserver.h
//  Productivity
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTPeriodLog.h"
#import "PTStatistic.h"

@class PTStatObserver;

@protocol PTStatObserverDelegate <NSObject>

@optional
- (void)statObserverUpdatedStatistics:(PTStatObserver *)observer;

@end

@interface PTStatObserver : NSObject <PTPeriodLogObserver> {
    NSMutableArray * statistics;
    NSMutableArray * pendingIDs;
    NSMutableArray * periodIDs;
    
    __weak PTPeriodLog * periodLog;
    NSThread * processThread;
    __weak id<PTStatObserverDelegate> delegate;
}

@property (nonatomic, weak) id<PTStatObserverDelegate> delegate;
@property (readonly) PTPeriodLog * periodLog;

- (id)initWithPeriodLog:(PTPeriodLog *)aLog;
- (void)startObserving;
- (void)stopObserving;

- (NSArray *)statisticsWithStateID:(NSString *)aStateID;

@end

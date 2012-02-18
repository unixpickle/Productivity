//
//  PTPeriodLog.h
//  Productivity
//
//  Created by Alex Nichol on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTLogDatabase.h"
#import "PTObserverInfo.h"

@interface PTPeriodLog : NSObject {
    NSCache * rowCache;
    NSMutableArray * entries;
    PTLogDatabase * database;
    NSMutableArray * observers;
}

- (id)initWithLogFile:(NSString *)file;

- (void)addLogObserver:(id<PTPeriodLogObserver>)observer;
- (void)removeLogObserver:(id<PTPeriodLogObserver>)observer;

- (NSArray *)periodIDs;
- (PTPeriod *)periodWithID:(NSUInteger)integer;
- (void)addPeriod:(PTPeriod *)aPeriod;
- (void)removePeriodWithID:(NSUInteger)periodID;

@end

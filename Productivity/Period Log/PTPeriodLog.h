//
//  PTPeriodLog.h
//  Productivity
//
//  Created by Alex Nichol on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTLogDatabase.h"
#import "PTLogObserver.h"

@interface PTPeriodLog : NSObject {
    NSCache * rowCache;
    NSMutableArray * entries;
    PTLogDatabase * database;
    NSMutableArray * observers;
    NSLock * operationLock;
}

- (id)initWithLogFile:(NSString *)file;

- (void)addLogObserver:(id<PTPeriodLogObserver>)observer;
- (void)removeLogObserver:(id<PTPeriodLogObserver>)observer;

- (NSArray *)periodIDs;
- (PTPeriod *)periodForID:(NSUInteger)integer;
- (void)addPeriod:(PTPeriod *)aPeriod;
- (void)removePeriodWithID:(NSUInteger)periodID;

@end

//
//  PTPeriodLog.h
//  Productivity
//
//  Created by Alex Nichol on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTLogDatabase.h"

@interface PTPeriodLog : NSObject {
    NSCache * rowCache;
    NSMutableArray * entries;
    PTLogDatabase * database;
}

- (id)initWithLogFile:(NSString *)file;

- (NSArray *)periodIDs;
- (PTPeriod *)periodWithID:(NSUInteger)integer;
- (void)addPeriod:(PTPeriod *)aPeriod;
- (void)removePeriodWithID:(NSUInteger)periodID;

@end

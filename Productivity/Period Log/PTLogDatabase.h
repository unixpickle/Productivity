//
//  PTLogDatabase.h
//  Productivity
//
//  Created by Alex Nichol on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTLogEntry.h"
#import "PTPeriod.h"
#include <sqlite3.h>

@interface PTLogDatabase : NSObject {
    sqlite3 * database;
}

- (id)initWithFile:(NSString *)databaseFile error:(NSError **)error;
- (void)close;

- (NSArray *)entryDescriptors;
- (PTPeriod *)periodForID:(NSUInteger)periodID;
- (NSUInteger)insertPeriod:(PTPeriod *)aPeriod;
- (void)removePeriodForID:(NSUInteger)periodID;

@end

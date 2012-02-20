//
//  PTLogDatabase.m
//  Productivity
//
//  Created by Alex Nichol on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTLogDatabase.h"

@interface PTLogDatabase (Private)

- (sqlite3_stmt *)prepareStatement:(NSString *)query;
- (NSError *)errorWithResult:(int)result;
- (NSException *)exceptionWithResult:(int)result;

@end

@implementation PTLogDatabase

- (id)initWithFile:(NSString *)databaseFile error:(NSError **)error {
    if ((self = [super init])) {
        int result = sqlite3_open([databaseFile UTF8String], &database);
        if (result != SQLITE_OK) {
            if (error) *error = [self errorWithResult:result];
            return nil;
        }
        
        const char * createQuery = "CREATE TABLE IF NOT EXISTS periods (id INTEGER NOT NULL, creation INTEGER NOT NULL, period BLOB NOT NULL, PRIMARY KEY (id), UNIQUE (id))";
        result = sqlite3_exec(database, createQuery, NULL, NULL, NULL);
        if (result != SQLITE_OK) {
            if (error) *error = [self errorWithResult:result];
            return nil;
        }
    }
    return self;
}

- (void)close {
    sqlite3_close(database);
    database = NULL;
}

- (NSArray *)entryDescriptors {
    NSMutableArray * mResult = [[NSMutableArray alloc] init];
    
    NSString * query = @"SELECT id, creation FROM periods ORDER BY creation ASC";
    sqlite3_stmt * statement = [self prepareStatement:query];
    while (sqlite3_step(statement) == SQLITE_ROW) {
        sqlite3_int64 uniqueID = sqlite3_column_int64(statement, 0);
        sqlite3_int64 creation = sqlite3_column_int64(statement, 1);
        PTLogEntry * entry = [[PTLogEntry alloc] initWithID:(NSUInteger)uniqueID
                                                       time:(NSUInteger)creation];
        [mResult addObject:entry];
    }
    sqlite3_finalize(statement);
    
    return [NSArray arrayWithArray:mResult];
}

- (PTPeriod *)periodForID:(NSUInteger)periodID {
    NSString * query = @"SELECT (period) FROM periods WHERE (id=?)";
    sqlite3_stmt * statement = [self prepareStatement:query];
    int result = sqlite3_bind_int64(statement, 1, (sqlite3_int64)periodID);
    if (result != SQLITE_OK) {
        @throw [self exceptionWithResult:result];
    }
    
    result = sqlite3_step(statement);
    if (result != SQLITE_ROW) {
        sqlite3_finalize(statement);
        if (result != SQLITE_DONE) {
            @throw [self exceptionWithResult:result];
        }
        return nil;
    }
    
    const void * periodBlob = sqlite3_column_blob(statement, 0);
    int length = sqlite3_column_bytes(statement, 0);
    NSData * data = [NSData dataWithBytes:periodBlob length:length];

    sqlite3_finalize(statement);
    
    PTPeriod * period = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return period;
}

- (NSUInteger)insertPeriod:(PTPeriod *)aPeriod {
    NSTimeInterval epoch = [[aPeriod startDate] timeIntervalSince1970];
    NSData * encoded = [NSKeyedArchiver archivedDataWithRootObject:aPeriod];
    NSString * query = @"INSERT INTO periods (creation, period) VALUES (?, ?)";
    sqlite3_stmt * statement = [self prepareStatement:query];
    
    int result = sqlite3_bind_int64(statement, 1, (sqlite3_int64)epoch);
    if (result != SQLITE_OK) {
        sqlite3_finalize(statement);
        @throw [self exceptionWithResult:result];
    }
    
    result = sqlite3_bind_blob(statement, 2, [encoded bytes], (int)[encoded length], SQLITE_TRANSIENT);
    if (result != SQLITE_OK) {
        sqlite3_finalize(statement);
        @throw [self exceptionWithResult:result];
    }
    
    result = sqlite3_step(statement);
    if (result != SQLITE_DONE) {
        sqlite3_finalize(statement);
        @throw [self exceptionWithResult:result];
    }
    
    sqlite3_finalize(statement);
    return (NSUInteger)sqlite3_last_insert_rowid(database);
}

- (void)removePeriodForID:(NSUInteger)periodID {
    NSString * query = @"DELETE FROM periods WHERE (id=?)";
    sqlite3_stmt * statement = [self prepareStatement:query];
    
    int result = sqlite3_bind_int64(statement, 1, (sqlite3_int64)periodID);
    if (result != SQLITE_OK) {
        sqlite3_finalize(statement);
        @throw [self exceptionWithResult:result];
    }
    
    result = sqlite3_step(statement);
    if (result == SQLITE_ERROR) {
        sqlite3_finalize(statement);
        @throw [self exceptionWithResult:result];
    }
    
    sqlite3_finalize(statement);
}

- (void)dealloc {
    if (database) [self close];
}

#pragma mark - Private -

- (sqlite3_stmt *)prepareStatement:(NSString *)query {
    sqlite3_stmt * statement = NULL;
    int result = sqlite3_prepare(database, [query UTF8String], (int)[query length], &statement, NULL);
    if (result != SQLITE_OK) {
        if (statement) sqlite3_finalize(statement);
        @throw [self exceptionWithResult:result];
    }
    return statement;
}

- (NSError *)errorWithResult:(int)result {
    NSString * errorMsg = nil;
    NSDictionary * userInfo = nil;
    if (database) {
        const char * msgStr = sqlite3_errmsg(database);
        errorMsg = [NSString stringWithUTF8String:msgStr];
        sqlite3_close(database);
    }
    if (errorMsg) {
        userInfo = [NSDictionary dictionaryWithObject:errorMsg
                                               forKey:NSLocalizedDescriptionKey];
    }
    return [NSError errorWithDomain:@"SQLite3" code:result userInfo:userInfo];
}

- (NSException *)exceptionWithResult:(int)result {
    NSString * errorMsg = nil;
    NSDictionary * userInfo = nil;
    if (database) {
        const char * msgStr = sqlite3_errmsg(database);
        errorMsg = [NSString stringWithUTF8String:msgStr];
        sqlite3_close(database);
    }
    userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:result]
                                           forKey:@"Code"];
    
    return [NSException exceptionWithName:@"SQLite3"
                                   reason:errorMsg
                                 userInfo:userInfo];
}

@end

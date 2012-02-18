//
//  PTLogEntry.m
//  Productivity
//
//  Created by Alex Nichol on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTLogEntry.h"

@implementation PTLogEntry

@synthesize uniqueID;
@synthesize timestamp;

- (id)initWithID:(NSUInteger)anID time:(NSUInteger)time {
    if ((self = [super init])) {
        uniqueID = anID;
        timestamp = time;
    }
    return self;
}

- (NSComparisonResult)compare:(PTLogEntry *)entry {
    if ([entry timestamp] > timestamp) return NSOrderedAscending;
    else if ([entry timestamp] < timestamp) return NSOrderedDescending;
    return NSOrderedSame;
}

@end

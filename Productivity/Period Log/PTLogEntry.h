//
//  PTLogEntry.h
//  Productivity
//
//  Created by Alex Nichol on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTLogEntry : NSObject {
    NSUInteger uniqueID;
    NSUInteger timestamp;
}

@property (readonly) NSUInteger uniqueID;
@property (readonly) NSUInteger timestamp;

- (id)initWithID:(NSUInteger)anID time:(NSUInteger)time;
- (NSComparisonResult)compareToEntry:(PTLogEntry *)entry;

@end

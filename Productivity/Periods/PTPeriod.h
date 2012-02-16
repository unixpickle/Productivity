//
//  PTPeriod.h
//  Productivity
//
//  Created by Alex Nichol on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTState.h"

@interface PTPeriod : NSObject {
    NSArray * states;
    NSDate * startTime;
    NSDate * endTime;
    NSTimeInterval idleTime;
    NSUInteger totalKeys;
    NSUInteger idleKeys;
}

@property (nonatomic, retain) NSArray * states;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (readwrite) NSTimeInterval idleTime;
@property (readwrite) NSUInteger totalKeys;
@property (readwrite) NSUInteger idleKeys;

@end

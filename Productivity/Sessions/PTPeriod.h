//
//  PTPeriod.h
//  Productivity
//
//  Created by Alex Nichol on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTStateObserver.h"

@interface PTPeriod : NSObject <NSCoding> {
    NSArray * states;
    NSDate * startDate;
    NSTimeInterval periodDuration;
    NSTimeInterval idleDuration;
    NSUInteger totalProductivity;
    NSUInteger idleProductivity;
}

@property (nonatomic, retain) NSArray * states;
@property (nonatomic, retain) NSDate * startDate;
@property (readwrite) NSTimeInterval periodDuration;
@property (readwrite) NSTimeInterval idleDuration;
@property (readwrite) NSUInteger totalProductivity;
@property (readwrite) NSUInteger idleProductivity;

- (id)initWithStateObservers:(NSArray *)observers;

@end

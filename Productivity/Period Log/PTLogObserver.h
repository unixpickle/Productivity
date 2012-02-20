//
//  PTLogObserver.h
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTPeriodLog;
@class PTPeriod;

@protocol PTPeriodLogObserver <NSObject>

@optional
- (void)periodLog:(PTPeriodLog *)log removedPeriod:(PTPeriod *)period atIndex:(NSUInteger)index;
- (void)periodLog:(PTPeriodLog *)log addedPeriodAtIndex:(NSUInteger)index;

@end

@interface PTLogObserver : NSObject {
    __weak id<PTPeriodLogObserver> observer;
}

@property (nonatomic, weak) id<PTPeriodLogObserver> observer;

- (id)initWithObserver:(id<PTPeriodLogObserver>)anObserver;
- (void)notifyLog:(PTPeriodLog *)log removed:(PTPeriod *)period atIndex:(NSUInteger)index;
- (void)notifyLog:(PTPeriodLog *)log addedAtIndex:(NSUInteger)index;


@end

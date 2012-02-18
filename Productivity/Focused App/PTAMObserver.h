//
//  PTAMObserver.h
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTAppMonitor;

@protocol PTAppMonitorObserver <NSObject>

@optional
- (void)appMonitor:(PTAppMonitor *)monitor appFocused:(NSUInteger)index;
- (void)appMonitor:(PTAppMonitor *)monitor appAdded:(NSUInteger)index;
- (void)appMonitor:(PTAppMonitor *)monitor enableChanged:(NSUInteger)index;

@end

@interface PTAMObserver : NSObject {
    __weak id<PTAppMonitorObserver> observer;
}

@property (nonatomic, weak) id<PTAppMonitorObserver> observer;

- (id)initWithObserver:(id<PTAppMonitorObserver>)anObserver;
- (void)notifyMonitor:(PTAppMonitor *)monitor appFocused:(NSUInteger)index;
- (void)notifyMonitor:(PTAppMonitor *)monitor appAdded:(NSUInteger)index;
- (void)notifyMonitor:(PTAppMonitor *)monitor enableChanged:(NSUInteger)index;


@end

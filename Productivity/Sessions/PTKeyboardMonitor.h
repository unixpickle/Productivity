//
//  PTKeyboardMonitor.h
//  Productivity
//
//  Created by Alex Nichol on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTKeyboardMonitor;

@protocol PTKeyboardMonitorDelegate <NSObject>

@optional
- (void)keyboardMonitor:(PTKeyboardMonitor *)monitor keyDown:(NSUInteger)keyCode;

@end

@interface PTKeyboardMonitor : NSObject {
    CFMachPortRef eventTap;
    CFRunLoopSourceRef runLoopSource;
    __weak id<PTKeyboardMonitorDelegate> delegate;
}

@property (nonatomic, weak) id<PTKeyboardMonitorDelegate> delegate;

- (BOOL)startMonitoring;
- (void)stopMonitoring;

@end

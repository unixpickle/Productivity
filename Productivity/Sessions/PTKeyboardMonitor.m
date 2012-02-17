//
//  PTKeyboardMonitor.m
//  Productivity
//
//  Created by Alex Nichol on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTKeyboardMonitor.h"

static CGEventRef keyboardEventCallback(CGEventTapProxy proxy,
                                        CGEventType type,
                                        CGEventRef event,
                                        void * refcon) {
	NSUInteger keyCode = CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
    PTKeyboardMonitor * monitor = (__bridge PTKeyboardMonitor *)refcon;
    if ([monitor.delegate respondsToSelector:@selector(keyboardMonitor:keyDown:)]) {
        [monitor.delegate keyboardMonitor:monitor keyDown:keyCode];
    }
    return event;
}

@implementation PTKeyboardMonitor

@synthesize delegate;

- (BOOL)startMonitoring {
    if (eventTap || runLoopSource) {
        return NO;
    }
    
	CGEventFlags emask = CGEventMaskBit(kCGEventKeyDown);
	eventTap = CGEventTapCreate(kCGSessionEventTap,
                                kCGTailAppendEventTap,
                                kCGEventTapOptionListenOnly,
                                emask, &keyboardEventCallback,
                                (__bridge void *)self);
	if (!eventTap) {
		return NO;
	}
	
	runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
	    
    return YES;
}

- (void)stopMonitoring {
    if (eventTap) {
		CGEventTapEnable(eventTap, false);
		CFRelease(eventTap);
		eventTap = NULL;
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
        CFRelease(runLoopSource);
        runLoopSource = NULL;
    }
}

- (void)dealloc {
    if (runLoopSource) [self stopMonitoring];
}

@end

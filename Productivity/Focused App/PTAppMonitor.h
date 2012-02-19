//
//  PTAppMonitor.h
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTAMObserver.h"

@interface PTAppMonitor : NSObject {
    NSMutableArray * rules;
    NSMutableArray * observers;
    NSCache * appIcons;
    NSCache * appTitles;
}

- (void)addMonitorObserver:(id<PTAppMonitorObserver>)observer;
- (void)removeMonitorObserver:(id<PTAppMonitorObserver>)observer;

- (NSArray *)applicationBundleIDs;
- (NSImage *)iconForBundleID:(NSString *)bundleID;
- (NSString *)titleForBundleID:(NSString *)bundleID;
- (BOOL)enabledForBundleID:(NSString *)bundleID;
- (void)setEnabled:(BOOL)flag forBundleID:(NSString *)bundleID;

- (void)startObserving;
- (void)stopObserving;

@end

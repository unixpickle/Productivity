//
//  PTAppMonitor.m
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTAppMonitor.h"

@interface PTAppMonitor (Private)

- (void)readRules;
- (void)writeRules;
- (NSDictionary *)ruleDictionaryWithBundleID:(NSString *)bundleID enabled:(BOOL)flag;

- (void)appFocusedNotification:(NSNotification *)notification;
- (void)appLaunchedNotification:(NSNotification *)notification;

- (void)handleAppBundleID:(NSString *)bundleID;

@end

@implementation PTAppMonitor

- (id)init {
    if ((self = [super init])) {
        [self readRules];
        
        NSArray * runningApps = [[NSWorkspace sharedWorkspace] runningApplications];
        for (NSRunningApplication * application in runningApps) {
            if ([application activationPolicy] != NSApplicationActivationPolicyRegular) {
                continue;
            }
            NSString * bundleID = [application bundleIdentifier];
            [self handleAppBundleID:bundleID];
        }
        
        appIcons = [[NSCache alloc] init];
        [appIcons setCountLimit:10];
        appTitles = [[NSCache alloc] init];
        [appTitles setCountLimit:1000];
        
        observers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self stopObserving];
}

#pragma mark - Observers -

- (void)addMonitorObserver:(id<PTAppMonitorObserver>)observer {
    [observers addObject:[[PTAMObserver alloc] initWithObserver:observer]];
}

- (void)removeMonitorObserver:(id<PTAppMonitorObserver>)observer {
    for (NSUInteger i = 0; i < [observers count]; i++) {
        if ([[[observers objectAtIndex:i] observer] isEqual:observer]) {
            [observers removeObjectAtIndex:i];
            return;
        }
    }
}

#pragma mark - Accessing -

- (NSArray *)applicationBundleIDs {
    NSMutableArray * mBundleIDs = [[NSMutableArray alloc] initWithCapacity:[rules count]];
    for (NSDictionary * rule in rules) {
        [mBundleIDs addObject:[rule objectForKey:@"bundleID"]];
    }
    return [NSArray arrayWithArray:mBundleIDs];
}

- (NSImage *)iconForBundleID:(NSString *)bundleID {
    if ([appIcons objectForKey:bundleID]) {
        return [appIcons objectForKey:bundleID];
    }
    
    NSString * path = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:bundleID];
    if (!path) return nil;
    
    NSImage * image = [[NSWorkspace sharedWorkspace] iconForFile:path];
    if (!image) return nil;
    
    [appIcons setObject:image forKey:bundleID];
    return image;
}

- (NSString *)titleForBundleID:(NSString *)bundleID {
    if ([appTitles objectForKey:bundleID]) {
        return [appTitles objectForKey:bundleID];
    }
    
    NSString * path = [[NSWorkspace sharedWorkspace] absolutePathForAppBundleWithIdentifier:bundleID];
    if (!path) return nil;
    
    NSBundle * bundle = [NSBundle bundleWithPath:path];
    NSString * dispName = [[bundle infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString * realName = [[bundle infoDictionary] objectForKey:@"CFBundleName"];
    if (dispName) return dispName;
    return realName;
}

- (BOOL)enabledForBundleID:(NSString *)bundleID {
    for (NSDictionary * rule in rules) {
        NSString * aBundleID = [rule objectForKey:@"bundleID"];
        if ([aBundleID isEqualToString:bundleID]) {
            BOOL enabled = [[rule objectForKey:@"enabled"] boolValue];
            return enabled;
        }
    }
    return NO;
}

- (void)setEnabled:(BOOL)flag forBundleID:(NSString *)bundleID {    
    for (NSUInteger i = 0; i < [rules count]; i++) {
        NSDictionary * rule = [rules objectAtIndex:i];
        NSString * aBundleID = [rule objectForKey:@"bundleID"];
        
        if ([aBundleID isEqualToString:bundleID]) {
            NSDictionary * modified = [self ruleDictionaryWithBundleID:bundleID enabled:flag];
            [rules replaceObjectAtIndex:i withObject:modified];
            
            for (PTAMObserver * observer in observers) {
                [observer notifyMonitor:self enableChanged:i];
            }
        }
    }
    [self writeRules];
}

#pragma mark - Notifications -

- (void)startObserving {
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(appFocusedNotification:)
                                                               name:NSWorkspaceDidActivateApplicationNotification
                                                             object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(appLaunchedNotification:)
                                                               name:NSWorkspaceWillLaunchApplicationNotification
                                                             object:nil];
}

- (void)stopObserving {
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
}

#pragma mark Receiving

- (void)appFocusedNotification:(NSNotification *)notification {
    NSRunningApplication * application = [[notification userInfo] objectForKey:NSWorkspaceApplicationKey];
    NSString * bundleID = [application bundleIdentifier];
    if (!bundleID) return;
    [self handleAppBundleID:bundleID];
    
    NSUInteger index = [[self applicationBundleIDs] indexOfObject:bundleID];
    for (PTAMObserver * observer in observers) {
        [observer notifyMonitor:self appFocused:index];
    }
}

- (void)appLaunchedNotification:(NSNotification *)notification {
    NSRunningApplication * application = [[notification userInfo] objectForKey:NSWorkspaceApplicationKey];
    if ([application activationPolicy] != NSApplicationActivationPolicyRegular) {
        return;
    }
    [self handleAppBundleID:[application bundleIdentifier]];
}

- (void)handleAppBundleID:(NSString *)bundleID {
    if (!bundleID) return;
    if (![[self applicationBundleIDs] containsObject:bundleID]) {
        NSDictionary * dictionary = [self ruleDictionaryWithBundleID:bundleID
                                                             enabled:NO];
        [rules addObject:dictionary];
        [self writeRules];
        for (PTAMObserver * observer in observers) {
            [observer notifyMonitor:self appAdded:([rules count] - 1)];
        }
    }
}

#pragma mark - Miscellaneous -

- (void)readRules {
    // TODO: remove the lines right under this one
    rules = [[NSMutableArray alloc] init];
    return;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"appRules"]) {
        rules = [[defaults objectForKey:@"appRules"] mutableCopy];
        if (![rules isKindOfClass:[NSMutableArray class]]) {
            rules = [[NSMutableArray alloc] init];
            [defaults setObject:rules forKey:@"appRules"];
            [defaults synchronize];
        }
    } else {
        rules = [[NSMutableArray alloc] init];
    }
}

- (void)writeRules {
    // TODO: remove the line right under this one
    return;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:rules forKey:@"appRules"];
    [defaults synchronize];
}

- (NSDictionary *)ruleDictionaryWithBundleID:(NSString *)bundleID enabled:(BOOL)flag {
    return [NSDictionary dictionaryWithObjectsAndKeys:[bundleID copy], @"bundleID",
            [NSNumber numberWithBool:flag], @"enabled", nil];
}

@end

//
//  PTAppDelegate.m
//  Productivity
//
//  Created by Alex Nichol on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTAppDelegate.h"

@implementation PTAppDelegate

@synthesize window = _window;

- (NSString *)logPath {
    NSString * bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString * appSupport = [paths objectAtIndex:0];
    NSString * dataDir = [appSupport stringByAppendingPathComponent:bundleName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataDir
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    NSString * dbPath = [dataDir stringByAppendingPathComponent:@"log.db"];
    return dbPath;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSRect viewFrame = NSMakeRect(10, 5,
                                  [self.window.contentView frame].size.width - 20,
                                  [self.window.contentView frame].size.height - 10);
    
    controller = [[PTController alloc] initWithLogFile:[self logPath]];
    view = [[PTView alloc] initWithFrame:viewFrame
                              controller:controller];
    [view configure];
    [view setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [self.window.contentView addSubview:view];
}

@end

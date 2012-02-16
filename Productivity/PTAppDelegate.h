//
//  PTAppDelegate.h
//  Productivity
//
//  Created by Alex Nichol on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTMusicObserver.h"

@interface PTAppDelegate : NSObject <NSApplicationDelegate> {
    PTMusicObserver * observer;
}

@property (assign) IBOutlet NSWindow *window;

@end

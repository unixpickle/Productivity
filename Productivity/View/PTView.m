//
//  PTView.m
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTView.h"

@implementation PTView

@synthesize controller;

- (id)initWithFrame:(NSRect)frameRect controller:(PTController *)aController {
    if ((self = [super initWithFrame:frameRect])) {
        controller = aController;
    }
    return self;
}

- (void)configure {
    NSRect content = [self contentRect];
    NSRect viewFrame = NSMakeRect(0, 0, content.size.width, content.size.height);
    setupView = [[PTSetupView alloc] initWithFrame:viewFrame controller:controller];
    logView = [[PTLogView alloc] initWithFrame:viewFrame];
    
    NSTabViewItem * setupItem = [[NSTabViewItem alloc] initWithIdentifier:@"setup"];
    NSTabViewItem * logItem = [[NSTabViewItem alloc] initWithIdentifier:@"log"];
    [setupItem setLabel:@"Setup"];
    [logItem setLabel:@"Log"];
    [setupItem setView:setupView];
    [logItem setView:logView];
    [self addTabViewItem:setupItem];
    [self addTabViewItem:logItem];
    
    [self selectFirstTabViewItem:self];
}

@end

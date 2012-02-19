//
//  PTSetupView.h
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTController.h"

@interface PTSetupView : NSView <PTAppMonitorObserver, NSTableViewDataSource, NSTableViewDelegate> {
    __weak PTController * controller;
    NSScrollView * scrollView;
    NSTableView * tableView;
    NSArray * bundleIDs;
}

- (id)initWithFrame:(NSRect)frameRect controller:(PTController *)aController;

@end

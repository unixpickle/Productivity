//
//  PTSetupView.m
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTSetupView.h"

@implementation PTSetupView

- (id)initWithFrame:(NSRect)frameRect controller:(PTController *)aController {
    if ((self = [super initWithFrame:frameRect])) {
        controller = aController;
        [controller.appMonitor addMonitorObserver:self];
        bundleIDs = [controller.appMonitor applicationBundleIDs];
        
        NSTableColumn * enabled = [[NSTableColumn alloc] initWithIdentifier:@"Enabled"];
        [[enabled headerCell] setTitle:@""];
        [enabled setWidth:16];
        
        NSTableColumn * icon = [[NSTableColumn alloc] initWithIdentifier:@"Icon"];
        [[icon headerCell] setTitle:@""];
        [icon setWidth:24];
        
        NSTableColumn * appName = [[NSTableColumn alloc] initWithIdentifier:@"Name"];
        [[appName headerCell] setTitle:@"Name"];
        [appName setWidth:frameRect.size.width - 86];
        
        
        NSRect tableFrame = NSMakeRect(10, 10, frameRect.size.width - 20, frameRect.size.height - 20);
        tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, 10, 10)];
        [tableView addTableColumn:enabled];
        [tableView addTableColumn:icon];
        [tableView addTableColumn:appName];
        [tableView setRowHeight:24];
        [tableView setDataSource:self];
        [tableView setDelegate:self];
        scrollView = [[NSScrollView alloc] initWithFrame:tableFrame];
        [scrollView setBorderType:NSBezelBorder];
        [scrollView setDocumentView:tableView];
        [scrollView setHasVerticalScroller:YES];

        [self addSubview:scrollView];
    }
    return self;
}

#pragma mark - App Monitor -

- (void)appMonitor:(PTAppMonitor *)monitor appAdded:(NSUInteger)index {
    bundleIDs = [controller.appMonitor applicationBundleIDs];
    [tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index]
                     withAnimation:NSTableViewAnimationEffectFade];
}

- (void)appMonitor:(PTAppMonitor *)monitor appFocused:(NSUInteger)index {
}

- (void)appMonitor:(PTAppMonitor *)monitor enableChanged:(NSUInteger)index {
    [tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index]
                         columnIndexes:[NSIndexSet indexSetWithIndex:0]];
}

#pragma mark - Table View -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [bundleIDs count];
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if (!tableColumn) return nil;
	if ([[tableColumn identifier] isEqualToString:@"Enabled"]) {
		NSButtonCell * cell = [[NSButtonCell alloc] init];
		[cell setAllowsMixedState:YES];
		[cell setButtonType:NSSwitchButton];
		[cell setAllowsMixedState:NO];
		return cell;
	} else if ([[tableColumn identifier] isEqualToString:@"Icon"]) {
		NSImageCell * img = [[NSImageCell alloc] initImageCell:nil];
		return img;
	} else {
        NSCell * cell = [[NSCell alloc] initTextCell:@""];
        cell.font = [NSFont systemFontOfSize:17];
        return cell;
    }
	return nil;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString * bundleID = [bundleIDs objectAtIndex:row];
    if ([[tableColumn identifier] isEqualToString:@"Enabled"]) {
        BOOL enabled = [controller.appMonitor enabledForBundleID:bundleID];
        return [NSNumber numberWithBool:enabled];
    } else if ([[tableColumn identifier] isEqualToString:@"Name"]) {
        return [controller.appMonitor titleForBundleID:bundleID];
    } else if ([[tableColumn identifier] isEqualToString:@"Icon"]) {
        return [controller.appMonitor iconForBundleID:bundleID];
    }
    return nil;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString * bundleID = [bundleIDs objectAtIndex:row];
    if ([[tableColumn identifier] isEqualToString:@"Enabled"]) {
        BOOL flag = [object boolValue];
        [controller.appMonitor setEnabled:flag forBundleID:bundleID];
    }
}

@end

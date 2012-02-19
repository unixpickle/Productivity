//
//  PTSetupView.m
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTSetupView.h"

@interface PTSetupView (Private)

- (void)setupAppsTable;

@end

@implementation PTSetupView

- (id)initWithFrame:(NSRect)frameRect controller:(PTController *)aController {
    if ((self = [super initWithFrame:frameRect])) {
        controller = aController;
        [controller.appMonitor addMonitorObserver:self];
        bundleIDs = [controller.appMonitor applicationBundleIDs];
        
        NSTextField * labelField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, frameRect.size.height - 28, 200, 18)];
        [labelField setBordered:NO];
        [labelField setBackgroundColor:[NSColor clearColor]];
        [labelField setSelectable:NO];
        [labelField setStringValue:@"Record data for these apps:"];
        [labelField setAutoresizingMask:NSViewMinYMargin];
        [self addSubview:labelField];
        
        startButton = [[NSButton alloc] initWithFrame:NSMakeRect(frameRect.size.width - 85, 10,
                                                                 80, 24)];
        [startButton setBezelStyle:NSRoundedBezelStyle];
        [startButton setTarget:self];
        [startButton setAction:@selector(startStopPress:)];
        [startButton setAutoresizingMask:NSViewMinXMargin];
        [startButton setTitle:@"Start"];
        [self addSubview:startButton];
        
        timeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, 100, 18)];
        [timeLabel setBordered:NO];
        [timeLabel setBackgroundColor:[NSColor clearColor]];
        [timeLabel setSelectable:NO];
        [timeLabel setAutoresizingMask:NSViewMaxYMargin];
        [self addSubview:timeLabel];
        
        [self setupAppsTable];
    }
    return self;
}

- (void)setupAppsTable {
    NSRect frameRect = self.frame;
    
    NSTableColumn * enabled = [[NSTableColumn alloc] initWithIdentifier:@"Enabled"];
    [[enabled headerCell] setTitle:@""];
    [enabled setWidth:16];
    
    NSTableColumn * icon = [[NSTableColumn alloc] initWithIdentifier:@"Icon"];
    [[icon headerCell] setTitle:@""];
    [icon setWidth:24];
    
    NSTableColumn * appName = [[NSTableColumn alloc] initWithIdentifier:@"Name"];
    [[appName headerCell] setTitle:@"Name"];
    [appName setWidth:frameRect.size.width - 86];
    
    NSRect tableFrame = NSMakeRect(10, 40, frameRect.size.width - 20, frameRect.size.height - 68);
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
    [scrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    
    [self addSubview:scrollView];
}

- (void)startStopPress:(id)sender {
    if (!controller.sessionStart) {
        [startButton setTitle:@"Stop"];
        [controller beginSession];
        timeLabelTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(updateTimeLabel:)
                                                        userInfo:nil
                                                         repeats:YES];
    } else {
        [startButton setTitle:@"Start"];
        [controller endSession];
        [timeLabelTimer invalidate];
        timeLabelTimer = nil;
        [timeLabel setStringValue:@""];
    }
}

- (void)updateTimeLabel:(id)sender {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:controller.sessionStart];
    int days = (int)interval / 60 / 60 / 24;
    int hours = ((int)interval / 60 / 60) % 24;
    int minutes = ((int)interval / 60) % 60;
    int seconds = (int)interval % 60;
    
    NSString * timeStr = nil;
    if (days > 0) {
        timeStr = [NSString stringWithFormat:@"%dd:%02d:%02d:%02d", days, hours, minutes, seconds];
    } else if (hours > 0) {
        timeStr = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    } else {
        timeStr = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    [timeLabel setStringValue:[@"Active for " stringByAppendingString:timeStr]];
}

#pragma mark - App Monitor -

- (void)appMonitor:(PTAppMonitor *)monitor appAdded:(NSUInteger)index {
    bundleIDs = [controller.appMonitor applicationBundleIDs];
    [tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:index]
                     withAnimation:NSTableViewAnimationEffectFade];
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

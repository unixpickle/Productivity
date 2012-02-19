//
//  PTView.h
//  Productivity
//
//  Created by Alex Nichol on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTController.h"
#import "PTSetupView.h"
#import "PTLogView.h"

@interface PTView : NSTabView {
    __weak PTController * controller;
    PTSetupView * setupView;
    PTLogView * logView;
}

@property (readonly) PTController * controller;

- (id)initWithFrame:(NSRect)frameRect controller:(PTController *)aController;
- (void)configure;

@end

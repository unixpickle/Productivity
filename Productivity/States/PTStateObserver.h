//
//  PTStateObserver.h
//  Productivity
//
//  Created by Alex Nichol on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTState.h"

@class PTStateObserver;

@protocol PTStateObserverDelegate <NSObject>

@optional
- (void)stateObserverStateChanged:(PTStateObserver *)sender;

@end

@interface PTStateObserver : NSObject {
    PTState * state;
    __weak id<PTStateObserverDelegate> delegate;
}

@property (readonly) PTState * state;
@property (nonatomic, weak) id<PTStateObserverDelegate> delegate;

- (void)startObserving;
- (void)stopObserving;

@end

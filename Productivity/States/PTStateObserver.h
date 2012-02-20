//
//  PTStateObserver.h
//  Productivity
//
//  Created by Alex Nichol on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTState.h"

@protocol PTStateObserverDelegate <NSObject>

@optional
- (void)stateObserverChangedState:(id)sender;

@end

@protocol PTStateObserver <NSObject>

@property (readonly, strong) id<PTState> state;
@property (nonatomic, weak) id<PTStateObserverDelegate> delegate;
+ (Class)stateClass;
- (void)startObserving;
- (void)stopObserving;

@end

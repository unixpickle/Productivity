//
//  PTSMObserver.h
//  Productivity
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTStatManager;

@protocol PTStatManagerObserver <NSObject>

@optional
- (void)statManagerUpdatedStatistics:(PTStatManager *)observer;

@end

@interface PTSMObserver : NSObject {
    __weak id<PTStatManagerObserver> observer;
}

@property (nonatomic, weak) id<PTStatManagerObserver> observer;

- (id)initWithObserver:(id<PTStatManagerObserver>)anObserver;
- (void)notifyObserverUpdated:(PTStatManager *)sender;

@end

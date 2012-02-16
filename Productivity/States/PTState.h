//
//  PTState.h
//  Productivity
//
//  Created by Alex Nichol on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTStateObserver;

@interface PTState : NSObject <NSCoding, NSCopying> {
    __weak PTStateObserver * stateObserver;
}

@property (nonatomic, weak) PTStateObserver * stateObserver;

+ (NSString *)stateID;
+ (NSString *)stateString;
- (NSString *)stateDescription;
- (NSUInteger)hash;

@end

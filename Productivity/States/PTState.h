//
//  PTState.h
//  Productivity
//
//  Created by Alex Nichol on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PTState <NSObject, NSCopying, NSCoding>

+ (NSString *)stateID;
+ (NSString *)stateString;
- (NSString *)stateDescription;
- (UInt32)stateHash;
- (BOOL)isEqualToState:(id<PTState>)aState;

@end

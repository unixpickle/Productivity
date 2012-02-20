//
//  PTStatistic.h
//  Productivity
//
//  Created by Alex Nichol on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTState.h"

@interface PTStatistic : NSObject <NSCopying> {
    id<PTState> state;
    NSInteger totalKeys;
    NSTimeInterval totalTime;
    NSUInteger stateCount;
}

@property (readonly) id<PTState> state;
@property (readwrite) NSInteger totalKeys;
@property (readwrite) NSTimeInterval totalTime;
@property (readwrite) NSUInteger stateCount;

- (id)initWithState:(id<PTState>)aState;

@end

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
    NSInteger stateCount;
}

@property (readonly) id<PTState> state;
@property (readwrite) NSInteger totalKeys;
@property (readwrite) NSTimeInterval totalTime;
@property (readwrite) NSInteger stateCount;

- (id)initWithState:(id<PTState>)aState;
- (double)keyRate;
- (NSComparisonResult)compareToStatistic:(PTStatistic *)statistic;
- (NSComparisonResult)invertedCompareToStatistic:(PTStatistic *)statistic;

@end

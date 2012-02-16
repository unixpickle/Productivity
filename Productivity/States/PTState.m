//
//  PTState.m
//  Productivity
//
//  Created by Alex Nichol on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTState.h"

@implementation PTState

@synthesize stateObserver;

+ (NSString *)stateID {
    return nil;
}

+ (NSString *)stateString {
    return nil;
}

- (NSString *)stateDescription {
    return nil;
}

- (NSUInteger)hash {
    return 0;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
    }
    return self;
}

@end

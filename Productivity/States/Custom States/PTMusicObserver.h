//
//  PTMusicObserver.h
//  Productivity
//
//  Created by Alex Nichol on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTStateObserver.h"
#import "PTMusicState.h"
#import "iTunes.h"

#define kPlayerInfoNotificationName @"com.apple.iTunes.playerInfo"

@interface PTMusicObserver : PTStateObserver {
}

- (PTMusicState *)musicState;

@end

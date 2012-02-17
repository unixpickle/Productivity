//
//  PTMusicObserver.m
//  Productivity
//
//  Created by Alex Nichol on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTMusicObserver.h"

@interface PTMusicObserver (Private)

- (void)updateTrackInfo:(NSNotification *)notification;

@end

@implementation PTMusicObserver

@synthesize state;
@synthesize delegate;

- (id)init {
    if ((self = [super init])) {
        iTunesApplication * application = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
        if ([application isRunning]) {
            iTunesTrack * track = [application currentTrack];
            NSString * title = [track name];
            NSString * artist = [track artist];
            NSString * album = [track album];
            state = [[PTMusicState alloc] initWithTitle:title artist:artist album:album];
        } else {
            state = [[PTMusicState alloc] initWithTitle:nil artist:nil album:nil];
        }
    }
    return self;
}

- (PTMusicState *)musicState {
    if (![state isKindOfClass:[PTMusicState class]]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Invalid class for music state."
                                     userInfo:nil];
    }
    return (PTMusicState *)state;
}

- (void)startObserving {
    NSDistributedNotificationCenter * dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc addObserver:self
            selector:@selector(updateTrackInfo:)
                name:kPlayerInfoNotificationName
              object:nil];
}

- (void)stopObserving {
    NSDistributedNotificationCenter * dnc = [NSDistributedNotificationCenter defaultCenter];
    [dnc removeObserver:self name:kPlayerInfoNotificationName object:nil];
}

- (void)updateTrackInfo:(NSNotification *)notification {
    NSString * playerState = [[notification userInfo] objectForKey:@"Player State"];
    if (![playerState isEqualToString:@"Playing"]) {
        state = [[PTMusicState alloc] initWithTitle:nil artist:nil album:nil];
    } else {
        NSString * title = [[notification userInfo] objectForKey:@"Name"];
        NSString * artist = [[notification userInfo] objectForKey:@"Artist"];
        NSString * album = [[notification userInfo] objectForKey:@"Album"];
        state = [[PTMusicState alloc] initWithTitle:title artist:artist album:album];
    }
    if ([delegate respondsToSelector:@selector(stateObserverChangedState:)]) {
        [delegate stateObserverChangedState:self];
    }
}

@end

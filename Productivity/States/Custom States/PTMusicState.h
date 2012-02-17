//
//  PTMusicState.h
//  Productivity
//
//  Created by Alex Nichol on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTState.h"

@interface PTMusicState : NSObject <PTState> {
    NSString * songTitle;
    NSString * songArtist;
    NSString * songAlbum;
}

@property (readonly) NSString * songTitle;
@property (readonly) NSString * songArtist;
@property (readonly) NSString * songAlbum;

- (id)initWithTitle:(NSString *)title artist:(NSString *)artist album:(NSString *)album;

@end

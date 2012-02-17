//
//  PTMusicState.m
//  Productivity
//
//  Created by Alex Nichol on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PTMusicState.h"

@implementation PTMusicState

@synthesize songTitle;
@synthesize songArtist;
@synthesize songAlbum;

+ (NSString *)stateID {
    return @"MusicState";
}

+ (NSString *)stateString {
    return @"Song";
}

- (id)initWithTitle:(NSString *)title artist:(NSString *)artist album:(NSString *)album {
    if ((self = [super init])) {
        songTitle = title;
        songArtist = artist;
        songAlbum = album;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        songTitle = [aDecoder decodeObjectForKey:@"title"];
        songArtist = [aDecoder decodeObjectForKey:@"artist"];
        songAlbum = [aDecoder decodeObjectForKey:@"album"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:songTitle forKey:@"title"];
    [aCoder encodeObject:songArtist forKey:@"artist"];
    [aCoder encodeObject:songAlbum forKey:@"album"];
}

- (id)copyWithZone:(NSZone *)zone {
    PTMusicState * state;
    state = [[PTMusicState allocWithZone:zone] initWithTitle:[songTitle copy]
                                                      artist:[songArtist copy]
                                                       album:[songAlbum copy]];
    return state;
}

- (NSString *)stateDescription {
    if (!songTitle && !songAlbum && !songArtist) return @"No song";
    return [NSString stringWithFormat:@"Playing %@", songTitle];
}

- (UInt32)stateHash {
    char hashBuff[4];
    int index = 0;
    
    if (!songTitle && !songArtist && !songAlbum) {
        return 0;
    }
    
    bzero(hashBuff, 4);
    NSString * hashString = [NSString stringWithFormat:@"%@%@%@",
                             (songTitle ? songTitle : @""),
                             (songArtist ? songArtist : @""),
                             (songAlbum ? songAlbum : @"")];
    for (NSUInteger i = 0; i < [hashString length]; i++) {
        char theChar = (char)[hashString characterAtIndex:i];
        hashBuff[index] ^= theChar;
        index++;
        if (index == 4) index = 0;
    }
    return *((UInt32 *)hashBuff);
}

@end

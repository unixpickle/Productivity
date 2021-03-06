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

- (id)initWithTitle:(NSString *)title artist:(NSString *)artist album:(NSString *)album {
    if ((self = [super init])) {
        songTitle = title;
        songArtist = artist;
        songAlbum = album;
    }
    return self;
}

#pragma mark - Various Protocols -

#pragma mark Coding

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        songTitle = [aDecoder decodeObjectForKey:@"title"];
        songArtist = [aDecoder decodeObjectForKey:@"artist"];
        songAlbum = [aDecoder decodeObjectForKey:@"album"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if (songTitle) [aCoder encodeObject:songTitle forKey:@"title"];
    if (songArtist) [aCoder encodeObject:songArtist forKey:@"artist"];
    if (songAlbum) [aCoder encodeObject:songAlbum forKey:@"album"];
}

#pragma mark Copying

- (id)copyWithZone:(NSZone *)zone {
    PTMusicState * state;
    state = [[PTMusicState allocWithZone:zone] initWithTitle:[songTitle copy]
                                                      artist:[songArtist copy]
                                                       album:[songAlbum copy]];
    return state;
}

#pragma mark Compare

- (BOOL)isEqualToMusicState:(PTMusicState *)aState {
    if (![[aState songTitle] isEqualToString:self.songTitle] && self.songTitle != aState.songTitle) {
        return NO;
    }
    if (![[aState songArtist] isEqualToString:self.songArtist] && self.songArtist != aState.songArtist) {
        return NO;
    }
    if (![[aState songAlbum] isEqualToString:self.songAlbum] && self.songAlbum != aState.songAlbum) {
        return NO;
    }
    return YES;
}

- (BOOL)isEqualToState:(id<PTState>)aState {
    return [self isEqual:aState];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        return [self isEqualToMusicState:object];
    }
    return NO;
}

#pragma mark State

+ (NSString *)stateID {
    return @"MusicState";
}

+ (NSString *)stateString {
    return @"Song";
}

- (NSString *)stateDescription {
    if (!songTitle && !songAlbum && !songArtist) return @"No song";
    if (!songArtist) return [songTitle copy];
    return [NSString stringWithFormat:@"%@ by %@", songTitle, songArtist];
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

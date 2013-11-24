//
//  DRTArtworkResult.m
//  dArt
//
//  Created by Habib A on 24/11/2013.
//  Copyright (c) 2013 alAmin. All rights reserved.
//

#import "DRTArtworkResult.h"

@implementation DRTArtworkResult

@synthesize artworkTitle;
@synthesize artworkImage;

- (id)initWithTitle:(NSString *)resultTitle andImageData:(NSData *)resultImageData {
    self = [self init];
    [self setArtworkTitle:resultTitle];
    [self setArtworkImage:[[NSImage alloc] initWithData:resultImageData]];
    return self;
}
- (id)initWithTitle:(NSString *)resultTitle andImage:(NSImage *)resultImage {
    self = [self init];
    [self setArtworkTitle:resultTitle];
    [self setArtworkImage:resultImage];
    return self;
}

@end

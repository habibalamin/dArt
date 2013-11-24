//
//  DRTArtworkResult.m
//  dArt
//
//  Created by Habib A on 24/11/2013.
//  Copyright (c) 2013 alAmin. All rights reserved.
//

#import "DRTArtworkResult.h"

@implementation DRTArtworkResult

@synthesize title;
@synthesize image;

- (id)initWithTitle:(NSString *)resultTitle andImageData:(NSData *)resultImageData {
    self = [self init];
    [self setTitle:resultTitle];
    [self setImage:[[NSImage alloc] initWithData:resultImageData]];
    return self;
}
- (id)initWithTitle:(NSString *)resultTitle andImage:(NSImage *)resultImage {
    self = [self init];
    [self setTitle:resultTitle];
    [self setImage:resultImage];
    return self;
}

@end

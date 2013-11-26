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
@synthesize downloadTo;

- (id)initWithTitle:(NSString *)resultTitle imageData:(NSData *)resultImageData andDownloadTo:(NSString *)downloadPath {
    self = [super init];
    if (self) {
        artworkTitle = resultTitle;
        artworkImage = [[NSImage alloc] initWithData:resultImageData];
        downloadTo = downloadPath;
    }
    return self;
}

- (id)initWithTitle:(NSString *)resultTitle image:(NSImage *)resultImage andDownloadTo:(NSString *)downloadPath {
    self = [super init];
    if (self) {
        artworkTitle = resultTitle;
        artworkImage = resultImage;
        downloadTo = downloadPath;
    }
    return self;
}

@end

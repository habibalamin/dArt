//
//  DRTArtworkResult.h
//  dArt
//
//  Created by Habib A on 24/11/2013.
//  Copyright (c) 2013 alAmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRTArtworkResult : NSObject

@property NSString *artworkTitle;
@property NSImage *artworkImage;
@property NSString *downloadTo;

- (id)initWithTitle:(NSString *)resultTitle imageData:(NSData *)resultImageData andDownloadTo:(NSString *)downloadPath;
- (id)initWithTitle:(NSString *)resultTitle image:(NSImage *)resultImage andDownloadTo:(NSString *)downloadPath;

@end

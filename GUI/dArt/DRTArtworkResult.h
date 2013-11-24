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

- (id)initWithTitle:(NSString *)resultTitle andImageData:(NSData *)resultImageData;
- (id)initWithTitle:(NSString *)resultTitle andImage:(NSImage *)resultImage;

@end

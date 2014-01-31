//
//  DRTTableCellView.m
//  dArt
//
//  Created by Habib A on 31/01/2014.
//  Copyright (c) 2014 alAmin. All rights reserved.
//

#import "DRTTableCellView.h"

@implementation DRTTableCellView

@synthesize dlButton;
@synthesize imageView;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
}

- (IBAction)downloadImage:(id)sender {
	[[[imageView image] TIFFRepresentation] writeToFile:[[dlButton dlPath] stringByAppendingPathExtension:@"tiff"] atomically:NO];
}

@end

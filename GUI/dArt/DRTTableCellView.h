//
//  DRTTableCellView.h
//  dArt
//
//  Created by Habib A on 31/01/2014.
//  Copyright (c) 2014 alAmin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DRTDownloadButton.h"

@class DRTDownloadButton;
@interface DRTTableCellView : NSTableCellView

@property(assign) IBOutlet DRTDownloadButton *dlButton;

- (IBAction)downloadImage:(id)sender;

@end

//
//  AppDelegate.h
//  dArt
//
//  Created by Habib A on 09/02/2013.
//  Copyright (c) 2013 alAmin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SearchURL;
@class PictureConnection;
@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *searchTerm;
@property (weak) IBOutlet NSTextField *lookupID;
@property (weak) IBOutlet NSPopUpButton *storeCountry;
@property (weak) IBOutlet NSButton *explicitFilter;
@property (weak) IBOutlet NSPopUpButton *mediaType;
@property (weak) IBOutlet NSTextField *downloadLocation;
@property (weak) IBOutlet NSMatrix *searchBy;
@property (weak) IBOutlet NSCollectionView *resultsView;

@property (strong) SearchURL *searchURL;
@property (strong) NSMutableArray *artworkResults;

- (IBAction)updateSearchTerm:(id)sender;
- (IBAction)updateLookupID:(id)sender;
- (IBAction)updateStoreCountry:(id)sender;
- (IBAction)updateFilterExplicit:(id)sender;
- (IBAction)updateMediaType:(id)sender;
- (IBAction)updateDownloadLocation:(id)sender;
- (IBAction)searchTheArt:(id)sender;
- (IBAction)updateSearchBy:(id)sender;

- (void)updateUI;
- (NSString *)convertCountryToISO:(NSString *)countryName;
- (NSString *)convertMediaType:(NSString *)humanReadableMediaType;
- (void)downloadEngine:(NSString *)APISearchURLString;

@end

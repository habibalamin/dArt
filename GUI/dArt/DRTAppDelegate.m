//
//  DRTAppDelegate.m
//  dArt
//
//  Created by Habib A on 09/02/2013.
//  Copyright (c) 2013 alAmin. All rights reserved.
//

#import "DRTAppDelegate.h"
#import "DRTSearchURL.h"
#import "DRTArtworkResult.h"
#import "DRTDownloadButton.h"
#import "DRTTableCellView.h"

@implementation DRTAppDelegate

@synthesize searchTerm;
@synthesize lookupID;
@synthesize storeCountry;
@synthesize mediaType;
@synthesize downloadLocation;
@synthesize explicitFilter;
@synthesize artworkResults;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DRTSearchURL *aSearchURL = [[DRTSearchURL alloc] init];
    artworkResults = [[NSMutableArray alloc] init];
    [self setSearchURL:aSearchURL];
    [self updateSearchBy:self.searchBy];
    [self updateUI];
    [self updateStoreCountry:self.storeCountry];
    [self updateMediaType:self.mediaType];
    [self updateFilterExplicit:self.explicitFilter];
    [self.searchURL setTheDownloadLocation:[NSHomeDirectory() stringByAppendingString:@"/Downloads/Artwork"]];
    [self.downloadLocation setStringValue:[[NSHomeDirectory() stringByAppendingString:@"/Downloads/Artwork"] stringByAbbreviatingWithTildeInPath]];
    
}

- (IBAction)updateSearchTerm:(id)sender {
    NSString *theSearchTerm = [sender stringValue];
    [self.searchURL setTheSearchTerm:theSearchTerm];
}

- (IBAction)updateLookupID:(id)sender {
    NSString *theLookupID = [sender stringValue];
    [self.searchURL setTheLookupID:theLookupID];
}

- (IBAction)updateStoreCountry:(id)sender {
    NSString *theStoreCountry = [sender titleOfSelectedItem];
    [self.searchURL setTheStoreCountry:[self convertCountryToISO:theStoreCountry]];
}

- (IBAction)updateFilterExplicit:(id)sender {
    BOOL filterExplicit = [sender state];
    if (filterExplicit == 0) {
        [self.searchURL setIsExplicit:@"&explicit=yes"];
    }
    else {
        [self.searchURL setIsExplicit:@"&explicit=no"];
    }
}

- (IBAction)updateMediaType:(id)sender {
    NSString *theMediaType = [sender titleOfSelectedItem];
    [self.searchURL setTheMediaType:[self convertMediaType:theMediaType]];
}

- (IBAction)updateDownloadLocation:(id)sender {
    
    NSOpenPanel *chooseDownloadLocation = [[NSOpenPanel alloc] init];
    [chooseDownloadLocation setCanChooseFiles:NO];
    [chooseDownloadLocation setCanChooseDirectories:YES];
    [chooseDownloadLocation setAllowsMultipleSelection:NO];
    [chooseDownloadLocation setCanCreateDirectories:YES];
    
    if ([chooseDownloadLocation runModal] == NSOKButton)
    {
        [self.searchURL setTheDownloadLocation:[[chooseDownloadLocation URL] path]];
        [self.downloadLocation setStringValue:[[[chooseDownloadLocation URL] path] stringByAbbreviatingWithTildeInPath]];
    }
}

- (IBAction)searchTheArt:(id)sender {
    [[NSFileManager defaultManager] createDirectoryAtPath:[self.searchURL theDownloadLocation] withIntermediateDirectories:YES attributes:nil error:nil];
    [self updateUI];
    if ([[[self.searchBy selectedCell] title] isEqualToString:@"Keywords"]) {
        //Search by keywords!
        [self.searchURL setTheSearchTerm:[[self.searchURL theSearchTerm] stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
        [self.searchURL setFinalURL:[@"https://itunes.apple.com/search?term=" stringByAppendingString:[[self.searchURL theSearchTerm] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [self.searchURL setFinalURL:[[self.searchURL finalURL] stringByAppendingString:[self.searchURL theMediaType]]];
        [self.searchURL setFinalURL:[[self.searchURL finalURL] stringByAppendingString:[self.searchURL theStoreCountry]]];
        [self.searchURL setFinalURL:[[self.searchURL finalURL] stringByAppendingString:[self.searchURL isExplicit]]];
        [self.searchURL setFinalURL:[[self.searchURL finalURL] stringByAppendingString:@"&limit=200"]];
    } else {
        //Search by iTunes ID!
        [self.searchURL setFinalURL:[@"https://itunes.apple.com/lookup?id=" stringByAppendingString:[self.searchURL theLookupID]]];
    }
    [self downloadEngine:[self.searchURL finalURL]];
}

- (IBAction)updateSearchBy:(id)sender {
    if ([[[sender selectedCell] title] isEqualToString:@"iTunes ID"]) {
        [self.explicitFilter setEnabled:NO];
        [self.mediaType setEnabled:NO];
        [self.storeCountry setEnabled:NO];
        [self.searchTerm setEnabled:NO];
        [self.lookupID setEnabled:YES];
        [self.explicitFilter setState:0];
        [self.mediaType selectItemAtIndex:-1];
        [self.storeCountry selectItemAtIndex:-1];
        [self.searchURL setTheSearchTerm:@""];
        [self.searchTerm setStringValue:@""];
        
    } else {
        [self.explicitFilter setEnabled:YES];
        [self.mediaType setEnabled:YES];
        [self.storeCountry setEnabled:YES];
        [self.searchTerm setEnabled:YES];
        [self.lookupID setEnabled:NO];
        [self.mediaType selectItemAtIndex:0];
        [self.storeCountry selectItemAtIndex:0];
        [self.searchURL setTheLookupID:@""];
        [self.lookupID setStringValue:@""];
    }
}

- (NSString *)convertCountryToISO:(NSString *)countryName {
    if ([countryName isEqualToString: @"United Kingdom"]) {
        return @"&country=gb";
    }
    else if ([countryName isEqualToString: @"United States"]) {
        return @"&country=us";
    }
    else if ([countryName isEqualToString:@"United Arab Emirates"]) {
        return @"&country=ae";
    }
    return 0;
}

- (NSString *)convertMediaType:(NSString *)humanReadableMediaType {
    if ([humanReadableMediaType isEqualToString: @"All"]) {
        return @"&media=all";
    }
    else if ([humanReadableMediaType isEqualToString: @"Movie"]) {
        return @"&media=movie";
    }
    else if ([humanReadableMediaType isEqualToString:@"Short Film"]) {
        return @"&media=shortFilm";
    }
    else if ([humanReadableMediaType isEqualToString:@"TV Show"]) {
        return @"&media=tvShow";
    }
    else if ([humanReadableMediaType isEqualToString:@"Music"]) {
        return @"&media=music";
    }
    else if ([humanReadableMediaType isEqualToString:@"Music Video"]) {
        return @"&media=musicVideo";
    }
    else if ([humanReadableMediaType isEqualToString:@"Podcast"]) {
        return @"&media=podcast";
    }
    else if ([humanReadableMediaType isEqualToString:@"Audiobook"]) {
        return @"&media=audiobook";
    }
    else if ([humanReadableMediaType isEqualToString:@"iBook"]) {
        return @"&media=ebook";
    }
    else if ([humanReadableMediaType isEqualToString:@"Software"]) {
        return @"&media=software";
    }
    return 0;
}

- (void)updateUI {
    [self updateSearchTerm:self.searchTerm];
    [self updateLookupID:self.lookupID];
}

- (void)downloadEngine:(NSString *)APISearchURLString {
    // Use Grand Central Dispatch to handle threading
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self artworkResults] removeAllObjects];
        [[self resultsView] reloadData];
        NSURL *JSONURL = [[NSURL alloc] initWithString:APISearchURLString];
        NSData *JSONResults = [NSData dataWithContentsOfURL:JSONURL];
        NSDictionary *decodedJSONResults = [NSJSONSerialization JSONObjectWithData:JSONResults options:NSJSONReadingMutableContainers & NSJSONReadingMutableLeaves error:NULL];
        NSString *downloadLoc = [self.searchURL theDownloadLocation];
        for (int i = 0; i < [[decodedJSONResults objectForKey:@"results"] count]; i++) {
            NSString *extension = [[[[[decodedJSONResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"artworkUrl100"] lastPathComponent] pathExtension];
            NSString *fileName;
            if ([[[decodedJSONResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"trackName"] == nil) {
                // Albums and such
                fileName = [[[[[decodedJSONResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"collectionName"] stringByReplacingOccurrencesOfString:@"/" withString:@"OR"] stringByReplacingOccurrencesOfString:@":" withString:@" -"];
            } else {
                // Single entities
                fileName = [[[[[decodedJSONResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"trackName"] stringByReplacingOccurrencesOfString:@"/" withString:@"OR"] stringByReplacingOccurrencesOfString:@":" withString:@" -"];
            }
            NSString *downloadPath = [[NSString alloc] initWithString:[[downloadLoc stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:extension]];
            // NSLog(@"%@", downloadPath);
            NSImage *pictureFullSize = [[NSImage alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:[[[[decodedJSONResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"artworkUrl100"] stringByReplacingOccurrencesOfString:@".100x100-75" withString:@""]]];
			if (!pictureFullSize) {
				NSImage *picture600px = [[NSImage alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:[[[[decodedJSONResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"artworkUrl100"] stringByReplacingOccurrencesOfString:@".100x100-75" withString:@".600x600-75"]]];
				if (!picture600px) {
					NSImage *picture300px = [[NSImage alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:[[[[decodedJSONResults objectForKey:@"results"] objectAtIndex:i] objectForKey:@"artworkUrl100"] stringByReplacingOccurrencesOfString:@".100x100-75" withString:@".300x300-75"]]];
					if (!picture300px) {
						break;
					}
					else {
						DRTArtworkResult *res = [[DRTArtworkResult alloc] initWithTitle:[fileName stringByAppendingString:@"\n\n300px"] image:picture300px andDownloadTo:downloadPath];
						[artworkResults addObject:res];
					}
				}
				else {
					DRTArtworkResult *res = [[DRTArtworkResult alloc] initWithTitle:[fileName stringByAppendingString:@"\n\n600px"] image:picture600px andDownloadTo:downloadPath];
					[artworkResults addObject:res];
				}
			}
			else {
				DRTArtworkResult *res = [[DRTArtworkResult alloc] initWithTitle:[fileName stringByAppendingString:@"\n\nFull size"] image:pictureFullSize andDownloadTo:downloadPath];
				[artworkResults addObject:res];
			}
            // Make sure function is done in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self resultsView] reloadData];
            });
        }
    });
}

// Table View Delegate methods
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    DRTTableCellView *view = [tableView makeViewWithIdentifier:@"artResult" owner:self];
    view.textField.stringValue = [[artworkResults objectAtIndex:row] artworkTitle];
    view.imageView.image = [[artworkResults objectAtIndex:row] artworkImage];
	view.dlButton.dlPath = [[artworkResults objectAtIndex:row] downloadTo];
    return view;
}

// Table View Data Source methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [artworkResults count];
}
@end

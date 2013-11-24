//
//  PictureConnection.h
//  dArt
//
//  Created by Habib A on 12/02/2013.
//  Copyright (c) 2013 alAmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRTPictureConnection : NSURLConnection <NSURLConnectionDelegate> {
    NSURLConnection *connection;
    NSInteger picStatusCode;
    NSMutableData *picData;
    NSString *downloadToParam;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)setupConnection:(NSURLRequest *)request downloadTo:(NSString *)pathFileExtString;
@end
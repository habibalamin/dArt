//
//  DRTPictureConnection.m
//  dArt
//
//  Created by Habib A on 12/02/2013.
//  Copyright (c) 2013 alAmin. All rights reserved.
//

#import "DRTPictureConnection.h"

@implementation DRTPictureConnection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    picStatusCode = [response statusCode];
    [picData setLength:0];
    if ([response statusCode] != 200) {
        [self cancel];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [picData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (picStatusCode == 200) {
        [picData writeToFile:downloadToParam atomically:YES];
        NSLog(@"Succeeded! Received %ld bytes of data",(unsigned long)[picData length]);
    } else {
        NSLog(@"Failed with HTTP status code %ld!", (long)picStatusCode);
    }
}
- (void)setupConnection:(NSURLRequest *)request downloadTo:(NSString *)pathFileExtString{
    NSURLConnection *pictureConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (pictureConnection) {
        picData = [NSMutableData new];
        downloadToParam = pathFileExtString;
    }
}
@end

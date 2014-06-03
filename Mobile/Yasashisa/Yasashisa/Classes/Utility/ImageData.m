//
//  imageData.m
//  PhotoUploader
//
//  Created by 楊野 勇智 on 2012/09/04.
//  Copyright (c) 2012年 salesforce.com. All rights reserved.
//

#import "ImageData.h"

@implementation ImageData
@synthesize folderId;
@synthesize image;
@synthesize bs64;
@synthesize delegate;
@synthesize error;
@synthesize response;
@synthesize docId;

static ImageData *_instance;

+(id)getInstance {
    if (_instance == nil) {
        _instance = [[ImageData alloc] init];
    }
    return _instance;
}

+(id)refreshInstance
{
    _instance = [[ImageData alloc] init];
    return _instance;
}

- (void)upload
{
    if (self.bs64 != nil) {
        [self uploadImageToSfdc];
    }
}

- (void)uploadImageToSfdc
{
    NSDate *today;
    today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    
    NSString *body = self.bs64;
    NSString *contentType = @"image/jpeg";
    NSString *description = @"";
    NSString *developerName = [[NSString alloc] initWithFormat:@"PHOTO_%@", [formatter stringFromDate:today]];
    NSString *folder = self.folderId;
    NSString *isPublic = @"true";
    NSString *keywords = @"";
    NSString *name = developerName;
    
    NSArray *apinames = [[NSArray alloc] initWithObjects:
                         @"Body",
                         @"ContentType",
                         @"Description",
                         @"DeveloperName",
                         @"FolderId",
                         @"IsPublic",
                         @"Keywords",
                         @"Name",
                         nil];
    NSArray *values = [[NSArray alloc] initWithObjects:
                       body,
                       contentType,
                       description,
                       developerName,
                       folder,
                       isPublic,
                       keywords,
                       name,
                       nil];
    
    NSDictionary *postData = [[NSDictionary alloc] initWithObjects:values forKeys:apinames];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    SFRestAPI *api = [SFRestAPI sharedInstance];
    SFRestRequest *request = [api requestForCreateWithObjectType:@"Document" fields:postData];
    [api send:request delegate:self];
    
}

- (void)request:(SFRestRequest *)request didFailLoadWithError:(NSError *)error {
    [self endNetworkAcktivity];
    self.error = error;
    if (self.delegate != nil) {
        [self.delegate failed:self];
    }
}
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    [self endNetworkAcktivity];
    self.response = jsonResponse;
    self.docId = [jsonResponse objectForKey:@"id"];
    if (self.delegate != nil) {
        [self.delegate uploaded:self];
    }
}
- (void)requestDidCancelLoad:(SFRestRequest *)request {
    [self endNetworkAcktivity];
}
- (void)requestDidTimeout:(SFRestRequest *)request {
    [self endNetworkAcktivity];
}
- (void)endNetworkAcktivity {
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}

@end

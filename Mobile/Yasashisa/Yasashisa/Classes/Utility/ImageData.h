//
//  imageData.h
//  PhotoUploader
//
//  Created by 楊野 勇智 on 2012/09/04.
//  Copyright (c) 2012年 salesforce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "SfdcImageUploadDelegate.h"

@interface ImageData : NSObject<SFRestDelegate>

@property (nonatomic, retain) NSString* folderId;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *bs64;
@property (nonatomic, retain) NSString *docId;
@property (nonatomic, retain) id<SfdcImageUploadDelegate> delegate;
@property (nonatomic, retain)NSDictionary *response;
@property (nonatomic, retain) NSError *error;

+ (id)getInstance;
+ (id)refreshInstance;
- (void) upload;

@end

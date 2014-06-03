//
//  ObjectDescriptor.m
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import "ObjectDescriptor.h"

@implementation ObjectDescriptor

static ObjectDescriptor *_instance;

- (id)init
{
    self = [super init];
    self.objects = [[NSMutableDictionary alloc] init];
    return self;
}

+(ObjectDescriptor*)sharedInstance
{
    if (_instance == nil) {
        _instance = [[ObjectDescriptor alloc] init];
    }
    return _instance;
}

- (NSDictionary*)getDescription:(NSString *)sobject
{
    return self.objects[sobject];
}

- (void)describe:(NSString *)sobject completion:(void (^)(NSDictionary *description))block
{
    SFRestAPI *api = [SFRestAPI sharedInstance];
    SFRestRequest *request = [api requestForDescribeWithObjectType:sobject];
    [api sendRESTRequest:request
               failBlock:^(NSError* error)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        });
    }
           completeBlock:^(id jsonResponse)
    {
        NSString *name = jsonResponse[@"name"];
        self.objects[name] = jsonResponse;
        if (block != nil) {
            block(jsonResponse);
        }
    }];
}

@end

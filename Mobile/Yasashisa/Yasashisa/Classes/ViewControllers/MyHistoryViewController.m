//
//  MyHistoryViewController.m
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/03.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import "MyHistoryViewController.h"

@interface MyHistoryViewController ()

@end

@implementation MyHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self queryMyInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryMyInfo
{
    SFRestAPI *api = [SFRestAPI sharedInstance];
    SFRestRequest *request = [api requestForQuery:[[NSString alloc] initWithFormat:@"SELECT Id,Point__c FROM User WHERE Id = '%@'", api.coordinator.credentials.userId]];
    [api sendRESTRequest:request
               failBlock:^(NSError *error)
    {
    }
           completeBlock:^(id jsonResponse)
    {
        if ([jsonResponse[@"records"] isKindOfClass:[NSArray class]]) {
            NSArray *users = jsonResponse[@"records"];
            NSDictionary *user = nil;
            if (users.count > 0) user = users[0];
            if (user != nil) {
                NSNumber *point = user[@"Point__c"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.point.text = [[NSString alloc] initWithFormat:@"%d", [point intValue]];
                });
            }
        }
    }];
}

@end

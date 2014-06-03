//
//  MapMarkerDetailViewController.m
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import "MapMarkerDetailViewController.h"

@interface MapMarkerDetailViewController ()

@end

@implementation MapMarkerDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.record != nil) {
        self.subject.text = self.record[@"Subject__c"] != [NSNull null] ? self.record[@"Subject__c"] : @"";
        self.type.text = self.record[@"Type__c"] != [NSNull null] ? self.record[@"Type__c"] : @"";
        self.description.text = self.record[@"Description__c"] != [NSNull null] ? self.record[@"Description__c"] : @"";
        self.address.text = self.record[@"Address__c"] != [NSNull null] ? self.record[@"Address__c"] : @"";
        NSString *urlstr = [[NSString alloc] initWithFormat:@"%@", self.record[@"ImageUrl__c"]];
        NSURL *url = [NSURL URLWithString:urlstr];
        [self.imgView setImageWithURL:url];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

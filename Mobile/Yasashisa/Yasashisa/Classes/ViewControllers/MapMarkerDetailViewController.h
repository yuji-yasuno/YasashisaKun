//
//  MapMarkerDetailViewController.h
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetWorking.h"

@interface MapMarkerDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property(strong, nonatomic) NSDictionary *record;
- (IBAction)back:(UIButton *)sender;

@end

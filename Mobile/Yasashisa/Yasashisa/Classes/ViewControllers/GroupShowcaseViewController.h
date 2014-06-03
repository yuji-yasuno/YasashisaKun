//
//  GroupShowcaseViewController.h
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "GroupShowcaseCell.h"
#import "GroupChatterViewController.h"

@interface GroupShowcaseViewController : UICollectionViewController

@property (strong, nonatomic) NSArray *records;

@end

//
//  TypeMiniMenuViewController.h
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionSelectDelegate.h"

@interface TypeMiniMenuViewController : UITableViewController

@property (strong, nonatomic) id<CollectionSelectDelegate> delegate;
@property (strong, nonatomic) NSArray *options;

@end

//
//  ContainerViewController.h
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/05/30.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFrostedSidebar.h"
#import "NavigationUtil.h"

@interface ContainerViewController : UIViewController<RNFrostedSidebarDelegate>

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
- (IBAction)showMenu:(UIButton *)sender;

@end

//
//  GroupChatterViewController.h
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupChatterViewController : UIViewController

@property (strong, nonatomic) NSString *entityId;
@property (weak, nonatomic) IBOutlet UIWebView *chatterView;
- (IBAction)back:(UIButton *)sender;

@end

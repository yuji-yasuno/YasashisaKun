//
//  NavigationUtil.h
//  ReportMP
//
//  Created by 楊野 勇智 on 2014/05/29.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationUtil : NSObject

@property(strong, nonatomic) UINavigationController* navigation;
+(NavigationUtil*)sharedInstance;
@end

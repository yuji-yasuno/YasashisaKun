//
//  NavigationUtil.m
//  ReportMP
//
//  Created by 楊野 勇智 on 2014/05/29.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import "NavigationUtil.h"

@implementation NavigationUtil

static NavigationUtil *_instance;

+(NavigationUtil*)sharedInstance {
    if (_instance == nil) {
        _instance = [[NavigationUtil alloc] init];
    }
    return _instance;
}

@end

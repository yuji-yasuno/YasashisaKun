//
//  SfdcImageUploadDelegate.h
//  RoadReport
//
//  Created by 楊野 勇智 on 2012/10/17.
//  Copyright (c) 2012年 salesforce.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SfdcImageUploadDelegate <NSObject>

@required
-(void)uploaded:(id)imgData;
-(void)failed:(id)imgData;

@end

//
//  ObjectDescriptor.h
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectDescriptor : NSObject

@property (strong, nonatomic) NSMutableDictionary *objects;

+ (ObjectDescriptor*)sharedInstance;
- (NSDictionary*)getDescription:(NSString*)sobject;
- (void)describe:(NSString*)sobject completion:(void (^)(NSDictionary *description))block;

@end

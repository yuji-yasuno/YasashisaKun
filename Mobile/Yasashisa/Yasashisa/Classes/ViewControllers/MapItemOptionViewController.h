//
//  MapItemOptionViewController.h
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectDescriptor.h"
#import "CollectionSelectDelegate.h"
#import "CollectionItemCell.h"

@interface MapItemOptionViewController : UICollectionViewController 

@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) id<CollectionSelectDelegate> delegate;

@end

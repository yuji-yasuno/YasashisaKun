//
//  CollectionItemCell.h
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapItemOptionViewController.h"

@class MapItemOptionViewController;
@interface CollectionItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) MapItemOptionViewController *parent;

@end

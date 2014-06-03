//
//  MapItemOptionViewController.m
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import "MapItemOptionViewController.h"

@interface MapItemOptionViewController ()

@end

@implementation MapItemOptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.options != nil ? self.options.count + 1 : 0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"type_option_cell";
    CollectionItemCell *cell = (CollectionItemCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == self.options.count) {
        cell.title.text = @"すべて";
    }
    else {
        cell.title.text = self.options[indexPath.row];
    }
    
    return cell;
}

#pragma mark - My Custom Method
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(selectOption:)]) {
        if (indexPath.row == self.options.count) {
            [self.delegate selectOption:@"すべて"];
        }
        else {
            [self.delegate selectOption:self.options[indexPath.row]];
        }
    }
}

@end

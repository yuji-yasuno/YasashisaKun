//
//  GroupShowcaseViewController.m
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import "GroupShowcaseViewController.h"

@interface GroupShowcaseViewController ()

@end

@implementation GroupShowcaseViewController

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
    [self queryGroups];
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
    return self.records != nil ? self.records.count : 0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"group_icon_cell";
    GroupShowcaseCell *cell = (GroupShowcaseCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *item = self.records[indexPath.row];
    cell.groupTitle.text = item[@"Name"];
    
    SFRestAPI *api = [SFRestAPI sharedInstance];
    NSString *oauth_token = api.coordinator.credentials.accessToken;
    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@?oauth_token=%@",item[@"SmallPhotoUrl"], oauth_token];
    NSLog(@"%@", oauth_token);
    NSURL *url = [NSURL URLWithString:urlstr];
    [cell.groupImageView setImageWithURL:url];
    
    return cell;
}

#pragma mark - UIColectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = self.records[indexPath.row];
    GroupChatterViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"chatter"];
    next.entityId = item[@"Id"];
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - My Custom Methods


- (void)queryGroups
{
    SFRestAPI *api = [SFRestAPI sharedInstance];
    SFRestRequest *request = [api requestForQuery:@"SELECT Id,Name,SmallPhotoUrl FROM CollaborationGroup"];
    [api sendRESTRequest:request
               failBlock:^(NSError* error)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
           completeBlock:^(id jsonResponse)
    {
        self.records = [jsonResponse objectForKey:@"records"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end

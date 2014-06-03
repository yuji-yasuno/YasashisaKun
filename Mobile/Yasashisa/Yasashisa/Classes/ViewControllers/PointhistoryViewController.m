//
//  PointhistoryViewController.m
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/03.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import "PointhistoryViewController.h"

@interface PointhistoryViewController ()

@end

@implementation PointhistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startQuerySequence];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.records != nil ? self.records.count : 0;
    }
    else {
        return self.feeds != nil ? self.feeds.count : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"point_history_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    if (indexPath.section == 0) {
        NSDictionary *record = self.records[indexPath.row];
        NSDate *dt = [formatter dateFromString:record[@"CreatedDate"]];
        cell.detailTextLabel.text = [formatter2 stringFromDate:dt];
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"情報提供 : %@", record[@"Subject__c"] != [NSNull null] ? record[@"Subject__c"] : @""];
    }
    else {
        NSDictionary *feed = self.feeds[indexPath.row];
        NSDate *dt = [formatter dateFromString:feed[@"CreatedDate"]];
        cell.detailTextLabel.text = [formatter2 stringFromDate:dt];
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"投稿 : %@", feed[@"Body"] != [NSNull null] ? feed[@"Body"] : @""];
    }
    UIImage *coin = [UIImage imageNamed:@"coin.png"];
    cell.imageView.image = coin;
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"情報提供";
    }
    else {
        return @"コミュニティへのポスト";
    }
}

#pragma mark - My custom code
- (void)startQuerySequence
{
    [self queryRecentRecords:^(id jsonResponse)
    {
        self.records = jsonResponse[@"records"];
        [self queryRecentFeeds];
    }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)queryRecentRecords:(void (^)(id jsonResponse))oncomplete
{
    SFRestAPI *api = [SFRestAPI sharedInstance];
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT CreatedById,CreatedDate,Id,Name,Subject__c FROM SuppliedInformation__c WHERE CreatedById = '%@' ORDER BY CreatedDate DESC NULLS LAST", api.coordinator.credentials.userId];
    SFRestRequest *request = [api requestForQuery:query];
    [api sendRESTRequest:request
               failBlock:^(NSError *error)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
           completeBlock:oncomplete];
}

- (void)queryRecentFeeds
{
    SFRestAPI *api = [SFRestAPI sharedInstance];
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT Body,CreatedById,CreatedDate,Id FROM FeedItem WHERE CreatedById = '%@' ORDER BY CreatedDate DESC NULLS LAST", api.coordinator.credentials.userId];
    SFRestRequest *request = [api requestForQuery:query];
    [api sendRESTRequest:request
               failBlock:^(NSError *error)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
           completeBlock:^(id jsonResponse)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.feeds = jsonResponse[@"records"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}





















@end

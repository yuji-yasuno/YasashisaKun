//
//  MapViewController.m
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/05/30.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
{
    BOOL isFirstLocation;
}
@end

@implementation MapViewController

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

    isFirstLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;
    
    ObjectDescriptor *descriptor = [ObjectDescriptor sharedInstance];
    if ([descriptor getDescription:@"SuppliedInformation__c"] == nil) {
        [descriptor describe:@"SuppliedInformation__c"
                  completion:^(NSDictionary* sobject)
         {
             [self analyzeOption:sobject];
         }];
    }
    else {
        NSDictionary* sobject = [descriptor getDescription:@"SuppliedInformation__c"];
        [self analyzeOption:sobject];
    }
    
    [self queryAllRecords];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier compare:@"map_to_type_options"] == NSOrderedSame) {
        MapItemOptionViewController *next = (MapItemOptionViewController*)[segue destinationViewController];
        next.options = self.options;
        next.delegate = self;
    }
}

#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    NSDictionary *record = nil;
    for (NSInteger ii = 0; ii < self.markers.count; ii++) {
        if (marker == self.markers[ii]) {
            record = self.records[ii];
        }
    }
    if (record == nil) return;
    
    MapMarkerDetailViewController *next = (MapMarkerDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"map_marker_detail"];
    next.record = record;
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - CollectionSelectDelegate
- (void)selectOption:(NSString *)option
{
    NSLog(@"option = %@", option);
    if ([option compare:@"すべて"] == NSOrderedSame) {
        [self queryAllRecords];
    }
    else {
        [self queryByType:option];
    }
}

#pragma mark - My Custom Methods
- (void)createMapAtLat:(double)latitude Lng:(double)longitude withZoom:(double)zoom
{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude longitude:longitude zoom:zoom bearing:0 viewingAngle:30];
    self.mapView = [GMSMapView mapWithFrame:self.mapContainerView.bounds camera:camera];
    self.mapView.delegate = self;
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.mapContainerView addSubview:self.mapView];
}

- (void)queryAllRecords
{
    SFRestAPI *api = [SFRestAPI sharedInstance];
    SFRestRequest *request = [api requestForQuery:@"SELECT Address__c,Description__c,Enabled__c,Id,ImageDocId__c,ImageUrl__c,IsDeleted,LatLng__Latitude__s,LatLng__Longitude__s,Name,OwnerId,PinImageUrl__c,Subject__c,Type__c FROM SuppliedInformation__c WHERE IsDeleted = false AND Enabled__c = true"];
    [api send:request delegate:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)queryByType:(NSString*)type
{
    SFRestAPI *api = [SFRestAPI sharedInstance];
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT Address__c,Description__c,Enabled__c,Id,ImageDocId__c,ImageUrl__c,IsDeleted,LatLng__Latitude__s,LatLng__Longitude__s,Name,OwnerId,PinImageUrl__c,Subject__c,Type__c FROM SuppliedInformation__c WHERE IsDeleted = false AND Enabled__c = true AND Type__c = '%@'", type];
    SFRestRequest *request = [api requestForQuery:query];
    [api send:request delegate:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)setPinsOnMap
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.markers != nil && self.markers.count > 0) {
            for (GMSMarker *marker in self.markers) {
                marker.map = nil;
            }
        }
        
        self.markers = [[NSMutableArray alloc] init];
        for (NSDictionary *item in self.records) {
            
            double lat = 0;
            double lng = 0;
            if ([item objectForKey:@"LatLng__Latitude__s"] != [NSNull null]) {
                lat = [[item objectForKey:@"LatLng__Latitude__s"] doubleValue];
            }
            if ([item objectForKey:@"LatLng__Longitude__s"] != [NSNull null]) {
                lng = [[item objectForKey:@"LatLng__Longitude__s"] doubleValue];
            }
            if (lat == 0 && lng == 0) continue;
            
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(lat, lng);
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.title = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:@"Subject__c"]];
            marker.snippet = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:@"Address__c"]];
            marker.map = self.mapView;
            
            NSString *urlstr = [[NSString alloc] initWithFormat:@"%@", [item objectForKey:@"PinImageUrl__c"]];
            NSURL *url = [NSURL URLWithString:urlstr];
            NSData *dt = [NSData dataWithContentsOfURL:url];
            marker.icon = [[UIImage alloc] initWithData:dt];
            
            [self.markers addObject:marker];
            
            NSLog(@"Address__c = %@", [item objectForKey:@"Address__c"]);
            NSLog(@"Description__c = %@", [item objectForKey:@"Description__c"]);
            NSLog(@"Enabled__c = %@", [[item objectForKey:@"Enabled__c"] boolValue] ? @"true" : @"false");
            NSLog(@"Id = %@", [item objectForKey:@"Id"]);
            NSLog(@"ImageDocId__c = %@", [item objectForKey:@"ImageDocId__c"]);
            NSLog(@"ImageUrl__c = %@", [item objectForKey:@"ImageUrl__c"]);
            NSLog(@"IsDeleted = %@", [[item objectForKey:@"IsDeleted"] boolValue] ? @"true" : @"false");
            NSLog(@"LatLng__Latitude__s = %f", [[item objectForKey:@"LatLng__Latitude__s"] doubleValue]);
            NSLog(@"LatLng__Longitude__s = %f", [[item objectForKey:@"LatLng__Longitude__s"] doubleValue]);
            NSLog(@"Name = %@", [item objectForKey:@"Name"]);
            NSLog(@"OwnerId = %@", [item objectForKey:@"OwnerId"]);
            NSLog(@"PinImageUrl__c = %@", [item objectForKey:@"PinImageUrl__c"]);
            NSLog(@"Subject__c = %@", [item objectForKey:@"Subject__c"]);
            NSLog(@"Type__c = %@", [item objectForKey:@"Type__c"]);
            
        }
    
    });
}

- (void)analyzeOption:(NSDictionary*)sobject
{
    NSArray *fields = sobject[@"fields"];
    for (NSDictionary* field in fields) {
        if ([field[@"name"] isEqualToString:@"Type__c"]) {
            NSArray *pickvals = field[@"picklistValues"];
            NSMutableArray *values = [[NSMutableArray alloc] init];
            for (NSDictionary *pickval in pickvals) {
                NSString *value = pickval[@"value"];
                [values addObject:value];
            }
            self.options = values;
        }
    }
}

#pragma mark - SFReslDelegate
- (void)request:(SFRestRequest *)request didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)request:(SFRestRequest *)request didLoadResponse:(id)dataResponse
{
    self.records = [dataResponse objectForKey:@"records"];
    [self setPinsOnMap];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)requestDidCancelLoad:(SFRestRequest *)request
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)requestDidTimeout:(SFRestRequest *)request
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (isFirstLocation) {
        CLLocation *location = [locations lastObject];
        [self createMapAtLat:location.coordinate.latitude Lng:location.coordinate.longitude withZoom:9];
        isFirstLocation = NO;
    }
}

@end

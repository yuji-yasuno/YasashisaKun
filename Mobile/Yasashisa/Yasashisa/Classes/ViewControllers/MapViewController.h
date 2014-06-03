//
//  MapViewController.h
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/05/30.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "CollectionSelectDelegate.h"
#import "MapItemOptionViewController.h"
#import "ObjectDescriptor.h"
#import "MapMarkerDetailViewController.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate,SFRestDelegate,CollectionSelectDelegate,GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property(strong, nonatomic) GMSMapView *mapView;
@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) NSArray *records;
@property(strong, nonatomic) NSMutableArray *markers;
@property(strong, nonatomic) NSArray *options;

@end

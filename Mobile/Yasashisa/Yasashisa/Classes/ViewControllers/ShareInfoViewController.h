//
//  ShareInfoViewController.h
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CollectionSelectDelegate.h"
#import "ObjectDescriptor.h"
#import "TypeMiniMenuViewController.h"
#import "ImageData.h"
#import "NSData+Base64.h"
#import "SfdcImageUploadDelegate.h"

@interface ShareInfoViewController : UIViewController <CLLocationManagerDelegate,CollectionSelectDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,SfdcImageUploadDelegate,SFRestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property(strong, nonatomic) NSArray *options;
@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) CLLocation *currentLocation;
@property(strong, nonatomic) NSString *currentAddress;
- (IBAction)share:(id)sender;
- (IBAction)takePicture:(id)sender;

@end

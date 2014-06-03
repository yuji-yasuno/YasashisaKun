//
//  ShareInfoViewController.m
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import "ShareInfoViewController.h"

@interface ShareInfoViewController ()

@end

@implementation ShareInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.currentLocation
                   completionHandler:^(NSArray* placemarks, NSError *error)
    {
        if (placemarks != nil && placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSMutableString *address = [[NSMutableString alloc] init];
            
            NSString *zip = [placemark.addressDictionary objectForKey:@"ZIP"] != nil ? [[NSString alloc] initWithFormat:@"%@", [placemark.addressDictionary objectForKey:@"ZIP"]] : @"";
            NSString *county = [placemark.addressDictionary objectForKey:@"Country"] != nil ? [[NSString alloc] initWithFormat:@"%@", [placemark.addressDictionary objectForKey:@"Country"]] : @"";
            NSString *state = [placemark.addressDictionary objectForKey:@"State"] != nil ? [[NSString alloc] initWithFormat:@"%@", [placemark.addressDictionary objectForKey:@"State"]] : @"";
            NSString *city = [placemark.addressDictionary objectForKey:@"City"] != nil ? [[NSString alloc] initWithFormat:@"%@", [placemark.addressDictionary objectForKey:@"City"]] : @"";
            NSString *street = [placemark.addressDictionary objectForKey:@"Street"] != nil ? [[NSString alloc] initWithFormat:@"%@", [placemark.addressDictionary objectForKey:@"Street"]] : @"";
            [address appendFormat:@"%@ %@ %@ %@ %@", zip, county, state, city, street];
            self.currentAddress = address;
        }

    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier compare:@"plus_to_type_option"] == NSOrderedSame) {
        TypeMiniMenuViewController *next = (TypeMiniMenuViewController*)[segue destinationViewController];
        next.options = self.options;
        next.delegate = self;
    }
}

#pragma mark - CollectionSelectDelegate
- (void)selectOption:(NSString *)option
{
    self.type.text = option;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imgView.image = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - My Custom Method
- (void)shareWithImage
{
    NSString *folderId = [[NSUserDefaults standardUserDefaults] stringForKey:@"folder_id"];
    if (folderId == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"フォルダIDが指定されていません。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    ImageData *dt = [ImageData getInstance];
    dt.folderId = folderId;
    dt.image = self.imgView.image;
    NSData *imgdt = UIImageJPEGRepresentation(self.imgView.image, 1.0);
    dt.bs64 = [imgdt base64EncodedString];
    dt.delegate = self;
    [dt upload];
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

- (void)shareWithoutImage
{
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    [fields addObject:@"Subject__c"];
    [fields addObject:@"Description__c"];
    [fields addObject:@"Type__c"];
    [fields addObject:@"Enabled__c"];
    [fields addObject:@"Address__c"];
    [fields addObject:@"LatLng__Latitude__s"];
    [fields addObject:@"LatLng__Longitude__s"];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[[NSString alloc] initWithFormat:@"%@", self.subject.text]];
    [values addObject:[[NSString alloc] initWithFormat:@"%@", self.description.text]];
    [values addObject:[[NSString alloc] initWithFormat:@"%@", self.type.text]];
    [values addObject:[[NSString alloc] initWithFormat:@"%@", @"true"]];
    [values addObject:[[NSString alloc] initWithFormat:@"%@", self.currentAddress]];
    [values addObject:[[NSString alloc] initWithFormat:@"%f", self.currentLocation.coordinate.latitude]];
    [values addObject:[[NSString alloc] initWithFormat:@"%f", self.currentLocation.coordinate.longitude]];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:values forKeys:fields];
    
    SFRestAPI *api = [SFRestAPI sharedInstance];
    SFRestRequest *request = [api requestForCreateWithObjectType:@"SuppliedInformation__c" fields:data];
    [api send:request delegate:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - SfdcImageUploadDelegate
- (void)uploaded:(id)imgData
{
    ImageData *dt = (ImageData*)imgData;
    
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    [fields addObject:@"Subject__c"];
    [fields addObject:@"Description__c"];
    [fields addObject:@"Type__c"];
    [fields addObject:@"ImageDocId__c"];
    [fields addObject:@"Enabled__c"];
    [fields addObject:@"Address__c"];
    [fields addObject:@"LatLng__Latitude__s"];
    [fields addObject:@"LatLng__Longitude__s"];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[[NSString alloc] initWithFormat:@"%@", self.subject.text]];
    [values addObject:[[NSString alloc] initWithFormat:@"%@", self.description.text]];
    [values addObject:[[NSString alloc] initWithFormat:@"%@", self.type.text]];
    [values addObject:[[NSString alloc] initWithFormat:@"%@", dt.docId]];
    [values addObject:[[NSString alloc] initWithFormat:@"%@", @"true"]];
    [values addObject:[[NSString alloc] initWithFormat:@"%@", self.currentAddress]];
    [values addObject:[[NSString alloc] initWithFormat:@"%f", self.currentLocation.coordinate.latitude]];
    [values addObject:[[NSString alloc] initWithFormat:@"%f", self.currentLocation.coordinate.longitude]];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:values forKeys:fields];
    
    SFRestAPI *api = [SFRestAPI sharedInstance];
    SFRestRequest *request = [api requestForCreateWithObjectType:@"SuppliedInformation__c" fields:data];
    [api send:request delegate:self];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)failed:(id)imgData
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"写真のアップロードに失敗しました。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    return;
}

#pragma mark - SFRestDelegate
- (void)request:(SFRestRequest *)request didFailLoadWithError:(NSError *)error {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"完了" message:@"情報が共有されました。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Events
- (IBAction)share:(id)sender {
    if (self.imgView.image != nil) {
        [self shareWithImage];
    }
    else {
        [self shareWithoutImage];
    }
}

- (IBAction)takePicture:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.allowsEditing = YES;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
    
}
@end

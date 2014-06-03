//
//  GroupChatterViewController.m
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/06/01.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import "GroupChatterViewController.h"

@interface GroupChatterViewController ()

@end

@implementation GroupChatterViewController

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
    [self setCookies];
    [self showChatter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - My Custom Events
- (void)showChatter
{
    SFRestAPI *api = [SFRestAPI sharedInstance];
    SFOAuthCredentials *creadentials = [[api coordinator] credentials];
    NSString *mainUrlStrig = [[NSString alloc] initWithFormat:@"%@", creadentials.instanceUrl.absoluteString];
    NSString *partialUrlString = [[NSString alloc] initWithFormat: @"/apex/YasashisaMobileChatterPage?entityId=%@", self.entityId];
    NSString *fullUrlString = [[NSString alloc] initWithFormat:@"%@%@", mainUrlStrig, partialUrlString];
    NSURL *url = [NSURL URLWithString:fullUrlString];
    NSURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [self.chatterView loadRequest:request];
    
}

- (void)setCookies {
    SFRestAPI *api = [SFRestAPI sharedInstance];
    SFOAuthCredentials *creadentials = [[api coordinator] credentials];
    NSString *accessToken = [[[api coordinator] credentials] accessToken];
    // setting cookie
    NSDictionary *cookiedata1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"sid",
                                 NSHTTPCookieName,
                                 accessToken,
                                 NSHTTPCookieValue,
                                 creadentials.instanceUrl.host,
                                 NSHTTPCookieDomain,
                                 @"/",
                                 NSHTTPCookiePath, nil];
    NSDictionary *cookiedata2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"oid",
                                 NSHTTPCookieName,
                                 creadentials.organizationId,
                                 NSHTTPCookieValue,
                                 creadentials.instanceUrl.host,
                                 NSHTTPCookieDomain,
                                 @"/",
                                 NSHTTPCookiePath, nil];
    NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cookiedata1];
    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cookiedata2];
    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStore setCookie:cookie1];
    [cookieStore setCookie:cookie2];
}

#pragma mark - Events
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

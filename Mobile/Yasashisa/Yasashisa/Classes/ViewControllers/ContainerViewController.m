//
//  ContainerViewController.m
//  Yasashisa
//
//  Created by 楊野勇智 on 2014/05/30.
//  Copyright (c) 2014年 salesforce.com. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showMenu:(UIButton *)sender {
    
    NSArray *images = @[
                        [UIImage imageNamed:@"icon_home"],
                        [UIImage imageNamed:@"icon_map"],
                        [UIImage imageNamed:@"icon_plus"],
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        ];
    self.optionIndices = [[NSMutableIndexSet alloc] init];
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images
                                                         selectedIndices:self.optionIndices
                                                            borderColors:colors];
    callout.delegate = self;
    [callout show];
    
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    
    NavigationUtil *util = [NavigationUtil sharedInstance];
    if (util.navigation == nil) return;
    
    NSString *boardId;
    switch (index) {
        case 1:
            boardId = @"map";
            break;
            
        case 2:
            boardId = @"plus";
            break;
            
        default:
            break;
    }
    
    if (boardId != nil) {
        [util.navigation popToRootViewControllerAnimated:NO];
        UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:boardId];
        [util.navigation pushViewController:next animated:YES];
    }
    else {
        [util.navigation popToRootViewControllerAnimated:YES];
    }
    [sidebar dismissAnimated:YES];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    [self.optionIndices addIndex:index];
}

@end

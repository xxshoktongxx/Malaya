//
//  CheckInController.m
//  Ayala360
//
//  Created by martin magalong on 11/30/12.
//
//

#import "CheckInController.h"

@interface CheckInController ()

@end

@implementation CheckInController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//navigationbar left button method
- (void)onHome{
    self.customTabbar = [self.controllerManager getCustomTabbar];
    [self.customTabbar onHome];
}


- (IBAction)on4sqr:(id)sender{
    _controller = [self.controllerManager getMenuWithType:menuTypeCheckInFoursquare];
    [self.navigationController pushViewController:_controller animated:YES];
}

- (IBAction)onFacebook:(id)sender{
    _controller = [self.controllerManager getMenuWithType:menuTypeCheckInFacebook];
    [self.navigationController pushViewController:_controller animated:YES];
}


- (void)viewDidAppear:(BOOL)animated{
    UIImage *buttonImage = [UIImage imageNamed:@"buttonNavigationBack.png"];
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[backButton setTitle:@"Home" forState:UIControlStateNormal];
	backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	backButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
	[backButton addTarget:self action:@selector(onHome) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = btnBack;
}

@end

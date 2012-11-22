//
//  SocialShare.m
//  Ayala360
//
//  Created by Martin on 11/22/12.
//
//

#import "SocialShare.h"

@interface SocialShare ()

@end

@implementation SocialShare

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
    // Do any additional setup after loading the view from its nib.
}

- (void)onHome{
    self.customTabbar = [self.controllerManager getCustomTabbar];
    [self.customTabbar onHome];
}

#pragma mark - Default Methods
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

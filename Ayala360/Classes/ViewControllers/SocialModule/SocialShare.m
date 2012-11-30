//
//  SocialShare.m
//  Ayala360
//
//  Created by Martin on 11/22/12.
//
//

#import "SocialShare.h"
#import "AppManager.h"

@implementation SocialShare

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Private Methods
- (void)onFB{
    
}

- (void)onTwitter{
    
}

- (void)onHome{
    self.customTabbar = [self.controllerManager getCustomTabbar];
    [self.customTabbar onHome];
}

#pragma mark - Default Methods
- (void)viewDidLoad{
    [super viewDidLoad];
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

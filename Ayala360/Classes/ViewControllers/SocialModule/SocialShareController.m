//
//  SocialShare.m
//  Ayala360
//
//  Created by Martin on 11/22/12.
//
//

#import "SocialShareController.h"
#import <Twitter/Twitter.h>
#import "NSDictionary_JSONExtensions.h"
#import "AFHTTPRequestOperation.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

typedef enum {
    shareWithFoursqaure,
    shareWithFaceBook,
    shareWithTwitter,
}ShareWith;

@implementation SocialShareController{
    ShareWith _shareWith;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark Private Method
- (void)authenticate{
    [self renderSpinner];
    if (_shareWith == shareWithFaceBook) {
        _fbManager = [AppManager sharedInstance].fbManager;
        [_fbManager login:^(void){
            [self loadLocationManager];
        }];
    }
    else if(_shareWith == shareWithFoursqaure){
        _foursquare = [AppManager sharedInstance].foursquareManager;
        [_foursquare startAuthentication:^(BOOL success){
            if(success){
                _foursquare.delegate = self;
            }else{
                [self unrenderSpinner];
                [self loadLocationManager];
            }
        }];
    }
}

//navigationbar left button method
- (void)onHome{
    self.customTabbar = [self.controllerManager getCustomTabbar];
    [self.customTabbar onHome];
}

#pragma mark -
#pragma mark Display Methods
- (void)showViewShareButtonsBox{
    if(![[self.view subviews] containsObject:_viewShareButtons]){
        _viewShareButtons.center = self.view.center;
        [self.view addSubview:_viewShareButtons];
    }
//    _viewShareButtons.hidden = NO;
//    [self.view bringSubviewToFront:_viewShareButtons];
}
//
//- (void)hideViewShareButtonsBox{
//    _viewShareButtons.hidden = YES;
//}

- (void)showTableBox{
    if(![[self.view subviews] containsObject:_viewTableBox]){
        _viewTableBox.center = self.view.center;
        [self.view addSubview:_viewTableBox];
    }
    _viewTableBox.hidden = NO;
    [self.view bringSubviewToFront:_viewTableBox];
}

- (IBAction)hideTableBox:(id)sender{
    _viewTableBox.hidden = YES;
}

- (void)showMessageBox{
    if(![[self.view subviews] containsObject:_viewMessageBox]){
        _viewMessageBox.center = self.view.center;
        [self.view addSubview:_viewMessageBox];
    }
    _viewMessageBox.hidden = NO;
    [self.view bringSubviewToFront:_viewMessageBox];
}

- (IBAction)hideMessageBox:(id)sender{
    _viewMessageBox.hidden = YES;
}

- (void)renderSpinner{
    if (!_viewSpinnerContainer) {
        _viewSpinnerContainer = [[UIView alloc]init];
        _viewSpinnerContainer.frame = self.view.frame;
        _viewSpinnerContainer.backgroundColor = [UIColor blackColor];
        _viewSpinnerContainer.alpha = 0.5;
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = _viewSpinnerContainer.center;
        [spinner startAnimating];
        [_viewSpinnerContainer addSubview:spinner];
        [self.view addSubview:_viewSpinnerContainer];
    }
    _viewSpinnerContainer.hidden = NO;
    [self.view bringSubviewToFront:_viewSpinnerContainer];
}

- (void)unrenderSpinner{
    _viewSpinnerContainer.hidden = YES;
}

- (void)updateUi{
    [_tableViewNearby reloadData];
}

#pragma mark -
#pragma mark User Actions
- (IBAction)onFacebook:(id)sender{
    _shareWith = shareWithFaceBook;
    if ([[[UIDevice currentDevice]systemVersion] hasPrefix:@"6"]) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled)
                    NSLog(@"Action cancelled!");
                else{
                    [self showAlert:@"Succes!"];
                    [self onHome];
                }
            };
            controller.completionHandler = myBlock;
            [controller setInitialText:@""];
            [self presentViewController:controller animated:YES completion:Nil];
        }
    }
    else if ([[[UIDevice currentDevice]systemVersion] hasPrefix:@"5"]){
        [self authenticate];
    }
}

- (IBAction)onFoursqaure:(id)sender{
    _shareWith = shareWithFoursqaure;
    [self authenticate];
}

- (IBAction)onTwitter:(id)sender{
    _shareWith = shareWithTwitter;
    if ([[[UIDevice currentDevice]systemVersion] hasPrefix:@"6"]) {
        if([SLComposeViewController instanceMethodForSelector:@selector(isAvailableForServiceType)] != nil)
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                NSLog(@"twitter available");
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                    if (result == SLComposeViewControllerResultCancelled)
                        NSLog(@"Action cancelled!");
                    else{
                        [self showAlert:@"Succes!"];
                        [self onHome];
                    }
                };
                [controller setCompletionHandler:myBlock];
                [controller setInitialText:@""];
                [self presentViewController:controller animated:YES completion:nil];
            }
        }
    }
    else if ([[[UIDevice currentDevice]systemVersion] hasPrefix:@"5"]){
        TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc]init];
        if([TWTweetComposeViewController canSendTweet]){
            [self presentModalViewController:twitter animated:YES];
        }
        else{
            [self showAlert:@"TWITTER NOT WORKING"];
        }
    }
}

- (IBAction)postMessage:(id)sender{
    [self renderSpinner];
    [_textViewMessage resignFirstResponder];
    if(_shareWith == shareWithFoursqaure){
        //Foursquare checkin with parameters
        NSString *objectId = [_selectedPlace objectForKey:@"id"];
        NSDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:objectId, @"venueId", @"public,facebook,twitter", @"broadcast",_textViewMessage.text?:@"",@"shout", nil];
        [_foursquare checkinWithParam:param];
    }
    else if(_shareWith == shareWithFaceBook){
        //Facebook checkin with parameters
        NSDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys: _textViewMessage.text?:@"", @"message", nil];
        [_fbManager publishStory:param callback:^(void){
            [self hideMessageBox:nil];
            [self hideTableBox:nil];
            [self unrenderSpinner];
        }];
    }
}



#pragma mark --
#pragma mark LocationManager
- (void)loadLocationManager{
    _location =  [AppManager sharedInstance].locationManager;
    [_location addObserver:self];
    [_location start];
}

#pragma mark Location Protocol
- (void)_locationManagerNotification:(CLLocation *)location{
    NSString *coor = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
    _currentLocation.latitude = location.coordinate.latitude;
    _currentLocation.longitude = location.coordinate.longitude;
    
    NSMutableDictionary *param = nil;
    if(_shareWith == shareWithFoursqaure){
        param = [NSMutableDictionary dictionaryWithObjectsAndKeys:coor, @"ll", nil];
        [_foursquare searchVenuesWithParam:param];
    }
    else if(_shareWith == shareWithFaceBook){
        [self showMessageBox];
        [self unrenderSpinner];
    }
}


#pragma mark - Facebook
#pragma mark - Foursqaure
#pragma mark Foursquare Delegates
- (void)_didSucceedRequest:(AFHTTPRequestOperation *)operation responseObject:(id)object{
    [self unrenderSpinner];
    NSDictionary *data = [NSDictionary dictionaryWithJSONData:object error:nil];
    NSString *requestUrl = [NSString stringWithFormat:@"%@",[[operation request]URL]];
    NSRange range;
    range = [requestUrl rangeOfString:@"venues/search"];
    if (range.location != NSNotFound) {
        NSLog(@"Succes on VENUE SEARCH");
        _listNearBy = [[[[data objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
        [self unrenderSpinner];
        [self showTableBox];
        [self updateUi];
    }
    range = [requestUrl rangeOfString:@"checkins/add"];
    if (range.location != NSNotFound) {
        // Show the result in an alert
        [[[UIAlertView alloc] initWithTitle:@"Result"
                                    message:@"Success!"
                                   delegate:self
                          cancelButtonTitle:@"OK!"
                          otherButtonTitles:nil]
         show];
        [_textViewMessage resignFirstResponder];
        [self hideMessageBox:nil];
        [self hideTableBox:nil];
        [self unrenderSpinner];
    }
}
- (void)_didFailRequest:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    NSLog(@"%@",error);
    [self unrenderSpinner];
}

#pragma mark Foursquare table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_listNearBy count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"Cell";
    
    NSString *name = (NSString *)[[_listNearBy objectAtIndex:indexPath.row] valueForKeyPath:@"name"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    cell.textLabel.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedPlace = [_listNearBy objectAtIndex:indexPath.row];
    [self showMessageBox];
}
#pragma mark - Twitter

#pragma mark -
#pragma mark Display methods
- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showViewShareButtonsBox];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    if (!CGRectContainsPoint(_textViewMessage.frame, location)) {
        [_textViewMessage resignFirstResponder];
    }
}
@end

//
//  CheckInTableView.m
//
//  Created by Martin on 11/27/12.
//  Copyright (c) 2012 Ripplewave. All rights reserved.
//

#import "CheckInTableView.h"
#import "AFHTTPRequestOperation.h"
#import "NSDictionary_JSONExtensions.h"
#import "MapAnnotation.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#define METERS_PER_MILE 150
#define TABLE_FRAME @"{{0, 150}, {320, 237}}"
@implementation CheckInTableView{
    /** Holds the infomation of selected place. */
    NSDictionary *_selectedPlace;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark Private Method
- (void)authenticate{
    [self renderSpinner];
    if (_checkIn == checkInFaceBook) {
        if ([[[UIDevice currentDevice]systemVersion] hasPrefix:@"6"]) {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                [self loadLocationManager];
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                    if (result == SLComposeViewControllerResultCancelled)
                        NSLog(@"Action cancelled!");
                    else{
                        [self showAlert:@"Succes!"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    [controller dismissViewControllerAnimated:YES completion:Nil];
                };
                controller.completionHandler = myBlock;
                [controller setInitialText:_textViewShout.text];
                //            [controller addURL:[NSURL URLWithString:@"http://www.mobile.safilsunny.com"]];
                //            [controller addImage:[UIImage imageNamed:@"fb.png"]];
                [self presentViewController:controller animated:YES completion:Nil];
            }
        }
        else if ([[[UIDevice currentDevice]systemVersion] hasPrefix:@"5"]){
            [self renderTable];
            _fbManager = [AppManager sharedInstance].fbManager;
            [_fbManager login:^(void){
                [self loadLocationManager];
            }];
        }
    }
    else if( _checkIn == checkInFoursqaure){
        [self renderTable];
        _foursquare = [AppManager sharedInstance].foursquareManager;
        [_foursquare startAuthentication:^(BOOL success){
            if (success) {
                _foursquare.delegate = self;
                [self loadLocationManager];
            }
            else
                [self.navigationController popToRootViewControllerAnimated:NO];

        }];
    }
}

- (void)postCheckIn{
    //Bring the overlay in front;
    [self unrenderSpinner];
    [self renderSpinner];
    if(_checkIn == checkInFoursqaure){
        //Foursquare checkin with parameters
        NSString *objectId = [_selectedPlace objectForKey:@"id"];
        NSDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:objectId, @"venueId", @"public,facebook,twitter", @"broadcast",_textViewShout.text?:@"",@"shout", nil];
        [_foursquare checkinWithParam:param];
    }
    else if(_checkIn == checkInFaceBook){
        //Facebook checkin with parameters
        NSString *objectId = [_selectedPlace objectForKey:@"id"];
        NSDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:objectId, @"place", _textViewShout.text?:@"", @"message", nil];
        [_fbManager publishStory:param callback:^(void){
            [_textViewShout resignFirstResponder];
            [self unrenderCheckInView];
        }];
    }
}

- (void)cancelCheckIn{
    [self unrenderCheckInView];
}

#pragma mark Display methods
- (void)renderNearByPlaces{
    NSString * name = nil;
    NSString * address = nil;
    NSNumber * latitude = nil;
    NSNumber * longitude = nil;
    
    for (int x = 0; x<_listNearBy.count; x++) {
        NSDictionary *data = [_listNearBy objectAtIndex:x];
        name = [data objectForKey:@"name"];
        if(_checkIn == checkInFoursqaure){
            latitude = [[data objectForKey:@"location"] objectForKey:@"lat"];
            longitude = [[data objectForKey:@"location"] objectForKey:@"lng"];
        }
        else if (_checkIn == checkInFaceBook){
            latitude = [[data objectForKey:@"location"] objectForKey:@"latitude"];
            longitude = [[data objectForKey:@"location"] objectForKey:@"longitude"];
        }
        address = [[data objectForKey:@"location"] objectForKey:@"address"];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        MapAnnotation *annotation = [[MapAnnotation alloc] initWithName:name address:address index:x coordinate:coordinate] ;
        [_mapview addAnnotation:annotation];
    }
}

- (void)renderTable{
    if (!_tableViewNearby) {
        _tableViewNearby = [[UITableView alloc]init];
        _tableViewNearby.delegate = self;
        _tableViewNearby.dataSource = self;
        _tableViewNearby.frame = CGRectFromString(TABLE_FRAME);
        _tableViewNearby.backgroundColor = [UIColor redColor];
        [self.view addSubview:_tableViewNearby];
    }
}

- (void)renderCheckInView{
    [self renderSpinner];
    if (!_viewCheckInShout) {
        _viewCheckInShout = [[UIView alloc]init];
        _viewCheckInShout.frame = self.view.frame;
        _viewCheckInShout.frame = CGRectInset(self.view.frame, 50, 50);
        _viewCheckInShout.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_viewCheckInShout];
        
        _textViewShout = [[UITextView alloc]init];
        _textViewShout.frame = CGRectMake(20, 10, _viewCheckInShout.frame.size.width-40, 100);
        [_viewCheckInShout addSubview:_textViewShout];
        
        UIButton *buttonPost = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buttonPost.frame = CGRectMake(_textViewShout.center.x, 130, 50, 30);
        [buttonPost setTitle:@"Post" forState:UIControlStateNormal];
        [buttonPost addTarget:self action:@selector(postCheckIn) forControlEvents:UIControlEventTouchUpInside];
        [_viewCheckInShout addSubview:buttonPost];
        
        UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buttonCancel.frame = CGRectMake(0, 130, 50, 30);
        [buttonCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [buttonCancel addTarget:self action:@selector(cancelCheckIn) forControlEvents:UIControlEventTouchUpInside];
        [_viewCheckInShout addSubview:buttonCancel];
    }
    _viewCheckInShout.hidden = NO;
    [self.view bringSubviewToFront:_viewCheckInShout];
}

- (void)unrenderCheckInView{
    [self unrenderSpinner];
    _viewCheckInShout.hidden = YES;
}

- (void)renderSpinner{
    if (!_viewSpinnerContainer && ![_mapview.annotations lastObject]) {
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
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_currentLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [_mapview regionThatFits:viewRegion];
    [_mapview setRegion:adjustedRegion animated:YES];
    [_tableViewNearby reloadData];
}


#pragma mark -
#pragma mark MKMap delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    _listAnnotation = [[NSMutableArray alloc]init];
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapview dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image=[UIImage imageNamed:@"buttonCheck.png"];//here we use a nice image instead of the default pins
        return annotationView;
    }
    return nil;    
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    _listAnnotation = views;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(NA, 4_0){
    MapAnnotation *annotation = [view annotation];
    if([annotation respondsToSelector:@selector(setIndex:)]){
        [_listNearBy objectAtIndex:annotation.index];
        
        //Find the selected place in the nearby table;
        NSIndexPath *index = [NSIndexPath indexPathForRow:annotation.index inSection:0];
        [_tableViewNearby scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    //Fetch nearby places based on checkin type
    if (_checkIn == checkInFaceBook) {
        if([[[UIDevice currentDevice]systemVersion] hasPrefix:@"6"]){
            [self updateUi];
            [self unrenderSpinner];
            [self renderNearByPlaces];
        }
        else if ([[[UIDevice currentDevice]systemVersion] hasPrefix:@"5"]){
            param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     @"place",@"type",coor,@"center",@"1000",@"distance",
                     nil];
            [_fbManager getNearBy:param callback:^(id result){
                _listNearBy = [result objectForKey:@"data"];
                [self updateUi];
                [self unrenderSpinner];
                [self renderNearByPlaces];
            }];
        }
    }
    else if(_checkIn == checkInFoursqaure){
        param = [NSMutableDictionary dictionaryWithObjectsAndKeys:coor, @"ll", nil];
        [_foursquare searchVenuesWithParam:param];
    }
}

#pragma mark - 
#pragma mark Tableview Delegate
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
    NSString *street = @"", *city = @"", *state = @"";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    street = (NSString *)[[_listNearBy objectAtIndex:indexPath.row] valueForKeyPath:@"location.address"];
    
    city = (NSString *)[[_listNearBy objectAtIndex:indexPath.row] valueForKeyPath:@"location.city"];
    state = (NSString *)[[_listNearBy objectAtIndex:indexPath.row] valueForKeyPath:@"location.state"];
    
    
    
    cell.textLabel.text = name;    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@, %@", street, city, state];
    
    if (street == nil || city == nil || state == nil){
         cell.detailTextLabel.text = @"";
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    _selectedPlace = [_listNearBy objectAtIndex:indexPath.row];
    [self renderCheckInView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //Find selected place in map
    for (MapAnnotation *temp in _mapview.annotations) {
        if ([temp isKindOfClass:[MapAnnotation class]]) {
            if (temp.index == indexPath.row) {
                [_mapview selectAnnotation:temp animated:YES];
            }
        }
    }
}

#pragma mark - 
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
        [self updateUi];
        [self unrenderSpinner];
        [self renderNearByPlaces];
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
        [_textViewShout resignFirstResponder];
        [self unrenderCheckInView];
    }
}
- (void)_didFailRequest:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    NSLog(@"%@",error);
    [self unrenderSpinner];
}

#pragma mark -
#pragma mark Default Methods
- (void)viewDidLoad{
    [super viewDidLoad];
    [self authenticate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_foursquare) {
        _foursquare.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_location removeObserver:self];
    _foursquare.delegate = nil;
}

@end

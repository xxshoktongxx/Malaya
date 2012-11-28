//
//  CheckInController.m
//  Foursquare3
//
//  Created by Martin on 11/27/12.
//  Copyright (c) 2012 Ripplewave. All rights reserved.
//

#import "CheckInController.h"
#import "AppDelegate.h"
#import "NSDictionary_JSONExtensions.h"

@implementation CheckInController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - Private Method
- (void)authenticate{
    _foursquare = [AppManager sharedInstance].foursquareManager;
    [_foursquare startAuthentication:^{
        [self unrenderSpinner];
        [self loadLocationManager];
    }];
}

- (void)searchVenues:(NSString *)location {
    NSDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"40.7,-74", @"ll", nil];
    [[Foursquare sharedInstance]requestWithPath:@"venues/search" methodType:typeGet parameters:param success:_success fail:_fail];
//    [self prepareForRequest];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"40.7,-74", @"ll", nil];
//    _request = [_foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
//    [_request start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)checkin:(NSString *)objectId{
//    [self prepareForRequest];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:objectId, @"venueId", @"public", @"broadcast", nil];
//    _request = [_foursquare requestWithPath:@"checkins/add" HTTPMethod:@"POST" parameters:parameters delegate:self];
//    [_request start];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//- (void)prepareForRequest {
//    [self cancelRequest];
//    _meta = nil;
//    _notifications = nil;
//    _response = nil;
//}
//
//- (void)cancelRequest {
//    if (_request) {
//        _request.delegate = nil;
//        [_request cancel];
//        _request = nil;
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    }
//}
//#pragma mark -  BZFoursquareRequestDelegate
//- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
//    _meta = request.meta;
//    _notifications = request.notifications;
//    _response = request.response;
//    if([[_request path] isEqualToString:@"venues/search"]){
//        _listNearBy = [_response objectForKey:@"venues"];
//        [_tableViewNearby reloadData];
//    }
//    else if([[_request path]isEqualToString:@"checkins/add"]){
//        NSLog(@"You have checked-in.");
//    }
//    _request = nil;
//}
//
//- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
//    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[error userInfo] objectForKey:@"errorDetail"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
//    [alertView show];
//    _meta = request.meta;
//    _notifications = request.notifications;
//    _response = request.response;
//    _request = nil;
//}

//#pragma mark - BZFoursquareSessionDelegate
//- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare {
//    //add spinner before this method
//    NSLog(@"foursquareDidAuthorize:");
//}
//
//- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo {
//    NSLog(@"%s: %@", __PRETTY_FUNCTION__, errorInfo);
//}


- (void)renderSpinner{
    if (!_viewSpinnerContainer) {
        _viewSpinnerContainer = [[UIView alloc]init];
        _viewSpinnerContainer.frame = self.view.frame;
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        [_viewSpinnerContainer addSubview:spinner];
        [self.view addSubview:_viewSpinnerContainer];
    }
}

- (void)unrenderSpinner{
    [_viewSpinnerContainer removeFromSuperview];
    _viewSpinnerContainer = nil;
}

//navigationbar left button method
- (void)onHome{
    self.customTabbar = [self.controllerManager getCustomTabbar];
    [self.customTabbar onHome];
}


#pragma mark - LocationManager
- (void)loadLocationManager{
    _location = [[LocationManager alloc]init];
    [_location addObserver:self];
    [_location start];
}
#pragma mark Location Protocol
- (void)_locationManagerNotification:(CLLocation *)location{
    NSLog(@"DID RECEIVE NOTIFICATION");
    NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    [self searchVenues:[NSString stringWithFormat:@"%@,%@",latitude,longitude]];
}

#pragma mark - Tableview Delegate
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *objectId = [[_listNearBy objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self checkin:objectId];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Default Methods
- (void)viewDidLoad{
    [super viewDidLoad];
    [self authenticate];
    
    _success = ^void(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"success");
        //[self didSucceedRequest:operation responseObject:responseObject];
        [self unrenderSpinner];
        NSDictionary *data = [NSDictionary dictionaryWithJSONData:responseObject error:nil];
        _listNearBy = [[[[data objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
        [_tableViewNearby reloadData];
    };
    
    _fail = ^void(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%@",error);
        //        [self didFailRequest:operation error:error];
        [self unrenderSpinner];
    };

}

- (void)viewWillAppear:(BOOL)animated{
    _tableViewNearby = [[UITableView alloc]init];
    _tableViewNearby.delegate = self;
    _tableViewNearby.dataSource = self;
    _tableViewNearby.frame = (CGRect){.origin=CGPointMake(0, 0),.size=CGSizeMake(320, 387)};
    _tableViewNearby.backgroundColor = [UIColor redColor];
    [self.view addSubview:_tableViewNearby];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self renderSpinner];
}


@end

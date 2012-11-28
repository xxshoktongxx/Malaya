//
//  CheckInTableView.m
//
//  Created by Martin on 11/27/12.
//  Copyright (c) 2012 Ripplewave. All rights reserved.
//

#import "CheckInTableView.h"
#import "AFHTTPRequestOperation.h"
#import "NSDictionary_JSONExtensions.h"

@implementation CheckInTableView

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
    [_foursquare requestWithPath:@"venues/search" methodType:typeGet parameters:param success:_success fail:_fail];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)checkin:(NSString *)objectId{
    NSDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:objectId, @"venueId", @"public", @"broadcast", nil];
    
    [_foursquare requestWithPath:@"checkins/add" methodType:typePost parameters:param success:_success fail:_fail];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

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
    _location =  [AppManager sharedInstance].locationManager;
    [_location addObserver:self];
    [_location start];
}
#pragma mark Location Protocol
- (void)_locationManagerNotification:(CLLocation *)location{
    NSLog(@"User location found");
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
    
    //URLRequest "success" callback
    void(^success)(id,id) = ^void(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"success");
        [self unrenderSpinner];
        NSDictionary *data = [NSDictionary dictionaryWithJSONData:responseObject error:nil];
        NSString *requestUrl = [NSString stringWithFormat:@"%@",[[operation request]URL]];
        NSRange range;
        range = [requestUrl rangeOfString:@"venues/search"];
        if (range.location != NSNotFound) {
            NSLog(@"VENUE SEARCH");
            _listNearBy = [[[[data objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
            [_tableViewNearby reloadData];
        }
        range = [requestUrl rangeOfString:@"checkins/add"];
        if (range.location != NSNotFound) {
            NSLog(@"CHECKIN");
        }
    };
    _success = success;
    
    //URLRequest "fail" callback
    void(^fail)(id,id) = ^void(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%@",error);
        [self unrenderSpinner];
    };
    _fail = fail;
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

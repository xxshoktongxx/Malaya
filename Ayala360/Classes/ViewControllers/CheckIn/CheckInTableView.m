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

#define METERS_PER_MILE 150
#define TABLE_FRAME @"{{0, 150}, {320, 237}}"
@implementation CheckInTableView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - 
#pragma mark Private Method
- (void)authenticate{
    _foursquare = [AppManager sharedInstance].foursquareManager;
    [_foursquare startAuthentication:^{
        [self unrenderSpinner];
        [self loadLocationManager];
    }];
}

- (void)searchVenues:(NSString *)location {
    NSDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:location, @"ll", nil];
    [_foursquare requestWithPath:@"venues/search" methodType:typeGet parameters:param success:_success fail:_fail];
}

- (void)checkin:(NSString *)objectId{
    NSDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:objectId, @"venueId", @"public", @"broadcast", nil];
    [_foursquare requestWithPath:@"checkins/add" methodType:typePost parameters:param success:_success fail:_fail];
}

- (void)updateUi{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_currentLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [_mapview regionThatFits:viewRegion];
    [_mapview setRegion:adjustedRegion animated:YES];
}

//navigationbar left button method
- (void)onHome{
    self.customTabbar = [self.controllerManager getCustomTabbar];
    [self.customTabbar onHome];
}

#pragma mark Display methods
- (void)renderNearByPlaces{
    for (int x = 0; x<_listNearBy.count; x++) {
        NSString * name = [[_listNearBy objectAtIndex:x] objectForKey:@"name"];
        NSNumber * lat = [[[_listNearBy objectAtIndex:x] objectForKey:@"location"] objectForKey:@"lat"];
        NSNumber * lng = [[[_listNearBy objectAtIndex:x] objectForKey:@"location"] objectForKey:@"lng"];
        NSString * address = [[[_listNearBy objectAtIndex:x] objectForKey:@"location"] objectForKey:@"address"];       
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = lat.doubleValue;
        coordinate.longitude = lng.doubleValue;
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
}

- (void)unrenderSpinner{
    [_viewSpinnerContainer removeFromSuperview];
    _viewSpinnerContainer = nil;
}

#pragma mark - 
#pragma mark MKMap delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(NA, 4_0){
    MapAnnotation *annotation = [view annotation];
    [_listNearBy objectAtIndex:annotation.index];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:annotation.index inSection:0];
    [_tableViewNearby scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark -
#pragma mark LocationManager
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
    
    //For map render
    _currentLocation.latitude = location.coordinate.latitude;
    _currentLocation.longitude = location.coordinate.longitude;
    [self updateUi];
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

#pragma mark - 
#pragma mark Default Methods
- (void)viewDidLoad{
    [super viewDidLoad];
    [self authenticate];
    
    //URLRequest "success" callback
    void(^success)(id,id) = ^void(AFHTTPRequestOperation *operation, id responseObject){
        [self unrenderSpinner];
        NSDictionary *data = [NSDictionary dictionaryWithJSONData:responseObject error:nil];
        NSString *requestUrl = [NSString stringWithFormat:@"%@",[[operation request]URL]];
        NSRange range;
        range = [requestUrl rangeOfString:@"venues/search"];
        if (range.location != NSNotFound) {
            NSLog(@"Succes on VENUE SEARCH");
            _listNearBy = [[[[data objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
            [self renderNearByPlaces];
            [_tableViewNearby reloadData];
        }
        range = [requestUrl rangeOfString:@"checkins/add"];
        if (range.location != NSNotFound) {
            NSLog(@"Success on CHECKIN");
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
    [super viewWillAppear:animated];
    [self renderTable];
    [self renderSpinner];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

@end

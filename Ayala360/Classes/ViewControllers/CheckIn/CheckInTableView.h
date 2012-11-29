//
//  CheckInTableView.h
//
//  Created by Martin on 11/27/12.
//  Copyright (c) 2012 Ripplewave. All rights reserved.
//

#import "BaseController.h"
#import "AppManager.h"
#import <MapKit/MapKit.h>

@interface CheckInTableView : BaseController <UITableViewDataSource,UITableViewDelegate,LocationManagerProtocol,MKMapViewDelegate>{
    /** Holds the instance of table view for nearby places. */
    UITableView *_tableViewNearby;
    /** Hold the list of all nearby places. */
    NSArray *_listNearBy;
    
    /** Attributes for forsqaure */
    Foursquare          *_foursquare;
    UIView *_viewSpinnerContainer;
    void(^_success)(id,id);
    void(^_fail)(id,id);
    
    /** Attributes for map */
    IBOutlet MKMapView *_mapview;
    CLLocationCoordinate2D _currentLocation;
    CLLocationCoordinate2D _tempLocation;
    
    //Manager
    LocationManager *_location;
}
@end

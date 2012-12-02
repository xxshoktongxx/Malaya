//
//  CheckInTableView.h
//
//  Created by Martin on 11/27/12.
//  Copyright (c) 2012 Ripplewave. All rights reserved.
//

#import "BaseController.h"
#import "AppManager.h"
#import <MapKit/MapKit.h>


typedef enum {
    checkInFoursqaure,
    checkInFaceBook,
}CheckInType;

@interface CheckInTableView : BaseController <UITableViewDataSource,UITableViewDelegate,LocationManagerProtocol,MKMapViewDelegate,FoursquareDelegate>{
    /** Holds the instance of table view for nearby places. */
    UITableView *_tableViewNearby;
    /** Hold the list of all nearby places. */
    NSArray *_listNearBy;
    /** Overlay to indicate some are process are running and prevents any user interactions. */
    UIView *_viewSpinnerContainer;
    /** View in which message box (_textViewShot) resides. */
    UIView *_viewCheckInShout;
    /** TextView in which user inputs message to post. */
    UITextView *_textViewShout;
    
    /** Attributes for map */
    IBOutlet MKMapView *_mapview;
    CLLocationCoordinate2D _currentLocation;
    NSArray *_listAnnotation;
    
    //Manager
    Foursquare *_foursquare;
    LocationManager *_location;
    FacebookManager *_fbManager;
}
@property (nonatomic, assign) CheckInType checkIn;
@end

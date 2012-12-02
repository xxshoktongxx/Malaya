//
//  SocialShare.h
//  Ayala360
//
//  Created by Martin on 11/22/12.
//
//

#import "BaseController.h"
#import "AppManager.h"

@interface SocialShareController : BaseController<LocationManagerProtocol,FoursquareDelegate,UITableViewDataSource,UITableViewDelegate>{
    /** Overlay to indicate some are process are running and prevents any user interactions. */
    UIView *_viewSpinnerContainer;
    /** View in which message box (_textViewMessage) resides. */
    IBOutlet UIView *_viewMessageBox;
    /** TextView in which user inputs message to post. */
    IBOutlet UITextView *_textViewMessage;
    IBOutlet UIView *_viewShareButtons;
    CLLocationCoordinate2D _currentLocation;
    
    //For Foursquare use only
    /** View in which _tableView resides. */
    IBOutlet UIView *_viewTableBox;
    /** Tableview for nearby places. User cannot post message unless place is specified, */
    IBOutlet UITableView *_tableViewNearby;
    /** Holds the infomation of selected place. */
    NSDictionary *_selectedPlace;
    /** Hold the list of all nearby places. */
    NSArray *_listNearBy;

    //Manager
    Foursquare *_foursquare;
    LocationManager *_location;
    FacebookManager *_fbManager;
}
@end

//
//  CheckInFacebookTable.m
//  Ayala360
//
//  Created by martin magalong on 11/30/12.
//
//

#import "CheckInFacebookTable.h"

@interface CheckInFacebookTable ()

@end

@implementation CheckInFacebookTable

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - 
#pragma mark Facebook
- (void)refresh {
    // if the session is open, then load the data for our view controller
    if (FBSession.activeSession.isOpen) {
        // Default to Seattle, this method calls loadData
        //        [self searchDisplayController:nil shouldReloadTableForSearchScope:SampleLocationSeattle];
        // the actual network round-trip with Facebook; likewise for the other two locations
        self.locationCoordinate = CLLocationCoordinate2DMake(47.6097, -122.3331);
        [self loadData];
    } else {
        // if the session isn't open, we open it here, which may cause UX to log in the user
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          if (!error) {
                                              [self refresh];
                                          } else {
                                              [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                          message:error.localizedDescription
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil]
                                               show];
                                          }
                                      }];
    }
}

- (void)placePickerViewControllerSelectionDidChange:(FBPlacePickerViewController *)placePicker
{
    // FBSample logic
    // Here we see a use of the FBGraphPlace protocol, where our code can use dot-notation to
    // select name and location data from the selected place
    id<FBGraphPlace> place = placePicker.selection;
    
    // we'll use logging to show the simple typed property access to place and location info
    NSLog(@"place=%@, city=%@, state=%@, lat long=%@ %@",
          place.name,
          place.location.city,
          place.location.state,
          place.location.latitude,
          place.location.longitude);
}

#pragma mark FBPlacePickerDelegate methods
- (void)placePickerViewControllerDataDidChange:(FBPlacePickerViewController *)placePicker {
    [self.tableView reloadData];
}

#pragma mark - 
#pragma mark Default methods
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refresh];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.delegate = self;
}

@end

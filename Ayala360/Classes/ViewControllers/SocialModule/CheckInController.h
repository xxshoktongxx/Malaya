//
//  CheckInController.h
//  Foursquare3
//
//  Created by Martin on 11/27/12.
//  Copyright (c) 2012 Ripplewave. All rights reserved.
//

#import "BaseController.h"
#import "BZFoursquare.h"
#import "LocationManager.h"
#import "Foursquare.h"

@interface CheckInController : BaseController <UITableViewDataSource,UITableViewDelegate,FoursquareProtocol/*,BZFoursquareRequestDelegate,BZFoursquareSessionDelegate*/,LocationManagerProtocol>{
    UITableView *_tableViewNearby;
    NSArray *_listNearBy;
    LocationManager *_location;
    
    /** Attributes for forsqaure */
//    BZFoursquare        *_foursquare;
//    BZFoursquareRequest *_request;
    Foursquare          *_foursquare;
    UIView *_viewSpinnerContainer;
    void(^_success)(id,id);
    void(^_fail)(id,id);
//    NSDictionary        *_meta;
//    NSArray             *_notifications;
//    NSDictionary        *_response;
}
@end

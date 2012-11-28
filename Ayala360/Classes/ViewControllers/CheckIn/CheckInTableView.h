//
//  CheckInTableView.h
//
//  Created by Martin on 11/27/12.
//  Copyright (c) 2012 Ripplewave. All rights reserved.
//

#import "BaseController.h"
#import "AppManager.h"

@interface CheckInTableView : BaseController <UITableViewDataSource,UITableViewDelegate,LocationManagerProtocol>{
    UITableView *_tableViewNearby;
    NSArray *_listNearBy;
    LocationManager *_location;
    
    /** Attributes for forsqaure */
    Foursquare          *_foursquare;
    UIView *_viewSpinnerContainer;
    void(^_success)(id,id);
    void(^_fail)(id,id);
}
@end

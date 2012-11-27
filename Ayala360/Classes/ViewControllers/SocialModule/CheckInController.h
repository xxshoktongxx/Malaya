//
//  CheckInController.h
//  Foursquare3
//
//  Created by Martin on 11/27/12.
//  Copyright (c) 2012 Ripplewave. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableViewNearby;
}
@property (nonatomic, retain)NSMutableArray *listNearBy;
@end

//
//  AppManager.h
//  ESBG
//
//  Created by Martin on 11/12/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Flurry.h"
#import "ViewControllerManager.h"
#import "Dijkstra.h"
#import "SqlManager.h"
#import "DataManager.h"

@interface AppManager : NSObject
@property (nonatomic, retain) __strong ViewControllerManager *controllerManager;
@property (nonatomic, retain) __strong Dijkstra *dijkstra;
@property (nonatomic, retain) __strong SqlManager *sqlManager;
@property (nonatomic, retain) __strong DataManager *dataManager;

+(AppManager *)sharedInstance;
- (void)loadManagers;
@end

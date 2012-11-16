//
//  AppManager.h
//  ESBG
//
//  Created by Martin on 11/12/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Flurry.h"
#import "RootViewController.h"
#import "Dijkstra.h"
#import "SqlManager.h"

@interface AppManager : NSObject
@property (nonatomic, retain) __strong RootViewController *rootController;
@property (nonatomic, retain) __strong Dijkstra *dijkstra;
@property (nonatomic, retain) __strong SqlManager *sqlManager;

+(AppManager *)sharedInstance;
- (void)loadManagers;
@end

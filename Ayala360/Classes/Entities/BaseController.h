//
//  BaseController.h
//  ESBG
//
//  Created by Martin on 11/8/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerManager.h"
#import "AppManager.h"
#import "DataManager.h"
#import "CustomTabbar.h"

@interface BaseController : UIViewController
@property (nonatomic, retain)CustomTabbar *customTabbar;
@property (nonatomic,retain) AppManager *appManager;
@property (nonatomic,retain) ViewControllerManager *controllerManager;
@property (nonatomic, retain) DataManager *dataManager;

- (void)setData:(id)data;
/** for debug purpose only. */
- (void)showAlert:(NSString *)text;
@end

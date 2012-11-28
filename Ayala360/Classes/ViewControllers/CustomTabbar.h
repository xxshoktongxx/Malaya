//
//  CustomTabbar.h
//  ESBG
//
//  Created by Martin on 11/13/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import "UIKit/UIKit.h"
@class ViewControllerManager;
@class Mall;
@class SqlManager;
@class DataManager;
@interface CustomTabbar : UITabBarController{
    NSMutableArray *_listTabImages;
    NSMutableArray *_listTabButtons;
    UINavigationController *_navigationController;
    void (^_blockPopup)(void);
    
    //Managers
    ViewControllerManager *_controllerManager;
    SqlManager *_sqlManager;
    DataManager *_dataManager;
}

- (void)setData:(id)data;
- (void)passBlock:(void(^)(void))a;
- (void)onAyalaMalls;
- (void)onHome;
@end

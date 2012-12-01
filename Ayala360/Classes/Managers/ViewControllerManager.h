//
//  ViewControllerManager.h
//  ESBG
//
//  Created by Martin on 11/13/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseController;
@class CustomTabbar;

typedef enum{
    menuTypeMapViewController,
    menuTypeMallMenu,
    menuTypeMallDetailMenu,
    menuTypeSocialShare,
//    menuTypeCheckInTable,
    menuTypeFavorites,
    menuTypeCheckInController,
    menuTypeCheckInFoursquare,
    menuTypeCheckInFacebook,
}MenuType;

@interface ViewControllerManager : NSObject{
    BaseController *_menu;
    CustomTabbar *_customTabbar;
    UINavigationController *_navigationController;
}

- (CustomTabbar *)getCustomTabbar;
- (BaseController *)getMenuWithType:(MenuType)type;
- (UINavigationController *)getMenuWithNavWithType:(MenuType)type;
@end

//
//  ViewControllerManager.m
//  ESBG
//
//  Created by Martin on 11/13/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import "ViewControllerManager.h"
#import "BaseController.h"
#import "MallMenu.h"
#import "MallDetailMenu.h"
#import "CustomTabbar.h"
#import "MapViewController.h"
#import "SocialShare.h"
#import "CheckInTableView.h"
#import "FavoritesController.h"

@implementation ViewControllerManager

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BaseController *)getMenuWithType:(MenuType)type{
    switch (type) {
        case menuTypeMapViewController:
            _menu = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
            break;
        case menuTypeMallMenu:
            _menu = [[MallMenu alloc]initWithNibName:@"MallMenu" bundle:nil];
            _menu.title = @"Ayala Malls";
            break;
        case menuTypeCheckIn:
            _menu = [[CheckInTableView alloc]initWithNibName:@"CheckInTableView" bundle:nil];
            break;
        default:
            break;
    }
    return _menu;
}

//Root controllers of customTabbar
- (UINavigationController *)getMenuWithNavWithType:(MenuType)type{
    switch (type) {
        case menuTypeSocialShare:
            _menu = [[SocialShare alloc]initWithNibName:@"SocialShare" bundle:nil];
            _navigationController = [[UINavigationController alloc]initWithRootViewController:_menu];
            break;
        case menuTypeMallDetailMenu:
            _menu = [[MallDetailMenu alloc]initWithNibName:@"MallDetailMenu" bundle:nil];
            _navigationController = [[UINavigationController alloc]initWithRootViewController:_menu];
            break;
        case menuTypeFavorites:
            _menu = [[FavoritesController alloc]initWithNibName:@"FavoritesController" bundle:nil];
            _navigationController = [[UINavigationController alloc]initWithRootViewController:_menu];
            break;
        default:
            break;
    }
    
    return _navigationController;
}

- (CustomTabbar *)getCustomTabbar{
    if (!_customTabbar) {
        _customTabbar = [[CustomTabbar alloc]init];
    }
    return _customTabbar;
}
@end

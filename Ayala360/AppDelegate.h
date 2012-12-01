//
//  AppDelegate.h
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "FacebookManager.h"

@class RootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RootViewController *rootViewController;
@property (nonatomic, strong) AppManager *appManager;
@property (strong, nonatomic) FacebookManager *fbManager;
@end

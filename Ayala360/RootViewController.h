//
//  RootViewController.h
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@class ViewControllerManager;
@interface RootViewController : UIViewController{
    BaseController *_controller;
    UINavigationController *_navigationController;
    ViewControllerManager *_controllerManager;
}
@end

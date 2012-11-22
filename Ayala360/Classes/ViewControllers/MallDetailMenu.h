//
//  MallDetailMenu.h
//
//  Created by Martin on 11/13/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import "BaseController.h"

@interface MallDetailMenu : BaseController{
    UIViewController *_controller;
    
    //Managers
    SqlManager *_sqlManager;
    DataManager *_dataManager;
}
@end

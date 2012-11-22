//
//  BaseController.m
//  ESBG
//
//  Created by Martin on 11/8/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import "BaseController.h"

@implementation BaseController
@synthesize controllerManager = _controllerManager;
@synthesize appManager = _appManager;

- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setData:(id)data{
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.controllerManager = [AppManager sharedInstance].controllerManager;
    self.dataManager = [AppManager sharedInstance].dataManager;
}


- (void)dealloc{
    NSLog(@"%@ deallocated!",[self nibName]);
}
@end

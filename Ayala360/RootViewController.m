//
//  RootViewController.m
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import "RootViewController.h"
#import "AppManager.h"

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _controllerManager = [AppManager sharedInstance].controllerManager;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _controller = [_controllerManager getMenuWithType:menuTypeMallMenu];
//    _navigationController = [[UINavigationController alloc]initWithRootViewController:(UIViewController *)_controller];
//    _navigationController.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:_controller.view];
}

- (void)dealloc{
    NSLog(@"%@ deallocated!",[self class]);
}
@end

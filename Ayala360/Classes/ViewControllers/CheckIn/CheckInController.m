//
//  CheckInController.m
//  Ayala360
//
//  Created by martin magalong on 11/30/12.
//
//

#import "CheckInController.h"

@interface CheckInController ()

@end

@implementation CheckInController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)on4sqr:(id)sender{
    _controller = [self.controllerManager getMenuWithType:menuTypeCheckInFoursquare];
    [self.navigationController pushViewController:_controller animated:YES];
}

- (IBAction)onFacebook:(id)sender{
    _controller = [self.controllerManager getMenuWithType:menuTypeCheckInFacebook];
    [self.navigationController pushViewController:_controller animated:YES];
}


@end

//
//  RootViewController.m
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import "RootViewController.h"
#import "MapViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _mapController = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    [self.view addSubview:_mapController.view];
    //[_mapController viewWillAppear:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
@end

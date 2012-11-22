//
//  MallDetailMenu.m
//  ESBG
//
//  Created by Martin on 11/13/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import "MallDetailMenu.h"
#import "AppManager.h"

@implementation MallDetailMenu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sqlManager = [AppManager sharedInstance].sqlManager;
        _dataManager = [AppManager sharedInstance].dataManager;
    }
    return self;
}

- (void)setData:(id)data{
    NSLog(@"data : %@",data);
    int mapId = [data intValue];
    //Get data from db
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Map WHERE mallid=%d;",mapId];
    NSArray *temp = [_sqlManager performSelectQuery:query];
    
    NSDictionary *tempDict = [temp lastObject];
    int intMallId = [[tempDict objectForKey:@"mallid"] intValue];
    NSNumber *mallId = [NSNumber numberWithInt:intMallId];
    NSDictionary *toObject = [[NSDictionary alloc]initWithObjectsAndKeys:mallId,@"mallId", nil];
    _dataManager.mall = [[Mall alloc]initWithData:toObject];
}

- (IBAction)onMenuSelected:(UIButton *)sender{
    [self openSelectedMenu:sender.tag];
}

- (void)openSelectedMenu:(int)tag{
    NSString *title = nil;
    switch (tag) {
        case 0:
            title = @"Cinema";
            break;
        case 1:
            title = @"Promos";
            break;
        case 2:
            title = @"Stores";
            break;
        case 3:
            title = @"Food";
            break;
        case 4:
            title = @"Map";
            break;
        case 5:
            title = @"Events";
            break;
        case 6:
            title = @"Restrooms";
            break;
        case 7:
            title = @"Mall Info";
            break;
        case 8:
            title = @"Parking";
            break;
        default:
            break;
    }
    _controller = [self.controllerManager getMenuWithType:menuTypeMapViewController];
    _controller.title = title;
    [self.navigationController pushViewController:_controller animated:YES];
}

- (void)onMallMenu{
    self.customTabbar = [self.controllerManager getCustomTabbar];
    [self.customTabbar onAyalaMalls];
}

#pragma mark - Default Methods
- (void)viewDidAppear:(BOOL)animated{
    UIImage *buttonImage = [UIImage imageNamed:@"buttonNavigationBack.png"];
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[backButton setTitle:@"Back" forState:UIControlStateNormal];
	backButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	backButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
	[backButton addTarget:self action:@selector(onMallMenu) forControlEvents:UIControlEventTouchUpInside];
    
	UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = btnBack;
}
@end

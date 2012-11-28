//
//  CustomTabbar.m
//  ESBG
//
//  Created by Martin on 11/13/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import "CustomTabbar.h"
#import "AppManager.h"

@implementation CustomTabbar

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setData:(id)data{
    NSLog(@"Mall id : %@",data);
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

- (void)passBlock:(void(^)(void))a
{
    _blockPopup = a;
}

- (void)onAyalaMalls{
    _blockPopup();
}
- (void)onHome{
    [self setActiveIndex:0];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _controllerManager = [AppManager sharedInstance].controllerManager;
    _sqlManager = [AppManager sharedInstance].sqlManager;
    _dataManager = [AppManager sharedInstance].dataManager;
    
    UINavigationController *controller1 = [_controllerManager getMenuWithNavWithType:menuTypeMallDetailMenu];
    controller1.tabBarItem.image = [UIImage imageNamed:@"tabButtonHome.png"];
    UINavigationController *controller2 = [_controllerManager getMenuWithNavWithType:menuTypeSocialShare];
    controller2.tabBarItem.image = [UIImage imageNamed:@"tabButtonCheckIn.png"];
    UINavigationController *controller3 = [_controllerManager getMenuWithNavWithType:menuTypeMallDetailMenu];
    controller3.tabBarItem.image = [UIImage imageNamed:@"tabButtonFavorites.png"];
    UINavigationController *controller4 = [_controllerManager getMenuWithNavWithType:menuTypeSocialShare];
    controller4.tabBarItem.image = [UIImage imageNamed:@"tabButtonShare.png"];
    UINavigationController *controller5 = [_controllerManager getMenuWithNavWithType:menuTypeMallDetailMenu];
    controller5.tabBarItem.image = [UIImage imageNamed:@"tabButtonPrefs.png"];
    
    NSArray *listControllers = [NSArray arrayWithObjects:controller1, controller2, controller3, controller4, controller5, nil];
    self.viewControllers = listControllers;
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainBG.png"]];
    background.frame = CGRectMake(0, 20, 320, 460);
    [self.view insertSubview:background atIndex:0];
    
    _listTabButtons = [[NSMutableArray alloc]init];
    //Prepare image names for buttonItems
    _listTabImages = [[NSMutableArray alloc]init];
    [_listTabImages addObject:@"tabButtonHome"];
    [_listTabImages addObject:@"tabButtonCheckIn"];
    [_listTabImages addObject:@"tabButtonFavorites"];
    [_listTabImages addObject:@"tabButtonShare"];
    [_listTabImages addObject:@"tabButtonPrefs"];
    
    [self setActiveIndex:0];
    [self setupTabBar];
}

-(void)setupTabBar{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden = YES;
        }
    }
    int count = [self.viewControllers count];
    float xWidth = 320 / count;
    float yCenter = 480.0 - 33.0f;
    
    for(int i = 0; i < count; i++){
        float x = xWidth * i + xWidth / 2;
        float y = yCenter;
        
        UINavigationController *navCtrl = [self.viewControllers objectAtIndex:i];
        UIButton *tabButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, navCtrl.tabBarItem.image.size.width, navCtrl.tabBarItem.image.size.height)];
        UIImage *image = nil;
        if (i == 0 )
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_p.png",[_listTabImages objectAtIndex:i]]];
        else
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[_listTabImages objectAtIndex:i]]];
        [tabButton setImage:image forState:UIControlStateNormal];
        [tabButton setCenter:CGPointMake(x, y)];
        [tabButton addTarget:self action:@selector(pressTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:tabButton];
        [_listTabButtons addObject:tabButton];
    }
}

- (void)pressTab:(UIButton *)sender{
    //Get the index of button in array
    int idx = [_listTabButtons indexOfObject:sender];
    
    //Find active button and set selected image
    for(int i=0; i<_listTabButtons.count; i++){
        UIButton *button = [_listTabButtons objectAtIndex:i];
        if (idx == i) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_p.png",[_listTabImages objectAtIndex:i]]];
            [button setImage:image forState:UIControlStateNormal];
        }
        else{
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[_listTabImages objectAtIndex:i]]];
            [button setImage:image forState:UIControlStateNormal];
        }
    }
    [self setActiveIndex:idx];
}

- (void)setActiveIndex:(int)x{
    self.selectedIndex = x;
}
@end

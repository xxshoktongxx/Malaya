//
//  MallMenu.m
//
//  Created by Martin on 11/12/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import "MallMenu.h"

@implementation MallMenu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (IBAction)onMenuSelected:(UIButton *)sender{
    [self openSelectedMenu:sender.tag];
}

- (void)openSelectedMenu:(int)tag{
    NSString *title = nil;
    switch (tag) {
        case 0:
            title = @"Gloreitta";
            break;
        case 1:
            title = @"Greenbelt";
            break;
        case 2:
            title = @"Alabang Town Center";
            break;
        case 3:
            title = @"Ayala Center Cebu";
            break;
        case 4:
            title = @"Market Market";
            break;
        case 5:
            title = @"Bonifacio High Street";
            break;
        case 6:
            title = @"Trinoma";
            break;
        case 7:
            title = @"Marquee Mall";
            break;
        case 8:
            title = @"Abreeza";
            break;
        default:
            break;
    }
    _customTabbar = [self.controllerManager getCustomTabbar];
    [_customTabbar setData:[NSNumber numberWithInt:tag]];
    [_customTabbar passBlock:^(void){
        [self popCustomTabbar];
    }];
    [self.view addSubview:_customTabbar.view];
    [self pushCustomTabbar];
}

- (void)pushCustomTabbar{
    CGRect tabbarFrame = _customTabbar.view.frame;
    tabbarFrame.origin = CGPointMake(320, tabbarFrame.origin.y);
    _customTabbar.view.frame = tabbarFrame;

    CGRect selfFrame = self.view.frame;
    selfFrame.origin = CGPointMake(-320, selfFrame.origin.y);
    [UIView animateWithDuration:0.3f animations:^(void){
        self.view.frame = selfFrame;
    } completion:^(BOOL finish){
        self.view.frame = (CGRect){.origin=CGPointMake(0, 0),.size=selfFrame.size};
        _customTabbar.view.frame = (CGRect){.origin=CGPointMake(0,0),.size=tabbarFrame.size};
    }];
}

- (void)popCustomTabbar{
    CGRect tabbarFrame = _customTabbar.view.frame;
    tabbarFrame.origin = CGPointMake(320, tabbarFrame.origin.y);
    _customTabbar.view.frame = tabbarFrame;

    CGRect selfFrame = self.view.frame;
    selfFrame.origin = CGPointMake(-320, selfFrame.origin.y);
    self.view.frame = selfFrame;
    
    [UIView animateWithDuration:0.3f animations:^(void){
        self.view.frame = (CGRect){.origin=CGPointMake(0,0),.size=selfFrame.size};
    } completion:^(BOOL finish){
        
    }];
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

@end

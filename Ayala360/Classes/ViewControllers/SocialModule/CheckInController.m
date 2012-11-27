//
//  CheckInController.m
//  Foursquare3
//
//  Created by Martin on 11/27/12.
//  Copyright (c) 2012 Ripplewave. All rights reserved.
//

#import "CheckInController.h"

@implementation CheckInController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _tableViewNearby = [[UITableView alloc]init];
    _tableViewNearby.frame = (CGRect){.origin=CGPointMake(0, 0),.size=CGSizeMake(320, 300)};
    
}

#pragma mark --
#pragma mark Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_listNearBy count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

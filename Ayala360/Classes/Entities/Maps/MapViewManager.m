//
//  MapViewManager
//  ESBG
//
//  Created by Martin on 11/9/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import "MapViewManager.h"
#import "PlistHelper.h"
#import "Mall.h"
@implementation MapViewManager

- (id)init{
    self = [super init];
    if (self) {
        _listMall = [[NSMutableArray alloc]init];
        [self loadData];
    }
    return self;
}

- (void)loadData{
}

- (UIView *)getMapWithType:(MapType)type{
    switch (type) {
        case 0:
            _map = [[AyalaCebuLvl1 alloc]init];
            _map.frame = CGRectMake(0, 0, 2000, 2000);
            
            break;
        case 1:
            _map = [[Glorietta4GF alloc]init];
            _map.frame = CGRectMake(0, 0, 2000, 2000);
            break;
        case 2:
            _map = [[TrinomaM2 alloc]init];
            _map.frame = CGRectMake(0, 0, 2000, 2000);
            break;
        default:
            break;
    }
    if (_map){
        return _map;
    }
    return nil;
}
@end

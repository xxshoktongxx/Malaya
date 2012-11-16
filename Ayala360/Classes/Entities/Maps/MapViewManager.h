//
//  MapViewManager
//  ESBG
//
//  Created by Martin on 11/9/12.
//  Copyright (c) 2012 idocode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AyalaCebuLvl1.h"
#import "Glorietta4GF.h"
#import "TrinomaM2.h"

typedef enum{
    typeAyalaCebu_1F = 0,
    typeGlorietta4_1F = 1,
    typeTrinomaM2 = 2,
}MapType;

@interface MapViewManager : NSObject{
    UIView *_map;
    MapType _mapType;
}
@property (nonatomic, retain) NSMutableArray *listMall;
- (UIView *)getMapWithType:(MapType)type;
@end

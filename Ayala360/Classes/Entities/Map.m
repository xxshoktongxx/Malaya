//
//  Map.m
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import "Map.h"

@implementation Map

- (id)initWithData:(id)data
{
    self = [super init];
    if (self)
    {
        _mapViewManager = [[MapViewManager alloc]init];
        
        //Create mapview (visual representation of the map)
        self = (Map *)[_mapViewManager getMapWithType:[[data objectForKey:@"mapNumber"] intValue]];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
@end

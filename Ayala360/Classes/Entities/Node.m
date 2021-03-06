//
//  Store.m
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import "Node.h"

@implementation Node

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        _nodeId = [NSNumber numberWithFloat:[[data objectForKey:@"nodeid"]intValue]];;
        _name = [data objectForKey:@"name"];
        _cost = [NSNumber numberWithFloat:MAXFLOAT];
        _coor = [data objectForKey:@"coor"];
        _zAxis = [[data objectForKey:@"zaxis"] floatValue];
        _mapLevel = [NSNumber numberWithFloat:[[data objectForKey:@"maplevel"] intValue]];
        _parentNode = nil;
    }
    return self;
}

- (double)getAngleTo:(Node *)node
{
    CGPoint st = CGPointFromString(self.coor);
    CGPoint en = CGPointFromString(node.coor);
    return M_PI_2+atan2f(en.y-st.y , en.x-st.x);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"id:%@ |name:%@ coor:%@ |level:%@",_nodeId,_name,_coor,_mapLevel];
}
@end

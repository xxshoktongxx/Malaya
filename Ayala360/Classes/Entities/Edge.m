//
//  Edge.m
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import "Edge.h"
#import "Node.h"

@implementation Edge
- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ : StartId=%@ EndId=%@ cost=%@",[super description],_start.nodeId,_end.nodeId,_cost];
}
@end

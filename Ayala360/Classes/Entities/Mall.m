//
//  Mall.m
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import "Mall.h"
#import "Map.h"
@implementation Mall

- (id)initWithData:(id)data
{
    self = [super init];
    if (self) {
        _listMap = [[NSMutableDictionary alloc]init];
        
        for (NSDictionary *temp in data) {
            NSString *level = [temp objectForKey:@"mapType"];
            map = [[Map alloc]initWithData:temp];
            [_listMap setObject:map forKey:level];
            NSLog(@"map:%@",[[_listMap objectForKey:level] listNodes]);
        }
    }
    return self;
}
@end

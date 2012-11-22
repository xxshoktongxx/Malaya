//
//  Mall.m
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import "Mall.h"
#import "AppManager.h"

@implementation Mall
@synthesize listMap = _listMap;

- (id)initWithData:(id)data
{
    self = [super init];
    if (self) {
        _listMap = [[NSMutableDictionary alloc]init];
        _listNodes = [[NSMutableArray alloc]init];
        _listEdges = [[NSMutableArray alloc]init];
        _listNodeObjects = [[NSMutableArray alloc]init];
        _listEdgeObjects = [[NSMutableArray alloc]init];
        
        _sqlManager = [AppManager sharedInstance].sqlManager;
        int mallId = [[data objectForKey:@"mallId"] intValue];
        _mallId = [NSNumber numberWithInt:mallId];
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM Map WHERE mallid=%d;",mallId ];
        NSArray *maps = nil;
        maps = [_sqlManager performSelectQuery:query];
        
        for (NSDictionary *tempDict in maps) {
            int intLevel = [[tempDict objectForKey:@"maplevel"] intValue];
            NSString *svgname = [tempDict objectForKey:@"svgname"];
            NSNumber *mapLevel = [NSNumber numberWithInt:intLevel];
            [_listMap setObject:svgname forKey:mapLevel];
            
            NSArray *nodes = [_sqlManager performSelectQuery:[NSString stringWithFormat:@"SELECT * FROM Node WHERE maplevel=%d AND mallid=%d",intLevel,mallId]];
            NSArray *edges = [_sqlManager performSelectQuery:[NSString stringWithFormat:@"SELECT * FROM Edge WHERE maplevel=%d AND mallid=%d",intLevel,mallId]];
            [_listNodes addObjectsFromArray:nodes];
            [_listEdges addObjectsFromArray:edges];
        }
        [self createGraphObjects];
    }
    return self;
}

- (void)createGraphObjects{
    [_listNodeObjects removeAllObjects];
    [_listEdgeObjects removeAllObjects];
    
    //Create Node data and add it to listNodes
    for(NSDictionary *entry in _listNodes){
        Node *node = [[Node alloc]initWithData:entry];
        [_listNodeObjects addObject:node];
    }

    //Create Edge data and add it to listEdges
    for(NSDictionary *entry in _listEdges)
    {
        NSNumber *startId = [NSNumber numberWithInt:[[entry objectForKey:@"startnodeid"] intValue]];
        NSNumber *endId = [NSNumber numberWithInt:[[entry objectForKey:@"endnodeid"]intValue]];
        Edge *edge = [[Edge alloc]init];
        edge.start = [self getNodeWithId:startId];
        edge.end = [self getNodeWithId:endId];
        [_listEdgeObjects addObject:edge];
        
        //Create another edge for opposite direction
        Edge *edge1 = [[Edge alloc]init];
        edge1.start = [self getNodeWithId:endId];
        edge1.end = [self getNodeWithId:startId];
        [_listEdgeObjects addObject:edge1];
    }
}

#pragma mark Node Methods
- (Node *)getNodeWithId:(NSNumber *)nodeId
{
    for(Node *temp in _listNodeObjects)
    {
        if ([temp.nodeId isEqualToNumber:nodeId])
        {
            return temp;
        }
    }
    return nil;
}

- (NSString *)getMapWithLevel:(int)mapLevel{
    if ([_listMap objectForKey:[NSNumber numberWithInt:mapLevel]]) {
        _activeMapIndex = [NSNumber numberWithInt:mapLevel];
        return [_listMap objectForKey:_activeMapIndex];
    }
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ |id:%@",[self class],_mallId];
}
@end

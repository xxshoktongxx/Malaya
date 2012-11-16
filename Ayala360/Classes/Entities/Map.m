//
//  Map.m
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import "Map.h"
#import "AyalaCebuLvl1.h"

@implementation Map

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        _listDataCopy = [[NSDictionary alloc]initWithDictionary:data];
        _mapViewManager = [[MapViewManager alloc]init];
        _listNodes = [[NSMutableArray alloc]init];
        _listEdges = [[NSMutableArray alloc]init];
        _mName = [data objectForKey:@"mapType"];
        
        //Create mapview (visual representation of the map)
        _mapView = [_mapViewManager getMapWithType:[[data objectForKey:@"mapType"] intValue]];
        _mapView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)generateGraph
{
    //clean first
    [_listNodes removeAllObjects];
    [_listEdges removeAllObjects];
    [_mapView removeFromSuperview];
    [_lineShapeContainer removeFromSuperlayer];
    _lineShapeContainer = [CAShapeLayer layer];
    
    
    //Create Node data and add it to listNodes
    for(NSDictionary *entry in [_listDataCopy objectForKey:@"Nodes"]){
        Node *node = [[Node alloc]initWithData:entry];
        node.z = [[_listDataCopy objectForKey:@"mapType"] floatValue];
        [_listNodes addObject:node];
    }
    
    //Create Edge data and add it to listEdges
    for(NSDictionary *entry in [_listDataCopy objectForKey:@"Edges"])
    {
        NSNumber *startId = [entry objectForKey:@"startId"];
        NSNumber *endId = [entry objectForKey:@"endId"];
        Edge *edge = [[Edge alloc]init];
        edge.start = [self getNodeWithId:startId];
        edge.end = [self getNodeWithId:endId];
        [_listEdges addObject:edge];
        
        //Create another edge for opposite direction
        Edge *edge1 = [[Edge alloc]init];
        edge1.start = [self getNodeWithId:endId];
        edge1.end = [self getNodeWithId:startId];
        [_listEdges addObject:edge1];
    }
    
    //render graph
    [self renderEdges];
    [self renderNodes];
    self.startNode = [self getNodeWithId:[NSNumber numberWithInt:0]];
    self.endNode = [self getNodeWithId:[NSNumber numberWithInt:8]];
}

- (void)addViewTo:(UIView *)renderLayer{
    [self generateGraph];
    [renderLayer addSubview:_mapView];
}

- (void)renderNodes
{
    CAShapeLayer *lineShape = [CAShapeLayer layer];
    CGMutablePathRef linePath = CGPathCreateMutable();
    
    for(Node *temp in _listNodes)
    {
        CGPoint coor = CGPointFromString(temp.coor);
        lineShape.lineWidth = 4.0f;
        lineShape.lineCap = kCALineCapRound;;
        //lineShape.strokeColor = [[UIColor blackColor] CGColor];
        lineShape.fillColor = [[UIColor redColor]CGColor];
        CGPathAddEllipseInRect(linePath, nil, CGRectMake(coor.x-5, coor.y-5, 10, 10));
        lineShape.path = linePath;
    }
    CGPathRelease(linePath);
    [_lineShapeContainer addSublayer:lineShape];
    [_mapView.layer addSublayer:_lineShapeContainer];
}

- (void)renderEdges
{
    CAShapeLayer *lineShape = [CAShapeLayer layer];
    CGMutablePathRef linePath = CGPathCreateMutable();
    for(Edge *temp in _listEdges)
    {
        CGPoint coorStart = CGPointFromString(temp.start.coor);
        CGPoint coorEnd = CGPointFromString(temp.end.coor);
        
        lineShape.lineWidth = 0.5f;
        lineShape.lineCap = kCALineCapRound;
        lineShape.strokeColor = [[UIColor blackColor] CGColor];
        CGPathMoveToPoint(linePath, nil, coorStart.x,coorStart.y);
        CGPathAddLineToPoint(linePath, nil, coorEnd.x, coorEnd.y);
        lineShape.path = linePath;
    }
    CGPathRelease(linePath);
    [_lineShapeContainer addSublayer:lineShape];
    [_mapView.layer addSublayer:_lineShapeContainer];
}

#pragma mark Node Methods
- (Node *)getNodeWithId:(NSNumber *)nodeId
{
    for(Node *temp in _listNodes)
    {
        if ([temp.nodeId isEqualToNumber:nodeId])
        {
            return temp;
        }
    }
    return nil;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ | name: %@",[super description],_mName];
}
@end

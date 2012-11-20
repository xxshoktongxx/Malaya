//
//  Dijkstra.m
//  TPS
//
//  Created by martin magalong on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dijkstra.h"

@implementation Dijkstra

- (NSMutableArray *)findPathInGraph:(Mall *)graph
{
    _graph = graph;

    //1. Set the cost of origin/start node to 0
    [_graph.startNode setCost:[NSNumber numberWithInt:0]];
    
    NSMutableArray *_listNodes = [[NSMutableArray alloc]initWithArray:[_graph listNodeObjects]];
    NSMutableArray *_listEdges = [[NSMutableArray alloc]initWithArray:[_graph listEdgeObjects]];
    //2. Get the node with the least cost value in the nodeList
    while(_listNodes.count > 0) {
        _listNodes =   [self sortArrayOfDictionary:_listNodes byKey:@"cost"];
        Node *node = [_listNodes objectAtIndex:0];
        
        //3. Get all the neigbor of the current node and update their cost value
        //[self relaxNeighbor:node nodeList:[_graph listNodes] edgeList:_listEdges];
        for (int x=0; x<_listEdges.count; x++) {
            Edge *edge = [_listEdges objectAtIndex:x];
            if([edge.start.nodeId isEqualToNumber:node.nodeId]){
                //3.1 Get the neighbor of the current node
                CGPoint coorStart = CGPointFromString(edge.start.coor);
                CGPoint coorEnd = CGPointFromString(edge.end.coor);
                float currentCost = [edge.end.cost floatValue];
                //compute distance using formula
                float newCost = sqrtf((coorEnd.x-coorStart.x)*(coorEnd.x-coorStart.x) +
                                        (coorEnd.y-coorStart.y)*(coorEnd.y-coorStart.y) +
                                        (edge.end.zAxis-edge.start.zAxis)*(edge.end.zAxis-edge.start.zAxis));
                newCost = ABS(newCost);
                if(newCost < currentCost)
                {
                    //3.2 Update the cost of neighbor node if newCost is less than the currentCost
                    for(int y=0; y<_listNodes.count; y++)
                    {
                        Node *end = [_listNodes objectAtIndex:y];
                        if ([end.nodeId isEqualToNumber:edge.end.nodeId]) {
                            end.cost = [NSNumber numberWithFloat:newCost];
                            //4. Set the parent of the node for tracing path later
                            [end setParentNode:[_graph getNodeWithId:edge.start.nodeId]];
                            break;
                        }
                    }
                }
            }
        }
        [_listNodes removeObject:node];
    }
    //5. Trace the path starting from the destination to start using nodes' parent.
    _listPath = nil;
    _listPath = [[NSMutableArray alloc]init];
    [self performSelector:@selector(getPath:) withObject:[_graph endNode]];
    return _listPath;
}

- (void)getPath:(Node *)node{
    if (node) {
        [_listPath insertObject:node atIndex:0];
        if(node.parentNode != nil){
            [self getPath:node.parentNode];
        }
        else {
            if ([_listPath objectAtIndex:0] != [_graph startNode]) {
                _listPath = nil;
            }
        }
    }
}

- (NSMutableArray *)sortArrayOfDictionary:(NSMutableArray *)array byKey:(NSString *)key
{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:key ascending:YES];
    [array sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];  
    return array;
}

@end
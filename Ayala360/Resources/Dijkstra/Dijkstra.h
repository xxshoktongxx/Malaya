//
//  Dijktra.h
//  TPS
//
//  Created by martin magalong on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mall.h"

@interface Dijkstra : NSObject
{

    NSMutableArray *_listPath;
    Mall *_graph;
    Node *startNode;
    Node *endNode;
}
/* Computes and returns route. */
- (NSMutableArray *)findPathInGraph:(Mall *)graph;

/* Returns an array of nodes(the path). */
- (void)getPath:(Node *)node;

/* Sorts array of dictionary in ascending according by key*/
- (NSMutableArray *)sortArrayOfDictionary:(NSMutableArray *)array byKey:(NSString *)key;

@end

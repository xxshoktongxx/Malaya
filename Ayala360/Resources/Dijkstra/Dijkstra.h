//
//  Dijktra.h
//  TPS
//
//  Created by martin magalong on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"

@interface Dijkstra : NSObject
{

    NSMutableArray *_listPath;
    Map *_graph;
    Node *startNode;
    Node *endNode;
}
/* Computes and returns route. */
- (NSMutableArray *)findPathInGraph:(Map *)graph;

/* Returns an array of nodes(the path). */
- (void)getPath:(Node *)node;

/* Sorts array of dictionary in ascending according by key*/
- (NSMutableArray *)sortArrayOfDictionary:(NSMutableArray *)array byKey:(NSString *)key;

@end

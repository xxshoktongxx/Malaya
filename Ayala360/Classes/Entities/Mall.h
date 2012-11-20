//
//  Mall.h
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import <Foundation/Foundation.h>
#import "Edge.h"
#import "Node.h"
#import "Map.h"
@class SqlManager;
@interface Mall : NSObject{
    Map *map;
    SqlManager *_sqlManager;
    NSMutableArray *_listNodes;         /**Holds the raw data of nodes for the specified mall. */
    NSMutableArray *_listEdges;         /**Holds the raw data of edges for the specified mall. */
    NSNumber *_activeMapIndex;
}
@property (nonatomic, retain) NSNumber *mUniqueId; //Mall identifier
@property (nonatomic, retain) NSNumber *mName;  //Mall name
@property (nonatomic, retain) NSMutableDictionary *listMap;  /**Holds the mall map view per level. */
@property (nonatomic, retain) NSMutableDictionary *listStore;  /**Holds the stores inside the mall. */
@property (nonatomic, retain) NSMutableArray *listNodeObjects; /**Holds the object data of nodes. */
@property (nonatomic, retain) NSMutableArray *listEdgeObjects; /**Holds the object data of edges. */
@property (nonatomic, retain) Node *startNode;                 /**Reference to the starting point when getting direction. */
@property (nonatomic, retain) Node *endNode;                   /**Reference to the destination point when getting the direction. */

- (id)initWithData:(id)data;
- (Node *)getNodeWithId:(NSNumber *)nodeId;
- (Map *)getMapWithLevel:(int)mapLevel;
@end

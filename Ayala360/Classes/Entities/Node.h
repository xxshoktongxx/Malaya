//
//  Store.h
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property (nonatomic,readonly) NSNumber *nodeId;
@property (nonatomic,retain) NSNumber *cost;
@property (nonatomic,readonly) __strong NSString *name;
@property (nonatomic,readonly) __strong NSString *coor;
@property (nonatomic,assign) float zAxis;               /** z axis for computing distance. */
@property (nonatomic,retain) Node *parentNode;
@property (nonatomic,retain) NSNumber *mapLevel;    /**Reference to level where the node is located. */

- (id)initWithData:(NSDictionary *)data;
- (double)getAngleTo:(Node *)node;
@end

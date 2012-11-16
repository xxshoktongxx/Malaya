//
//  Map.h
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import <UIKit/UIKit.h>
#import "Node.h"
#import "Edge.h"
#import "MapViewManager.h"
#import <QuartzCore/QuartzCore.h>

@interface Map : NSObject{
    NSDictionary *_listDataCopy;
    NSString *_mName;
    MapViewManager *_mapViewManager;
    CAShapeLayer *_lineShapeContainer;
}
@property (nonatomic, retain) UIView *mapView;
@property (nonatomic, retain) NSMutableArray *listEdges;
@property (nonatomic, retain) NSMutableArray *listNodes;
@property (nonatomic, retain) Node *startNode;
@property (nonatomic, retain) Node *endNode;


- (id)initWithData:(NSDictionary *)data;
- (void)addViewTo:(UIView *)renderLayer;
- (Node *)getNodeWithId:(NSNumber *)nodeId;
@end

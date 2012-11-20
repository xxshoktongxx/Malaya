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

@interface Map : UIView{
    
    MapViewManager *_mapViewManager;
}
- (id)initWithData:(id)data;
@end

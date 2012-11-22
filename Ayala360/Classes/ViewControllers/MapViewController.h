//
//  MapViewController.h
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import "BaseController.h"
#import "Mall.h"
@class Dijkstra;
@class SqlManager;

@interface MapViewController : BaseController{
    NSArray *_listRoute;
    UIImageView *_hero;
    Mall *_mMall;                       /** Holds the instance of mall */
    SVGViewController *_mapView;        /** Holds the refence of active map in mall.listmap*/
    
    /** Managers */
    Dijkstra *_dijkstra;
    SqlManager *_sqlManager;
}
- (IBAction)getRoute:(id)sender;
- (IBAction)previousMap:(id)sender;
- (IBAction)nextMap:(id)sender;
@end

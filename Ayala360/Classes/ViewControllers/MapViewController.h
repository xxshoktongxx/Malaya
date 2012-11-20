//
//  MapViewController.h
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import <UIKit/UIKit.h>
#import "Mall.h"
@class Dijkstra;
@class SqlManager;

@interface MapViewController : UIViewController{
    NSArray *_listRoute;
    UIImageView *_hero;
    UIScrollView *_scrollView;
    Mall *_mMall;                       /** Holds the instance of mall */
    Map *_mMap;                         /** Holds the refence of active map in mall.listmap*/
    
    /** Managers */
    Dijkstra *_dijkstra;
    SqlManager *_sqlManager;
}
- (IBAction)getRoute:(id)sender;
- (IBAction)previousMap:(id)sender;
- (IBAction)nextMap:(id)sender;
@end

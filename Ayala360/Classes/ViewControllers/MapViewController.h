//
//  MapViewController.h
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import <UIKit/UIKit.h>
@class Mall;
@class Map;
@class Dijkstra;

@interface MapViewController : UIViewController{
    int _mMapIndex;
    Mall *_mMall;
    Map *_mMap;
    Dijkstra *_dijkstra;
    NSArray *_listRoute;
    UIImageView *_hero;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (IBAction)previousMap:(id)sender;
- (IBAction)nextMap:(id)sender;
@end

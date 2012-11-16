//
//  MapViewController.m
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import "MapViewController.h"
#import "AppManager.h"
#import "PlistHelper.h"
#import "Mall.h"
#import "Map.h"

@implementation MapViewController{
    int animationIndex;
}

@synthesize scrollView = _scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dijkstra = [AppManager sharedInstance].dijkstra;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"hitTest: %@",NSStringFromCGPoint(point));
    return self.scrollView;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *plistData = [[NSArray alloc]initWithArray:[PlistHelper getArray:@"AyalaCebuData"]];
    _mMall = [[Mall alloc]initWithData:plistData];
    _dijkstra = [[Dijkstra alloc]init];
    
    //test area
    NSArray *kill = [_mMall.listMap allValues];
    _mMap = [kill objectAtIndex:0];
    _mMapIndex = 0;
    
    _hero = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.jpeg"]];
    _hero.frame = CGRectMake(0, 0, 30, 30);
}

- (IBAction)previousMap:(UIButton *)sender{
    NSArray *temp = [_mMall.listMap allValues];
    if (_mMapIndex > 0) {
        animationIndex = 0;
        _mMapIndex--;
        _mMap = [temp objectAtIndex:_mMapIndex];
        [_mMap addViewTo:_scrollView];
        _scrollView.contentSize = _mMap.mapView.frame.size;
        _listRoute = [_dijkstra findPathInGraph:_mMap];
    }
}
- (IBAction)nextMap:(UIButton *)sender{
    NSArray *temp = [_mMall.listMap allValues];
    if (_mMapIndex < temp.count-1) {
        animationIndex = 0;
        _mMapIndex++;
        _mMap = [temp objectAtIndex:_mMapIndex];
        [_mMap addViewTo:_scrollView];
        _scrollView.contentSize = _mMap.mapView.frame.size;
        _listRoute = [_dijkstra findPathInGraph:_mMap];
        //add table for shortest path simulation
    }
}

- (IBAction)animate:(id)sender{
    NSLog(@"Route: %@",_listRoute);
    [_scrollView insertSubview:_hero atIndex:10];
    if(animationIndex  < _listRoute.count){
        Node *node = [_listRoute objectAtIndex:animationIndex];
        CGPoint coor = CGPointFromString(node.coor);
        float time = [node.cost floatValue]/50;
        _hero.transform = CGAffineTransformMakeRotation([node.parentNode getAngleTo:node]);
        [UIView animateWithDuration:time animations:^{
            if (node.parentNode) {
                _hero.center = coor;
            }
        } completion:^(BOOL finished){
            animationIndex ++;
//            [self performSelector:@selector(animate)];
        }];
    }
}
@end

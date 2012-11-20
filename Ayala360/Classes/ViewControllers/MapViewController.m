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
    int activeMapLevel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dijkstra = [AppManager sharedInstance].dijkstra;
        _sqlManager = [AppManager sharedInstance].sqlManager;
    }
    return self;
}

- (IBAction)loadMap:(UIButton *)sender{
    //render hero
    _hero = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.jpeg"]];
    _hero.frame = CGRectMake(0, 0, 30, 30);
    [self loadMapWithid:sender.tag];
}

- (void)loadMapWithid:(int)mapId{
    [self cleanScrollview];
    
    //Get data from db
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Map WHERE mallid=%d;",mapId];
    NSArray *data = [_sqlManager performSelectQuery:query];
    
    NSDictionary *tempDict = [data lastObject];
    int intMallId = [[tempDict objectForKey:@"mallid"] intValue];
    NSNumber *mallId = [NSNumber numberWithInt:intMallId];
    NSDictionary *toObject = [[NSDictionary alloc]initWithObjectsAndKeys:mallId,@"mallId", nil];
    _mMall = [[Mall alloc]initWithData:toObject];
    
    //render
    [self selectMapForRender];
}

#pragma mark - Private methods
- (void)cleanScrollview{
    _mMap = nil;
    _mMall = nil;
    [_scrollView removeFromSuperview];
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 50, 320, 350);
    [self.view addSubview:_scrollView];
}

- (void)selectMapForRender{
    _mMap = [_mMall getMapWithLevel:activeMapLevel];
    if (_mMap) {
        [_scrollView addSubview:_mMap];
        _scrollView.contentSize = _mMap.frame.size;
    }
    else{
        NSLog(@"Map data not available");
    }
}

- (void)centerHero{
    _scrollView.frame = CGRectMake(0, 0, 100, 100);
}

#pragma mark - IBActions
- (IBAction)getRoute:(id)sender{
//    [self loadMapWithid:activeMapLevel];
    _listRoute = nil;
    //Set origin and destination for path finding
    _mMall.startNode = [_mMall getNodeWithId:[NSNumber numberWithInt:0]];
    _mMall.endNode = [_mMall getNodeWithId:[NSNumber numberWithInt:23]];
    _listRoute = [_dijkstra findPathInGraph:_mMall];
    NSLog(@"Route: %@",_listRoute);
}

- (IBAction)previousMap:(UIButton *)sender{
    _mMap = [_mMall getMapWithLevel:activeMapLevel-1];
    if (_mMap) {
        animationIndex = 0;
        activeMapLevel--;
        [self selectMapForRender];
    }
}
- (IBAction)nextMap:(UIButton *)sender{
    _mMap = [_mMall getMapWithLevel:activeMapLevel+1];
    if (_mMap) {
        animationIndex = 0;
        activeMapLevel++;
        [self selectMapForRender];
    }
}

- (IBAction)animate:(id)sender{

    if(animationIndex  < _listRoute.count){
        Node *node = [_listRoute objectAtIndex:animationIndex];
        NSLog(@"Current node: %@",node);
        CGPoint coor = CGPointFromString(node.coor);
        float time = [node.cost floatValue]/50;
        _hero.transform = CGAffineTransformMakeRotation([node.parentNode getAngleTo:node]);
        
        if(node.mapLevel.intValue == activeMapLevel){
            [UIView animateWithDuration:time animations:^{
                if (node.parentNode) {
                    _hero.center = coor;
                }
            } completion:^(BOOL finished){
                animationIndex ++;
                //[self performSelector:@selector(animate)];
            }];
        }
        else{
            activeMapLevel = node.mapLevel.intValue;
            [self loadMapWithid:activeMapLevel];
            [UIView animateWithDuration:time animations:^{
                if (node.parentNode) {
                    _hero.center = coor;
                }
            } completion:^(BOOL finished){
                animationIndex ++;
                //[self performSelector:@selector(animate)];
            }];
        }
    }
    else{
        animationIndex = 0;
    }
        [_scrollView insertSubview:_hero atIndex:10];
}

#pragma mark - Overriden methods
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
@end

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
#import <QuartzCore/QuartzCore.h>

@implementation MapViewController{
    int animationIndex;
    int activeMapLevel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadMapWithLevel:(int)mapLevel{
    activeMapLevel = mapLevel;
    [self selectMapForRender];
}

- (void)selectMapForRender{
    NSString *svgName = [_mMall getMapWithLevel:activeMapLevel];
    if (svgName) {
        NSLog(@"Active SVG:%@",svgName);
        [_mapView setDetailItem:svgName];
        _mapView.view.backgroundColor = [UIColor whiteColor];
        _mapView.view.frame = CGRectMake(0, 60, 320, 300);
        [self centerHero:_hero.center];
        [_mapView addToView:self.view];
        [self renderGraph];
    }
    else{
        NSLog(@"Map data not available");
    }
}

- (void)renderGraph{
    
    //Edges
    CAShapeLayer *lineShape1 = [CAShapeLayer layer];;
    CGMutablePathRef linePath1 = CGPathCreateMutable();
    for(Edge *edge in _mMall.listEdgeObjects){
        if (edge.start.mapLevel.intValue == activeMapLevel) {
            
            CGPoint coorStart = CGPointFromString(edge.start.coor);
            CGPoint coorEnd = CGPointFromString(edge.end.coor);
            
            lineShape1.lineWidth = 0.5f;
            lineShape1.lineCap = kCALineCapRound;;
            lineShape1.strokeColor = [[UIColor blackColor] CGColor];
            
            CGPathMoveToPoint(linePath1, NULL, coorStart.x,coorStart.y);
            CGPathAddLineToPoint(linePath1, NULL, coorEnd.x, coorEnd.y);
            lineShape1.path = linePath1;
        }
    }
    CGPathRelease(linePath1);
    [_mapView.contentView.layer addSublayer:lineShape1];
    
    //Nodes
    CAShapeLayer *lineShape = [CAShapeLayer layer];;
    CGMutablePathRef linePath = CGPathCreateMutable();
    for(Node *node in _mMall.listNodeObjects){
        if (node.mapLevel.intValue == activeMapLevel) {
            CGPoint coorStart = CGPointFromString(node.coor);
            
            lineShape.lineWidth = 3.0f;
            lineShape.lineCap = kCALineCapRound;;
            lineShape.strokeColor = [[UIColor redColor] CGColor];
            
            CGPathMoveToPoint(linePath, NULL, coorStart.x, coorStart.y);
            CGPathAddLineToPoint(linePath, NULL, coorStart.x, coorStart.y);
            lineShape.path = linePath;
        }
    }
    CGPathRelease(linePath);
    [_mapView.contentView.layer addSublayer:lineShape];
}

#pragma mark - IBActions
- (IBAction)getRoute:(id)sender{
    _listRoute = nil;
    if (_mMall) {
        //Set origin and destination for path finding
        _mMall.startNode = [_mMall getNodeWithId:[NSNumber numberWithInt:0]];
        _mMall.endNode = [_mMall getNodeWithId:[NSNumber numberWithInt:8]];
        _listRoute = [_dijkstra findPathInGraph:_mMall];
        NSLog(@"Route: %@",_listRoute);
    }
}

- (IBAction)previousMap:(UIButton *)sender{
    if ([_mMall getMapWithLevel:activeMapLevel-1]) {
        animationIndex = 0;
        activeMapLevel--;
        [self selectMapForRender];
    }
}
- (IBAction)nextMap:(UIButton *)sender{
    if ([_mMall getMapWithLevel:activeMapLevel+1]) {
        animationIndex = 0;
        activeMapLevel++;
        [self selectMapForRender];
    }
}

- (IBAction)animate:(id)sender{
    if(animationIndex  < _listRoute.count){
        Node *node = [_listRoute objectAtIndex:animationIndex];
        NSLog(@"Node: %@",node);
        CGPoint coor = CGPointFromString(node.coor);
        float time = [node.cost floatValue]/50;
        _hero.transform = CGAffineTransformMakeRotation([node.parentNode getAngleTo:node]);
        
        if(node.mapLevel.intValue == activeMapLevel){
            [UIView animateWithDuration:time animations:^{
                if (node.parentNode) {
                   [self centerHero:coor];
                }
            } completion:^(BOOL finished){
                animationIndex ++;
                //[self performSelector:@selector(animate)];
            }];
        }
        else{
            activeMapLevel = node.mapLevel.intValue;
            [self selectMapForRender];
            [UIView animateWithDuration:3.0f animations:^{

            } completion:^(BOOL finished){
                if (node.parentNode) {
                    [self centerHero:coor];
                }
                animationIndex ++;
                //[self performSelector:@selector(animate)];
            }];
        }
    }
    else{
        animationIndex = 0;
    }
    [_mapView.contentView insertSubview:_hero atIndex:10];
}

- (void)centerHero:(CGPoint)coor{
    UIScrollView *scrollView = _mapView.scrollView;
    CGPoint point = coor;
    _hero.center = coor;
    
    point.x = point.x - scrollView.frame.size.width/2;
    point.y = point.y - scrollView.frame.size.height/2;
    [_mapView.scrollView setContentOffset:point];
}

#pragma mark - Overriden methods
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadMapWithLevel:1];
    
    _hero = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow.jpeg"]];
    _hero.frame = CGRectMake(0, 0, 30, 30);
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _dijkstra = [AppManager sharedInstance].dijkstra;
    _sqlManager = [AppManager sharedInstance].sqlManager;
    _mapView = [[SVGViewController alloc]init];
    _mMall = self.dataManager.mall;
}

- (void)dealloc{
    [_mapView.view removeFromSuperview];
    _mMall = nil;
}
@end

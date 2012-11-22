//
//  SVGGradientElement.h
//  SVGPad
//
//  Created by Kevin Stich on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SVGElement.h"
#import "SVGGradientStop.h"

@interface SVGGradientElement : SVGElement {
    @public
    BOOL radial;
    NSString *gradientUnits;
    CGPoint startPoint, endPoint;
    
    @protected
    NSMutableArray *_stops;
    
    @private
    NSArray *colors, *locations;
}

@property (readonly, retain)NSArray *stops;

-(void)addStop:(SVGGradientStop *)gradientStop;

@end

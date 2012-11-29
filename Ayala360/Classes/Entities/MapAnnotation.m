//
//  MapAnnotation.m
//  Ayala360
//
//  Created by Martin on 11/29/12.
//
//

#import "MapAnnotation.h"

@implementation MapAnnotation
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address index:(int)index coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        _index = index;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}

@end

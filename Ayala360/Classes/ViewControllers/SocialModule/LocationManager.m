//
//  LocationManager.m
//  Foursquare3
//
//  Created by Martin on 11/27/12.
//  Copyright (c) 2012 Ripplewave. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

- (id)init{
    
	if(self == [super init]){
        _listObservers = [[NSMutableArray alloc]init];
		_locationManager = [[CLLocationManager alloc]  init];
		_locationManager.delegate = self;
		_locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
		_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		_tempCoord.latitude = 0.0;
		_tempCoord.longitude = 0.0;
//        returnFakeLoc = NO;
	}
	
	return self;
}

- (void)start{
	[_locationManager startUpdatingLocation];
	[_locationManager startUpdatingHeading];
}

-(NSInteger)getDistanceToCoordinateInMeters:(CLLocationCoordinate2D) coordinate{
	CLLocation *current = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
	
	return [_locationManager.location distanceFromLocation:current];
}

#pragma mark - LocationManager Delegate
/** This method is deprecated. If locationManager:didUpdateLocations: is
    implemented, this method will not be called. */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    [self notifyObservers];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self notifyObservers];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
     NSLog(@"locationManagerShouldDisplayHeadingCalibration");
	return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
     NSLog(@"didUpdateHeading:");
    //	self.currentHeading = newHeading;
}

#pragma mark 6.0 Methods


#pragma mark - OBSERVERS
- (void)notifyObservers{
    for(id<LocationManagerProtocol> observer in _listObservers){
        [observer _locationManagerNotification:_locationManager.location];
    }
    [_locationManager stopUpdatingLocation];
    [_locationManager stopUpdatingHeading];
}
- (void)addObserver:(id<LocationManagerProtocol>)observer{
    if ([observer conformsToProtocol:@protocol(LocationManagerProtocol)]) {
        [_listObservers addObject:observer];
    }
}
- (void)removeObserver:(id<LocationManagerProtocol>)observer{
    if ([_listObservers containsObject:observer]) {
        [_listObservers removeObject:observer];
    }
}

- (NSArray *)getAllObservers{
    return [_listObservers copy];
}

@end

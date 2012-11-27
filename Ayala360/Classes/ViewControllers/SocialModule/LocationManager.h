//
//  LocationManager.h
//  Foursquare3
//
//  Created by Martin on 11/27/12.
//  Copyright (c) 2012 Ripplewave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerProtocol;
@interface LocationManager : NSObject <CLLocationManagerDelegate>{
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _tempCoord;
	CLLocationCoordinate2D _curCoord;
    
    //Observer
    NSMutableArray *_listObservers;
}
- (void)start;
- (NSInteger)getDistanceToCoordinateInMeters:(CLLocationCoordinate2D) coordinate;

//OBSERVER
- (void)addObserver:(id<LocationManagerProtocol>)observer;
- (void)removeObserver:(id<LocationManagerProtocol>)observer;
- (NSArray *)getAllObservers;
@end

@protocol LocationManagerProtocol <NSObject>
- (void)_locationManagerNotification:(CLLocation *)location;
@end

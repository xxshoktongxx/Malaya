//
//  DataManager.h
//  Ayala360
//
//  Created by Martin on 11/21/12.
//
//

#import <Foundation/Foundation.h>
#import "Mall.h"
#import <CoreLocation/CoreLocation.h>
@interface DataManager : NSObject
@property (nonatomic, retain) Mall *mall;
@property (nonatomic, retain) CLLocation *currentLocation;
@end

//
//  MapAnnotation.h
//  Ayala360
//
//  Created by Martin on 11/29/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>{
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (assign) int index;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address index:(int)index coordinate:(CLLocationCoordinate2D)coordinate;
@end

//
//  Mall.h
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import <Foundation/Foundation.h>

@class Map;
@interface Mall : NSObject{
    Map *map;
}
@property (nonatomic, retain) NSNumber *mUniqueId; //Mall identifier
@property (nonatomic, retain) NSNumber *mName;  //Mall name
@property (nonatomic, retain) NSMutableDictionary *listMap; //Holds the mall map per level.
@property (nonatomic, retain) NSMutableDictionary *listStore; //Holds the stores inside the mall.

- (id)initWithData:(id)data;
@end

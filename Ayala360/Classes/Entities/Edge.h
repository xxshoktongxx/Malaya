//
//  Edge.h
//  Ayala360
//
//  Created by Martin on 11/14/12.
//
//

#import <Foundation/Foundation.h>
@class Node;

@interface Edge : NSObject
@property(nonatomic,retain) __strong Node *start;
@property(nonatomic,retain) __strong Node *end;
@property(nonatomic,retain) NSNumber *cost;

- (id)initWithData:(NSDictionary *)data;
@end

//
//  FacebookManager.h
//  FacebookTest
//
//  Created by martin magalong on 11/30/12.
//  Copyright (c) 2012 ripplewave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookManager : NSObject
@property (strong, nonatomic) FBSession *session;
//@property (strong, nonatomic) FBSession *activeSession;
+ (FacebookManager *)sharedInstance;
- (void)login:(void(^)(void))finish;
- (void)logout;
- (BOOL)isAuthenticated;
- (void)publishStory:(NSDictionary *)param callback:(void(^)(void))callback;
- (void)getNearBy:(NSDictionary *)param callback:(void(^)(id))callback;
@end


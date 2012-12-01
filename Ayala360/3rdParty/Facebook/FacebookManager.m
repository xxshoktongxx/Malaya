//
//  FacebookManager.m
//  FacebookTest
//
//  Created by martin magalong on 11/30/12.
//  Copyright (c) 2012 ripplewave. All rights reserved.
//

#import "FacebookManager.h"

@implementation FacebookManager


static FacebookManager *_facebookManager = nil;

+(FacebookManager *)sharedInstance{
    if (_facebookManager == nil) {
        _facebookManager = [[self alloc]init];
    }
    return _facebookManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self showDebugLog];
        NSArray *array = [[NSArray alloc]initWithObjects:@"status_update",@"publish_actions",@"publish_stream",@"read_stream",@"publish_checkins", nil];
        self.session = [[FBSession alloc] initWithPermissions:array];
    }
    return self;
}

#pragma mark - 
#pragma mark Actions
#pragma mark Post Story
- (void)postStory:(NSDictionary *)param callback:(void(^)(void))callback{
    [param setValue:_session.accessToken forKey:@"access_token"];
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:param
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:@"Failed!"];
         } else {
             alertText = [NSString stringWithFormat:@"Success!"];
         }
         [self showAlertWithText:alertText];
         callback();
     }];
}

- (void)publishStory:(NSDictionary *)param callback:(void(^)(void))callback{
    if ([self.session.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        [self.session
         reauthorizeWithPublishPermissions:
         [NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 // If permissions granted, publish the story
                 [self postStory:param callback:callback];
             }
         }];
    } else {
        // If permissions present, publish the story
        [self postStory:param callback:callback];
    }
}

#pragma mark Nearby Places
- (void)getNearBy:(NSDictionary *)param callback:(void(^)(id))callback{
        [param setValue:_session.accessToken forKey:@"access_token"];
        [FBRequestConnection
         startWithGraphPath:@"search"
         parameters:param
         HTTPMethod:@"GET"
         completionHandler:^(FBRequestConnection *connection,
                             id result,
                             NSError *error) {
             NSString *alertText;
             if (error) {
                 alertText = [NSString stringWithFormat:@"Failed!"];
             } else {
                 alertText = [NSString stringWithFormat:@"Success!"];
             }
//             [self showAlertWithText:alertText];
             callback(result);
         }];
    
//    FBRequest *request = [FBRequest requestForPlacesSearchAtCoordinate:location radiusInMeters:500 resultsLimit:20 searchText:@""];
//    [FBRequestConnection startForPostWithGraphPath:[request graphPath] graphObject:[request graphObject]completionHandler:nil];
}

#pragma mark CheckIn

#pragma mark others
- (void)showAlertWithText:(NSString *)alertText{
    // Show the result in an alert
    [[[UIAlertView alloc] initWithTitle:@"Result"
                                message:alertText
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
}

- (void)showDebugLog{
    if (DEBUG) {
        [FBSettings setLoggingBehavior:[NSSet setWithObjects:FBLoggingBehaviorFBRequests, FBLoggingBehaviorFBURLConnections, nil]];
    }
}


#pragma mark -
#pragma mark Session
- (void)login:(void(^)(void))finish{
    if (!self.session.isOpen) {
        if (self.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            self.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [self.session openWithCompletionHandler:^(FBSession *session,
                                                  FBSessionState status,
                                                  NSError *error) {
            finish();
            // and here we make sure to update our UX according to the new session state
        }];
    }
    else{
        finish();
    }
}

- (void)logout{
    if (self.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [self.session closeAndClearTokenInformation];
    }
}

- (BOOL)isAuthenticated{
    if (self.session.isOpen) {
        return YES;
    }
    return NO;
}
@end

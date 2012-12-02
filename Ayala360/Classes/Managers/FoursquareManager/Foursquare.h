//
//  Foursquare.h
//
//  Created by martin magalong on 11/28/12.
//  Copyright (c) 2012 ripplewave. All rights reserved.
//

/** ==============================================================================
 INSTRUCTIONS:
 
 1. Add/Import AFNetwork files in current project.
 2. Add the following frameworks; Security, CoreLocation, SystemConfiguration, MobileCoreServices.
 3. Add/Import Foursquare.h and Foursquare.m in current project.
 4. Classes which will make foursquare request must add the "BLOCK" code in their implementation.
     void(^_success)(id,id) = ^void(AFHTTPRequestOperation *operation, id responseObject){
     NSLog(@"success");
     [MY_CLASS_NAME didSucceedRequest:operation responseObject:responseObject];
     };
     
     void(^_fail)(id,id) = ^void(AFHTTPRequestOperation *operation, NSError *error){
     NSLog(@"%@",error);
     [MY_CLASS_NAME didFailRequest:operation error:error];
     };
 5. Classes which make foursquare request must implement Foursquare Protocol. The protocol methods will be called by the blocks in the previous step.
 
 ============================================================================== **/
#import "AFHTTPClient.h"

typedef enum{
    typePost,
    typeGet,
}HTTPMethodType;

@protocol FoursquareDelegate;
@interface Foursquare : AFHTTPClient <UIWebViewDelegate>{
    /** For application authentication. */
    UIWebView *_webview;
    /** Reference to the auth key after authentication process. */
    NSString *_tokenId;
    /** Hold a copy of callback to be excuted after authentication. */
    void(^_callback)(BOOL);
    /** Type of request method for specific request. */
    HTTPMethodType *httpMethodType;
    
    void(^_success)(id,id);
    void(^_fail)(id,id);
}

@property (nonatomic, assign)id<FoursquareDelegate>delegate;

//+ (Foursquare *)sharedInstance;
/** Starts the authentication process.*/
- (void)startAuthentication:(void(^)(BOOL))callback;
- (BOOL)isSessionValid;
/** Method used when making a urlRequest */
- (void)requestWithPath:(NSString *)path methodType:(HTTPMethodType)method parameters:(NSDictionary *)parameters success:(id)success fail:(id)fail;

- (void)searchVenuesWithParam:(NSDictionary *)param;
- (void)checkinWithParam:(NSDictionary *)param;
//- (void)addPostWithParam:(NSDictionary *)param;
@end

@protocol FoursquareDelegate <NSObject>
@required
- (void)_didSucceedRequest:(AFHTTPRequestOperation *)operation responseObject:(id)object;
- (void)_didFailRequest:(AFHTTPRequestOperation *)operation error:(NSError *)error;
@end;

/**
 Actual code when making request via GET or POST method.
 
 //Code starts here
 //GET REQUEST
 NSDictionary *param = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"37.33,-122.03",@"ll",
 @"4bf58dd8d48988d1e0931735",@"categoryId",@"2",@"limit",
 @"20120506",@"v",nil];
 [[Foursquare sharedInstance]requestWithPath:@"venues/search" methodType:typeGet parameters:param success:_success fail:_fail];
 
 //POST REQUEST
 NSDictionary *param2 = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"ITS REAL LY",@"name",@"44.3,37.2",@"ll", nil];
 [[Foursquare sharedInstance]requestWithPath:@"venues/add" methodType:typePost parameters:param2 success:_success fail:_fail];
 //Code ends here
 
*/

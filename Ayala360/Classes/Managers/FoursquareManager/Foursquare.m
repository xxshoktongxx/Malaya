//
//  Foursquare.m
//
//  Created by martin magalong on 11/28/12.
//  Copyright (c) 2012 ripplewave. All rights reserved.
//

#import "Foursquare.h"

@implementation Foursquare

#define kFOURSQUARE_AUTH_BASE_URL  @"https://foursquare.com/oauth2/authorize"
#define kFOURSQUARE_BASE_URL  @"https://api.Foursquare.com/v2/"
#define kFOURSQUARE_CLIENT_ID @"10MGRKDEYRVM32E2EBN1FET3G45YJP3CFYQ3DTCQ2JFNGL0V"
#define KFOURSQAURE_CALLBACK_URL @"http://ripple-wave.com"
#define kFOURSQUARE_AUTH_KEY @"AUTH_KEY"

+ (Foursquare *)sharedInstance{
    static Foursquare *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Foursquare alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:kFOURSQUARE_BASE_URL]];
    if (self) {
        _tokenId = [[NSUserDefaults standardUserDefaults]objectForKey:kFOURSQUARE_AUTH_KEY];
    }
    return self;
}

- (BOOL)isSessionValid{
    if(_tokenId){
        return YES;
    }
    return NO;
}

- (void)requestWithPath:(NSString *)path methodType:(HTTPMethodType)method parameters:(NSMutableDictionary *)parameters success:(id)success fail:(id)fail{
    if ([self isSessionValid]){
        [parameters setObject:_tokenId forKey:@"oauth_token"];
        if(method == typeGet){
            [self getPath:path parameters:parameters success:success failure:fail];
        }
        else if (method == typePost){
            [self postPath:path parameters:parameters success:success failure:fail];
        }
    }
    else{
        NSLog(@"MISSING TOKEN");
    }
}

#pragma mark - Authentication Process
- (void)startAuthentication:(void(^)(void))callback{
    if (![self isSessionValid]) {
        _callback = [callback copy];
        NSMutableArray *pairs = [NSMutableArray array];
        NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                   @"token",@"response_type",
                                   kFOURSQUARE_CLIENT_ID,@"client_id",
                                   KFOURSQAURE_CALLBACK_URL,@"redirect_uri",
                                   nil];

        for (NSString *key in parameters) {
            NSString *value = [parameters objectForKey:key];
            CFStringRef escapedValue = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)value, NULL, CFSTR("%:/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
            NSMutableString *pair = [key mutableCopy];
            [pair appendString:@"="];
            [pair appendString:(__bridge NSString *)escapedValue];
            [pairs addObject:pair];
            CFRelease(escapedValue);
        }
        NSString *URLString = kFOURSQUARE_AUTH_BASE_URL;
        NSMutableString *mURLString = [URLString mutableCopy];
        [mURLString appendString:@"?"];
        [mURLString appendString:[pairs componentsJoinedByString:@"&"]];
        NSURL *URL = [NSURL URLWithString:mURLString];
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:URL];
        _webview = [[UIWebView alloc]init];
        _webview.frame = (CGRect){.origin=CGPointMake(0,0),.size=CGSizeMake(320, 300)};
        _webview.delegate = self;
        [_webview loadRequest:request];
        UIView *view = [[UIApplication sharedApplication]keyWindow];
        [view addSubview:_webview];
    }
    else{
        if (callback != nil) {
            callback();
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestUrl = [[request URL] absoluteString];
    NSRange range = [requestUrl rangeOfString:@"access_token="];
    if (range.location != NSNotFound) {
        _tokenId = [[requestUrl componentsSeparatedByString:@"="] lastObject];
        [[NSUserDefaults standardUserDefaults] setValue:_tokenId forKey:kFOURSQUARE_AUTH_KEY];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSLog(@"TokenId: %@",_tokenId);
        [_webview removeFromSuperview];
        if (_tokenId) {
            if (_callback) {
                _callback();
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Sorry but something went wrong. Kindly reload this page." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
    }
    return YES;
}
@end

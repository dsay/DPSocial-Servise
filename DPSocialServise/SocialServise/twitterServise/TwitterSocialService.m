//
//  TwitterSocialService.m
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterSocialService.h"

#import "OAuthConsumer.h"
#import "OAuth.h"

typedef void (^LoadSel)(id);

@interface TwitterSocialService() 

@property (readwrite, copy)   LoadSel onSelectBlock;
@property (nonatomic, retain) NSMutableArray *quare;
@property (nonatomic, retain) OAConsumer *consumer;
@property (nonatomic, retain) OAToken *accessToken;
@property (nonatomic, retain) AuthorizeWebViewController *authorizeWebView;

@end

@implementation TwitterSocialService

@synthesize onSelectBlock;
@synthesize quare = _quare;
@synthesize consumer = _consumer;
@synthesize accessToken = _accessToken;
@synthesize authorizeWebView = _authorizeWebView;

#pragma mark - 
#pragma mark init

- (id)initWithDelegate:(id<DPSocialServiseProtocolDelegate>)delegate
{
    if (self = [super init]) 
        if (delegate) 
            self.delegate = delegate;
    
    return self;
}

#pragma mark - 
#pragma mark open

- (BOOL)isAuthorized;
{
    if (![super isConnection]) 
       return NO;
    
    [self consumer];
    self.accessToken = [[OAToken alloc]initWithKey:[[NSUserDefaults standardUserDefaults] stringForKey:TwitterAccessTokenKey] 
                                            secret:[[NSUserDefaults standardUserDefaults] stringForKey:TwitterSecretTokenKey]];
    
    if(_accessToken.key && _accessToken.secret && _consumer)
        return YES;
    
    return NO;
}

- (void)login
{
    if (![super isConnection])
        return;
    
    if(![self isAuthorized]){
 
        OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TwitterRequest]
                                                                       consumer:self.consumer
                                                                          token:nil
                                                                          realm:nil
                                                              signatureProvider:nil] ;
        
        [request setHTTPMethod:@"POST"];
        OARequestParameter *p0 = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:@"oob"];
        
        NSArray *params = [NSArray arrayWithObject:p0];
        [request setParameters:params];
        
        OADataFetcher *fetcher = [[OADataFetcher alloc] init];
        
        
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(responseCousumerAuthorized:didFinishWithData:)
                      didFailSelector:@selector(responseCousumerAuthorized:didFailWithError:)];
    }
}

- (void)logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:TwitterAccessTokenKey];
    [defaults setObject:nil forKey:TwitterSecretTokenKey];
    [defaults setObject:nil forKey:TwitterUserID];
    [defaults setObject:nil forKey:TwitterUserScreenName];
    [defaults synchronize];
    
    self.accessToken = nil;
}

- (void)getUserInfo
{
    if ([self isAuthorized]) {
        
        OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TwitterUserInfo]
                                                                        consumer:self.consumer
                                                                           token:self.accessToken
                                                                           realm:nil
                                                               signatureProvider:nil];
        
        [oRequest setHTTPMethod:@"GET"];
        OADataFetcher *fetcher = [[OADataFetcher alloc] init] ;
        
        
        [fetcher fetchDataWithRequest:oRequest
                             delegate:self
                    didFinishSelector:@selector(getUserInfo:didFinishWithData:)
                      didFailSelector:@selector(getUserInfo:didFailWithError:)];	
        
        
    }else{
        
        onSelectBlock = ^ (id himself) {[himself getUserInfo];};
        [self.quare   addObject:onSelectBlock];
        [self login];
        
    }
}

- (void)getFriendsInfo
{
    if ([self isAuthorized]) {
        
        OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TwitterFriendsID]
                                                                        consumer:self.consumer
                                                                           token:self.accessToken
                                                                           realm:nil
                                                               signatureProvider:nil];
        [oRequest setHTTPMethod:@"GET"];
        
        OARequestParameter* p = [[OARequestParameter alloc] initWithName:@"screen_name" 
                                                                   value:[[NSUserDefaults standardUserDefaults] stringForKey:TwitterUserScreenName]];
        [oRequest setParameters:[NSArray arrayWithObject:p]];
        
        OADataFetcher *fetcher = [[OADataFetcher alloc] init] ;
        
        
        [fetcher fetchDataWithRequest:oRequest
                             delegate:self
                    didFinishSelector:@selector(getFriendsID:didFinishWithData:)
                      didFailSelector:@selector(getFriendsID:didFailWithError:)];
        
    }else{
        
        onSelectBlock = ^ (id himself) {[himself getFriendsInfo];};
        [self.quare addObject:onSelectBlock];
        [self login];
        
    }
}

- (void)postOnMyWallMessage:(NSString *)message imageURL:(NSString *)path link:(NSString *)url
{
    if ([self isAuthorized]) {
        
        OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TwitrerUpdate]
                                                                       consumer:self.consumer
                                                                          token:self.accessToken
                                                                          realm:nil
                                                              signatureProvider:nil] ;
        
        [request setHTTPMethod:@"POST"];
        
        
        NSString *mes = [NSString stringWithFormat:@"%@ %@",message,url];
        
        OARequestParameter *x1 = [[OARequestParameter alloc] initWithName:@"status" value:mes];
        
        NSArray *params = [NSArray arrayWithObjects:x1, nil];
        [request setParameters:params];
        
        
        OADataFetcher *fetcher = [[OADataFetcher alloc] init];
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(postOnMyWallStatus:didFinishWithData:)
                      didFailSelector:@selector(postOnMyWallStatus:didFailWithError:)];
        
        
    }else{
        
        onSelectBlock = ^ (id himself) {[himself postOnMyWallMessage:message imageURL:path link:url];};
        [self.quare addObject:onSelectBlock];
        [self login];
        
    }
}
- (void)postOnFriendsWallMessage:(NSString *)message friendID:(NSNumber *)frien imageURL:(NSString *)path link:(NSString *)url
{
    if ([self isAuthorized]) {
        
        OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TwitterFriendsUpdate]
                                                                        consumer:self.consumer
                                                                           token:self.accessToken
                                                                           realm:nil
                                                               signatureProvider:nil];
        [oRequest setHTTPMethod:@"POST"];
        
        OARequestParameter* p = [[OARequestParameter alloc] initWithName:@"text" value:[NSString stringWithFormat:@"%@ %@",message,url]];
        OARequestParameter* usersID = [[OARequestParameter alloc] initWithName:@"user_id" value:[frien stringValue]];
        [oRequest setParameters:[NSArray arrayWithObjects:p, usersID, nil]];
        OADataFetcher *fetcher = [[OADataFetcher alloc] init];
        [fetcher fetchDataWithRequest:oRequest
                             delegate:self
                    didFinishSelector:@selector(postOnFriendWallStatus:didFinishWithData:)
                      didFailSelector:@selector(postOnFriendWallStatus:didFailWithError:)]; 
        
    }else{
        
        onSelectBlock = ^ (id himself) {[himself postOnFriendsWallMessage:message friendID:frien imageURL:path link:url];};
        [self.quare addObject:onSelectBlock];
        [self login];
        
    }
}
#pragma mark - 
#pragma mark privat

#pragma mark Response Cousumer Authorized
- (void)responseCousumerAuthorized:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        if (self.accessToken != nil) {
            self.accessToken = nil;
        }
        _accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
       
        
        OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TwitterAuthorize]
                                                                       consumer:self.consumer
                                                                          token:self.accessToken
                                                                          realm:nil
                                                              signatureProvider:nil];
        
        
        OARequestParameter *p0 = [[OARequestParameter alloc] initWithName:@"oauth_token"
                                                                    value:self.accessToken.key];
        NSArray *params = [NSArray arrayWithObject:p0];
        [request setParameters:params];
        
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        [keyWindow addSubview:self.authorizeWebView.view];
        [self.authorizeWebView.webView loadRequest:request];

    }

}
- (void)responseCousumerAuthorized:(OAServiceTicket *)ticket didFailWithError:(NSError *)error 
{

    if ([self.delegate respondsToSelector:@selector(socialService:didFailWithError:)]) 
        [self.delegate socialService:self didFailWithError:error];
}

#pragma mark Web User Authorized delegate

- (void)successfulAuthorizationWithPin:(NSString *)pin
{
    [self.authorizeWebView.view removeFromSuperview];

	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TwitterAccess]
                                                                   consumer:self.consumer
                                                                      token:self.accessToken
                                                                      realm:nil
                                                          signatureProvider:nil];
	
	
	OARequestParameter *p0 = [[OARequestParameter alloc] initWithName:@"oauth_token"
                                                                value:self.accessToken.key];
	OARequestParameter *p1 = [[OARequestParameter alloc] initWithName:@"oauth_verifier"
                                                                value:pin];
	NSArray *params = [NSArray arrayWithObjects:p0, p1, nil];
	[request setParameters:params];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
	
	[fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(responseUserAuthorized:didFinishWithData:)
				  didFailSelector:@selector(responseUserAuthorized:didFailWithError:)];
}

- (void)failedAuthorization
{
    [self.authorizeWebView.view removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(socialService:didFailWithError:)]) 
        [self.delegate socialService:self didFailWithError:[NSError errorWithDomain:@"You cannot Authorization !!" code:2 userInfo:nil]];  
}

#pragma mark Response User Authorized

-(void)responseUserAuthorized:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        NSArray *pairs = [responseBody componentsSeparatedByString:@"&"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        
        for (NSString *pair in pairs) {
            if ([pair hasPrefix:@"oauth_token="]) {
                [defaults setObject:[pair stringByReplacingOccurrencesOfString:@"oauth_token=" withString:@""] forKey:TwitterAccessTokenKey];
            }
            if ([pair hasPrefix:@"oauth_token_secret="]) {
                [defaults setObject:[pair stringByReplacingOccurrencesOfString:@"oauth_token_secret=" withString:@""] forKey:TwitterSecretTokenKey];
            }
            if ([pair hasPrefix:@"user_id="]) {
                [defaults setObject:[pair stringByReplacingOccurrencesOfString:@"user_id=" withString:@""] forKey:TwitterUserID];
            }
            if ([pair hasPrefix:@"screen_name="]) {
                [defaults setObject:[pair stringByReplacingOccurrencesOfString:@"screen_name=" withString:@""] forKey:TwitterUserScreenName];
            }
        }
        
        [defaults synchronize];   
        
        if (self.accessToken != nil) 
            self.accessToken = nil;
        
        for (LoadSel block in _quare) 
            block(self);
        
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        

        if ([self.delegate respondsToSelector:@selector(socialServiceDidLogin:)])
            [self.delegate socialServiceDidLogin:self];
    }
}
-(void)responseUserAuthorized:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
   
    if ([self.delegate respondsToSelector:@selector(socialService:didFailWithError:)]) 
        [self.delegate socialService:self didFailWithError:error];
}

#pragma mark Get User Info
- (void)getUserInfo:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
    if (ticket.didSucceed) {
    
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;	
        SBJSON *parser = [[SBJSON alloc] init];
        NSDictionary *status = [parser objectWithString:string error:nil];
    
        User *user = [[User alloc] init];
        user.userID = [status objectForKey:@"id"];
        user.imageURL = [status objectForKey:@"profile_image_url"];
        user.name = [status objectForKey:@"name"];
        user.screenname = [status objectForKey:@"screen_name"];
        
        if ([self.delegate respondsToSelector:@selector(socialService:didLoadUserInfo:)]) 
            [self.delegate socialService:self didLoadUserInfo:user];     
    }
    
}

- (void)getUserInfo:(OAServiceTicket *)ticket didFailWithError:(NSError *)error 
{
    if ([self.delegate respondsToSelector:@selector(socialService:didFailWithError:)]) 
        [self.delegate socialService:self didFailWithError:error];    
}

#pragma mark Get Friends ID
- (void)getFriendsID:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed) {
        
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;	
        SBJSON *parser = [[SBJSON alloc] init];
        NSMutableDictionary *json = [parser objectWithString:string error:nil];
        
        NSMutableArray *status = [NSMutableArray arrayWithArray: [json objectForKey:@"ids"]];
        
        
        OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TwitterFriendsInfo]
                                                                        consumer:self.consumer
                                                                           token:self.accessToken
                                                                           realm:nil
                                                               signatureProvider:nil];
        [oRequest setHTTPMethod:@"GET"];
        
        int pages = (int)([status count] / 50);
        for (int page = 0; page <= pages; page++) {
            
            int count = 0;
            
            if ([status count] > 50) {
                count = 50;
            } else {
                count= [status count];
            }
            
            NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
            
            for (int i = 0; i < count; i ++) {
                [indexes addIndex:i];
            }
            
            NSMutableArray *friends = [NSMutableArray array];
            [friends addObjectsFromArray:[status objectsAtIndexes:indexes]];
            [status removeObjectsAtIndexes:indexes];
            
            OARequestParameter* requestParameter = [[OARequestParameter alloc] initWithName:@"user_id" 
                                                                                      value:[friends componentsJoinedByString:@", "]];
            [oRequest setParameters:[NSArray arrayWithObject:requestParameter]];
            
            OADataFetcher *friendsFetcher = [[OADataFetcher alloc] init];
            [friendsFetcher fetchDataWithRequest:oRequest
                                        delegate:self
                               didFinishSelector:@selector(getFriendsInfo:didFinishWithData:)
                                 didFailSelector:@selector(getFriendsInfo:didFailWithError:)]; 
            
        }
    }
}
- (void)getFriendsID:(OAServiceTicket *)ticket didFailWithError:(NSError *)error 
{
    if ([self.delegate respondsToSelector:@selector(socialService:didFailWithError:)]) 
        [self.delegate socialService:self didFailWithError:error];    
}

#pragma mark Get Friends Info
- (void)getFriendsInfo:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;	
        SBJSON *parser = [[SBJSON alloc] init];
        
        NSMutableArray *status = [parser objectWithString:string error:nil];

        for (NSMutableDictionary *dict in status) {
            User *friend = [[User alloc] init];
            friend.name = [dict objectForKey:@"name"];
            friend.imageURL = [dict objectForKey:@"profile_image_url"];
            friend.screenname = [dict objectForKey:@"screen_name"];
            friend.userID = [dict objectForKey:@"id"];
            [array addObject:friend];
        }

        if ([self.delegate respondsToSelector:@selector(socialService:didLoadFriendsInfo:)]) 
            [self.delegate socialService:self didLoadFriendsInfo:array];
    }

}
- (void)getFriendsInfo:(OAServiceTicket *)ticket didFailWithError:(NSError *)error 
{
    if ([self.delegate respondsToSelector:@selector(socialService:didFailWithError:)]) 
        [self.delegate socialService:self didFailWithError:error];   
}

#pragma mark Post on my wall
- (void)postOnMyWallStatus:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
    if ([self.delegate respondsToSelector:@selector(socialServiceDidPost:)])  
        [self.delegate socialServiceDidPost:self];
    
    NSLog(@"post on my wall");
}
- (void)postOnMyWallStatus:(OAServiceTicket *)ticket didFailWithError:(NSError *)error 
{
    if ([self.delegate respondsToSelector:@selector(socialService:didFailWithError:)]) 
        [self.delegate socialService:self didFailWithError:error];
}

#pragma mark Post on friend wall
- (void)postOnFriendWallStatus:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed) {
        if ([self.delegate respondsToSelector:@selector(socialServiceDidPost:)])  
            [self.delegate socialServiceDidPost:self];
        
        NSLog(@"post on friends wall");
    }else
        if ([self.delegate respondsToSelector:@selector(socialService:didFailWithError:)]) 
            [self.delegate socialService:self didFailWithError:[NSError errorWithDomain:@"You cannot send messages to users who are not following you" code:1 userInfo:nil]];
    NSLog(@"You cannot send messages to users who are not following you");
}  

-(void)postOnFriendWallStatus:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(socialService:didFailWithError:)]) 
        [self.delegate socialService:self didFailWithError:error];
}

#pragma mark - 
#pragma mark property

-(AuthorizeWebViewController *)authorizeWebView
{
    if (_authorizeWebView) 
        return _authorizeWebView;
    
    _authorizeWebView =[[AuthorizeWebViewController alloc] initWithNibName:@"AuthorizeWebViewController" bundle:nil];
    _authorizeWebView.delegate = self;
    
    return _authorizeWebView;
        
}

-(NSMutableArray *)quare
{
    if (_quare) 
        return _quare;
    
    _quare = [[NSMutableArray alloc] init];
    return _quare;

}

-(OAConsumer *)consumer
{ 
    if (_consumer) 
        return _consumer;
    
    _consumer = [[OAConsumer alloc] initWithKey:TwitterKey
                                             secret:TwitterSecret];
    return _consumer;
}

@end

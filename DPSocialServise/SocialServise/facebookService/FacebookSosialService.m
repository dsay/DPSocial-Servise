//
//  FacebookSosialService.m
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookSosialService.h"

typedef void (^LoadSel)(id);

@interface FacebookSosialService() 


@property (nonatomic, strong) Facebook *facebook;
@property (readwrite, copy)   LoadSel onSelectBlock;
@property (nonatomic, strong) NSMutableArray *quare;
@property (nonatomic, assign) BOOL didOpenAuthorizedDialog;
@property (nonatomic, strong) NSArray *permissions;

- (User *)parseInfo:(NSDictionary *)users;

@end


@implementation FacebookSosialService

@synthesize facebook = _facebook;
@synthesize onSelectBlock;
@synthesize quare = _quare;
@synthesize didOpenAuthorizedDialog;
@synthesize permissions = _permissions;

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
    
    if ([self.facebook isSessionValid]) 
        return YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.facebook.accessToken = [defaults stringForKey:FacebookAccessTokenKey];
    self.facebook.expirationDate = [defaults objectForKey:FacebookExpiryDateKey];
    
    return [self.facebook isSessionValid];
}

- (void)login
{
    if (![super isConnection]) 
        return ;
    
    if (!didOpenAuthorizedDialog) 
        if(![self isAuthorized]){
            
            [self.facebook authorize:self.permissions];
            didOpenAuthorizedDialog = YES;
        }
}

- (void)logout
{
    [self.facebook logout:self];

}

- (void)getUserInfo
{
    if ([self isAuthorized]) {
        
        [self.facebook requestWithGraphPath:@"me" andDelegate:self];
        
    }else{
        
        onSelectBlock = ^ (id himself) {[himself getUserInfo];};
        [self.quare   addObject:onSelectBlock];
        [self login];
        
    }
}

- (void)getFriendsInfo
{
     if ([self isAuthorized]) {
         
         [self.facebook requestWithGraphPath:@"me/friends" andDelegate:self];
         
     }else{
         
         onSelectBlock = ^ (id himself) {[himself getFriendsInfo];};
         [self.quare addObject:onSelectBlock];
         [self login];
         
     }
}

- (void)postOnMyWallMessage:(NSString *)message imageURL:(NSString *)path link:(NSString *)url
{
    if ([self isAuthorized]) {
    
        NSString *graph = [NSString stringWithFormat:@"feed"];        

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *actions = [NSString stringWithFormat:@"{\"name\":\"Get %@\",\"link\":\"%@\"}",  
                                                        MyAppName, MyAppURL];
       
        [params setObject:actions forKey:@"actions"];
        [params setObject:url forKey:@"link"];
        [params setObject:message forKey:@"name"];
        [params setObject:path forKey:@"picture"];
        
        [self.facebook requestWithGraphPath:graph andParams:params andHttpMethod:@"POST" andDelegate:self];
      
        if ([self.delegate respondsToSelector:@selector(socialServiceDidPost:)])    
            [self.delegate socialServiceDidPost:self];
    
    }else{
    
        onSelectBlock = ^ (id himself) {[himself postOnMyWallMessage:message imageURL:path link:url];};
        [self.quare addObject:onSelectBlock];
        [self login];
    
    }
}
- (void)postOnFriendsWallMessage:(NSString *)message friendID:(NSNumber *)frien imageURL:(NSString *)path link:(NSString *)url
{
     if ([self isAuthorized]) {
    
        NSString *graph = [NSString stringWithFormat:@"%@/feed",frien];        
        
         NSMutableDictionary *params = [NSMutableDictionary dictionary];
         NSString *actions = [NSString stringWithFormat:@"{\"name\":\"Get %@\",\"link\":\"%@\"}",  
                                                        MyAppName, MyAppURL];
         
         [params setObject:actions forKey:@"actions"];
         [params setObject:url forKey:@"link"];
         [params setObject:message forKey:@"name"];
         [params setObject:path forKey:@"picture"];
        
        
        [self.facebook requestWithGraphPath:graph andParams:params andHttpMethod:@"POST" andDelegate:self];
         
         if ([self.delegate respondsToSelector:@selector(socialServiceDidPost:)])  
             [self.delegate socialServiceDidPost:self];
    
     }else{
     
         onSelectBlock = ^ (id himself) {[himself postOnFriendsWallMessage:message friendID:frien imageURL:path link:url];};
         [self.quare addObject:onSelectBlock];
         [self login];
    
     }
}

#pragma mark - 
#pragma mark facebook delegate
-(void)fbDidLogin
{
    NSString *accessToken = [self.facebook accessToken];
    NSDate *expiryDate = [self.facebook expirationDate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:FacebookAccessTokenKey];
    [defaults setObject:expiryDate forKey:FacebookExpiryDateKey];
    [defaults synchronize];
    
    for (LoadSel block in _quare) 
        block(self);
    
    didOpenAuthorizedDialog = NO;
    
     if ([self.delegate respondsToSelector:@selector(socialServiceDidLogin:)])
         [self.delegate socialServiceDidLogin:self];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    didOpenAuthorizedDialog = NO;
}

-(void)fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:FacebookAccessTokenKey];
    [defaults setObject:nil forKey:FacebookExpiryDateKey];
    [defaults synchronize];
}

-(void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    [self.delegate socialService:self  didFailWithError:error];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    
    
    if ([request.url isEqualToString:FacebookUserInfo]) {
        
        if ([self.delegate respondsToSelector:@selector(socialService:didLoadUserInfo:)]) 
            [self.delegate socialService:self didLoadUserInfo:[self parseInfo:result]];
        
    } else if([request.url isEqualToString:FacebookFriendsInfo]){
        
        NSMutableArray *friendsToAdd = [NSMutableArray array];
        NSDictionary *data = [result objectForKey:@"data"];
        
        if (data) {
            for (NSDictionary *friend in data) 
                [friendsToAdd addObject:[self parseInfo:friend]];
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            [friendsToAdd sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            
            if ([self.delegate respondsToSelector:@selector(socialService:didLoadFriendsInfo:)])
                [self.delegate  socialService:self didLoadFriendsInfo:friendsToAdd];
            
        }
        
    }
}
#pragma mark - 
#pragma mark privat

-(User *)parseInfo:(NSDictionary *)users
{
    User *user = [[User alloc] init];
    user.userID = [users objectForKey:@"id"];
    user.name = [users objectForKey:@"name"];
    user.firstName = [users objectForKey:@"first_name"];
    user.imageURL = [NSString stringWithFormat:FacebookGetImageWihtID,[users objectForKey:@"id"]]; 
    
    return user;
}
#pragma mark - 
#pragma mark property

-(Facebook *)facebook
{
    if (_facebook) {
        return _facebook;
    }
    _facebook = [[Facebook alloc] initWithAppId:FacebookKey andDelegate:self];
    return _facebook;
}

-(NSMutableArray *)quare
{
    if (_quare) 
        return _quare;
    _quare = [[NSMutableArray alloc] init];
    return _quare;
}

-(NSArray *)permissions
{
    if (_permissions) 
        return _permissions;
    _permissions = [NSArray arrayWithObjects: @"read_stream", 
                    @"publish_stream",
                    @"offline_access",
                    @"user_photos",
                    @"friends_location",
                    @"friends_photos",
                    @"friends_about_me",
                    @"user_about_me",
                    @"user_photos",
                    @"read_friendlists",
                    nil];
    return _permissions;
}

@end

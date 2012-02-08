//
//  DPSocialServise.m
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DPSocialServise.h"

#import "FacebookSosialService.h"
#import "TwitterSocialService.h"


@implementation DPSocialServise

@synthesize delegate;

@synthesize quare = _quare;
@synthesize didOpenAuthorizedDialog;

+ (DPSocialServise *)socialServiseType:(SocialServiseType)type andDelegate:(id<DPSocialServiseProtocolDelegate>)delegate
{
    switch (type) {
        case SocialServiseFacebook:
            return [[FacebookSosialService alloc] initWithDelegate:delegate];
            break;
        case SocialServiseTwitter:
            return [[TwitterSocialService alloc] initWithDelegate:delegate];
            break;    
        default:
            break;
    }
    return nil;
    
}
- (BOOL)isAuthorized
{
    return NO;
}
- (void)login
{
}
- (void)logout
{
}
- (void)getUserInfo
{
}
- (void)getFriendsInfo
{
}

- (void)postOnFriendsWallMessage:(NSString *)message friendID:(NSNumber *)frien imageURL:(NSString *)path link:(NSString *)url
{
}
- (void)postOnMyWallMessage:(NSString *)message imageURL:(NSString *)path link:(NSString *)url
{
}

-(void)callService:(LoadSel)block
{
     if ([self isConnection]) {
            if ([self isAuthorized]){
                block();
            }else{
                if (!didOpenAuthorizedDialog) 
                {
                    didOpenAuthorizedDialog = YES;
                    [self login];
                }
                [self.quare addObject:[block copy]];
            }    
        }
}

- (BOOL)isConnection
{    
    switch ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            return NO;
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            return YES;
            break;
        }
        default:
            return YES;
            NSLog(@"The internet is working via 3G.");
       
    }

}
#pragma mark - 
#pragma mark property

-(NSMutableArray *)quare
{
    if (_quare) 
        return _quare;
    _quare = [[NSMutableArray alloc] init];
    return _quare;
}
@end

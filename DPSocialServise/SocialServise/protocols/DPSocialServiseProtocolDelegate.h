//
//  DPSocialServiseProtocol.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class DPSocialService;

@protocol DPSocialServiseProtocolDelegate <NSObject>

@optional
- (void)socialServiceDidLogin:(DPSocialService *)servise;
- (void)socialServiceDidPost:(DPSocialService *)servise;

- (void)socialService:(DPSocialService *)service didLoadUserInfo:(User *)user;
- (void)socialService:(DPSocialService *)service didLoadFriendsInfo:(NSArray *)friends;

- (void)socialService:(DPSocialService *)servise didFailWithError:(NSError *)error;

@end

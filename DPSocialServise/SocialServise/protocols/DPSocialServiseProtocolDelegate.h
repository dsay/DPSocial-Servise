//
//  DPSocialServiseProtocol.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class DPSocialServise;

@protocol DPSocialServiseProtocolDelegate <NSObject>

@optional
- (void)socialServiceDidLogin:(DPSocialServise *)servise;
- (void)socialServiceDidPost:(DPSocialServise *)servise;

- (void)socialService:(DPSocialServise *)service didLoadUserInfo:(User *)user;
- (void)socialService:(DPSocialServise *)service didLoadFriendsInfo:(NSArray *)friends;

- (void)socialService:(DPSocialServise *)servise didFailWithError:(NSError *)error;

@end

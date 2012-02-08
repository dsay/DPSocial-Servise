//
//  DPSocialServiceProtocol.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DPSocialServiceProtocol <NSObject>

- (BOOL)isAuthorized;
- (void)login;
- (void)logout;

@optional

- (void)getUserInfo;
- (void)getFriendsInfo;

- (void)postOnFriendsWallMessage:(NSString *)message 
                        friendID:(NSNumber *)frien 
                        imageURL:(NSString *)path 
                            link:(NSString *)url;
- (void)postOnMyWallMessage:(NSString *)message 
                   imageURL:(NSString *)path 
                       link:(NSString *)url;


@end

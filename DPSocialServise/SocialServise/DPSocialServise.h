//
//  DPSocialServise.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DPSocialServiceProtocol.h"
#import "DPSocialServiseProtocolDelegate.h"
#import "User.h"
#import "Config.h"
#import "JSON.h"
#import "Reachability.h"
#import "DPShortURL.h"

typedef enum 
{
    SocialServiseFacebook,
    SocialServiseTwitter
    
}SocialServiseType;

@interface DPSocialServise : NSObject <DPSocialServiceProtocol>

@property (nonatomic, unsafe_unretained) id<DPSocialServiseProtocolDelegate>delegate;

+ (DPSocialServise *)socialServiseType:(SocialServiseType)type andDelegate:(id<DPSocialServiseProtocolDelegate>)delegate;
- (BOOL)isConnection;

@end

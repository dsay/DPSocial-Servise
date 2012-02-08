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

typedef void (^LoadSel)();

typedef enum 
{
    SocialServiseFacebook,
    SocialServiseTwitter
    
}SocialServiseType;

@interface DPSocialServise : NSObject <DPSocialServiceProtocol>

@property (nonatomic, unsafe_unretained) id<DPSocialServiseProtocolDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *quare;
@property (nonatomic, assign) BOOL didOpenAuthorizedDialog;
+ (DPSocialServise *)socialServiseType:(SocialServiseType)type andDelegate:(id<DPSocialServiseProtocolDelegate>)delegate;
- (BOOL)isConnection;
- (void)callService:(LoadSel)block;

@end

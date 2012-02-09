//
//  TwitterSocialService.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DPSocialService.h"
#import "AuthorizeWebViewController.h"

@interface TwitterSocialService : DPSocialService <AuthorizeWebViewControllerDelegate>

- (id)initWithDelegate:(id<DPSocialServiseProtocolDelegate>)delegate;

@end

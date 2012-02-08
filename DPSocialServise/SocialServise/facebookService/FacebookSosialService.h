//
//  FacebookSosialService.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPSocialServise.h"
#import "FBConnect.h"


@interface FacebookSosialService : DPSocialServise <FBDialogDelegate , FBRequestDelegate, FBSessionDelegate>

- (id)initWithDelegate:(id<DPSocialServiseProtocolDelegate>)delegate;

@end

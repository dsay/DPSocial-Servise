//
//  DPShortURL.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPShortURLProtocolDelegate.h"
#import "JSON.h"
#import "Config.h"

@interface DPShortURL : NSObject

@property (nonatomic, retain) id <DPShortURLProtocolDelegate>delegate;

- (void)getShortURL:(NSString *)string;

@end

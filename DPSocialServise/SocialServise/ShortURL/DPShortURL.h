//
//  DPShortURL.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSON.h"
#import "Config.h"

typedef void (^getURL)(NSString *bitLyURL, NSError *bitLyError);

@interface DPShortURL : NSObject

- (void)getShortURL:(NSString *)string completionUrl:(getURL)completionUrl;

@end

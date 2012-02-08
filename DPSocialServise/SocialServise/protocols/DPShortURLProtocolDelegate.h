//
//  DPShortURLProtocolDelegate.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DPShortURLProtocolDelegate <NSObject>

- (void)didLoadShortURL:(NSString *)shortURL;
- (void)didFailWithError:(NSError *)error;

@end

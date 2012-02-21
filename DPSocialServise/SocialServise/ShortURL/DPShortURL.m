//
//  DPShortURL.m
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DPShortURL.h"



@implementation DPShortURL


- (void)getShortURL:(NSString *)string completionUrl:(getURL)completionUrl
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *shortURL = nil;
        NSString *urlWithoutParams = [NSString stringWithFormat:BITLY_API_URL, @"shorten", BITLY_LOGIN_NAME, BITLY_KEY];	
        NSString *parameters = [NSString stringWithFormat:@"longUrl=%@", [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *finalURL = [urlWithoutParams stringByAppendingString:parameters];
        
        NSURL *url = [NSURL URLWithString:finalURL];
        
        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
        
        NSHTTPURLResponse* urlResponse = nil;  
        NSError *error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&urlResponse error:&error];	
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
        {
            SBJSON *jsonParser = [SBJSON new];
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *dict = (NSDictionary*)[jsonParser objectWithString:jsonString];
            
            NSString *statusCode = [dict objectForKey:@"statusCode"];
            
            if([statusCode isEqualToString:@"OK"])
            {
                shortURL = [[[dict objectForKey:@"results"] 
                             objectForKey:string] 
                            objectForKey:@"shortUrl"];
            }
            
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionUrl(shortURL,error);

        });
    });
    
	
}

@end

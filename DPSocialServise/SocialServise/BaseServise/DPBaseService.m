//
//  DPBaseService.m
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DPBaseService.h"

@implementation DPBaseService

- (void)isHaveAPPkey
{
    if ([FacebookKey isEqualToString:@""]) 
        NSLog(@"You don't have FacebookKey");
        
    if ([FacebookSecret isEqualToString:@""]) 
        NSLog(@"You don't have FacebookSecret");
    
    
    if ([TwitterKey isEqualToString:@""]) 
        NSLog(@"You don't have TwitterKey");
    
    if ([TwitterSecret isEqualToString:@""]) 
        NSLog(@"You don't have TwitterSecret"); 
    
    
    if ([BITLY_KEY isEqualToString:@""]) 
        NSLog(@"You don't have Bitly key");
    
    if ([BITLY_LOGIN_NAME isEqualToString:@""]) 
        NSLog(@"You don't have Bitly login name");
    
        
}

@end

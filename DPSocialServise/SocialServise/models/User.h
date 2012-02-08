//
//  Users.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *imageURL;

@end

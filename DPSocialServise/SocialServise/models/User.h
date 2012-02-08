//
//  Users.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, retain) NSNumber *userID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *screenname;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *imageURL;

@end

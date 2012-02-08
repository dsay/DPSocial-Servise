//
//  AppDelegate.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPSocialServise.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,DPSocialServiseProtocolDelegate>
{
    DPSocialServise *djhfjs;
}
@property (strong, nonatomic) UIWindow *window;

@end

//
//  AppDelegate.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPSocialService.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,DPSocialServiseProtocolDelegate>
{
    DPSocialService *socialServise;
}
@property (strong, nonatomic) UIWindow *window;

@end

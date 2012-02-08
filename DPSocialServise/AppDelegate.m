//
//  AppDelegate.m
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "DPSocialServise.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    socialServise = [DPSocialServise socialServiseType:SocialServiseFacebook andDelegate:self];
    
   // [djhfjs postOnMyWallMessage:@"dkv fg  kg  agfdklgdfjkv vdfkjv  vfrkgh jvv v ejfv jjfrfn jdjfhjf" imageURL:@"http://art.ngfiles.com/medium_views/107/shenaniganon_angry-face.png" link:@"http://www.box.com/s/7cuh1mxdfxaopy86bazm"];
    [socialServise logout];
    [socialServise getUserInfo];
    [socialServise getFriendsInfo];
    [socialServise postOnMyWallMessage:@"dsf" imageURL:@"http://lady.webnice.ru/img/2011/10/img20111030082252_3779.jpg" link:@"http://rest-night.com/online-radio-all-stations-world/"];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)socialServiceDidLogin:(DPSocialServise *)servise
{
    NSLog(@"%@",servise);
    NSLog(@"%@",socialServise);
}
-(void)socialService:(DPSocialServise *)service didLoadUserInfo:(User *)user
{
     NSLog(@"%@",service);
    NSLog(@"%@",user.name);
}
//
- (void)socialService:(DPSocialServise *)service didLoadFriendsInfo:(NSArray *)friends
{
    for (User *user in friends) 
        NSLog(@"%@",user.name);
    [socialServise postOnFriendsWallMessage:@"sdjfh" friendID:[[friends objectAtIndex:4]userID] imageURL:@"http://lady.webnice.ru/img/2011/10/img20111030082252_3779.jpg" link:@"http://rest-night.com/online-radio-all-stations-world/"];
}
//- (void)socialServiceDidPost:(DPSocialServise *)servise
//{
//    
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end

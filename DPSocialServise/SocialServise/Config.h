//
//  Config.h
//  DPSocialServise
//
//  Created by Dmitriy Say on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//NAME APP
#define  MyAppName                  @"DSayAPP"
#define  MyAppURL                   @"http://DsayAPP"


//BITLY
#define BITLY_API_URL               @"http://api.bit.ly/%@?version=2.0.1&login=%@&apiKey=%@&"

#define BITLY_LOGIN_NAME            @"dsay23"//=====================================
#define BITLY_KEY                   @"R_31299f48814a60b0d380feab98473cfd"//=========

//FACEBOOK
#define  FacebookKey                @"159045627536061"//============================
#define  FacebookSecret             @"203acbf346458730687634ae712ed44d"//===========
//URL
#define  FacebookUserInfo           @"https://graph.facebook.com/me"
#define  FacebookFriendsInfo        @"https://graph.facebook.com/me/friends"
#define  FacebookGetImageWihtID     @"http://graph.facebook.com/%@/picture"
//const
#define  FacebookAccessTokenKey     @"FacebookAccessToken"
#define  FacebookExpiryDateKey      @"FacebookExpiryDate"

//TWITTER
//HEADER_SEARCH_PATHS $SDKROOT/usr/include/libz $SDKROOT/usr/include/libxml2
//Frameworks - CFNetwork, MobileCoreServices, SystemConfiguration, Security, MessageUI

#define TwitterKey                  @"jYOu0LbC7vX1JUAt54mcAA"//========================
#define TwitterSecret               @"EhkC00KaWxpynzieRzDLB5aaWgPa6VeuMdXfvhuf8"//=====
#define TWITPIC_API_KEY             @"1f314871761bee6d4da99f7f0710ab24"//==============    
//URL
#define TwitterAuthorize            @"https://api.twitter.com/oauth/authorize"
#define TwitterRequest              @"https://api.twitter.com/oauth/request_token"
#define TwitterAccess               @"https://api.twitter.com/oauth/access_token" 
#define TwitrerUpdate               @"http://api.twitter.com/1/statuses/update.json"
#define TwitterFriendsUpdate        @"https://api.twitter.com/1/direct_messages/new.json"
#define TwitterUserInfo             @"https://api.twitter.com/account/verify_credentials.json"
#define TwitterFriendsID            @"https://api.twitter.com/1/friends/ids.json"
#define TwitterFriendsInfo          @"https://api.twitter.com/1/users/lookup.json"
//TwitPic URL
#define TwitPicUpdate               @"http://api.twitpic.com/1/upload.json"
//const
#define TwitterAccessTokenKey       @"TwitterAccessTokenKey"
#define TwitterSecretTokenKey       @"TwitterSecretTokenKey"
#define TwitterUserID               @"TwitterUserID"
#define TwitterUserScreenName       @"TwitterUserScreenName"

//error
#define TwitterErrorCannotSend      @"You cannot send messages to users who are not following you"
#define TwitterErrorTimedOut        @"Timed out verifying authentication token with Twitter.com. This could be a problem with TwitPic servers. Try again later."

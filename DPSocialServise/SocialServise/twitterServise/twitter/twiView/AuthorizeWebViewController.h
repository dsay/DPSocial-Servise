/**
 Copyright 2010 Charles Y. Choi, Yummy Melon Software LLC
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */ 

#import <UIKit/UIKit.h>

@protocol AuthorizeWebViewControllerDelegate <NSObject>
@optional
- (void)successfulAuthorizationWithPin:(NSString *)pin;
- (void)failedAuthorization;
@end


@interface AuthorizeWebViewController : UIViewController 
<UIWebViewDelegate, NSXMLParserDelegate>
{
    id <AuthorizeWebViewControllerDelegate> delegate;
    UIWebView *webView;
    UIBarButtonItem *doneButton;
}

@property (nonatomic, retain) id <AuthorizeWebViewControllerDelegate> delegate;  
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)backButtonAction;
- (void)compliteAutorized;
@end

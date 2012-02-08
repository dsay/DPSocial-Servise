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

#import "AuthorizeWebViewController.h"


@implementation AuthorizeWebViewController

@synthesize delegate;
@synthesize webView;
@synthesize doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[webView release];
    [super dealloc];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    //[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; 
	[doneButton setEnabled:NO];
}


- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[doneButton setEnabled:YES];
    
    if ([[_webView.request.URL absoluteString] isEqualToString:@"https://api.twitter.com/oauth/authorize"]) 
    [self compliteAutorized];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"webView:shouldStartLoadWithRequest:");
    NSLog(@"%@", [request.URL absoluteString]);
    return YES;
}


- (void)checkForAutorized{
	
}



- (void)compliteAutorized {

    NSString *pin = [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('oauth_pin').innerHTML"];
    
    NSArray* words = [ pin componentsSeparatedByCharactersInSet:
                      [ NSCharacterSet characterSetWithCharactersInString: @"<>-/" ]];
    
    for (NSString *string in words) {
        if ([string intValue] != 0) {
            pin = [NSString stringWithString:string]; 
        }
      
    }
    if ([pin length] > 0) {
        NSLog(@"pin %@", pin);
     //   UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        if ([delegate respondsToSelector:@selector(successfulAuthorizationWithPin:)])
            [delegate successfulAuthorizationWithPin:pin];
	//	[self dismissModalViewControllerAnimated:YES];
                
    }
}
-(IBAction)backButtonAction
{
    NSLog(@"no pin");
    if ([delegate respondsToSelector:@selector(failedAuthorization)])
        [delegate failedAuthorization]; 
   // [self dismissModalViewControllerAnimated:NO];
}
@end

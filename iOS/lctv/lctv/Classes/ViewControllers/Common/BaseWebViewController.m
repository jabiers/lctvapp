//
//  BaseWebViewController.m
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 17..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import "BaseWebViewController.h"
//#import "PlayerView.h"

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:HOME_URL_REQUEST];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - IBActions

-(IBAction)onRefreshButtonClicked:(id)sender {
    [self refresh];
}

-(IBAction)onHomeButtonClicked:(id)sender {
    [self goHome];
}

-(IBAction)onForwardButtonClicked:(id)sender {
    [self goForward];
}

-(IBAction)onBackButtonClicked:(id)sender {
    [self goBack];
}


#pragma mark -
#pragma mark - Public Methods

-(void)refresh {
    [self.webView stopLoading];
    [self.webView reload];
}

-(void)goHome {
    
    if (![self.webView.request.URL.absoluteString isEqualToString:HOST_URL_STRING]) {
        [self.webView loadRequest:HOME_URL_REQUEST];
    }
}
-(void)goForward {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

-(void)goBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}


#pragma mark -
#pragma mark - private methods

-(void)updateButtonStatus {
    
    [self.forwardButton setEnabled:[self.webView canGoForward]];
    [self.backButton setEnabled:[self.webView canGoBack]];
    
}

-(BOOL)hasElementPosition:(NSString *)elementIdOrClass {
    NSString *js = @"function f(){ var r = document.getElementById('%@').getBoundingClientRect(); return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } f();";
    NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:js, elementIdOrClass]];
    if ([result isEqual:@""]) {
        js = @"function f(){ var r = document.getElementsByClassName('%@')[0].getBoundingClientRect(); return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } f();";
        result = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:js, elementIdOrClass]];
    }
    
    NSLog(@"elementIdOrClass : %@, result : %@", elementIdOrClass, result);
    
    return ![result isEqualToString:@""];

}

-(CGRect)getElementPosition:(NSString *)elementIdOrClass {

    NSString *js = @"function f(){ var r = document.getElementById('%@').getBoundingClientRect(); return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } f();";
    NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:js, elementIdOrClass]];
    if ([result isEqual:@""]) {
        js = @"function f(){ var r = document.getElementsByClassName('%@')[0].getBoundingClientRect(); return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } f();";
        result = [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:js, elementIdOrClass]];
    }
    
    NSLog(@"elementIdOrClass : %@, result : %@", elementIdOrClass, result);
    
    return CGRectFromString(result);
}


#pragma mark -
#pragma mark - UIWebView Delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

#define PLAYERHIDDENVIEWTAG 10000

-(void)webViewDidStartLoad:(UIWebView *)webView {
//    [self.playViewController.player pause];
//    [self.playViewController.player stop];
//    self.playViewController = nil;
    
    for (UIView *subView in self.webView.scrollView.subviews) {
        if (subView.tag == PLAYERHIDDENVIEWTAG) {
            [subView removeFromSuperview];
        }
    }

    [self updateButtonStatus];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self updateButtonStatus];
    
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
    NSString *sourceString = [[NSString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
    
    NSString *rtmp;
    NSException *exception;
    @try {
        NSRange start = [sourceString rangeOfString: @"rtmp"];
        NSString *startString = [sourceString substringFromIndex:start.location];
        NSRange end = [startString rangeOfString: @"\","];
        rtmp = [startString substringToIndex:end.location];
        
    } @catch (NSException * e) {
        exception = e;
    }

//    NSLog(@"html : %@", html);
    
    int i = 0;
    for (NSString *idOrClass in [Configs flashAlertIdAndClass]) {
        i++;
        NSLog(@"count : %d", i);
        
        if ([self hasElementPosition:idOrClass]) {
            CGRect r = [self getElementPosition:idOrClass];
            
            UIView *subView = [[UIView alloc] init];
            [subView setTag:PLAYERHIDDENVIEWTAG];
            [subView setBackgroundColor:[UIColor whiteColor]];
            [subView setFrame:r];
            [self.webView.scrollView addSubview:subView];
            
            if (exception) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error" message:@"no exist rtmp url" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
            }
            
            self.playViewController = [[PlayerViewController alloc] initWithURL:[NSURL URLWithString:rtmp]];
            
            [self addChildViewController:self.playViewController];
            [self.playViewController.view setFrame:subView.bounds];
            
            [subView addSubview:self.playViewController.view];
            
        }
    }
    
//    NSLog(@"html : %@", html);
//    UIView *view = [[UIView alloc] init];
//    [view setBackgroundColor:[UIColor whiteColor]];
//    [view setFrame:[self getElementPosition:@"id_jwplayer"]];
//    
//    [self.webView addSubview:view];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"error : %@", error);
}
@end

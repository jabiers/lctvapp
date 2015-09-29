//
//  BaseWebViewController.m
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 17..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import "BaseWebViewController.h"
#import "RootViewController.h"
#import "BaseMenuObject.h"

#import "TFHpple.h"

#import "NSString+URLEncode.h"


@implementation BaseWebViewController

-(void)awakeFromNib {
    NSLog(@"awake ");
}

-(NSUInteger)supportedInterfaceOrientations {
    NSLog(@"support ");
    if ([self isStreamingPlatform]) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
//        return [super supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft
        || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight
        ) {
//        [self.playViewController setOrientation:toInterfaceOrientation];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:HOME_URL_REQUEST];
    
    __weak BaseWebViewController *weak = self;
    [self setRefreshWithScrollView:self.webView.scrollView withAction:^{
        [weak refresh];
    }];
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

-(void)loadUrl:(NSURL *)url {
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

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

-(BOOL)isStreamingPlatform {

    NSLog(@"checK isStreamingPlatform");
    NSString *type = [self.webView stringByEvaluatingJavaScriptFromString:@" \
     function getVideoContent() {\
        var metas = document.getElementsByTagName('meta');  \
        for (i=0; i<metas.length; i++) {    \
            if (metas[i].getAttribute('property') == 'og:type') { \
                return metas[i].getAttribute('content');    \
                }   \
            }   \
        return "";  \
     }; getVideoContent();"];
    
    if ([type isEqualToString:@"streaming platform"]) {
        return YES;
    }
    
    return NO;
}

-(NSString *)getChatUrl {
    NSString *url = [self.webView stringByEvaluatingJavaScriptFromString:@" \
                      function getVideoContent() {\
                      var metas = document.getElementsByTagName('meta');  \
                      for (i=0; i<metas.length; i++) {    \
                      if (metas[i].getAttribute('property') == 'og:url') { \
                      return metas[i].getAttribute('content');    \
                      }   \
                      }   \
                      return "";  \
                      }; getVideoContent();"];
    
    
    return [NSString stringWithFormat:@"%@/chat%@",HOST_URL_STRING, url];
}

-(void)getMenuList:(NSData *)data {
    
    TFHpple *xpath = [[TFHpple alloc] initWithData:data
                                             isXML:NO];
    NSArray *leftMenuElements = [NSArray array];
    NSArray *rightMenuElements = [NSArray array];
    
    //    mobile-menu
    leftMenuElements = [xpath searchWithXPathQuery:@"//html//body//section[@class='mobile-menu-user visible-xs is-load-visible']//li"]; // <-- left
    rightMenuElements = [xpath searchWithXPathQuery:@"//html//body//section[@class='mobile-menu visible-xs is-load-visible']//li"]; // <-- right

    
    NSMutableArray *leftMenus = [NSMutableArray array];
    NSMutableArray *rightMenus = [NSMutableArray array];
    
    for (TFHppleElement *element in leftMenuElements) {
        BaseMenuObject *menu = [[BaseMenuObject alloc] init];
        menu.name = element.content;
        TFHppleElement *a = element.firstChild;
        menu.url = a.attributes[@"href"];
        [leftMenus addObject:menu];
    }
    
    if ([rightMenuElements count] > 0) {
        
    } else {
        rightMenuElements = [xpath searchWithXPathQuery:@"//html//body//section[@class='mobile-menu visible-xs']//li"]; // <-- right
    }
    
    for (TFHppleElement *element in rightMenuElements) {
        BaseMenuObject *menu = [[BaseMenuObject alloc] init];
        menu.name = element.content;
        TFHppleElement *a = element.firstChild;
        menu.url = a.attributes[@"href"];
        [rightMenus addObject:menu];
    }
    
    [[APP_DELEGATE rootViewController] setLeftMenuList:leftMenus];
    [[APP_DELEGATE rootViewController] setRightMenuList:rightMenus];
}

-(void)removeHeaderElement {
    // remove header

    if (self.webView) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"function f() { var element = document.getElementById('topSidebar'); element.parentNode.removeChild(element); } f();"];
        
        [self.webView stringByEvaluatingJavaScriptFromString:@"function f() { var element = document.getElementById('mobSidebar'); element.parentNode.removeChild(element); } f();"];

    }
}

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

-(void)replaceImageSrc:(NSString *)element title:(NSString *)title chat:(NSString *)chat onClickTarget:(NSString *)rtmpUrl {
    
    //link 세팅
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function f() { document.getElementsByClassName('%@')[0].onclick = function() {document.location='lctvapp://openplayer?title=%@&chat=%@&rtmp=%@';}}; f(); ", element, [title URLDecode], [chat URLDecode], [rtmpUrl URLEncode]]];
    
    //이미지 바꾸기
    NSString *js = [NSString stringWithFormat:@"function f() { document.getElementsByClassName('%@')[0].src = 'https://github.com/jabiers/lctvapp/blob/master/noflash.jpg?raw=true'}; f();", element];
    
    NSLog(@"replace result : %@", [self.webView stringByEvaluatingJavaScriptFromString:js]);

}

#pragma mark -
#pragma mark - UIWebView Delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = request.URL.absoluteString;
    
    if ([urlString hasPrefix:@"lctvapp://openplayer?"]) {
        
        NSString *allParams = [urlString componentsSeparatedByString:@"?"][1];
        NSArray *params = [allParams componentsSeparatedByString:@"&"];
        
        
        NSString *title = @"";
        NSString *chat = @"";
        NSString *rtmp = @"";
        
        for (NSString *param in params) {
            NSString *key = [param componentsSeparatedByString:@"="][0];
            NSString *value = [param componentsSeparatedByString:@"="][1];
            
            
            if ([key isEqualToString:@"title"]) {
                title = [value URLDecode];
            } else if ([key isEqualToString:@"chat"]) {
                chat = [value URLDecode];
            } else if ([key isEqualToString:@"rtmp"]) {
                rtmp = [value URLDecode];
            }
        }

        [PlayerViewController presentFromViewController:self withTitle:title URL:[NSURL URLWithString:rtmp] withChatUrl:chat completion:^{
        }];
        return NO;
    }
    
    [[APP_DELEGATE rootViewController] headerHidden:[Configs checkIfNeedRemoveHeader:request]];
    
    return YES;
}

#define PLAYERHIDDENVIEWTAG 10000

-(void)webViewDidStartLoad:(UIWebView *)webView {
    //    [self.playViewController.player pause];
    //    [self.playViewController.player stop];
    //    self.playViewController = nil;
    
    NSLog(@"start Load");
    for (UIView *subView in self.webView.scrollView.subviews) {
        if (subView.tag == PLAYERHIDDENVIEWTAG) {
            [subView removeFromSuperview];
        }
    }
    
    [self removeHeaderElement];
    [self updateButtonStatus];
    NSLog(@"start finish");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self endRefreshControl];
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];

    NSLog(@"html : %@", html);
    
    [self updateButtonStatus];
    [self removeHeaderElement];
    
    if ([Configs checkCanGetHeaderInfo:webView.request]
        ||  [self isStreamingPlatform]) {
        [self getMenuList:[html dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSString *sourceString = [[NSString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
    
    NSString *rtmp;
    NSException *exception;
    @try {
        NSRange start = [sourceString rangeOfString: @"rtmp://"];
        NSString *startString = [sourceString substringFromIndex:start.location];
        NSRange end = [startString rangeOfString: @"\","];
        rtmp = [startString substringToIndex:end.location];
        
    } @catch (NSException * e) {
        exception = e;
    }
    
    //    NSLog(@"html : %@", html);
    
//    int i = 0;
    
    
    
    NSString *streamTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('title')[0].text"];
    
    [self replaceImageSrc:@"video-home--image js-noflash" title:streamTitle chat:[self getChatUrl] onClickTarget:rtmp];
    [self replaceImageSrc:@"noflash-img showIt" title:streamTitle chat:[self getChatUrl] onClickTarget:rtmp];

    
//    a35d6384
    //    for (NSString *idOrClass in [Configs flashAlertIdAndClass]) {
//        i++;
//        NSLog(@"count : %d", i);
//        
//        if ([self hasElementPosition:idOrClass]) {
//            CGRect r = [self getElementPosition:idOrClass];
//            
//            if (exception) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error" message:@"no exist rtmp url" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//                [alertView show];
//            }
//            
//            if (self.playViewController) {
//                NSLog(@"remove playerViewCon");
//                [self.playViewController onClickPause:nil];
//                if (self.playViewController.view.superview) {
//                    [self.playViewController.view removeFromSuperview];
//                }
//
//                self.playViewController = nil;
//            }
//            NSLog(@"alloc playerView ");
//            self.playViewController = [[PlayerViewController alloc] initWithURL:[NSURL URLWithString:rtmp]];
//            
//            [self addChildViewController:self.playViewController];
//            [self.playViewController.view setFrame:r];
//            [self.playViewController.view setTag:PLAYERHIDDENVIEWTAG];
//            [self.webView.scrollView setContentOffset:CGPointZero animated:NO];
//            [self.webView.scrollView addSubview:self.playViewController.view];
//            
//        }
//    }
    
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

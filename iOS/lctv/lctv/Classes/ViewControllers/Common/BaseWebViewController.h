//
//  BaseWebViewController.h
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 17..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewController.h"

@interface BaseWebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) PlayerViewController *playViewController;
-(void)goHome;
-(void)refresh;
-(void)goForward;
-(void)goBack;


@end

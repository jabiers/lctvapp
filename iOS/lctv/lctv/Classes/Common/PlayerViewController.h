//
//  PlayerViewController.h
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 17..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import <IJKMediaFramework/IJKMediaFramework.h>

@interface PlayerViewController : ESViewController <UIWebViewDelegate>

@property(atomic,strong) NSURL *url;
@property (strong, nonatomic) NSString *chatUrl;

@property(atomic, retain) id<IJKMediaPlayback> player;

@property(nonatomic, weak) IBOutlet UIView *overlayPanel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (assign, nonatomic) BOOL isShownChat;

//@property(nonatomic,strong) IBOutlet UIButton *playButton;
//@property(nonatomic,strong) IBOutlet UIButton *pauseButton;
//
//@property(nonatomic,strong) IBOutlet UILabel *currentTimeLabel;
//@property(nonatomic,strong) IBOutlet UILabel *totalDurationLabel;
//@property(nonatomic,strong) IBOutlet UISlider *mediaProgressSlider;

- (id)initWithURL:(NSURL *)url;

+(void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url withChatUrl:(NSString *)chatUrl completion:(void (^)())completion;
    
- (IBAction)onClickMediaControl:(id)sender;
- (IBAction)onClickOverlay:(id)sender;
- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickPlay:(id)sender;
- (IBAction)onClickPause:(id)sender;

- (IBAction)didSliderTouchDown;
- (IBAction)didSliderTouchCancel;
- (IBAction)didSliderTouchUpOutside;
- (IBAction)didSliderTouchUpInside;
- (IBAction)didSliderValueChanged;

@end

//
//  PlayerViewController.h
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 17..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface PlayerViewController : UIViewController

@property(atomic,strong) NSURL *url;
@property(atomic, retain) id<IJKMediaPlayback> player;

@property(nonatomic,strong) IBOutlet UIView *overlayPanel;
@property(nonatomic,strong) IBOutlet UIView *topPanel;
@property(nonatomic,strong) IBOutlet UIView *bottomPanel;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
//@property(nonatomic,strong) IBOutlet UIButton *playButton;
//@property(nonatomic,strong) IBOutlet UIButton *pauseButton;
//
//@property(nonatomic,strong) IBOutlet UILabel *currentTimeLabel;
//@property(nonatomic,strong) IBOutlet UILabel *totalDurationLabel;
//@property(nonatomic,strong) IBOutlet UISlider *mediaProgressSlider;

- (id)initWithURL:(NSURL *)url;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void(^)())completion;

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

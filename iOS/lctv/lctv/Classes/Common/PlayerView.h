//
//  PlayerView.h
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 17..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface PlayerView : UIView

@property(atomic,strong) NSURL *url;
@property(atomic, retain) id<IJKMediaPlayback> player;

+(PlayerView *)viewWithUrl:(NSURL *)url;

@end

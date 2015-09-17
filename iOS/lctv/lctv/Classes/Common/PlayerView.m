//
//  PlayerView.m
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 17..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

#define EXPECTED_IJKPLAYER_VERSION (1 << 16) & 0xFF) |

+(PlayerView *)viewWithUrl:(NSURL *)url {
    
    PlayerView *view = [[PlayerView alloc] init];
    view.url = url;
    return view;
}

-(instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:nil];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.bounds;
    self.player.scalingMode = MPMovieScalingModeAspectFit;
    //
    self.autoresizesSubviews = YES;
    [self addSubview:self.player.view];
    
    [self.player prepareToPlay];
    [self.player play];

}
@end

//
//  BaseMenuObject.h
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 19..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MENU_ACTION_GO_LINK,
    MENU_ACTION_PLAY_LIVE_STREAM,
    MENU_ACTION_PLAY_VOD
} MENU_ACTION;

@interface BaseMenuObject : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (assign, nonatomic) MENU_ACTION action;

-(NSURL *)getUrl;

@end

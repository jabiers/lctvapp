//
//  Configs.m
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 17..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import "Configs.h"

@implementation Configs

+(NSArray *)flashAlertIdAndClass {
    return @[@"id_jwplayer", @"noflash-img"];
}

+(BOOL)checkCanGetHeaderInfo:(NSURLRequest *)request {
    NSString *urlStr = request.URL.absoluteString;

    if ([CAN_GET_HEADER_INFO containsObject:urlStr]) {
        return YES;
    }
    
    return NO;
}

+(BOOL)checkIfNeedRemoveHeader:(NSURLRequest *)request {
    NSString *urlStr = request.URL.absoluteString;
    
    if ([urlStr isEqualToString:@"https://www.livecoding.tv/"]) {
        return YES;
    }
    
    return NO;
}

@end

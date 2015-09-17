//
//  Configs.h
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 17..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HOST_URL_STRING @"https://livecoding.tv"
#define HOST_URL [NSURL URLWithString:HOST_URL_STRING]
#define HOME_URL_REQUEST [CommonUtils requestFromString:HOST_URL_STRING]

@interface Configs : NSObject

+(NSArray *)flashAlertIdAndClass;

@end

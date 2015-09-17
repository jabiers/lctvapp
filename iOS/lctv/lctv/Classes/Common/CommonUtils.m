//
//  CommonUtils.m
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 17..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+(NSURLRequest *)requestFromString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    return request;
}

@end

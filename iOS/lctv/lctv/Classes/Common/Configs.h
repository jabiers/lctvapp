//
//  Configs.h
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 17..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configs : NSObject

+(BOOL)checkIfNeedRemoveHeader:(NSURLRequest *)request;
+(BOOL)checkCanGetHeaderInfo:(NSURLRequest *)request;
+(NSArray *)flashAlertIdAndClass;

@end

//
//  BaseMenuObject.m
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 19..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import "BaseMenuObject.h"

@implementation BaseMenuObject

-(NSURL *)getUrl {
    if ([self.url hasPrefix:@"http://"]
        || [self.url hasPrefix:@"https://"]) {
        return [NSURL URLWithString:self.url];
    } else {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST_URL_STRING, self.url]];
    }

}
@end

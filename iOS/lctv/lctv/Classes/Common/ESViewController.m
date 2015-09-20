//
//  ESUIViewController.m
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 20..
//  Copyright © 2015년 Kim DaeHyun. All rights reserved.
//

#import "ESViewController.h"

@implementation ESViewController

- (void)setRefreshWithScrollView:(UIScrollView *)scrollView
                      withAction:(ViewControllerRefresh)action {
    
    if (self.refreshControl) {
        [self.refreshControl removeFromSuperview];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(onRefreshTouched)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshAction = action;
    
    [scrollView addSubview:self.refreshControl];
    
}

-(void)onRefreshTouched {
    if (self.refreshAction) {
        self.refreshAction();
    }
}

-(void)endRefreshControl {
    [self.refreshControl endRefreshing];
}


@end

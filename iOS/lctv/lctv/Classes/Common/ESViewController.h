//
//  ESUIViewController.h
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 20..
//  Copyright © 2015년 Kim DaeHyun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ViewControllerRefresh)();

@interface ESViewController : UIViewController

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (copy, nonatomic) ViewControllerRefresh refreshAction;

- (void)setRefreshWithScrollView:(UIScrollView *)scrollView
                      withAction:(ViewControllerRefresh)action;
-(void)endRefreshControl;
@end

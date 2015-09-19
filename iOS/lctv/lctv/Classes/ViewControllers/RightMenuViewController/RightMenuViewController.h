//
//  RightMenuViewController.h
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 19..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMenuObject.h"

@protocol RightMenuViewProtocol;

@interface RightMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *menuArray;
@property (weak, nonatomic) id<RightMenuViewProtocol> delegate;

@end
@protocol RightMenuViewProtocol <NSObject>

-(void)rightMenu:(RightMenuViewController *)rightMenu didSelectedMenu:(BaseMenuObject *)menu;

@end


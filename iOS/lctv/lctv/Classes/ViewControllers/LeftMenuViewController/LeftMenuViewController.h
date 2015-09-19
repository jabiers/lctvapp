//
//  LeftMenuViewController.h
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 19..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMenuObject.h"

@protocol LeftMenuViewProtocol;

@interface LeftMenuViewController : UIViewController
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *menuArray;
@property (weak, nonatomic) id <LeftMenuViewProtocol> delegate;

@end

@protocol LeftMenuViewProtocol <NSObject>

-(void)leftMenu:(LeftMenuViewController *)leftMenu didSelectedMenu:(BaseMenuObject *)menu;

@end

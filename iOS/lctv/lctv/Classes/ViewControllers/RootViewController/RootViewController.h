//
//  RootViewController.h
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 19..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"
#import "BaseWebViewController.h"

@interface UINavigationController (Rotation_IOS6)

@end

@interface RootViewController : UIViewController <LeftMenuViewProtocol, RightMenuViewProtocol>

@property (weak, nonatomic) IBOutlet UIButton *leftMenuButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *rightMenuButton;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *headerViewBg;
@property (weak, nonatomic) IBOutlet UIView *dimmView;

@property (weak, nonatomic) IBOutlet UIView *mainContainer;
@property (weak, nonatomic) IBOutlet UIView *leftMenuContainer;
@property (weak, nonatomic) IBOutlet UIView *rightMenuContainer;

@property (strong, nonatomic) BaseWebViewController *mainViewController;
@property (strong, nonatomic) LeftMenuViewController *leftMenuViewController;
@property (strong, nonatomic) RightMenuViewController *rightMenuViewController;

@property (assign, nonatomic) BOOL isShownLeftMenu;
@property (assign, nonatomic) BOOL isShownRightMenu;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMenuWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMenuRightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMenuWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMenuLeftConstraint;


@property (strong, nonatomic) NSMutableArray *leftMenuList;
@property (strong, nonatomic) NSMutableArray *rightMenuList;

@property (assign, nonatomic) BOOL isLogedIn;

-(void)headerHidden:(BOOL)hidden;

@end

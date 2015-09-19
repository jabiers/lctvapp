//
//  RootViewController.m
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 19..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import "RootViewController.h"

@implementation UINavigationController (Rotation_IOS6)

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end

@implementation RootViewController


-(BOOL)shouldAutorotate {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations {
    if (self.mainViewController) {
        return [self.mainViewController supportedInterfaceOrientations];
    } else {
        return [super supportedInterfaceOrientations];
    }

}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    APP_DELEGATE.rootViewController = self;

}

#pragma mark -
#pragma mark - Public Methods

-(void)setIsLogedIn:(BOOL)isLogedIn {
    
}

-(void)setLeftMenuList:(NSMutableArray *)leftMenuList {
    if ([leftMenuList count] > 0) {
        [self.leftMenuButton setHidden:NO];
        self.leftMenuViewController.menuArray = leftMenuList;
    } else {
        [self.leftMenuButton setHidden:YES];
    }
}

-(void)setRightMenuList:(NSMutableArray *)rightMenuList {
    self.rightMenuViewController.menuArray = rightMenuList;
}

-(void)headerHidden:(BOOL)hidden {
    [self.headerView setHidden:hidden];
    [self.headerViewBg setHidden:hidden];
}

#pragma mark -
#pragma mark - Private Methods

-(void)showLeftMenuIfNeed {
    
    if (self.isShownLeftMenu) {
        [self hideLeftMenuView];
    } else {
        [self.dimmView setHidden:NO];
        [self.view bringSubviewToFront:self.dimmView];
        [self.view bringSubviewToFront:self.leftMenuContainer];
        self.leftMenuRightConstraint.constant = [UIScreen mainScreen].bounds.size.width * self.leftMenuWidthConstraint.multiplier;
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             if (!self.isShownLeftMenu) {
                                 [self.dimmView setAlpha:1.0f];
                             }
                             
                             [self.view layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             if (!self.isShownLeftMenu) {
                                 self.isShownLeftMenu = YES;
                             }
                         }];
        
    }
    
}

-(void)hideLeftMenuView {
    if (self.isShownLeftMenu) {
        self.leftMenuRightConstraint.constant = 0;
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             if (self.isShownLeftMenu) {
                                 [self.dimmView setAlpha:0.0f];
                             }
                             
                             [self.view layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             if (self.isShownLeftMenu) {
                                 self.isShownLeftMenu = NO;
                             }
                         }];
    }
}

-(void)showRightMenuIfNeed {
    
    if (self.isShownRightMenu) {
        [self hideRightMenuView];
    } else {
        [self.dimmView setHidden:NO];
        [self.view bringSubviewToFront:self.dimmView];
        [self.view bringSubviewToFront:self.rightMenuContainer];
        self.rightMenuLeftConstraint.constant = -[UIScreen mainScreen].bounds.size.width * self.rightMenuWidthConstraint.multiplier;
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             if (!self.isShownRightMenu) {
                                 [self.dimmView setAlpha:1.0f];
                             }
                             
                             [self.view layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             if (!self.isShownRightMenu) {
                                 self.isShownRightMenu = YES;
                             }
                         }];
        
    }
    
}

-(void)hideRightMenuView {
    if (self.isShownRightMenu) {
        self.rightMenuLeftConstraint.constant = 0;
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             if (self.isShownRightMenu) {
                                 [self.dimmView setAlpha:0.0f];
                             }
                             
                             [self.view layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             if (self.isShownRightMenu) {
                                 self.isShownRightMenu = NO;
                             }
                         }];
    }
    
}

-(void)hideAllView {
    [self hideLeftMenuView];
    [self hideRightMenuView];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"BaseWebViewController"]) {
        self.mainViewController = [segue destinationViewController];
//        self.currentViewController = [segue destinationViewController];
    } else if ([[segue identifier] isEqualToString:@"LeftMenuViewController"]) {
        self.leftMenuViewController = [segue destinationViewController];
        self.leftMenuViewController.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"RightMenuViewController"]) {
        self.rightMenuViewController = [segue destinationViewController];
        self.rightMenuViewController.delegate = self;
    }
}

#pragma mark -
#pragma mark - IBAction Methods

-(IBAction)onLeftButtonClicked:(id)sender {
    [self showLeftMenuIfNeed];
}

-(IBAction)onHomeButtonClicked:(id)sender {
    [self.mainViewController goHome];
}

-(IBAction)onRightButtonClicked:(id)sender {
    [self showRightMenuIfNeed];
}

-(IBAction)onDimmViewClicked:(id)sender {
    [self hideAllView];
}

#pragma mark - 
#pragma mark - LeftMenu & RightMenu Delegate

-(void)leftMenu:(LeftMenuViewController *)leftMenu didSelectedMenu:(BaseMenuObject *)menu {
    [self.mainViewController loadUrl:[menu getUrl]];
    [self hideAllView];
}

-(void)rightMenu:(RightMenuViewController *)rightMenu didSelectedMenu:(BaseMenuObject *)menu {
    [self.mainViewController loadUrl:[menu getUrl]];
    [self hideAllView];
}

@end

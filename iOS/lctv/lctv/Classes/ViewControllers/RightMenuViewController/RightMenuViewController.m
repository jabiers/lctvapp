//
//  RightMenuViewController.m
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 19..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import "RightMenuViewController.h"

@implementation RightMenuViewController

#pragma mark -
#pragma mark - Public Methods

-(void)setMenuArray:(NSMutableArray *)menuArray {
    _menuArray =  menuArray;
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(rightMenu:didSelectedMenu:)]) {
            [self.delegate rightMenu:self didSelectedMenu:[self.menuArray objectAtIndex:indexPath.row]];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -
#pragma mark - UITableView DataSrouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseMenuObject *menu = [self.menuArray objectAtIndex:indexPath.row];
    
    if ([menu.name isEqualToString:@""]) {
        return 2;
    }
    
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    UILabel *label =  (UILabel *)[cell viewWithTag:100];
    BaseMenuObject *menu = [self.menuArray objectAtIndex:indexPath.row];
    [label setText:menu.name];
    return cell;

}

@end

//
//  LeftMenuViewController.m
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 19..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#import "LeftMenuViewController.h"

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


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
        if ([self.delegate respondsToSelector:@selector(leftMenu:didSelectedMenu:)]) {
            [self.delegate leftMenu:self didSelectedMenu:[self.menuArray objectAtIndex:indexPath.row]];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

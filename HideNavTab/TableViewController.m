//
//  TableViewController.m
//  HideNavTab
//
//  Created by 郑林琴 on 15/8/15.
//  Copyright (c) 2015年 BL. All rights reserved.
//

#import "TableViewController.h"
#import "UINavTabInteraction.h"

@interface TableViewController ()<UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate>
{
    NSArray *_dataSource;
    UINavTabInteraction *_interaction;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TableViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    _dataSource = @[@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",
                    @"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",
                    @"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _interaction = [UINavTabInteraction new];
    _interaction.operationVC = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_interaction scrollViewDidScroll:scrollView];
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_interaction scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_interaction scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44.f)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}


@end

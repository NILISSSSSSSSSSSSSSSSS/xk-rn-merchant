//
//  XKVideoSearchMoreViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoSearchMoreViewController.h"

#import "XKVideoSearchHotTopicTableViewCell.h"
#import "XKVideoSearchUserTableViewCell.h"
#import "XKVideoSearchTopicTableViewCell.h"
#import "XKVideoSearchUserModel.h"
#import "XKVideoSearchTopicModel.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKVideoSearchViewController.h"

@interface XKVideoSearchMoreViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *hotTopics;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) NSUInteger maxPage;

@end

@implementation XKVideoSearchMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.keyword && self.keyword.length) {
//        搜索关键字
        self.searchBar.textField.text = self.keyword;
        [self postSearchWithKeyword:self.searchBar.textField.text];
    }
    self.searchBar.textField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf postSearchWithKeyword:weakSelf.searchBar.textField.text];
    }];
    [weakSelf.tableView.mj_header beginRefreshing];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.page > weakSelf.maxPage) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [weakSelf postSearchWithKeyword:weakSelf.searchBar.textField.text];
    }];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
    footer.ignoredScrollViewContentInsetBottom = kBottomSafeHeight;
    self.tableView.mj_footer = footer;
}

#pragma mark - POST

/**
 搜索
 */
- (void)postSearchWithKeyword:(NSString *) keyword {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:keyword forKey:@"searchWord"];
    [para setObject:@(self.page) forKey:@"page"];
    [para setObject:@(20) forKey:@"num"];
    NSString *url = @"";
    if (self.dataType == XKVideoSearchDataTypeUser) {
//        用户
        url = [XKAPPNetworkConfig getSearchMoreUsersUrl];
    } else if (self.dataType == XKVideoSearchDataTypeTopic) {
//        话题
        url = [XKAPPNetworkConfig getSearchMoreTopicsUrl];
    }
    [XKZBHTTPClient postRequestWithURLString:url timeoutInterval:20.0 parameters:para success:^(id  _Nonnull responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.page == 0) {
            [self.tableView.mj_footer resetNoMoreData];
            if (self.dataType == XKVideoSearchDataTypeUser ||
                (self.dataType == XKVideoSearchDataTypeTopic && keyword.length)) {
                [self.datas removeAllObjects];
            } else {
                [self.hotTopics removeAllObjects];
            }
        }
        if (self.dataType == XKVideoSearchDataTypeUser ||
            (self.dataType == XKVideoSearchDataTypeTopic && keyword.length)) {
//            用户搜索或者话题搜索
            if (self.dataType == XKVideoSearchDataTypeUser) {
                [self.datas addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKVideoSearchUserModel class] json:responseObject[@"body"][@"data"][@"user"]]];
            } else {
                [self.datas addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKVideoSearchTopicModel class] json:responseObject[@"body"][@"data"][@"topic"]]];
                for (XKVideoSearchTopicModel *topic in self.datas) {
                    topic.searchKeyword = keyword;
                }
            }
            [self.tableView reloadData];
            if (self.datas.count) {
                [self.tableViewEmptyView hide];
            } else {
                __weak typeof(self) weakSelf = self;
                self.tableViewEmptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
                [self.tableViewEmptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
                    [weakSelf postSearchWithKeyword:keyword];
                }];
            }
        } else {
//            热门话题
            [self.hotTopics addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKVideoSearchTopicModel class] json:responseObject[@"body"][@"data"][@"topic"]]];
            for (XKVideoSearchTopicModel *topic in self.hotTopics) {
                topic.searchKeyword = keyword;
            }
            [self.tableView reloadData];
            if (self.hotTopics.count) {
                [self.tableViewEmptyView hide];
            } else {
                __weak typeof(self) weakSelf = self;
                self.tableViewEmptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
                [self.tableViewEmptyView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:^{
                    [weakSelf postSearchWithKeyword:keyword];
                }];
            }
        }
        self.page += 1;
    } failure:^(XKHttpErrror * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.datas.count == 0 && self.hotTopics.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.tableViewEmptyView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
            [self.tableViewEmptyView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postSearchWithKeyword:keyword];
            }];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    [self.tableView reloadData];
    [self.tableViewEmptyView hide];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *keyword = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (keyword.length) {
        self.page = 0;
        [self postSearchWithKeyword:keyword];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableViewEmptyView hide];
        });
    }
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataType == XKVideoSearchDataTypeUser ||
        (self.dataType == XKVideoSearchDataTypeTopic && self.searchBar.textField.text.length)) {
        return self.datas.count;
    } else {
        return self.hotTopics.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataType == XKVideoSearchDataTypeUser) {
//        用户
        XKVideoSearchUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKVideoSearchUserTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.datas.count == 1) {
            [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 66.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
        } else if (indexPath.row == 0) {
            [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 66.0) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)];
        } else if (indexPath.row == self.datas.count - 1) {
            [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 66.0) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0, 8.0)];
        } else {
            [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 66.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0.0, 0.0)];
        }
        [cell setMoreViewHidden:YES];
        XKVideoSearchUserModel *user = self.datas[indexPath.row];
        cell.user = user;
        return cell;
    } else if (self.dataType == XKVideoSearchDataTypeTopic) {
        if (self.searchBar.textField.text.length) {
//            话题
            XKVideoSearchTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKVideoSearchTopicTableViewCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.datas.count == 1) {
                [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 34.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
            } else if (indexPath.row == 0) {
                [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 34.0) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)];
            } else if (indexPath.row == self.datas.count - 1) {
                [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 34.0) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0, 8.0)];
            } else {
                [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 34.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0.0, 0.0)];
            }
            XKVideoSearchTopicModel *topic = self.datas[indexPath.row];
            cell.topic = topic;
            return cell;
        } else {
//            热门话题
            XKVideoSearchHotTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKVideoSearchHotTopicTableViewCell class]) forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.datas.count == 1) {
                [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 40.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
            } else if (indexPath.row == 0) {
                [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 40.0) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)];
            } else if (indexPath.row == self.hotTopics.count - 1) {
                [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 40.0) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0, 8.0)];
            } else {
                [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 40.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0.0, 0.0)];
            }
            XKVideoSearchTopicModel *topic = self.hotTopics[indexPath.row];
            topic.serialNum = indexPath.row + 1;
            cell.topic = topic;
            return cell;
        }
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataType == XKVideoSearchDataTypeUser) {
        return 66.0;
    }  else if (self.dataType == XKVideoSearchDataTypeTopic) {
        if (self.searchBar.textField.text.length) {
            return 34.0;
        } else {
            return 40.0;
        }
    } else {
        return 0.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataType == XKVideoSearchDataTypeUser) {
        XKVideoSearchUserModel *user = self.datas[indexPath.row];
        XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc] init];
        vc.userId = user.id;
        [self.navigationController pushViewController:vc animated:YES];
    }  else if (self.dataType == XKVideoSearchDataTypeTopic) {
        XKVideoSearchTopicModel *topic;
        if (self.searchBar.textField.text.length) {
            topic = self.datas[indexPath.row];
        } else {
            topic = self.hotTopics[indexPath.row];
        }
        XKVideoSearchViewController *vc = [[XKVideoSearchViewController alloc] init];
        vc.searchTopic = topic;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - getter setter

- (NSMutableArray *)hotTopics {
    if (!_hotTopics) {
        _hotTopics = [NSMutableArray array];
    }
    return _hotTopics;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

@end

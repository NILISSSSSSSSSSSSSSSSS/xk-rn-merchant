//
//  XKVideoSearchHeaderView.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/15.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKVideoSearchCollectionHeader.h"

#import "XKVideoSearchHeader.h"
#import "XKVideoSearchUserTableViewCell.h"
#import "XKVideoSearchTopicTableViewCell.h"

#import "XKVideoSearchResultModel.h"

@interface XKVideoSearchCollectionHeader() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XKVideoSearchCollectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEX_RGB(0xf6f6f6);
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.tableFooterView = nil;
        self.tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[XKVideoSearchUserTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKVideoSearchUserTableViewCell class])];
        [self.tableView registerClass:[XKVideoSearchTopicTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKVideoSearchTopicTableViewCell class])];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0));
        }];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.resultModel.users.count && self.resultModel.topics.count) {
        return 2;
    } else if (self.resultModel.users.count || self.resultModel.topics.count) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.resultModel.users.count) {
        return 1;
    } else {
        return self.resultModel.topics.count > 4 ? 4 : self.resultModel.topics.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.resultModel.users.count) {
        XKVideoSearchUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKVideoSearchUserTableViewCell class]) forIndexPath:indexPath];
        [cell setMoreViewHidden: NO];
        cell.user = self.resultModel.users[indexPath.row];
        if (self.resultModel.topics.count) {
            [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 64.0) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)];
        } else {
            [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 64.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
        }
        cell.moreView.tag = 1000 + indexPath.row;
        UITapGestureRecognizer *moreUserTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreUserTapAction:)];
        [cell.moreView addGestureRecognizer:moreUserTap];
        return cell;
    } else {
        XKVideoSearchTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKVideoSearchTopicTableViewCell class]) forIndexPath:indexPath];
        [cell setSearchImgHidden:YES];
        cell.topic = self.resultModel.topics[indexPath.row];
        if (indexPath.row == [self tableView:self.tableView numberOfRowsInSection:indexPath.section] - 1) {
            // 最后一个CELL
            [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 34.0) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0, 8.0)];
        } else {
            // 普通CELL
            [cell.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 34.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0.0, 0.0)];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.resultModel.users.count) {
        return 64.0;
    } else {
        return 34.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.resultModel.users.count) {
        return 0.0;
    } else {
        if (self.resultModel.topics.count) {
            return 34.0;
        } else {
            return 0.0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.resultModel.users.count) {
        return nil;
    } else {
        if (self.resultModel.topics.count) {
            XKVideoSearchHeader *header = [[XKVideoSearchHeader alloc] init];
            header.titleLab.text = @"话题";
            header.moreLab.textColor = HEX_RGB(0x777777);
            header.arrowImgView.image = IMG_NAME(@"ic_btn_msg_circle_rightArrow");
            [header setDownLineHidden:YES];
            if (self.resultModel.users.count) {
                [header.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 34.0) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(0.0, 0.0)];
            } else {
                [header.containerView cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, SCREEN_WIDTH - 10.0 * 2, 34.0) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8.0, 8.0)];
            }
            header.moreBlock = ^{
                [self moreTopicTapAction];
            };
            return header;
        } else {
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && self.resultModel.users.count) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(header:didClikedUser:)]) {
            [self.delegate header:self didClikedUser:self.resultModel.users[indexPath.row]];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(header:didClikedTopic:)]) {
            [self.delegate header:self didClikedTopic:self.resultModel.topics[indexPath.row]];
        }
    }
}

#pragma mark - privite method

- (void)moreUserTapAction:(UIGestureRecognizer *) sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:didClikedMoreUser:)]) {
        [self.delegate header:self didClikedMoreUser:self.resultModel.users[sender.view.tag - 1000]];
    }
}

- (void)moreTopicTapAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerDidClikedMoreTopic:)]) {
        [self.delegate headerDidClikedMoreTopic:self];
    }
}

#pragma mark - setter

- (void)setResultModel:(XKVideoSearchResultModel *)resultModel {
    _resultModel = resultModel;
    [self.tableView reloadData];
}

@end

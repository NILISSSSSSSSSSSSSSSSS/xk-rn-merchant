//
//  XKWelfareJoinBuyCarView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareJoinBuyCarView.h"
#import "XKWelfareGoodsDetailJoinBuyCarTopCell.h"
#import "XKWelfareGoodsDetailJoinBuyCarBottomCell.h"
@interface  XKWelfareJoinBuyCarView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UIButton *headerRightBtn;
@property (nonatomic, strong) UIView *headerLineView;

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *footerBtn;
@property (nonatomic, strong) UIView *footerBottomView;

@end

@implementation XKWelfareJoinBuyCarView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.5];
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.headerView addSubview:self.headerTitleLabel];
    [self.headerView addSubview:self.headerRightBtn];
    [self.headerView addSubview:self.headerLineView];
    [self.footerView addSubview:self.footerBtn];
    [self.footerView addSubview:self.footerBottomView];
    [self addSubview:self.tableView];
}

- (void)addUIConstraint {
    
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left).offset(10);
        make.top.bottom.equalTo(self.headerView);
    }];
    
    [self.headerRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.headerView);
        make.width.mas_equalTo(40);
    }];
    
    [self.headerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.headerView);
        make.height.mas_equalTo(1);
    }];
    
    [self.footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.footerView);
        make.bottom.equalTo(self.footerView.mas_bottom).offset(-kBottomSafeHeight);
    }];
    
    [self.footerBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.footerView);
        make.height.mas_equalTo(kBottomSafeHeight);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

#pragma mark 响应事件
- (void)closeBtnClick:(UIButton *)sender {
    if(self.closeBlock) {
        self.closeBlock();
    }
}

- (void)footerBtnClick:(UIButton *)sender {
    if(self.sureClickBlock) {
        self.sureClickBlock();
    }
}

#pragma mark tableview delegate / dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        XKWelfareGoodsDetailJoinBuyCarTopCell *topCell = [[XKWelfareGoodsDetailJoinBuyCarTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return topCell;
    } else {
        XKWelfareGoodsDetailJoinBuyCarBottomCell *bottomCell = [[XKWelfareGoodsDetailJoinBuyCarBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return bottomCell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XKWelfareGoodsDetailJoinBuyCarTopCell class] forCellReuseIdentifier:@"XKWelfareGoodsDetailJoinBuyCarTopCell"];
        [_tableView registerClass:[XKWelfareGoodsDetailJoinBuyCarBottomCell class] forCellReuseIdentifier:@"XKWelfareGoodsDetailJoinBuyCarBottomCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 40;
        _tableView.sectionFooterHeight = 50 + kBottomSafeHeight;
    }
    return _tableView;
}

- (UIView *)headerView {
    if(!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UIView *)footerView {
    if(!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = [UIColor whiteColor];
    }
    return _footerView;
}

- (UILabel *)headerTitleLabel {
    if(!_headerTitleLabel) {
        _headerTitleLabel = [[UILabel alloc] init];
        _headerTitleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.f];
        _headerTitleLabel.text = @"详情";
    }
    return _headerTitleLabel;
}

- (UIButton *)headerRightBtn {
    if(!_headerRightBtn) {
        _headerRightBtn = [[UIButton alloc] init];
        [_headerRightBtn setImage:[UIImage imageNamed:@"xk_icon_welfaregoods_detail_close"] forState:0];
        [_headerRightBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerRightBtn;
}

- (UIView *)headerLineView {
    if(!_headerLineView) {
        _headerLineView = [[UIView alloc] init];
        _headerLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _headerLineView;
}

- (UIButton *)footerBtn {
    if(!_footerBtn) {
        _footerBtn = [[UIButton alloc] init];
        [_footerBtn setTitle:@"确定" forState:0];
        [_footerBtn setBackgroundColor:XKMainTypeColor];
        [_footerBtn addTarget:self action:@selector(footerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerBtn;
}

- (UIView *)footerBottomView {
    if(!_footerBottomView) {
        _footerBottomView = [[UIView alloc] init];
        _footerBottomView.backgroundColor = [UIColor whiteColor];
    }
    return _footerBottomView;
}
@end

//
//  XKStoreEidtMenuBottomShopCarView.m
//  XKSquare
//
//  Created by hupan on 2018/9/25.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreEidtMenuBottomShopCarView.h"
#import "XKStoreEidtMenuBottomShopCarTableViewCell.h"
#import "XKTradingAreaGoodsInfoModel.h"
#import "XKTradingAreaShopCarManager.h"

static NSString * const tableViewCellID  = @"tableViewCell";

@interface XKStoreEidtMenuBottomShopCarView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView            *topView;
@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) UIButton          *topClearShopCarBtn;
@property (nonatomic, strong) UIButton          *gotoBuyBtn;
@property (nonatomic, strong) UILabel           *topNameLabel;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic ,strong) NSArray<NSArray<GoodsSkuVOListItem *> *> *modelArr;



@end

@implementation XKStoreEidtMenuBottomShopCarView



- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self initViews];
        [self layoutViews];
    }
    return self;
    
}


#pragma mark - Events



#pragma mark - Private Metheods


- (void)initViews {
    
    [self addSubview:self.topView];
    [self.topView addSubview:self.topClearShopCarBtn];
    [self.topView addSubview:self.topNameLabel];
    [self.topView addSubview:self.lineView];
    [self addSubview:self.tableView];
    [self addSubview:self.gotoBuyBtn];
}


- (void)layoutViews {
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@50);
    }];
    
    
    
    [self.topNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(10);
        make.centerY.equalTo(self.topView);
    }];
    
    
    [self.topClearShopCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView).offset(-10);
        make.centerY.equalTo(self.topView);
        make.width.equalTo(@100);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.topView);
        make.height.equalTo(@1);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.gotoBuyBtn.mas_top);
    }];
    [self.gotoBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.width.equalTo(@105);
        make.height.equalTo(@50);
    }];
}


- (void)setValueWithModelArr:(NSArray<NSArray<GoodsSkuVOListItem *> *> *)modelArr {
    
    self.modelArr = modelArr;
    [self.tableView reloadData];
}

#pragma mark - UITableviewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKStoreEidtMenuBottomShopCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID];
    if (!cell) {
        cell = [[XKStoreEidtMenuBottomShopCarTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:tableViewCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.xkIndustryType = self.xkIndustryType;
        XKWeakSelf(weakSelf);
        cell.refreshBlock = ^{
            [weakSelf refreshData];
        };
    }
    [cell setValueWithModel:self.modelArr[indexPath.row][0] shopId:self.shopId num:self.modelArr[indexPath.row].count];
    return cell;
}


- (void)refreshData {
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}


#pragma mark - coustomDelegate


#pragma mark - Events

- (void)clearShopCarBtnClicked {
    if (self.clearBlock) {
        self.clearBlock();
    }
}

- (void)gotoBuyBtnClicked {
    if (self.gotoBuyBlock) {
        self.gotoBuyBlock();
    }
}

#pragma mark - setter && getter


- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UILabel *)topNameLabel {
    if (!_topNameLabel) {
        _topNameLabel = [[UILabel alloc] init];
        _topNameLabel.text = @"购物车";
        _topNameLabel.textColor = HEX_RGB(0x000000);;
        _topNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    }
    return _topNameLabel;
}

- (UIButton *)topClearShopCarBtn {
    if (!_topClearShopCarBtn) {
        _topClearShopCarBtn = [[UIButton alloc] init];
        _topClearShopCarBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_topClearShopCarBtn setTitle:@"清空购物车" forState:UIControlStateNormal];
        [_topClearShopCarBtn setTitleColor:HEX_RGB(0x777777) forState:UIControlStateNormal];
        [_topClearShopCarBtn setImage:[UIImage imageNamed:@"xk_btn_coinDeail_timeDelete"] forState:UIControlStateNormal];
        [_topClearShopCarBtn addTarget:self action:@selector(clearShopCarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topClearShopCarBtn;
}

- (UIButton *)gotoBuyBtn {
    if (!_gotoBuyBtn) {
        _gotoBuyBtn = [[UIButton alloc] init];
        [_gotoBuyBtn addTarget:self action:@selector(gotoBuyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _gotoBuyBtn.backgroundColor = XKMainTypeColor;
        [_gotoBuyBtn setTitle:@"去结算" forState:UIControlStateNormal];
        [_gotoBuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _gotoBuyBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _gotoBuyBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:(UITableViewStylePlain)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end

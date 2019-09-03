//
//  XKSquareCouponView.m
//  XKSquare
//
//  Created by hupan on 2018/10/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSquareCouponView.h"
#import "XKSquareCouponCell.h"

static NSString *const cellID = @"storeCollectionViewCell";

@interface XKSquareCouponView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton         *closeBtn;
@property (nonatomic, strong) UIImageView      *headerImgView;
@property (nonatomic, strong) UIImageView      *imgView;

@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, assign) NSInteger        selectedIndex;

@end

@implementation XKSquareCouponView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    
    self.selectedIndex = -1;
    
    [self addSubview:self.closeBtn];
    [self addSubview:self.headerImgView];
    [self addSubview:self.imgView];
    [self.imgView addSubview:self.tableView];
}

- (void)layoutViews {
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self);
        make.width.height.equalTo(@20);
    }];
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.closeBtn.mas_bottom).offset(10);
        make.left.right.equalTo(self);
        make.height.equalTo(@(130 * ScreenScale));
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView);
        make.bottom.equalTo(self.imgView).offset(-10);
        make.left.equalTo(self.imgView).offset(30);
        make.right.equalTo(self.imgView).offset(-30);
    }];
}

#pragma mark - Events

- (void)closeBtnClicked:(UIButton *)sender {
    
    if (self.closeBtn) {
        self.closeBlock();
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardCoupons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKSquareCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[XKSquareCouponCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xk_openClip = YES;
    cell.xk_radius = 5;
    cell.xk_clipType = XKCornerClipTypeAllCorners;
    [cell configCellWithCardCouponModel:self.cardCoupons[indexPath.row]];
    __weak typeof(self) weakSelf = self;
    cell.useBtnBlock = ^(XKSquareCardCouponModel *theCardCoupon) {
        if (weakSelf.useBtnBlock) {
            weakSelf.useBtnBlock(theCardCoupon);
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - getter && setter

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"xk_iocn_hone_coupon_back"];
        _imgView.userInteractionEnabled = YES;
    }
    return _imgView;
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"xk_iocn_hone_coupon_header"];
        _headerImgView.userInteractionEnabled = YES;
    }
    return _headerImgView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"xk_btn_hone_coupon_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 10, 10) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
    }
    return _tableView;
}

- (void)setCardCoupons:(NSArray<XKSquareCardCouponModel *> *)cardCoupons {
    _cardCoupons = cardCoupons;
    [self.tableView reloadData];
}

@end

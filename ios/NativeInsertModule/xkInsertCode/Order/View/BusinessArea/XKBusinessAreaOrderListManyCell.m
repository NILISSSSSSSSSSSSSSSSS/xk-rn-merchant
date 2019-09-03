//
//  XKBusinessAreaOrderListManyCell.m
//  XKSquare
//
//  Created by hupan on 2018/11/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBusinessAreaOrderListManyCell.h"
#import "XKSingleImgCollectionViewCell.h"
#import "XKBusinessAreaOrderListModel.h"

@interface XKBusinessAreaOrderListManyCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *middleLineView;

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *transportLabel;
@property (nonatomic, strong) UIButton *bottomRightBtn;
@property (nonatomic, strong) UIButton *bottomLeftBtn;
@property (nonatomic, strong) AreaOrderListModel *item;

@end

@implementation XKBusinessAreaOrderListManyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.bgContainView.xk_openClip = YES;
        self.bgContainView.xk_radius = 6;
        self.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.bgContainView];
    
    [self.bgContainView addSubview:self.titleLabel];
    [self.bgContainView addSubview:self.statusLabel];
    [self.bgContainView addSubview:self.topLineView];
    
    [self.bgContainView addSubview:self.collectionView];
    [self.bgContainView addSubview:self.middleLineView];
    
    [self.bgContainView addSubview:self.countLabel];
    [self.bgContainView addSubview:self.timeLabel];

    [self.bgContainView addSubview:self.bottomLineView];
    [self.bgContainView addSubview:self.transportLabel];
    [self.bgContainView addSubview:self.bottomRightBtn];
    [self.bgContainView addSubview:self.bottomLeftBtn];
}


- (void)bindData:(AreaOrderListModel *)item {
    _item = item;
    
    NSString *str = @"";
    if (self.cellType == ManyCellType_PICK) {
        str = @"待接单";
        [_bottomRightBtn setTitle:@"查看详情" forState:0];
        [_bottomRightBtn setTitleColor:XKMainTypeColor forState:0];
        [_bottomRightBtn setBackgroundColor:[UIColor whiteColor]];
        _bottomRightBtn.layer.borderWidth = 1.f;
        _bottomRightBtn.layer.borderColor = XKMainTypeColor.CGColor;
        
        _bottomLeftBtn.hidden = YES;
    } else if (self.cellType == ManyCellType_PAY) {
        str = @"待支付";
    } else if (self.cellType == ManyCellType_USE) {
        str = @"待消费";
    } else if (self.cellType == ManyCellType_PREPARE) {
        str = @"备货中";
    } else if (self.cellType == ManyCellType_USEING) {
        str = @"进行中";
    } else if (self.cellType == ManyCellType_EVALUATE) {
        str = @"待评价";
    } else if (self.cellType == ManyCellType_FINISH) {
        str = @"已完成";
    } else if (self.cellType == ManyCellType_REFUND) {
        str = @"退款中";
    } else if (self.cellType == ManyCellType_CLOSED) {
        str = @"已关闭";
    }
    
    self.statusLabel.text = str;
    self.titleLabel.text = item.shopName;
    
    if (item.appointRange.length == 0) {
        self.timeLabel.hidden = YES;
    } else {
        NSArray *timeArr = [item.appointRange componentsSeparatedByString:@"-"];
        if (timeArr.count == 2) {
            self.timeLabel.hidden = YES;
        } else {
            self.timeLabel.hidden = NO;
            NSString *timeStr = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:item.appointRange];
            [self.timeLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.paragraphStyle.alignment(NSTextAlignmentLeft);
                confer.text(@"预约时间  ");
                confer.text(timeStr).textColor(HEX_RGB(0x555555));
            }];
        }
    }
    CGFloat totalprice = 0;
    for (XKOrderDetailGoodsItem *good in item.goods) {
        totalprice = totalprice + good.platformPrice.floatValue + good.purchasePrice * good.purchaseNum;
    }
    totalprice = totalprice / 100.0;
    [self.countLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.paragraphStyle.alignment(NSTextAlignmentRight);
        confer.text([NSString stringWithFormat:@"共计%d件:",(int)item.goods.count]);
        confer.text([NSString stringWithFormat:@"￥%.2f", totalprice]).textColor(HEX_RGB(0xEE6161)).font(XKMediumFont(16));
    }];
    if ([item.sceneStatus isEqualToString:@"TAKE_OUT"]) {
        self.transportLabel.text = item.isSelfLifting ? @"到店自提" : @"配送上门";
    }
    
 
    [self.collectionView reloadData];
    [self hanleBottomBtnStatusWithItem:item];
}

- (void)hanleBottomBtnStatusWithItem:(AreaOrderListModel *)item {
    
    _bottomLeftBtn.hidden   = NO;
    _bottomRightBtn.hidden  = NO;
    _transportLabel.hidden  = NO;
    _bottomRightBtn.userInteractionEnabled = YES;
    _bottomLeftBtn.userInteractionEnabled = YES;
    if ([item.bcleOrderPayStatus isEqualToString:@"NOT_PAY"]) {
        [self statusWithNeeedPay:YES];
    } else {
        [self statusWithNeeedPay:NO];
    }
    
}

- (void)statusWithNeeedPay:(BOOL)payNeed {
    if (payNeed) {
        [_bottomLeftBtn setTitle:@"查看详情" forState:0];
        [_bottomLeftBtn setTitleColor:XKMainTypeColor forState:0];
        [_bottomLeftBtn setBackgroundColor:[UIColor whiteColor]];
        _bottomLeftBtn.layer.borderWidth = 1.f;
        _bottomLeftBtn.layer.borderColor = XKMainTypeColor.CGColor;
        _bottomLeftBtn.userInteractionEnabled = NO;
        //确认收货  隐藏
        [_bottomRightBtn setTitle:@"去支付" forState:0];
        [_bottomRightBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_bottomRightBtn setBackgroundColor:XKMainTypeColor];
        _bottomRightBtn.layer.borderWidth = 0.f;
        _bottomRightBtn.layer.borderColor = XKMainTypeColor.CGColor;
    } else {
        [_bottomRightBtn setTitle:@"查看详情" forState:0];
        [_bottomRightBtn setTitleColor:XKMainTypeColor forState:0];
        [_bottomRightBtn setBackgroundColor:[UIColor whiteColor]];
        _bottomRightBtn.layer.borderWidth = 1.f;
        _bottomRightBtn.layer.borderColor = XKMainTypeColor.CGColor;
        _bottomRightBtn.userInteractionEnabled = NO;
        _bottomLeftBtn.hidden = YES;
    }
}

- (void)leftBtnClick:(UIButton *)sender {

}

- (void)rightBtnClick:(UIButton *)sender {
    XKWeakSelf(ws);
 if (self.cellType == ManyCellType_PAY || self.cellType == ManyCellType_USEING) {
     if (self.payBlock) {
         self.payBlock(ws.index);
     }
    } else if (self.cellType == ManyCellType_EVALUATE) {
        if (self.evluateBlock) {
            self.evluateBlock(ws.index);
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 如果 touch 的point 在 self 的bounds 内
    if ([self pointInside:point withEvent:event])
    {
        UIView *view = [super hitTest:point withEvent:event];
        if([view isKindOfClass:[UICollectionView class]]) {
            return self;
        } else {
            return view;
        }
        
    }
    return nil;
}

- (void)addUIConstraint {
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(10);
        make.top.equalTo(self.bgContainView.mas_top).offset(0);
        make.bottom.equalTo(self.topLineView.mas_top).offset(0);

    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgContainView.mas_top).offset(40);
        make.left.right.equalTo(self.bgContainView);
        make.height.mas_equalTo(1);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLineView.mas_bottom);
        make.left.right.equalTo(self.bgContainView);
        make.height.mas_equalTo(30+80*ScreenScale);
    }];
    
    
    [self.middleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.right.equalTo(self.bgContainView);
        make.height.mas_equalTo(1);
    }];
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(15);
        make.height.equalTo(@40);
        make.top.equalTo(self.middleLineView.mas_bottom);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
        make.left.equalTo(self.timeLabel.mas_right).offset(5);
        make.centerY.equalTo(self.timeLabel);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleLineView.mas_bottom).offset(40);
        make.left.right.equalTo(self.bgContainView);
        make.bottom.equalTo(self.bgContainView).offset(-42);
        make.height.mas_equalTo(1);
    }];
    
    [self.bottomRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(10);
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(70, 22));
        
    }];
    
    [self.bottomLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomRightBtn.mas_centerY);
        make.right.equalTo(self.bottomRightBtn.mas_left).offset(-15);
        make.size.mas_equalTo(CGSizeMake(70, 22));
    }];
    
    [self.transportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomRightBtn.mas_centerY);
        make.left.equalTo(self.bgContainView.mas_left).offset(15);
    }];
    
    
}

#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.item.goods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKSingleImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKSingleImgCollectionViewCell" forIndexPath:indexPath];
    XKOrderDetailGoodsItem *item = self.item.goods[indexPath.row];
    [cell setImageWithImgUrl:item.skuUrl];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80*ScreenScale, 80*ScreenScale);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//    XKWeakSelf(ws);
//    if (self.selectedBlock) {
//      // self.selectedBlock(ws.item.index);
//    }
}

#pragma mark  懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH - 20, 30+80*ScreenScale) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[XKSingleImgCollectionViewCell class] forCellWithReuseIdentifier:@"XKSingleImgCollectionViewCell"];
        
    }
    return _collectionView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x222222);
        _titleLabel.font = XKRegularFont(14);
    }
    return _titleLabel;
}

- (UILabel *)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = XKRegularFont(14);
        _statusLabel.textColor = UIColorFromRGB(0xee6161);
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

- (UIView *)topLineView {
    if(!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if(!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _bottomLineView;
}

- (UILabel *)countLabel {
    if(!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _countLabel.textColor  = UIColorFromRGB(0x222222);
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        //        _titleLabel.text = @"晓可广场";
        _timeLabel.textColor = UIColorFromRGB(0x999999);
        _timeLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
    }
    return _timeLabel;
}

- (UIView *)middleLineView {
    if(!_middleLineView) {
        _middleLineView = [[UIView alloc] init];
        _middleLineView.backgroundColor = XKSeparatorLineColor;
    }
    return _middleLineView;
}


- (UILabel *)transportLabel {
    if(!_transportLabel) {
        _transportLabel = [[UILabel alloc] init];
        _transportLabel.font = XKRegularFont(14);
        _transportLabel.textColor = XKMainTypeColor;
        //        _transportLabel.text = @"到店自提";
    }
    return _transportLabel;
}

- (UIButton *)bottomRightBtn {
    if (!_bottomRightBtn) {
        _bottomRightBtn = [[UIButton alloc] init];
        _bottomRightBtn.layer.cornerRadius = 11.f;
        _bottomRightBtn.layer.masksToBounds = YES;
        _bottomRightBtn.titleLabel.font = XKRegularFont(12);
        [_bottomRightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomRightBtn;
}

- (UIButton *)bottomLeftBtn {
    if (!_bottomLeftBtn) {
        _bottomLeftBtn = [[UIButton alloc] init];
        _bottomLeftBtn.layer.cornerRadius = 11.f;
        _bottomLeftBtn.layer.masksToBounds = YES;
        _bottomLeftBtn.titleLabel.font = XKRegularFont(12);
        [_bottomLeftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomLeftBtn;
}
@end

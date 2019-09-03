//
//  XKMallOrderWaitPayManyCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderWaitPayManyCell.h"
#import "XKSingleImgCollectionViewCell.h"
@interface XKMallOrderWaitPayManyCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UIButton *choseBtn;
@property (nonatomic, strong)UIImageView *arrowImgView;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIView *topLineView;

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UILabel *countLabel;

@property (nonatomic, strong)UIView *bottomLineView;
@property (nonatomic, strong)UIButton *moreBtn;
@property (nonatomic, strong)UIButton *payBtn;
@property (nonatomic, strong)MallOrderListDataItem *item;
@end

@implementation XKMallOrderWaitPayManyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.bgContainView.xk_openClip = YES;
        self.bgContainView.xk_radius = 6.f;
        self.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.bgContainView];
    
    [self.bgContainView addSubview:self.choseBtn];
    [self.bgContainView addSubview:self.arrowImgView];
    [self.bgContainView addSubview:self.statusLabel];
    [self.bgContainView addSubview:self.topLineView];
    
    [self.bgContainView addSubview:self.collectionView];
    [self.bgContainView addSubview:self.countLabel];
    
    [self.bgContainView addSubview:self.bottomLineView];
    [self.bgContainView addSubview:self.moreBtn];
    [self.bgContainView addSubview:self.payBtn];
}

- (void)bindData:(MallOrderListDataItem *)item {
    _item = item;
    self.choseBtn.selected = item.isChose;
    self.countLabel.text = [NSString stringWithFormat:@"共%zd件商品",item.goods.count];
    [self.collectionView reloadData];
}

- (void)addUIConstraint {
    
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(10);
        make.top.equalTo(self.bgContainView);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.choseBtn.mas_right).offset(10);
        make.centerY.equalTo(self.choseBtn);
        make.size.mas_equalTo(CGSizeMake(8, 14));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
        make.centerY.equalTo(self.choseBtn);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgContainView.mas_top).offset(30);
        make.left.right.equalTo(self.bgContainView);
        make.height.mas_equalTo(1);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLineView.mas_bottom);
        make.left.right.equalTo(self.bgContainView);
        make.height.mas_equalTo(115);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
        make.top.equalTo(self.topLineView.mas_bottom).offset(90);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgContainView);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(10);
        make.bottom.equalTo(self.bgContainView.mas_bottom).offset(-10);
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payBtn.mas_left).offset(-15);
        make.centerY.equalTo(self.payBtn);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    
    
}
#pragma mark event
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

- (void)choseBtnClick:(UIButton *)sender {
    if(self.choseBtnBlock) {
        sender.selected = !sender.selected;
        _item.isChose = !_item.isChose;
        self.choseBtnBlock(sender,_item.index);
    }
}

- (void)moreBtnClick:(UIButton *)sender {
    if(self.moreBtnBlock) {
        self.moreBtnBlock(sender,_item.index);
    }
}

- (void)payBtnClick:(UIButton *)sender {
    if(self.payBtnBlock) {
        self.payBtnBlock(sender,_item.index);
    }
}

#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _item.goods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKSingleImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKSingleImgCollectionViewCell" forIndexPath:indexPath];
    [cell bindItem:_item.goods[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, 70);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 7;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    XKWeakSelf(ws);
    if (self.selectedBlock) {
        self.selectedBlock(ws.item.index);
    }
}

#pragma mark  懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 28, 15);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH - 20, 115) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[XKSingleImgCollectionViewCell class] forCellWithReuseIdentifier:@"XKSingleImgCollectionViewCell"];
        
    }
    return _collectionView;
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

- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setTitle:@"晓可商城" forState:0];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_choseBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
        [_choseBtn setTitle:@"晓可商城" forState:UIControlStateSelected];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
        [_choseBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
        _choseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _choseBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choseBtn;
}

- (UIImageView *)arrowImgView {
    if(!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImgView.image = [UIImage imageNamed:@"xk_btn_order_grayArrow"];
    }
    return _arrowImgView;
}

- (UILabel *)statusLabel {
    if(!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        [_statusLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _statusLabel.textColor = UIColorFromRGB(0xee6161);
        _statusLabel.text = @"等待买家付款";
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

- (UIButton *)payBtn {
    if(!_payBtn) {
        _payBtn = [[UIButton alloc] init];
        [_payBtn setTitle:@"去付款" forState:0];
        _payBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_payBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        _payBtn.layer.cornerRadius = 10.f;
        _payBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        _payBtn.layer.borderWidth = 1.f;
        _payBtn.layer.masksToBounds = YES;
        [_payBtn setBackgroundColor:[UIColor whiteColor]];
        [_payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (UIButton *)moreBtn {
    if(!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setTitle:@"更多" forState:0];
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _moreBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_moreBtn setTitleColor:UIColorFromRGB(0x222222) forState:0];
        [_moreBtn setBackgroundColor:[UIColor whiteColor]];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
@end

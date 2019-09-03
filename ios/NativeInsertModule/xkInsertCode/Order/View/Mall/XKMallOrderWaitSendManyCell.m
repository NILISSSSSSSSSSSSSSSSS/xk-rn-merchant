//
//  XKMallOrderWaitSendManyCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderWaitSendManyCell.h"
#import "XKSingleImgCollectionViewCell.h"
@interface XKMallOrderWaitSendManyCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)UILabel *mallLabel;
@property (nonatomic, strong)UIImageView *arrowImgView;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIView *topLineView;

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UILabel *countLabel;
@property (nonatomic, strong)UILabel *refundLabel;

@property (nonatomic, strong)UIView *bottomLineView;
@property (nonatomic, strong)UIButton *moreBtn;
@property (nonatomic, strong)UIButton *tipBtn;
@property (nonatomic, strong)MallOrderListDataItem *item;
@end

@implementation XKMallOrderWaitSendManyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        [self cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 190)];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.mallLabel];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.topLineView];
    
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.refundLabel];
    
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.moreBtn];
    [self.contentView addSubview:self.tipBtn];
}

- (void)bindData:(MallOrderListDataItem *)item {
    _item = item;
    self.countLabel.text = [NSString stringWithFormat:@"共%zd件商品",item.goods.count];
    [self.collectionView reloadData];
}

- (void)addUIConstraint {
    [self.mallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mallLabel.mas_right).offset(10);
        make.centerY.equalTo(self.mallLabel);
        make.size.mas_equalTo(CGSizeMake(8, 14));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.mallLabel);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(30);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLineView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(115);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.topLineView.mas_bottom).offset(90);
    }];
    
    [self.refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countLabel.mas_left).offset(-80);
        make.centerY.equalTo(self.countLabel);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tipBtn.mas_left).offset(-15);
        make.centerY.equalTo(self.tipBtn);
        make.size.mas_equalTo(CGSizeMake(70, 20));
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

- (void)moreBtnClick:(UIButton *)sender {
    XKWeakSelf(ws);
    if(self.moreBtnBlock) {
        self.moreBtnBlock(sender, ws.item.index);
    }
}

- (void)tipBtnClick:(UIButton *)sender {
     XKWeakSelf(ws);
    if(self.tipBtnBlock) {
        self.tipBtnBlock(sender, ws.item.index);
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

- (UILabel *)refundLabel {
    if(!_refundLabel) {
        _refundLabel = [[UILabel alloc] init];
        _refundLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _refundLabel.textColor  = UIColorFromRGB(0xee6161);
        _refundLabel.textAlignment = NSTextAlignmentRight;

    }
    return _refundLabel;
}

- (UILabel *)mallLabel {
    if(!_mallLabel) {
        _mallLabel = [[UILabel alloc] init];
        _mallLabel.text = @"晓可商城";
        _mallLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        _mallLabel.textColor = UIColorFromRGB(0x222222);
    }
    return _mallLabel;
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
        _statusLabel.text = @"等待卖家发货";
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

- (UIButton *)tipBtn {
    if(!_tipBtn) {
        _tipBtn = [[UIButton alloc] init];
        [_tipBtn setTitle:@"提醒发货" forState:0];
        _tipBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_tipBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        _tipBtn.layer.cornerRadius = 10.f;
        _tipBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        _tipBtn.layer.borderWidth = 1.f;
        _tipBtn.layer.masksToBounds = YES;
        [_tipBtn setBackgroundColor:[UIColor whiteColor]];
        [_tipBtn addTarget:self action:@selector(tipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
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

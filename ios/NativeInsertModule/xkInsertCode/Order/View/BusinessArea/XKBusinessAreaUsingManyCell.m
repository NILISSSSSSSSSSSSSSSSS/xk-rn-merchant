//
//  XKBusinessAreaUsingManyCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBusinessAreaUsingManyCell.h"
#import "XKSingleImgCollectionViewCell.h"
#import "XKBusinessAreaOrderListModel.h"

@interface XKBusinessAreaUsingManyCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *arrowImgView;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIView *topLineView;

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UILabel *countLabel;

@property (nonatomic, strong)UIView *bottomLineView;
@property (nonatomic, strong)UILabel *transportLabel;
@property (nonatomic, strong)UIButton *acceptBtn;
@property (nonatomic, strong)AreaOrderListModel *item;
@end

@implementation XKBusinessAreaUsingManyCell

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
    [self.bgContainView addSubview:self.arrowImgView];
    [self.bgContainView addSubview:self.statusLabel];
    [self.bgContainView addSubview:self.topLineView];
    
    [self.bgContainView addSubview:self.collectionView];
    [self.bgContainView addSubview:self.countLabel];
    
    [self.bgContainView addSubview:self.bottomLineView];
    [self.bgContainView addSubview:self.transportLabel];
    [self.bgContainView addSubview:self.acceptBtn];
}


- (void)bindData:(AreaOrderListModel *)item {
    _item = item;
    //    self.choseBtn.selected = item.isChose;
    self.titleLabel.text = item.shopName;
    self.transportLabel.text = item.isSelfLifting ? @"到店自提" : @"配送上门";
    self.countLabel.text = [NSString stringWithFormat:@"共%zd件商品",item.goods.count];
    [self.collectionView reloadData];
}

- (void)addUIConstraint {
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(10);
        make.top.equalTo(self.bgContainView.mas_top).offset(6);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(8, 14));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
        make.centerY.equalTo(self.titleLabel);
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
    
    [self.acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 22));
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(10);
        make.right.equalTo(self.bgContainView.mas_right).offset(-15);
    }];
    
    [self.transportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(5);
        make.bottom.equalTo(self.bgContainView.mas_bottom).offset(-5);
        make.left.equalTo(self.bgContainView.mas_left).offset(15);
    }];
    
    
}

- (void)acceptBtnClick:(UIButton *)sender {
    if(self.acceptBtnBlock) {
        self.acceptBtnBlock(sender,nil);
    }
}

#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKSingleImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKSingleImgCollectionViewCell" forIndexPath:indexPath];
    //  [cell bindItem:_item.goods[indexPath.row]];
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
        // self.selectedBlock(ws.item.index);
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
//        _countLabel.text = @"共三单";
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.text = @"晓可广场";
        _titleLabel.textColor = UIColorFromRGB(0x222222);
        _titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    return _titleLabel;
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
        _statusLabel.text = @"进行中";
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

- (UILabel *)transportLabel {
    if(!_transportLabel) {
        _transportLabel = [[UILabel alloc] init];
        [_transportLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14]];
        _transportLabel.textColor = XKMainTypeColor;
//        _transportLabel.text = @"到店自提";
    }
    return _transportLabel;
}

- (UIButton *)acceptBtn {
    if(!_acceptBtn) {
        _acceptBtn = [[UIButton alloc] init];
        [_acceptBtn setTitle:@"确认收货" forState:0];
        _acceptBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_acceptBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        _acceptBtn.layer.cornerRadius = 10.f;
        _acceptBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        _acceptBtn.layer.borderWidth = 1.f;
        _acceptBtn.layer.masksToBounds = YES;
        [_acceptBtn setBackgroundColor:[UIColor whiteColor]];
        [_acceptBtn addTarget:self action:@selector(acceptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _acceptBtn;
}

@end

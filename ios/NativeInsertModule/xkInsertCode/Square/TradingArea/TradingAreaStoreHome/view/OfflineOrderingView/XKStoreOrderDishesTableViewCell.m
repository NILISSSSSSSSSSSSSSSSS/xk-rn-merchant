//
//  XKStoreOrderDishesTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreOrderDishesTableViewCell.h"
#import "XKStoreOrderDishesCollectionCell.h"
#import "XKTradingAreaShopInfoModel.h"

#define itemWidth   (int)((SCREEN_WIDTH - 20 - 20) / 3.5)
#define itemHeight  itemWidth + 50

static NSString *const collectionViewCellID = @"collectionViewCell";

@interface XKStoreOrderDishesTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView            *headerView;
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UIButton          *scanBtn;
@property (nonatomic, strong) UIView            *lineView;

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, copy  ) NSArray           *dataArr;

@end

@implementation XKStoreOrderDishesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    [self.contentView addSubview:self.headerView];
    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.scanBtn];
    [self.headerView addSubview:self.lineView];
    [self.contentView addSubview:self.collectionView];
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@40);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(15);
        make.centerY.equalTo(self.headerView);
    }];
    
    
    [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView).offset(-10);
        make.height.with.equalTo(@40);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.headerView);
        make.height.equalTo(@1);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@(itemHeight + 5));
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - Setter



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKStoreOrderDishesCollectionCell class] forCellWithReuseIdentifier:collectionViewCellID];
    }
    return _collectionView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEX_RGB(0x222222);
        _titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _titleLabel.text = @"现场购买";
    }
    return _titleLabel;
}

- (UIButton *)scanBtn {
    if (!_scanBtn) {
        _scanBtn = [[UIButton alloc] init];
        [_scanBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(scanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


- (void)setValueWithModelArr:(NSArray<ATShopGoodsItem *> *)arr {
    
    self.dataArr = arr;
    [self.collectionView reloadData];
}

#pragma mark - Events

- (void)scanBtnClicked:(UIButton *)sender {
    
    
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKStoreOrderDishesCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    [cell setValueWithModel:self.dataArr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.itemBlock) {
        self.itemBlock(collectionView, indexPath);
    }
}

@end

//
//  XKStoreTakeoutTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreTakeoutTableViewCell.h"
#import "XKStoreTakeoutCollectionCell.h"
#import "XKTradingAreaShopInfoModel.h"

#define itemWidth   (int)((SCREEN_WIDTH - 20 - 20) / 3.5)
#define itemHeight  itemWidth + 30

static NSString *const collectionViewCellID = @"collectionViewCell";

@interface XKStoreTakeoutTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UIView            *headerView;
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UIView            *lineView;

@property (nonatomic, strong) UIView            *footerView;
@property (nonatomic, strong) UIButton          *goBuyBtn;
@property (nonatomic, strong) UIView            *lineView2;
@property (nonatomic, strong) UIImageView       *imgView;

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, copy  ) NSArray            *dataArr;


@end

@implementation XKStoreTakeoutTableViewCell

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
    [self.headerView addSubview:self.lineView];
    
    [self.contentView addSubview:self.collectionView];

    [self.contentView addSubview:self.footerView];
    [self.footerView addSubview:self.goBuyBtn];
    [self.footerView addSubview:self.imgView];
    [self.footerView addSubview:self.lineView2];
    
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
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.headerView);
        make.height.equalTo(@1);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@(itemHeight + 1));
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@44);
        make.bottom.equalTo(self.contentView);
    }];
    
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.footerView);
        make.height.equalTo(@1);
    }];
    
    [self.goBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(self.footerView);
        make.centerX.equalTo(self.footerView);
        make.width.equalTo(@60);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goBuyBtn);
        make.left.equalTo(self.goBuyBtn.mas_right);
        make.width.equalTo(@7);
        make.height.equalTo(@10);
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
        [_collectionView registerClass:[XKStoreTakeoutCollectionCell class] forCellWithReuseIdentifier:collectionViewCellID];
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
        _titleLabel.text = @"外卖";
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
    }
    return _footerView;
}


- (UIButton *)goBuyBtn {
    if (!_goBuyBtn) {
        _goBuyBtn = [[UIButton alloc] init];
        [_goBuyBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
        [_goBuyBtn setTitle:@"进入购买" forState:UIControlStateNormal];
        _goBuyBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_goBuyBtn addTarget:self action:@selector(goBuyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goBuyBtn;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"];
    }
    return _imgView;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView2;
}


- (void)setValueWithModelArr:(NSArray<ATShopGoodsItem *> *)arr {
    
    self.dataArr = arr;
    [self.collectionView reloadData];
}


#pragma mark - Events

- (void)setTitleName:(NSString *)titleName {
    
    self.titleLabel.text = titleName;
}

- (void)goBuyBtnClicked:(UIButton *)sender {
    
    if (self.goBuyBlock) {
        self.goBuyBlock(self);
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKStoreTakeoutCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    [cell setValueWithModel:self.dataArr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ATShopGoodsItem *model = self.dataArr[indexPath.row];
    if (self.itemBlock) {
        self.itemBlock(collectionView, indexPath, model.goodsId);
    }
    
}

@end

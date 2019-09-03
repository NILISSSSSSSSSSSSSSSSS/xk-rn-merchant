//
//  XKGamesWalletTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/13.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKGamesWalletTableViewCell.h"
#import "XKGamesWalletCollectionViewCell.h"

static NSString *const collectionViewCellID = @"collectionViewCell";

@interface XKGamesWalletTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (nonatomic, copy  ) UIView            *bgView;
@property (nonatomic, copy  ) UILabel           *nameLabel;
@property (nonatomic, copy  ) UIButton          *buyBtn;
@property (nonatomic, copy  ) UICollectionView  *collectionView;
@property (nonatomic, strong) UIView            *lineView;


@end

@implementation XKGamesWalletTableViewCell

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
        self.contentView.backgroundColor = XKMainTypeColor;
        [self initViews];
        [self layoutViews];
    }
    return self;
}


#pragma mark - Private


- (void)initViews {
    
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.buyBtn];
    [self.bgView addSubview:self.collectionView];
}



- (void)layoutViews {
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bgView).offset(10);
    }];
    
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-10);
        make.width.equalTo(@70);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(self.bgView);
        make.height.equalTo(@60);
    }];

}


- (void)buyBtnClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyButtonClicked:)]) {
        [self.delegate buyButtonClicked:sender];
    }
}


#pragma mark - Setter


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 5;
    }
    return _bgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"资产钱包";
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        _nameLabel.textColor = HEX_RGB(0x222222);
    }
    return _nameLabel;
    
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [[UIButton alloc] init];
        [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.layer.cornerRadius = 10;
        _buyBtn.layer.borderColor = XKMainTypeColor.CGColor;
        _buyBtn.layer.borderWidth = 1;
        [_buyBtn addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}


- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 20) / 4, 60);
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKGamesWalletCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
        
    }
    return _collectionView;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return _dataArr.count;
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKGamesWalletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    XKWeakSelf(weakSelf);
    cell.bindCoinBlock = ^(UIButton *sender) {
        [weakSelf bindCoinButtonClicked:sender indexPath:indexPath];
    };
    if (indexPath.row == 3) {
        [cell hiddenLineView:YES];
    } else {
        [cell hiddenLineView:NO];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    

}


- (void)bindCoinButtonClicked:(UIButton *)sender indexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bindCoinButtonClicked:index:)]) {
        [self.delegate bindCoinButtonClicked:sender index:indexPath.row];
    }
}

@end

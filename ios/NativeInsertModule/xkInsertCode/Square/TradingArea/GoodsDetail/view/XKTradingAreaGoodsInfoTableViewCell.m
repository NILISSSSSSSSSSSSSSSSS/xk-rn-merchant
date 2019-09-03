//
//  XKTradingAreaGoodsInfoTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKTradingAreaGoodsInfoTableViewCell.h"
#import "XKStoreInfoCollectionCell.h"
#import "XKTradingAreaGoodsInfoModel.h"

#define itemWidth   (int)((SCREEN_WIDTH - 20 - 20) / 4)
#define itemHeight  itemWidth

static NSString *const collectionViewCellID = @"collectionViewCell";

@interface XKTradingAreaGoodsInfoTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView            *headerView;
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UIView            *lineView;
/*
@property (nonatomic, strong) UILabel           *goodsNamelabel;
@property (nonatomic, strong) UILabel           *priceLabel;*/
@property (nonatomic, strong) UILabel           *introductionLabel;
@property (nonatomic, strong) UILabel           *decLable;
@property (nonatomic, strong) UICollectionView  *collectionView;

@property (nonatomic, copy  ) NSArray           *picArr;



@end


@implementation XKTradingAreaGoodsInfoTableViewCell

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
    /*
    [self.contentView addSubview:self.goodsNamelabel];
    [self.contentView addSubview:self.priceLabel];*/
    
    [self.contentView addSubview:self.introductionLabel];
    [self.contentView addSubview:self.decLable];
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
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.headerView);
        make.height.equalTo(@1);
    }];
    /*
    [self.goodsNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.priceLabel.mas_left).offset(-15);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.goodsNamelabel);
    }];*/
    
    [self.introductionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.decLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introductionLabel.mas_bottom).offset(2);
        make.left.equalTo(self.introductionLabel.mas_left);
        make.right.lessThanOrEqualTo(self.contentView).offset(-15);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.decLable.mas_bottom).offset(0);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@(itemHeight + 1));
        make.bottom.equalTo(self.contentView).offset(-10);
    }];

}



#pragma mark - Setter


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
        _titleLabel.text = @"商品说明";
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

/*
- (UILabel *)goodsNamelabel {
    if (!_goodsNamelabel) {
        _goodsNamelabel = [[UILabel alloc] init];
        _goodsNamelabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _goodsNamelabel.textColor = HEX_RGB(0x222222);
        _goodsNamelabel.textAlignment = NSTextAlignmentLeft;
//        _goodsNamelabel.text = @"酸菜土豆丝200g";
    }
    return _goodsNamelabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _priceLabel.textColor = HEX_RGB(0x222222);
        _priceLabel.textAlignment = NSTextAlignmentRight;
//        _priceLabel.text = @"1         11.5元";
    }
    return _priceLabel;
}*/


- (UILabel *)introductionLabel {
    if (!_introductionLabel) {
        _introductionLabel = [[UILabel alloc] init];
        _introductionLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _introductionLabel.textColor = HEX_RGB(0x555555);
        _introductionLabel.textAlignment = NSTextAlignmentLeft;
        _introductionLabel.text = @"详细信息";
    }
    return _introductionLabel;
}


- (UILabel *)decLable {
    if (!_decLable) {
        _decLable = [[UILabel alloc] init];
        _decLable.numberOfLines = 0;
        _decLable.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _decLable.textColor = HEX_RGB(0x555555);
        _decLable.textAlignment = NSTextAlignmentLeft;
//        _decLable.text = @"食材：土豆、辣椒\n调料：醋、豆瓣";
    }
    return _decLable;
}


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
        [_collectionView registerClass:[XKStoreInfoCollectionCell class] forCellWithReuseIdentifier:collectionViewCellID];
    }
    return _collectionView;
}


- (void)setValuesWithModel:(GoodsModel *)model {
    self.picArr = model.showPics;
    /*
    self.goodsNamelabel.text = model.defaultSkuName;
    self.priceLabel.text = [NSString stringWithFormat:@"1      %@元", model.originalPrice];*/
    
    self.decLable.text = model.details;
    
    
    if (self.picArr.count) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(itemHeight + 1));
        }];
    } else {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }

    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKStoreInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    [cell setImgViewWithImgUrl:self.picArr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsInfoImgCollectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate goodsInfoImgCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}



@end

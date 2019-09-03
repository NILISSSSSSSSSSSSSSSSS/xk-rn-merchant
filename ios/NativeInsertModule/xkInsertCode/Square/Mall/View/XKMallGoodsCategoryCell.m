//
//  XKMallGoodsCategoryCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/16.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallGoodsCategoryCell.h"

@interface XKMallGoodsCategoryCell ()

@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIImageView  *statusImgView;

@end

@implementation XKMallGoodsCategoryCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addCustomSubviews];
        [self addUIConstraint];
        self.xk_openClip = YES;
        self.xk_radius = 2;
        self.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.titleBtn];
    [self addSubview:self.statusImgView];
}

//- (void)bindData:(MallGoodsListItem *)item {
//    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:kDefaultPlaceHolderImg];
//    self.nameLabel.text = item.name;
//    self.sellLabel.text = [NSString stringWithFormat:@"月销量:%zd",item.saleQ];
//    self.priceLabel.text = [NSString stringWithFormat:@"¥%zd",item.price];
//}

- (void)addUIConstraint {
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

- (void)updateStatus:(ItemStatus )status withTitle:(NSString *)title{
   
    switch (status) {
        case ItemStatusChose: {
            self.statusImgView.hidden = NO;
            self.statusImgView.image = [UIImage imageNamed:@"xk_btn_mall_add"];
            [self bringSubviewToFront:self.statusImgView];
        }
            break;
        case ItemStatusDelete: {
            self.statusImgView.hidden = NO;
            self.statusImgView.image = [UIImage imageNamed:@"xk_btn_mall_delete"];
            [self bringSubviewToFront:self.statusImgView];
        }
            break;
        case ItemStatusNone:
             self.statusImgView.hidden = YES;
            break;
            
        default:
            break;
    }
    [self.titleBtn setTitle:title forState:0];
    
}

- (void)titleBtnClick:(UIButton *)sender {
    if (self.choseBlock) {
        XKWeakSelf(ws);
        self.choseBlock(ws.index, sender);
    }
}

- (UIButton *)titleBtn {
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc] init];
        _titleBtn.titleLabel.font = XKRegularFont(14);
        [_titleBtn setTitleColor:UIColorFromRGB(0x555555) forState:0];
        [_titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleBtn;
}

- (UIImageView *)statusImgView {
    if (!_statusImgView) {
        _statusImgView = [[UIImageView alloc] init];
        _statusImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _statusImgView;
}
@end

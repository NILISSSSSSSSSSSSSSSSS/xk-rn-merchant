//
//  XKWelfareCollectionDoubleCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareCollectionDoubleCell.h"

@interface XKWelfareCollectionDoubleCell (){
    UIView *_line;
}
@property (nonatomic, assign)BOOL        isEdit;


@end
@implementation XKWelfareCollectionDoubleCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        [self addUIConstraint];
        _line = [UIView new];
        _line.backgroundColor = HEX_RGB(0xF2F2F2);
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (void)setModel:(XKCollectWelfareDataItem *)model {
    _model = model;
    [self layoutIfNeeded];
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.target.showPics] placeholderImage:kDefaultPlaceHolderImg];
    _nameLabel.text = model.target.goodsName;
    NSString *status = @(model.target.perPrice / 100).stringValue;
    NSString *statusStr = [NSString stringWithFormat:@"代金券：%@",status];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(4, statusStr.length - 4)];
    _priceLabel.attributedText = attrString;
    if (self.isEdit) {
        _shareButton.selected = _model.isSelected;
    }
}

- (void)createUI {
    [self addCustomSubviews];
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.bgContainView];
    [self.bgContainView addSubview:self.iconImgView];
    [self.bgContainView addSubview:self.nameLabel];
    [self.bgContainView addSubview:self.priceLabel];
    [self.bgContainView addSubview:self.shareButton];
}

- (void)addUIConstraint {
    [self.bgContainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgContainView);
        make.height.mas_equalTo(168);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgContainView.mas_left).offset(5);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(5);
        make.right.equalTo(self.bgContainView.mas_right).offset(-5);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * ScreenScale);
        make.right.equalTo(@(-10 * ScreenScale));
        make.width.height.equalTo(@(20 * ScreenScale));
    }];
}

- (void)shareAction:(UIButton *)sender {
    if (self.isEdit) {
        NSLog(@"编辑中");
        self.model.isSelected = !self.model.isSelected;
        if (self.block) {
            self.block();
        }
    }else{
        NSLog(@"分享");
        if (self.shareBlock) {
            self.shareBlock(self.model);
        }
    }
}
- (void)updateLayout {
    self.isEdit = YES;
    [self.shareButton setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
    [self.shareButton setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    
}

- (void)restoreLayout {
    self.isEdit = NO;
    [self.shareButton setImage:[UIImage imageNamed:@"xk_btn_home_share"] forState:0];
    [self.shareButton setImage:[UIImage imageNamed:@"xk_btn_home_share"] forState:UIControlStateSelected];
    
}
#pragma mark lazy
- (UIView *)bgContainView {
    if (!_bgContainView) {
        _bgContainView = [[UIView alloc] init];
        _bgContainView.backgroundColor = [UIColor whiteColor];
    }
    return _bgContainView;
}


- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.clipsToBounds = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.layer.cornerRadius = 3.f;
        _iconImgView.layer.borderWidth = 1.f;
        _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:XKRegularFont(14)];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        [_priceLabel setFont:XKRegularFont(12)];
        _priceLabel.textColor = UIColorFromRGB(0x777777);
        
    }
    return _priceLabel;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc]init];
        [_shareButton setImage:[UIImage imageNamed:@"xk_btn_home_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
@end

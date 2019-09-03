//
//  XKMallLoseEfficacyBuyCarCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallLoseEfficacyBuyCarCell.h"
#import "XKWelfareBuyCarSumView.h"
@interface XKMallLoseEfficacyBuyCarCell ()
@property (nonatomic, strong)UIButton *choseBtn;
@property (nonatomic, strong)UIButton *loseBtn;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *typeLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)XKWelfareBuyCarSumView *sumView;
@property (nonatomic, strong)UIButton *ticketBtn;
@property (nonatomic, strong)XKMallBuyCarItem *item;
@end

@implementation XKMallLoseEfficacyBuyCarCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
        
    }
    return self;
}

- (void)addCustomSubviews {
    
    [self addSubview:self.choseBtn];
    [self addSubview:self.loseBtn];
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.ticketBtn];
    [self.contentView addSubview:self.sumView];
}

- (void)handleDataModel:(XKMallBuyCarItem *)item managerModel:(BOOL)manager {
    _item = item;

    if(manager) {
        [self.choseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.mas_equalTo(40);
        }];
    } else {//非管理模式
        [self.choseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.width.mas_equalTo(0);
        }];
    }
    
    
    self.nameLabel.text = item.goodsName;
    self.choseBtn.selected = item.selected;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:kDefaultPlaceHolderImg];
    self.typeLabel.text = [NSString stringWithFormat:@"规格：%@",item.goodsAttr];
    NSString *price = @(item.price / 100).stringValue;
    NSString *priceStr = [NSString stringWithFormat:@"价格：%@",price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(3, priceStr.length - 3)];
    self.priceLabel.attributedText = attrString;
}

- (void)addUIConstraint {
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-40);
        make.left.equalTo(self.contentView);
        make.width.mas_equalTo(44);
    }];
    
    [self.loseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.choseBtn.mas_right);
        make.centerY.equalTo(self.choseBtn);
        make.size.mas_equalTo(CGSizeMake(33, 18));
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loseBtn.mas_right).offset(5);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.typeLabel.mas_bottom).offset(2);
    }];
    
    [self.ticketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    [self.sumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.ticketBtn.mas_top).offset(-10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    self.sumView.alpha = 0;
    
}

- (void)ticketBtnClick:(UIButton *)sender {
    XKWeakSelf(ws);
    if(self.ticketClickBlock) {
        self.ticketClickBlock(sender, ws.item.index);
    }
}

- (void)choseBtnClick:(UIButton *)sender {
    XKWeakSelf(ws);
    if(self.choseClickBlock) {
        self.choseBtn.selected = !self.choseBtn.selected;
        self.choseClickBlock(sender, ws.item.index);
    }
}

- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
        [_choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choseBtn;
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.layer.cornerRadius = 3.f;
        _iconImgView.layer.borderWidth = 1.f;
        _iconImgView.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _nameLabel.textColor = UIColorFromRGB(0x222222);
        _nameLabel.numberOfLines = 2;
      
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if(!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        [_typeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _typeLabel.textColor = UIColorFromRGB(0x555555);
       
    }
    return _typeLabel;
}

- (UILabel *)priceLabel {
    if(!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = UIColorFromRGB(0x555555);
        _priceLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.f];
       
    }
    return _priceLabel;
}

- (UIButton *)ticketBtn {
    if(!_ticketBtn) {
        _ticketBtn = [UIButton new];
        [_ticketBtn setTitle:@"请重新选择规格" forState:0];
        _ticketBtn.titleLabel.font = XKRegularFont(12);
        [_ticketBtn setTitleColor:XKMainTypeColor forState:0];
        _ticketBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_ticketBtn addTarget:self action:@selector(ticketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ticketBtn;
}

- (XKWelfareBuyCarSumView *)sumView {
    if(!_sumView) {
        XKWeakSelf(ws);
        _sumView = [[XKWelfareBuyCarSumView alloc] init];
        _sumView.addBlock = ^(UIButton *sender) {
            NSInteger current = ws.sumView.inputTf.text.integerValue;
            current += 1;
            ws.sumView.inputTf.text = @(current).stringValue;
        };
        _sumView.subBlock = ^(UIButton *sender) {
            NSInteger current = ws.sumView.inputTf.text.integerValue;
            if(current > 1) {
                current -= 1;
            }
            ws.sumView.inputTf.text = @(current).stringValue;
        };
    }
    return _sumView;
}

- (UIButton *)loseBtn {
    if(!_loseBtn) {
        _loseBtn = [[UIButton alloc] init];
        [_loseBtn setBackgroundColor:UIColorFromRGB(0xcccccc)];
        [_loseBtn setTitle:@"失效" forState:0];
        _loseBtn.userInteractionEnabled = NO;
        _loseBtn.titleLabel.font = XKRegularFont(12);
        [_loseBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_loseBtn cutCornerWithRoundedRect:CGRectMake(0, 0, 33, 18) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        
    }
    return _loseBtn;
}
@end

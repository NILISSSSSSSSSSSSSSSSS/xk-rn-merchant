//
//  XKWelfareCollectionViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/11/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareCollectionViewCell.h"
@interface XKWelfareCollectionViewCell ()
@property (nonatomic, strong)UIButton    *choseBtn;
@property (nonatomic, strong)UIView      *segmengView;
@property (nonatomic, strong)UIButton    *sendChoseBtn;

@end

@implementation XKWelfareCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        [self addUIConstraint];
    }
    return self;
}
- (void)createUI {
    [super createUI];
    [self addCustomSubviews];
}


- (void)setModel:(XKCollectWelfareDataItem *)model {
    _model = model;
    [self layoutIfNeeded];
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.target.showPics] placeholderImage:kDefaultPlaceHolderImg];
    _nameLabel.text = model.target.name;
    NSString *status = @(model.target.perPrice / 100).stringValue;
    NSString *statusStr = [NSString stringWithFormat:@"代金券：%@",status];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:statusStr];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:UIColorFromRGB(0xee6161)
                       range:NSMakeRange(4, statusStr.length - 4)];
    _priceLabel.attributedText = attrString;
    _choseBtn.selected = _model.isSelected;
    _sendChoseBtn.selected = _model.isSendSelected;
    if (self.controllerType == XKMeassageCollectControllerType) {
        _sendChoseBtn.hidden = NO;
        _shareButton.hidden = YES;
    }else {
        _sendChoseBtn.hidden = YES;
        _shareButton.hidden = NO;
    }
    
}
- (void)addCustomSubviews {
    [self.myContentView addSubview:self.iconImgView];
    [self.myContentView addSubview:self.nameLabel];
    [self.myContentView addSubview:self.priceLabel];
    [self.myContentView addSubview:self.choseBtn];
    [self.myContentView addSubview:self.segmengView];
    [self.myContentView addSubview:self.sendChoseBtn];
    [self.myContentView addSubview:self.shareButton];

    self.choseBtn.hidden = YES;
}
- (void)shareAction:(UIButton *)sender {
    NSLog(@"111111");
    if (self.shareBlock) {
        self.shareBlock(self.model);
    }
}
- (void)addUIConstraint {
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.myContentView);
        make.width.mas_equalTo(40 * ScreenScale);
    }];
    
    [self.segmengView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.myContentView);
        make.height.mas_equalTo(1);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myContentView.mas_left).offset(15 * ScreenScale);
//        make.top.equalTo(self.myContentView.mas_top).offset(15 * ScreenScale);
        make.size.mas_equalTo(CGSizeMake(100 * ScreenScale , 100 * ScreenScale));
        make.centerY.equalTo(self.myContentView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10 * ScreenScale);
        make.top.equalTo(self.iconImgView);
        make.right.equalTo(self.myContentView.mas_right).offset(-15 * ScreenScale);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0 * ScreenScale);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20 * ScreenScale));
        make.width.height.equalTo(@(20 * ScreenScale));
        make.bottom.equalTo(self.segmengView.mas_top).offset(-3 * ScreenScale);
    }];
    
    [self.sendChoseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20 * ScreenScale));
        make.width.height.equalTo(@(20 * ScreenScale));
        make.bottom.equalTo(self.segmengView.mas_top).offset(-3 * ScreenScale);
    }];
}

- (void)updateLayout {
    self.choseBtn.hidden = NO;
    [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myContentView.mas_left).offset(40 * ScreenScale);
    }];
}

- (void)restoreLayout {
    self.choseBtn.hidden = YES;
    [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myContentView.mas_left).offset(15 * ScreenScale);
    }];
}
- (void)choseAction:(UIButton *)sender {
    self.model.isSelected = !self.model.isSelected;
    if (self.block) {
        self.block();
    }
}
- (void)sendChoseAction:(UIButton *)sender {
    self.model.isSendSelected = !self.model.isSendSelected;
    if (self.sendChoseblock) {
        self.sendChoseblock(self.model);
    }
}


- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_choseBtn addTarget:self action:@selector(choseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    }
    return _choseBtn;
}

- (UIButton *)sendChoseBtn {
    if(!_sendChoseBtn) {
        _sendChoseBtn = [[UIButton alloc] init];
        [_sendChoseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_sendChoseBtn addTarget:self action:@selector(sendChoseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sendChoseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    }
    return _sendChoseBtn;
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
        _nameLabel.numberOfLines = 2;
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


- (UIView *)segmengView {
    if(!_segmengView) {
        _segmengView = [[UIView alloc] init];
        _segmengView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _segmengView;
}


- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc]init];
        [_shareButton setImage:[UIImage imageNamed:@"xk_btn_home_share"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (void)setFrame:(CGRect)frame {
    frame.size.width -= 20;
    frame.origin.x += 10;
    [super setFrame:frame];
}
@end

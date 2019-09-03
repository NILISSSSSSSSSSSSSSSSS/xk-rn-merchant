//
//  XKStoreInStoreTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKStoreInStoreTableViewCell.h"
#import "XKTradingAreaShopInfoModel.h"


@interface XKStoreInStoreTableViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIButton    *lookStoreButton;
@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, strong) ATShopsItem *model;

@end

@implementation XKStoreInStoreTableViewCell

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
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.lookStoreButton];
    [self.contentView addSubview:self.lineView];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.equalTo(@(60*ScreenScale));
        make.bottom.equalTo(self.contentView).offset(-15);
        
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgView);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.contentView).offset(-80);
    }];
    
    [self.lookStoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgView);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@22);
        make.width.equalTo(@60);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - Setter


- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 5;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLabel.textColor = HEX_RGB(0x474747);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}



- (UIButton *)lookStoreButton {
    if (!_lookStoreButton) {
        _lookStoreButton = [[UIButton alloc] init];
        _lookStoreButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        [_lookStoreButton setTitle:@"进入店铺" forState:UIControlStateNormal];
        [_lookStoreButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        [_lookStoreButton setBackgroundColor:[UIColor whiteColor]];
        _lookStoreButton.layer.masksToBounds = YES;
        _lookStoreButton.layer.cornerRadius = 11;
        _lookStoreButton.layer.borderWidth = 1;
        _lookStoreButton.layer.borderColor = XKMainTypeColor.CGColor;
        [_lookStoreButton addTarget:self action:@selector(lookStoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookStoreButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}

- (void)hiddenLineView:(BOOL)hidden {
    self.lineView.hidden = hidden;
}

- (void)setValueWithModel:(ATShopsItem *)model {
    self.model = model;
    [self.imgView sd_setImageWithURL:kURL(model.shopPic) placeholderImage:IMG_NAME(kDefaultPlaceHolderImgName)];
    self.nameLabel.text = model.shopName;
}


#pragma mark - Events

- (void)lookStoreButtonClicked:(UIButton *)sender {
    
    if (self.lookStoreBlock) {
        self.lookStoreBlock(self.model.shopId);
    }
}






@end

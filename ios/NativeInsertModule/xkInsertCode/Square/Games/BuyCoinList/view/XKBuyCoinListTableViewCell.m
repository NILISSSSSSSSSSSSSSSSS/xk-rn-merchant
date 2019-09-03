//
//  XKBuyCoinListTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBuyCoinListTableViewCell.h"


@interface XKBuyCoinListTableViewCell ()

@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, copy  ) UILabel           *nameLabel;
@property (nonatomic, copy  ) UILabel           *yuELabel;
@property (nonatomic, copy  ) UIButton          *buyBtn;
@property (nonatomic, strong) UIView            *lineView;


@end


@implementation XKBuyCoinListTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
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


- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}


- (void)initViews {
    
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.yuELabel];
    [self.contentView addSubview:self.buyBtn];
    
    [self.contentView addSubview:self.lineView];
    
}



- (void)layoutViews {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@37);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(-2);
        make.left.equalTo(self.imgView.mas_right).offset(10);
    }];
    
    
    [self.yuELabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView.mas_bottom);
        make.left.equalTo(self.imgView.mas_right).offset(10);
    }];
    
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.width.equalTo(@70);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}


- (void)buyBtnClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyButtonClicked:binded:)]) {
        [self.delegate buyButtonClicked:sender binded:NO];
    }
}


#pragma mark - Setter

- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor blueColor];
    }
    return _imgView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"晓可币";
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
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


- (UILabel *)yuELabel {
    if (!_yuELabel) {
        _yuELabel = [[UILabel alloc] init];
        _yuELabel.textAlignment = NSTextAlignmentLeft;
        _yuELabel.text = @"余额：238";
        _yuELabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _yuELabel.textColor = HEX_RGB(0x777777);
    }
    return _yuELabel;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


@end





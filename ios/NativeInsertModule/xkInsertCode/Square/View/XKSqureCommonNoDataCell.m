//
//  XKSqureCommonNoDataCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureCommonNoDataCell.h"
#import "XKSqureConsultModel.h"

@interface XKSqureCommonNoDataCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *decLable;
@property (nonatomic, strong) UIView      *lineView;

@end

@implementation XKSqureCommonNoDataCell

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
        self.contentView.backgroundColor = HEX_RGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.imgView];
    [self.backView addSubview:self.decLable];
    [self.backView addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView setNeedsLayout];
    [self.backView layoutIfNeeded];
}

- (void)layoutViews {
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(10);
        make.width.height.equalTo(@(60*ScreenScale));
        make.centerX.equalTo(self.backView);
    }];

    [self.decLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(5);
        make.left.right.equalTo(self.backView);
        make.bottom.equalTo(self.backView).offset(-20);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.backView);
        make.height.equalTo(@1);
    }];
}

- (void)setNoDataTitleName:(NSString *)name {
    self.decLable.text = name;
}

#pragma mark - Setter


- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}


- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:kEmptyPlaceImgName];
    }
    return _imgView;
}

- (UILabel *)decLable {
    
    if (!_decLable) {
        _decLable = [[UILabel alloc] init];
        _decLable.textAlignment = NSTextAlignmentCenter;
        _decLable.text = @"暂无相关数据";
        _decLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
        _decLable.textColor = HEX_RGB(0x777777);
    }
    return _decLable;
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

@end






















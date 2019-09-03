//
//  XKOnlineOderDetailSelfTakeCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOnlineOderDetailSelfTakeCell.h"
#import "XKCommonStarView.h"

@interface XKOnlineOderDetailSelfTakeCell ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UILabel           *timeNameLable;
@property (nonatomic, strong) UILabel           *timeLable;
@property (nonatomic, strong) UIView            *lineView1;
@property (nonatomic, strong) UILabel           *addressNameLable;
@property (nonatomic, strong) UILabel           *addressLable;


@end

@implementation XKOnlineOderDetailSelfTakeCell

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
    
    [self.contentView addSubview:self.timeNameLable];
    [self.contentView addSubview:self.timeLable];
    [self.contentView addSubview:self.lineView1];
    [self.contentView addSubview:self.addressNameLable];
    [self.contentView addSubview:self.addressLable];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    

    [self.timeNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.height.equalTo(@14);
    }];
    
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.timeNameLable);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeNameLable.mas_bottom).offset(15);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    
    [self.addressNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView1.mas_bottom).offset(15);
        make.height.equalTo(@14);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.addressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.addressNameLable);
    }];

}


#pragma mark - Events


#pragma mark - Setter



- (UILabel *)timeNameLable {
    if (!_timeNameLable) {
        _timeNameLable = [[UILabel alloc] init];
        _timeNameLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _timeNameLable.textColor = HEX_RGB(0x222222);
        _timeNameLable.textAlignment = NSTextAlignmentLeft;
        _timeNameLable.text = @"取货时间";
        
    }
    return _timeNameLable;
}

- (UILabel *)timeLable {
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _timeLable.textColor = HEX_RGB(0x222222);
        _timeLable.textAlignment = NSTextAlignmentRight;
        _timeLable.text = @"12:00-1:00";
        
    }
    return _timeLable;
}
- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView1;
}


- (UILabel *)addressNameLable {
    if (!_addressNameLable) {
        _addressNameLable = [[UILabel alloc] init];
        _addressNameLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _addressNameLable.textColor = HEX_RGB(0x222222);
        _addressNameLable.textAlignment = NSTextAlignmentLeft;
        _addressNameLable.text = @"商家地址";
    }
    return _addressNameLable;
}


- (UILabel *)addressLable {
    if (!_addressLable) {
        _addressLable = [[UILabel alloc] init];
        _addressLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _addressLable.textColor = HEX_RGB(0x222222);
        _addressLable.textAlignment = NSTextAlignmentRight;
        _addressLable.text = @"成都市天幻街道12号";
    }
    return _addressLable;
}


@end









//
//  XKWelfareGoodsDetailCommentCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareGoodsDetailCommentCell.h"
@interface XKWelfareGoodsDetailCommentCell ()
@property (nonatomic, strong) UIImageView *headerImgView;
@property (nonatomic, strong) UILabel     *userNameLabel;
@property (nonatomic, strong) UILabel     *summaryLabel;
@property (nonatomic, strong) UIButton    *unfoldButton;
@property (nonatomic, strong) UIView      *imgsContentView;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UILabel     *addressLabel;
@property (nonatomic, strong) UIButton    *commentButton;
@property (nonatomic, strong) UIView      *lineView;
@end

@implementation XKWelfareGoodsDetailCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.headerImgView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.summaryLabel];
    [self.contentView addSubview:self.unfoldButton];
    [self.contentView addSubview:self.imgsContentView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.commentButton];
    [self.contentView addSubview:self.lineView];
}

- (void)addUIConstraint {
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_top);
        make.left.equalTo(self.headerImgView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        
    }];
    
    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_left);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(3);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.unfoldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.userNameLabel.mas_left);
        make.top.equalTo(self.summaryLabel.mas_bottom).offset(1);
        make.height.equalTo(@20);
        make.width.equalTo(@40);
    }];
    
    [self.imgsContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.unfoldButton.mas_bottom).offset(2);
        make.left.equalTo(self.userNameLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@((SCREEN_WIDTH - 20 - 90 - 2*5) / 3));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_left);
        make.top.equalTo(self.imgsContentView.mas_bottom).offset(5);
        make.width.equalTo(@100);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.timeLabel);
        make.height.equalTo(@20);
        make.width.equalTo(@30);
        
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.userNameLabel.mas_left);
        make.top.equalTo(self.timeLabel.mas_bottom);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

#pragma mark - Setter


- (UIImageView *)headerImgView {
    
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.layer.cornerRadius = 5;
        _headerImgView.backgroundColor = [UIColor yellowColor];
    }
    return _headerImgView;
}


- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont systemFontOfSize:15];
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.text = @"刘德华的天空";
    }
    return _userNameLabel;
}


- (UILabel *)summaryLabel {
    
    if (!_summaryLabel) {
        _summaryLabel = [[UILabel alloc] init];
        _summaryLabel.textAlignment = NSTextAlignmentLeft;
        _summaryLabel.numberOfLines = 0;
        _summaryLabel.text = @"石英表供商人处少发点福利卡，石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡石英表供商人处少发点福利卡";
        _summaryLabel.font = [UIFont systemFontOfSize:12];
        _summaryLabel.textColor = [UIColor grayColor];
    }
    return _summaryLabel;
}

- (UIButton *)unfoldButton {
    if (!_unfoldButton) {
        _unfoldButton = [[UIButton alloc] init];
        _unfoldButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _unfoldButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _unfoldButton.titleEdgeInsets= UIEdgeInsetsMake(0, -11, 0, 0);
        [_unfoldButton setTitle:@"展开" forState:UIControlStateNormal];
        [_unfoldButton setTitle:@"收起" forState:UIControlStateSelected];
        [_unfoldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_unfoldButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    }
    return _unfoldButton;
}


- (UIView *)imgsContentView {
    if (!_imgsContentView) {
        _imgsContentView = [[UIView alloc] init];
        _imgsContentView.backgroundColor = [UIColor greenColor];
        CGFloat imgMargin = 5;
        CGFloat width = (SCREEN_WIDTH - 20 - 90 - 2*imgMargin) / 3;
        for (int i = 0; i < 3; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.tag = i;
            imgView.backgroundColor = [UIColor redColor];
            imgView.frame = CGRectMake(i * (width + imgMargin), 0, width, width);
            [_imgsContentView addSubview:imgView];
        }
    }
    return _imgsContentView;
}


- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.text = @"2小时前";
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = [UIColor grayColor];
    }
    return _timeLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.text = @"成都时代中心";
        _addressLabel.font = [UIFont systemFontOfSize:11];
        _addressLabel.textColor = [UIColor grayColor];
    }
    return _addressLabel;
}


- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [[UIButton alloc] init];
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _commentButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView;
}


@end

//
//  XKSqureRewardTableViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/8/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureRewardTableViewCell.h"
//#import "XKAutoVerticalScrollBar.h"


@interface XKSqureRewardTableViewCell ()

@property (nonatomic, strong) UIImageView             *imgView;
@property (nonatomic, strong) UIImageView             *myRewardImgView;
@property (nonatomic, strong) UIButton                *myRewardBtn;
@property (nonatomic, strong) UIButton                *rewardBtn;
@property (nonatomic, strong) UIView                  *lineView;
@property (nonatomic, strong) UIButton                *infoBtn;
//@property (nonatomic, strong) XKAutoVerticalScrollBar *labelView;
@property (nonatomic, strong) UILabel                 *decDetailLable;
@property (nonatomic, strong) UILabel                 *decLable;


@end

@implementation XKSqureRewardTableViewCell

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
    
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 5;
//
    [self.contentView addSubview:self.imgView];
    [self.imgView addSubview:self.myRewardImgView];
    [self.myRewardImgView addSubview:self.myRewardBtn];
    [self.myRewardImgView addSubview:self.rewardBtn];
    [self.imgView addSubview:self.lineView];
    [self.imgView addSubview:self.decLable];
    [self.imgView addSubview:self.decDetailLable];
    [self.imgView addSubview:self.infoBtn];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.height.equalTo(@64).priorityHigh();
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.myRewardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgView).offset(5);
        make.centerY.equalTo(self.imgView).offset(2);
        make.height.equalTo(@50);
        make.width.equalTo(@110);
    }];
    
    [self.myRewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myRewardImgView).offset(5);
        make.centerY.equalTo(self.myRewardImgView).offset(-2);
    }];
    
    [self.rewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.myRewardImgView).offset(-10);
        make.centerY.equalTo(self.myRewardImgView).offset(-2);
        make.height.width.equalTo(@36);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myRewardImgView.mas_right).offset(8);
        make.centerY.equalTo(self.myRewardImgView);
        make.height.equalTo(@30);
        make.width.equalTo(@1);

    }];
    
    [self.decLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(8);
        make.right.equalTo(self.infoBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.imgView).offset(-8);
    }];
    
    [self.decDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(8);
        make.right.equalTo(self.infoBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.imgView).offset(10);
    }];
    
    
    [self.infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgView);
        make.right.equalTo(self.imgView).offset(-5);
        make.width.equalTo(@80);
        make.height.equalTo(@46);
    }];
    
}

#pragma mark - Setter


- (UIImageView *)imgView {
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
//        _imgView.backgroundColor = HEX_RGB(0xEE6161);
//        _imgView.layer.masksToBounds = YES;
//        _imgView.layer.cornerRadius = 32;
        _imgView.image = [UIImage imageNamed:@"xk_icon_home_rewardBack"];
    }
    return _imgView;
}


- (UIImageView *)myRewardImgView {
    
    if (!_myRewardImgView) {
        _myRewardImgView = [[UIImageView alloc] init];
//        _myRewardImgView.backgroundColor = [UIColor yellowColor];
//        _myRewardImgView.layer.masksToBounds = YES;
//        _myRewardImgView.layer.cornerRadius = 20;
        _myRewardImgView.image = [UIImage imageNamed:@"xk_btn_home_myReward"];

    }
    return _myRewardImgView;
}

- (UIButton *)myRewardBtn {
    
    if (!_myRewardBtn) {
        _myRewardBtn = [[UIButton alloc] init];
        [_myRewardBtn setTitle:@" 我的大奖" forState:UIControlStateNormal];
        [_myRewardBtn setTitleColor:HEX_RGB(0xEE6161) forState:UIControlStateNormal];
        _myRewardBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:13];
    }
    return _myRewardBtn;
}

- (UIButton *)rewardBtn {
    
    if (!_rewardBtn) {
        _rewardBtn = [[UIButton alloc] init];
        [_rewardBtn setBackgroundColor:[UIColor whiteColor]];
        _rewardBtn.titleLabel.numberOfLines = 0;

        _rewardBtn.layer.masksToBounds = YES;
        _rewardBtn.layer.cornerRadius = 18;
        NSString *str = @"立即\n夺奖";

        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentCenter;
        paraStyle.lineSpacing = -3; //设置行间距
        
        NSDictionary *dic = @{NSFontAttributeName:XKMediumFont(11), NSForegroundColorAttributeName:HEX_RGB(0xEE6161), NSParagraphStyleAttributeName:paraStyle};
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
        [_rewardBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    }
    return _rewardBtn;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (UILabel *)decLable {
    
    if (!_decLable) {
        _decLable = [[UILabel alloc] init];
        _decLable.text = @"恭喜眼bioyd抽中Iphone8";
        _decLable.textColor = [UIColor whiteColor];
        _decLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:13];
    }
    return _decLable;
}
- (UILabel *)decDetailLable {
    
    if (!_decDetailLable) {
        _decDetailLable = [[UILabel alloc] init];
        _decDetailLable.text = @"上官粗粗、都养卡卡、欧阳克拉拉、慕容公子";
        _decDetailLable.textColor = [UIColor whiteColor];
        _decDetailLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
    }
    return _decDetailLable;
}

//- (XKAutoVerticalScrollBar *)labelView {
//
//    if (!_labelView) {
//        _labelView = [[XKAutoVerticalScrollBar alloc] initWithFrame:CGRectMake(75, 10*ScreenScale, SCREEN_WIDTH - 100, 30*ScreenScale)];
//        _labelView.contents = @[@"恭喜您的好友-130*******0抽奖获得iphone7一台",
//                                @"恭喜您的好友-131*******1抽奖获得iphone8一台",
//                                @"恭喜您的好友-132*******2抽奖获得iphone9一台"];
//    }
//    return _labelView;
//}

- (UIButton *)infoBtn {
    
    if (!_infoBtn) {
        _infoBtn = [[UIButton alloc] init];
//        _infoBtn.backgroundColor = [UIColor whiteColor];
//        _infoBtn.layer.masksToBounds = YES;
//        _infoBtn.layer.cornerRadius = 20;
//        _infoBtn.backgroundColor = [UIColor yellowColor];
        _infoBtn.titleLabel.numberOfLines = 0;
        [_infoBtn setBackgroundImage:[UIImage imageNamed:@"xk_btn_home_reward"] forState:UIControlStateNormal];
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = -3; //设置行间距
        
        NSDictionary *dic = @{NSFontAttributeName:XKMediumFont(12), NSForegroundColorAttributeName:HEX_RGB(0xEE6161), NSParagraphStyleAttributeName:paraStyle};
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"恭喜XX\n抽中500元" attributes:dic];
        [_infoBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    }
    return _infoBtn;
}



@end




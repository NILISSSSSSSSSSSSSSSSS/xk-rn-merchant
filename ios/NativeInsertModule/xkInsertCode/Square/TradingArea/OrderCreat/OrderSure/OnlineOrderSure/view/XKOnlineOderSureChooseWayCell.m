//
//  XKOnlineOderSureChooseWayCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOnlineOderSureChooseWayCell.h"
#import "XKCommonStarView.h"

@interface XKOnlineOderSureChooseWayCell ()<UITextFieldDelegate, UITextViewDelegate>


@property (nonatomic, strong) UIView            *chooseWayView;
@property (nonatomic, strong) UIButton          *leftWayBtn;
@property (nonatomic, strong) UIButton          *rightWayBtn;

@property (nonatomic, strong) UIView            *addressView;

@property (nonatomic, strong) UIButton          *chooseAdrBtn;
@property (nonatomic, strong) UIButton          *adrIndexBtn;

@property (nonatomic, strong) UILabel           *addressLable;
@property (nonatomic, strong) UIView            *lineView1;
@property (nonatomic, strong) UILabel           *phoneLable;

@property (nonatomic, strong) UIView            *lineView2;
@property (nonatomic, strong) UILabel           *timeLable;
@property (nonatomic, strong) UIButton          *chooseTimeBtn;

@property (nonatomic, assign) NSInteger         wayType;

@end

@implementation XKOnlineOderSureChooseWayCell

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
    
    [self.contentView addSubview:self.chooseWayView];
    [self.chooseWayView addSubview:self.leftWayBtn];
    [self.chooseWayView addSubview:self.rightWayBtn];
    
    [self.contentView addSubview:self.addressView];
    [self.addressView addSubview:self.chooseAdrBtn];
    [self.addressView addSubview:self.adrIndexBtn];

    [self.addressView addSubview:self.addressLable];
    [self.addressView addSubview:self.lineView1];
    [self.addressView addSubview:self.phoneLable];
    [self.addressView addSubview:self.lineView2];

    [self.contentView addSubview:self.timeLable];
    [self.contentView addSubview:self.chooseTimeBtn];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    

    [self.chooseWayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@47);
    }];
    
    [self.leftWayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.chooseWayView);
        make.right.equalTo(self.rightWayBtn.mas_left);
        make.width.equalTo(self.rightWayBtn.mas_width);
    }];
    
    [self.rightWayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.chooseWayView);
    }];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chooseWayView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@44);
    }];
    
    [self.addressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressView).offset(-10);
        make.left.equalTo(self.addressView).offset(10);
        make.top.equalTo(self.addressView);
        make.bottom.equalTo(self.lineView1.mas_top);
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.addressView);
        make.top.equalTo(self.addressView).offset(0);
        make.height.equalTo(@1);
    }];
    
    [self.phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressView).offset(-10);
        make.left.equalTo(self.addressView).offset(10);
        make.top.equalTo(self.lineView1.mas_bottom);
        make.bottom.equalTo(self.lineView2.mas_top);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.addressView);
        make.bottom.equalTo(self.addressView);
        make.height.equalTo(@1);
    }];
    
    [self.chooseAdrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-50);
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.lineView1.mas_bottom);
        make.bottom.equalTo(self.lineView2.mas_top);
    }];
    
    [self.adrIndexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chooseWayView).offset(-8);
        make.centerY.equalTo(self.chooseAdrBtn);
        make.height.equalTo(@12);
        make.width.equalTo(@10);
    }];
    
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.addressView.mas_bottom).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@14);
        make.width.equalTo(@100);
    }];
    
    [self.chooseTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.timeLable);
    }];
    
}


#pragma mark - Events

- (void)leftWayBtnCliked:(UIButton *)sender {
    if (self.leftWayBtn.selected) {
        return;
    }
    self.leftWayBtn.selected = YES;
    self.rightWayBtn.selected = NO;

    self.wayType = 0;
    
    [self.addressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
    }];
    [self.lineView1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView).offset(0);
    }];
    
    self.chooseAdrBtn.hidden = NO;
    self.adrIndexBtn.hidden = NO;
    
    self.lineView1.hidden = YES;
    self.addressLable.hidden = YES;
    self.phoneLable.hidden = YES;
    
    if (self.wayChooseBlock) {
        self.wayChooseBlock(self.wayType, nil, nil, nil);
    }
}

- (void)rightWayBtnCliked:(UIButton *)sender {
    
    if (self.rightWayBtn.selected) {
        return;
    }
    self.leftWayBtn.selected = NO;
    self.rightWayBtn.selected = YES;
    
    
    self.wayType = 1;

    [self.addressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@88);
    }];
    [self.lineView1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView).offset(43);
    }];
    self.chooseAdrBtn.hidden = YES;
    self.adrIndexBtn.hidden = YES;
    
    self.lineView1.hidden = NO;
    self.addressLable.hidden = NO;
    self.phoneLable.hidden = NO;
    
    if (self.wayChooseBlock) {
        self.wayChooseBlock(self.wayType, nil, nil, nil);
    }
}



- (void)chooseAddressButtonClicked:(UIButton *)sender {
    if (self.chooseAddressBlock) {
        self.chooseAddressBlock();
    }
}

- (void)chooseTimeButtonClicked:(UIButton *)sender {
    if (self.chooseTimeBlock) {
        self.chooseTimeBlock();
    }
}


- (void)setValueWithSendAddr:(NSString *)sendAddr yuyueTime:(NSString *)yuyueTime shopAddr:(NSString *)shopAddr shopPhone:(NSString *)shopPhone {
    
    if (sendAddr.length) {
        [self.chooseAdrBtn setTitle:sendAddr forState:UIControlStateNormal];
    } else {
        [self.chooseAdrBtn setTitle:@"请添加送货地址" forState:UIControlStateNormal];
    }
    if (yuyueTime.length) {
        [self.chooseTimeBtn setTitle:yuyueTime forState:UIControlStateNormal];
    } else {
        [self.chooseTimeBtn setTitle:@"请选择" forState:UIControlStateNormal];
    }
    [self.chooseTimeBtn setImageAtRightAndTitleAtLeftWithSpace:5];
    
    if (shopAddr.length) {
        self.addressLable.text = shopAddr;
    } else {
        self.addressLable.text = @"暂无";
    }
    
    self.phoneLable.text = shopPhone;
}

#pragma mark - Setter

- (UIView *)chooseWayView {
    if (!_chooseWayView) {
        _chooseWayView = [[UIView alloc] init];
    }
    return _chooseWayView;
}

- (UIButton *)leftWayBtn {
    if (!_leftWayBtn) {
        _leftWayBtn = [[UIButton alloc] init];
        _leftWayBtn.selected = YES;
        [_leftWayBtn setTitle:@"送货上门" forState:UIControlStateNormal];
        [_leftWayBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
        [_leftWayBtn setBackgroundImage:[UIImage imageNamed:@"xk_btn_readingArea_takeout_tab_left"] forState:UIControlStateNormal];
        [_leftWayBtn setBackgroundImage:[UIImage imageNamed:@"xk_btn_Mine_Setting_nextWhite"] forState:UIControlStateSelected];
        _leftWayBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        [_leftWayBtn addTarget:self action:@selector(leftWayBtnCliked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftWayBtn;
}

- (UIButton *)rightWayBtn {
    if (!_rightWayBtn) {
        _rightWayBtn = [[UIButton alloc] init];
        _rightWayBtn.selected = NO;
        [_rightWayBtn setTitle:@"到店自取" forState:UIControlStateNormal];
        [_rightWayBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
        [_rightWayBtn setBackgroundImage:[UIImage imageNamed:@"xk_btn_readingArea_takeout_tab_right"] forState:UIControlStateNormal];
        [_rightWayBtn setBackgroundImage:[UIImage imageNamed:@"xk_btn_Mine_Setting_nextWhite"] forState:UIControlStateSelected];
        _rightWayBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
        [_rightWayBtn addTarget:self action:@selector(rightWayBtnCliked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _rightWayBtn;
}

- (UIView *)addressView {
    if (!_addressView) {
        _addressView = [[UIView alloc] init];
    }
    return _addressView;
}


- (UIButton *)chooseAdrBtn {
    if (!_chooseAdrBtn) {
        _chooseAdrBtn = [[UIButton alloc] init];
        [_chooseAdrBtn setImage:[UIImage imageNamed:@"xk_icon_store_address"] forState:UIControlStateNormal];
        [_chooseAdrBtn addTarget:self action:@selector(chooseAddressButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [_chooseAdrBtn setTitle:@"请添加送货地址" forState:UIControlStateNormal];
        [_chooseAdrBtn setTitleColor:HEX_RGB(0x777777) forState:UIControlStateNormal];
        [_chooseAdrBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_chooseAdrBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        _chooseAdrBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];

    }
    return _chooseAdrBtn;
}

- (UIButton *)adrIndexBtn {
    if (!_adrIndexBtn) {
        _adrIndexBtn = [[UIButton alloc] init];
        [_adrIndexBtn setImage:[UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"] forState:UIControlStateNormal];
        [_adrIndexBtn addTarget:self action:@selector(chooseAddressButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _adrIndexBtn;
}
- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = XKSeparatorLineColor;
        _lineView1.hidden = YES;
    }
    return _lineView1;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = XKSeparatorLineColor;
    }
    return _lineView2;
}



- (UILabel *)addressLable {
    if (!_addressLable) {
        _addressLable = [[UILabel alloc] init];
        _addressLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _addressLable.textColor = HEX_RGB(0x222222);
        _addressLable.textAlignment = NSTextAlignmentLeft;
//        _addressLable.text = @"商家地址：成都市天幻街道12号";
        _addressLable.hidden = YES;

    }
    return _addressLable;
}

- (UILabel *)phoneLable {
    if (!_phoneLable) {
        _phoneLable = [[UILabel alloc] init];
        _phoneLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _phoneLable.textColor = HEX_RGB(0x222222);
        _phoneLable.textAlignment = NSTextAlignmentLeft;
//        _phoneLable.text = @"联系电话：13688937234";
        _phoneLable.hidden = YES;
    }
    return _phoneLable;
}

- (UILabel *)timeLable {
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _timeLable.textColor = HEX_RGB(0x222222);
        _timeLable.textAlignment = NSTextAlignmentLeft;
        _timeLable.text = @"预约时间";
    }
    return _timeLable;
}

- (UIButton *)chooseTimeBtn {
    if (!_chooseTimeBtn) {
        _chooseTimeBtn = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 200, 40) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] title:@"请选择" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_chooseTimeBtn setImage:[UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"] forState:UIControlStateNormal];
        [_chooseTimeBtn setImageAtRightAndTitleAtLeftWithSpace:5];
        [_chooseTimeBtn addTarget:self action:@selector(chooseTimeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseTimeBtn;
}

@end









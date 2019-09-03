//
//  XKOnlineOderDetailVividCakeWayCell.m
//  XKSquare
//
//  Created by hupan on 2018/10/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKOnlineOderDetailVividCakeWayCell.h"
#import "XKCommonStarView.h"

@interface XKOnlineOderDetailVividCakeWayCell ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UILabel           *nameLable;
@property (nonatomic, strong) UIButton          *lookLogisticsBtn;

@end

@implementation XKOnlineOderDetailVividCakeWayCell

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
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.lookLogisticsBtn];
    
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    

    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@14);
    }];
    
    [self.lookLogisticsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.nameLable);
    }];
    
}


#pragma mark - Events

- (void)lookLogisticsButtonClicked:(UIButton *)sender {
    
    
    
}



#pragma mark - Setter


- (UILabel *)nameLable {
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] init];
        _nameLable.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _nameLable.textColor = HEX_RGB(0x222222);
        _nameLable.textAlignment = NSTextAlignmentLeft;
        NSString *str = @"配送方式 配送上门";
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x999999) range:NSMakeRange(5, 4)];
        _nameLable.attributedText = attStr;
        
    }
    return _nameLable;
}

- (UIButton *)lookLogisticsBtn {
    if (!_lookLogisticsBtn) {
        _lookLogisticsBtn = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 200, 40) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14] title:@"查看物流" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_lookLogisticsBtn setImage:[UIImage imageNamed:@"ic_btn_msg_circle_rightArrow"] forState:UIControlStateNormal];
        [_lookLogisticsBtn setImageAtRightAndTitleAtLeftWithSpace:5];
        [_lookLogisticsBtn addTarget:self action:@selector(lookLogisticsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookLogisticsBtn;
}

@end









//
//  XKMineRedEnvelopeRecordsTableViewCell.m
//  XKSquare
//
//  Created by RyanYuan on 2018/11/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineRedEnvelopeRecordsTableViewCell.h"

@interface XKMineRedEnvelopeRecordsTableViewCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *prizeLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *balanceLab;
@property (nonatomic, strong) UILabel *downLine;

@end

@implementation XKMineRedEnvelopeRecordsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initializeViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clipBottomRadius:(BOOL)isClip {
    
    if (isClip) {
        self.containerView.xk_radius = 8.0;
        self.containerView.xk_clipType = XKCornerClipTypeBottomBoth;
        self.containerView.xk_openClip = YES;
    } else {
        self.containerView.xk_radius = 0.0;
        self.containerView.xk_clipType = XKCornerClipTypeNone;
        self.containerView.xk_openClip = YES;
    }
}

- (void)initializeViews {
    
    self.containerView = [UIView new];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.containerView];
    
    self.prizeLab = [[UILabel alloc] init];
    self.prizeLab.text = @"奖品名字";
    self.prizeLab.font = XKRegularFont(14.0);
    self.prizeLab.textColor = HEX_RGB(0x222222);
    [self.containerView addSubview:self.prizeLab];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.text = @"时间";
    self.timeLab.font = XKRegularFont(12.0);
    self.timeLab.textColor = HEX_RGB(0x999999);
    [self.containerView addSubview:self.timeLab];
    
    self.balanceLab = [[UILabel alloc] init];
    self.balanceLab.text = @"+100";
    self.balanceLab.font = XKRegularFont(20.0);
    self.balanceLab.textColor = HEX_RGB(0xEE6161);
    self.balanceLab.textAlignment = NSTextAlignmentRight;
    [self.containerView addSubview:self.balanceLab];
    
    self.downLine = [[UILabel alloc] init];
    self.downLine.backgroundColor = XKSeparatorLineColor;
    [self.containerView addSubview:self.downLine];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
    
    [self.prizeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14.0);
        make.bottom.mas_equalTo(self.containerView.mas_centerY).offset(-5.0);
        make.right.mas_equalTo(self.balanceLab.mas_left).offset(-10.0);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14.0);
        make.top.mas_equalTo(self.containerView.mas_centerY).offset(5.0);
        make.right.mas_equalTo(self.balanceLab.mas_left).offset(-10.0);
    }];
    
    [self.balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.containerView);
        make.trailing.mas_equalTo(-14.0);
        make.width.mas_equalTo(80.0);
    }];
    
    [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(self.containerView);
        make.height.mas_equalTo(1.0);
    }];
}

- (void)setDownLineHidden:(BOOL)isHidden {
    self.downLine.hidden = isHidden;
}

@end

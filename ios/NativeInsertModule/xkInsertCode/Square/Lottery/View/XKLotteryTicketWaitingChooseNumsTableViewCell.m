//
//  XKLotteryTicketWaitingChooseNumsTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketWaitingChooseNumsTableViewCell.h"

@interface XKLotteryTicketWaitingChooseNumsTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *numLab;

@property (nonatomic, strong) UILabel *subTitleLab;

@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation XKLotteryTicketWaitingChooseNumsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = HEX_RGB(0xFFFFFF);
    [self.contentView addSubview:self.containerView];
    
    self.iconImgView = [[UIImageView alloc] init];
    self.iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.containerView addSubview:self.iconImgView];
    self.iconImgView.layer.borderWidth = 1.0;
    self.iconImgView.layer.cornerRadius = 10.0;
    self.iconImgView.layer.borderColor = HEX_RGB(0xe7e7e7).CGColor;
    self.iconImgView.layer.masksToBounds = YES;
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.text = @"标题";
    self.titleLab.font = XKRegularFont(14.0);
    self.titleLab.textColor = HEX_RGB(0x222222);
    [self.containerView addSubview:self.titleLab];
    
    self.numLab = [[UILabel alloc] init];
    self.numLab.text = @"数量";
    self.numLab.font = XKRegularFont(14.0);
    self.numLab.textColor = HEX_RGB(0x222222);
    [self.containerView addSubview:self.numLab];
    
    self.subTitleLab = [[UILabel alloc] init];
    self.subTitleLab.text = @"子标题";
    self.subTitleLab.font = XKRegularFont(12.0);
    self.subTitleLab.textColor = HEX_RGB(0x555555);
    [self.containerView addSubview:self.subTitleLab];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.titleLabel.font = XKRegularFont(12.0);
    [self.confirmBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0xFFFFFF)] forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:HEX_RGB(0xFFFFFF) forState:UIControlStateDisabled];
    [self.confirmBtn setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0xCCCCCC)] forState:UIControlStateDisabled];
    [self.containerView addSubview:self.confirmBtn];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)).priorityHigh();
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(14.0);
        make.centerY.mas_equalTo(self.containerView);
        make.width.height.mas_equalTo(80.0);
    }];
    
    [self.titleLab setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImgView);
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(15.0);
        make.right.mas_equalTo(self.numLab.mas_left).offset(-10.0);
    }];
    
    [self.numLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab);
        make.trailing.mas_equalTo(-14.0);
    }];
    
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(15.0);
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(15.0);
        make.trailing.mas_equalTo(-14.0);
    }];

    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-14.0);
        make.bottom.mas_equalTo(-15.0);
        make.width.mas_equalTo(70.0);
        make.height.mas_equalTo(20.0);
    }];
}

#pragma mark -

- (void)confirmBtnAction:(UIButton *)sender {
    if (self.confirmBtnBlock) {
        self.confirmBtnBlock();
    }
}

@end

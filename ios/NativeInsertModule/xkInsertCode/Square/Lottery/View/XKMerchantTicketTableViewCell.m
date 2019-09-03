//
//  XKMerchantTicketTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/11/5.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMerchantTicketTableViewCell.h"
#import "XKLotteryTicketModel.h"

@interface XKMerchantTicketTableViewCell ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *leftImgView;

@property (nonatomic, strong) UIView *moreView;

@property (nonatomic, strong) UILabel *moreLab;

@property (nonatomic, strong) UIImageView *moreImgView;

@property (nonatomic, strong) UIImageView *rightImgView;

@property (nonatomic, strong) UILabel *orderIdLab;

@property (nonatomic, strong) UILabel *ticketNameLab;

@property (nonatomic, strong) UILabel *remarkLab;

@property (nonatomic, strong) UILabel *timeLab;


@property (nonatomic, strong) XKLotteryTicketModel *lotteryTicket;

@end

@implementation XKMerchantTicketTableViewCell

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
    [self.contentView addSubview:self.containerView];
    
    self.leftImgView = [[UIImageView alloc] init];
    self.leftImgView.image = IMG_NAME(@"xk_img_merchantTicker_left");
    [self.containerView addSubview:self.leftImgView];
    
    self.moreView = [[UIView alloc] init];
    [self.leftImgView addSubview:self.moreView];
    
    self.moreLab = [[UILabel alloc] init];
    self.moreLab.text = @"查看\n详情";
    self.moreLab.numberOfLines = 0;
    self.moreLab.font = XKRegularFont(12.0);
    self.moreLab.textColor = HEX_RGB(0xffffff);
    [self.leftImgView addSubview:self.moreLab];
    
    self.moreImgView = [[UIImageView alloc] init];
    self.moreImgView.image = IMG_NAME(@"xk_img_merchantTicker_more");
    [self.leftImgView addSubview:self.moreImgView];
    
    self.rightImgView = [[UIImageView alloc] init];
    self.rightImgView.image = IMG_NAME(@"xk_img_merchantTicker_right");
    [self.containerView addSubview:self.rightImgView];
    
    self.orderIdLab = [[UILabel alloc] init];
    self.orderIdLab.text = @"订单编号";
    self.orderIdLab.font = XKRegularFont(10.0);
    self.orderIdLab.textColor = HEX_RGB(0x999999);
    [self.rightImgView addSubview:self.orderIdLab];
    
    self.ticketNameLab = [[UILabel alloc] init];
    self.ticketNameLab.text = @"券标题";
    self.ticketNameLab.font = XKMediumFont(14.0);
    self.ticketNameLab.textColor = HEX_RGB(0xCEA462);
    [self.rightImgView addSubview:self.ticketNameLab];
    
    self.remarkLab = [[UILabel alloc] init];
    self.remarkLab.text = @"备注信息";
    self.remarkLab.font = XKRegularFont(10.0);
    self.remarkLab.textColor = HEX_RGB(0xCBA15E);
    [self.rightImgView addSubview:self.remarkLab];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.text = @"有效时间";
    self.timeLab.font = XKRegularFont(10.0);
    self.timeLab.textColor = HEX_RGB(0x555555);
    [self.rightImgView addSubview:self.timeLab];
}

- (void)updateViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(7.5, 10.0, 7.5, 10.0));
    }];
    
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self.containerView);
        make.width.mas_equalTo(self.leftImgView.mas_height).multipliedBy(85.0 / 100.0);
    }];
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.leftImgView);
    }];
    
    [self.moreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self.moreView);
    }];
    
    [self.moreImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.moreView);
        make.left.mas_equalTo(self.moreLab.mas_right).offset(5.0);
        make.trailing.mas_equalTo(self.moreView);
    }];
    
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.mas_equalTo(self.containerView);
        make.left.mas_equalTo(self.leftImgView.mas_right);
    }];
    
    [self.orderIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0);
        make.leading.mas_equalTo(15.0);
        make.trailing.mas_equalTo(-15.0);
    }];
    
    [self.ticketNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.orderIdLab);
        make.bottom.mas_equalTo(self.rightImgView.mas_centerY);
    }];
    
    [self.remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rightImgView.mas_centerY);
        make.leading.trailing.mas_equalTo(self.ticketNameLab);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-13.0);
        make.leading.trailing.mas_equalTo(self.orderIdLab);
    }];
}

- (void)configCellWithLotteryTicketModel:(XKLotteryTicketModel *)lotteryTicket {
    self.lotteryTicket = lotteryTicket;
}

@end

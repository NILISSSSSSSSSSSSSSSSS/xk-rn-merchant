//
//  XKLotteryTicketAnnouncementInfoTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketAnnouncementInfoTableViewCell.h"

@interface XKLotteryTicketAnnouncementInfoTableViewCell ()

@end

@implementation XKLotteryTicketAnnouncementInfoTableViewCell

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
    
    self.infoLab = [[UILabel alloc] init];
    self.infoLab.text = @"标题：";
    self.infoLab.font = XKRegularFont(14.0);
    self.infoLab.textColor = HEX_RGB(0x999999);
    [self.containerView addSubview:self.infoLab];
    
    self.infoContentLab = [[UILabel alloc] init];
    self.infoContentLab.text = @"内容";
    self.infoContentLab.font = XKRegularFont(14.0);
    self.infoContentLab.textColor = HEX_RGB(0x555555);
    [self.containerView addSubview:self.infoContentLab];
}

- (void)updateViews {
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)).priorityHigh();
    }];
    
    [self.infoLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.containerView);
        make.leading.mas_equalTo(10.0);
    }];
    
    [self.infoContentLab setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.infoContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.containerView);
        make.left.mas_equalTo(self.infoLab.mas_right).offset(5.0);
        make.trailing.mas_equalTo(-10.0);
    }];
}

@end

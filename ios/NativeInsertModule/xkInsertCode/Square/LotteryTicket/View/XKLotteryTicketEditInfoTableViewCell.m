//
//  XKLotteryTicketEditInfoTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/11.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketEditInfoTableViewCell.h"

@interface XKLotteryTicketEditInfoTableViewCell ()

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *line;

@end

@implementation XKLotteryTicketEditInfoTableViewCell

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
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = HEX_RGB(0xFFFFFF);
        [self.contentView addSubview:self.containerView];
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.text = @"四字长度";
        self.titleLab.font = XKRegularFont(14.0);
        self.titleLab.textColor = HEX_RGB(0x222222);
        [self.containerView addSubview:self.titleLab];
        
        self.contentTF = [[UITextField alloc] init];
        self.contentTF.font = XKRegularFont(14.0);
        self.contentTF.textColor = HEX_RGB(0x222222);
        self.contentTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.containerView addSubview:self.contentTF];
        
        self.line = [[UILabel alloc] init];
        self.line.backgroundColor = XKSeparatorLineColor;
        [self.containerView addSubview:self.line];
        
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.containerView);
            make.leading.mas_equalTo(15.0);
            make.width.mas_equalTo([self.titleLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 25.0 * 2, 0.0) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLab.font} context:nil].size.width + 1.0);
        }];
        
        [self.contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLab.mas_right).offset(10.0);
            make.top.bottom.mas_equalTo(self.containerView);
            make.trailing.mas_equalTo(-15.0);
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.mas_equalTo(self.containerView);
            make.height.mas_equalTo(1.0);
        }];
    }
    return self;
}

#pragma mark - getter setter

- (void)configCellWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    self.titleLab.text = title;
    self.contentTF.attributedPlaceholder = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        confer.text(placeholder).font(XKRegularFont(14.0)).textColor(HEX_RGB(0x999999));
    }];
}

- (void)setCellLineHidden:(BOOL)hidden {
    self.line.hidden = hidden;
}

@end

//
//  XKLotteryTicketNumbersTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/10.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketNumbersTableViewCell.h"
#import "XKLotteryTicketBallVIew.h"

@interface XKLotteryTicketNumbersTableViewCell ()

@property (nonatomic, strong) UILabel *lotteryTicketLab;

@property (nonatomic, strong) UIImageView *lotteryTicketImgView;

@property (nonatomic, strong) UIView *ballsView;

@property (nonatomic, strong) NSMutableArray <XKLotteryTicketBallVIew *>*balls;

@end

@implementation XKLotteryTicketNumbersTableViewCell

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
        self.cellType = XKLotteryTicketNumbersCellTypeImg;
    }
    return self;
}

- (void)initializeViews {
    
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.containerView];
    
    self.lotteryTicketLab = [[UILabel alloc] init];
    self.lotteryTicketLab.text = @"投注号码:";
    self.lotteryTicketLab.font  =XKRegularFont(14.0);
    self.lotteryTicketLab.textColor = HEX_RGB(0x999999);
    [self.containerView addSubview:self.lotteryTicketLab];

    self.lotteryTicketImgView = [[UIImageView alloc] init];
    self.lotteryTicketImgView.image = IMG_NAME(@"xk_img_lotteryTicket_aaLotteryTicket");
    [self.containerView addSubview:self.lotteryTicketImgView];

    self.ballsView = [[UIView alloc] init];
    [self.containerView addSubview:self.ballsView];

    for (int i = 0; i < 7; i++) {
        XKLotteryTicketBallVIew *ball = [[XKLotteryTicketBallVIew alloc] init];
        ball.ballFont = XKRegularFont(15.0);
        ball.ballColor = i < 5 ? XKMainRedColor : XKMainTypeColor;
        ball.ballSelected = YES;
        [self.ballsView addSubview:ball];
        [self.balls addObject:ball];
    }
}

- (void)updateViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
    
    [self.lotteryTicketLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.lotteryTicketLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.containerView);
        make.leading.mas_equalTo(10.0);
    }];
    
    [self.lotteryTicketImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10.0);
        make.centerY.mas_equalTo(self.containerView);
        make.width.height.mas_equalTo(40.0);
    }];

    [self.ballsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.containerView);
        make.left.mas_equalTo(self.lotteryTicketLab.mas_right).offset(10.0);
        make.trailing.mas_equalTo(-10.0);
    }];

    [self.balls mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:8.0 * ScreenScale leadSpacing:0.0 tailSpacing:0.0];

    [self.balls mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.ballsView);
        make.height.mas_equalTo(self.balls.firstObject.mas_width);
    }];
}

- (void)configBallsViewWithNums:(NSArray<NSNumber *> *)nums {
    if (nums.count != self.balls.count) {
        return;
    }
    for (int i = 0; i < self.balls.count; i++) {
        XKLotteryTicketBallVIew *ball = self.balls[i];
        ball.title = [NSString stringWithFormat:@"%tu", [nums[i] unsignedIntegerValue]];
    }
}

#pragma mark - getter setter

- (NSMutableArray *)balls {
    if (!_balls) {
        _balls = [NSMutableArray array];
    }
    return _balls;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.lotteryTicketLab.text = _title;
}

- (void)setCellType:(XKLotteryTicketNumbersCellType)cellType {
    _cellType = cellType;
    if (_cellType == XKLotteryTicketNumbersCellTypeText) {
        self.lotteryTicketLab.hidden = NO;
        self.lotteryTicketImgView.hidden = YES;
        [self.ballsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.containerView);
            make.left.mas_equalTo(self.lotteryTicketLab.mas_right).offset(10.0);
            make.trailing.mas_equalTo(-10.0);
        }];
    } else if (_cellType == XKLotteryTicketNumbersCellTypeImg) {
        self.lotteryTicketLab.hidden = YES;
        self.lotteryTicketImgView.hidden = NO;
        [self.ballsView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.containerView);
            make.leading.mas_equalTo(65.0);
            make.trailing.mas_equalTo(-10.0);
        }];
    }
}

@end

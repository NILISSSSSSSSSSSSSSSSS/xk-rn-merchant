//
//  XKLatestSecretTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/25.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLatestSecretTableViewCell.h"
#import "XKLatestSecretModel.h"

@interface XKLatestSecretTableViewCell()

@property (nonatomic, strong) UIImageView *prizeImgView;

@property (nonatomic, strong) UILabel *statusLab;

@property (nonatomic, strong) UILabel *prizeTitleLab;

@property (nonatomic, strong) UILabel *countdownLab;


@property (nonatomic, strong) XKLatestSecretModel *latestSecret;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation XKLatestSecretTableViewCell

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
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    [self.contentView addSubview:self.prizeImgView];
    [self.contentView addSubview:self.statusLab];
    [self.contentView addSubview:self.prizeTitleLab];
    [self.contentView addSubview:self.countdownLab];
}

- (void)updateViews {
    [self.prizeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.0);
        make.leading.mas_equalTo(24.0);
        make.bottom.mas_equalTo(-15.0);
        make.width.mas_equalTo(self.prizeImgView.mas_height);
    }];
    
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.prizeImgView);
        make.width.mas_equalTo(45.0);
        make.height.mas_equalTo(18.0);
    }];
    
    [self.prizeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.prizeImgView);
        make.left.mas_equalTo(self.prizeImgView.mas_right).offset(15.0);
        make.trailing.mas_equalTo(-24.0);
    }];
    
    [self.countdownLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.prizeTitleLab.mas_bottom).offset(15.0);
        make.leading.trailing.mas_equalTo(self.prizeTitleLab);
    }];
}

#pragma mark - public method

- (void)configCellWithLatestSecretModel:(XKLatestSecretModel *)latestSecret {
    self.latestSecret = latestSecret;
    BOOL isOpened = arc4random() % 2;
    self.statusLab.text = isOpened ? @"已开奖" : @"开奖中";
    self.statusLab.backgroundColor = isOpened ? HEX_RGB(0x0DCDCE) : HEX_RGB(0xF5A623);
    [self removeTimer];
    [self timerAction:nil];
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
}

- (void)removeTimer {
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - privite method

- (void)timerAction:(NSTimer *) sender {
    NSUInteger leftTimeStamp = self.latestSecret.openTimeStamp - (NSUInteger)[[NSDate date] timeIntervalSince1970];
    NSUInteger days = leftTimeStamp / 60 / 60 / 24;
    NSUInteger hours = leftTimeStamp / 60 / 60 % 24;
    NSUInteger minutes = leftTimeStamp / 60 % 60;
    NSUInteger seconds = leftTimeStamp % 60;
    NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"开奖倒计时：%02tu:%02tu:%02tu:%02tu", days, hours, minutes, seconds]];
    [timeStr addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, timeStr.length)];
    [timeStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x555555) range:NSMakeRange(0, 6)];
    [timeStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xEE6161) range:NSMakeRange(6, timeStr.length - 6)];
    self.countdownLab.attributedText = timeStr;
}

#pragma mark - getter setter

- (UIImageView *)prizeImgView {
    if (!_prizeImgView) {
        _prizeImgView = [[UIImageView alloc] init];
        _prizeImgView.layer.borderWidth = 1.0;
        _prizeImgView.layer.cornerRadius = 10.0;
        _prizeImgView.layer.borderColor = HEX_RGB(0xe7e7e7).CGColor;
    }
    return _prizeImgView;
}

- (UILabel *)statusLab {
    if (!_statusLab) {
        _statusLab = [[UILabel alloc] init];
        _statusLab.text = @"状态";
        _statusLab.font = XKRegularFont(9.0);
        _statusLab.textColor = [UIColor whiteColor];
        _statusLab.textAlignment = NSTextAlignmentCenter;
        [_statusLab cutCornerWithRoundedRect:CGRectMake(0.0, 0.0, 45.0, 18.0) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0, 8.0)];
    }
    return _statusLab;
}

- (UILabel *)prizeTitleLab {
    if (!_prizeTitleLab) {
        _prizeTitleLab = [[UILabel alloc] init];
        _prizeTitleLab.text = @"标题";
        _prizeTitleLab.font = XKRegularFont(14.0);
        _prizeTitleLab.numberOfLines = 2;
    }
    return _prizeTitleLab;
}

- (UILabel *)countdownLab {
    if (!_countdownLab) {
        _countdownLab = [[UILabel alloc] init];
        _countdownLab.text = @"开奖倒计时";
    }
    return _countdownLab;
}

@end

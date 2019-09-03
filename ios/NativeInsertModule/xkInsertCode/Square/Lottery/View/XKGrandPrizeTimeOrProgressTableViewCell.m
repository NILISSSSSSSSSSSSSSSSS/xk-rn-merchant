//
//  XKGrandPrizeTimeOrProgressTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/31.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGrandPrizeTimeOrProgressTableViewCell.h"

@interface XKGrandPrizeTimeOrProgressTableViewCell ()

@property (nonatomic, strong) UIImageView *prizeImgView;

@property (nonatomic, strong) UILabel *prizeTitleLab;

@property (nonatomic, strong) UIView *progressView;

@property (nonatomic, strong) UILabel *progressLab;

@property (nonatomic, strong) UIProgressView *progressBar;

@property (nonatomic, strong) UILabel *progressValueLab;

@property (nonatomic, strong) UIView *timeView;

@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, strong) UIButton *detailBtn;


@property (nonatomic, strong) XKGrandPrizeModel *grandPrize;

@property (nonatomic, copy) void(^detailBtnBlock)(void);

@end

@implementation XKGrandPrizeTimeOrProgressTableViewCell

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
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.prizeImgView];
    [self.containerView addSubview:self.prizeTitleLab];
    [self.containerView addSubview:self.progressView];
    [self.progressView addSubview:self.progressLab];
    [self.progressView addSubview:self.progressBar];
    [self.progressView addSubview:self.progressValueLab];
    [self.containerView addSubview:self.timeView];
    [self.timeView addSubview:self.timeLab];
    [self.containerView addSubview:self.detailBtn];
    
}

- (void)updateViews {
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
    
    [self.prizeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.0);
        make.leading.mas_equalTo(14.0);
        make.width.height.mas_equalTo(80.0);
    }];
    
    [self.prizeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.0);
        make.left.mas_equalTo(self.prizeImgView.mas_right).offset(15.0);
        make.trailing.mas_equalTo(-14.0);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.prizeTitleLab.mas_bottom).offset(5.0);
        make.leading.trailing.mas_equalTo(self.prizeTitleLab);
        make.height.mas_equalTo(28.0);
    }];
    
    [self.progressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.progressView);
        make.leading.mas_equalTo(10.0);
    }];
    
    [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.progressLab.mas_right).offset(5.0);
        make.trailing.mas_equalTo(-10.0);
        make.centerY.mas_equalTo(self.progressLab);
        make.height.mas_equalTo(2.0);
    }];
    
    [self.progressValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.progressBar);
        make.leading.mas_equalTo(self.progressBar);
    }];
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(2.0);
        make.leading.trailing.mas_equalTo(self.prizeTitleLab);
        make.height.mas_equalTo(28.0);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0));
    }];
    
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeView.mas_bottom).offset(8.0);
        make.trailing.mas_equalTo(self.prizeTitleLab);
        make.width.mas_equalTo(70.0);
        make.height.mas_equalTo(20.0);
        make.bottom.mas_equalTo(-15.0).priorityMedium();
    }];
}

#pragma mark - public method

- (void)configCellWithGrandPrizeModel:(XKGrandPrizeModel *) grandPrize detailBtnBlock:(void(^ _Nullable )(void)) detailBtnBlock {
    _grandPrize = grandPrize;
    _detailBtnBlock = detailBtnBlock;
    
    [self.contentView layoutIfNeeded];
    CGFloat progressBarWidth = CGRectGetWidth(self.progressBar.frame);
    CGSize progreeeValueLabSize = [self.progressValueLab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 0.0) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.progressValueLab.font} context:nil].size;
    [self.progressValueLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.progressBar);
        if (self.progressBar.progress <= 1 - ((progreeeValueLabSize.width + 1.0) / progressBarWidth)) {
            make.leading.mas_equalTo(self.progressBar).offset(self.progressBar.progress * progressBarWidth);
        } else {
            make.trailing.mas_equalTo(self.progressBar);
        }
        make.size.mas_equalTo(CGSizeMake(progreeeValueLabSize.width + 1.0, progreeeValueLabSize.height));
    }];
}

#pragma mark - privite method

- (void)detailBtnAction {
    if (self.detailBtnBlock) {
        self.detailBtnBlock();
    }
}

#pragma mark - getter setter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIImageView *)prizeImgView {
    if (!_prizeImgView) {
        _prizeImgView = [[UIImageView alloc] init];
        _prizeImgView.layer.borderWidth = 1.0;
        _prizeImgView.layer.cornerRadius = 10.0;
        _prizeImgView.layer.borderColor = HEX_RGB(0xe7e7e7).CGColor;
    }
    return _prizeImgView;
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

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.layer.cornerRadius = 4.0;
        _progressView.layer.masksToBounds = YES;
        _progressView.backgroundColor = HEX_RGB(0xF0F6FF);
    }
    return _progressView;
}

- (UILabel *)progressLab {
    if (!_progressLab) {
        _progressLab = [[UILabel alloc] init];
        _progressLab.text = @"开奖进度：";
        _progressLab.font = XKRegularFont(12.0);
        _progressLab.textColor = HEX_RGB(0x555555);
    }
    return _progressLab;
}

- (UIProgressView *)progressBar {
    if (!_progressBar) {
        _progressBar = [[UIProgressView alloc] init];
        _progressBar.tintColor = XKMainTypeColor;
    }
    return _progressBar;
}

- (UILabel *)progressValueLab {
    if (!_progressValueLab) {
        _progressValueLab = [[UILabel alloc] init];
        _progressValueLab.text = @" 100/100 ";
        _progressValueLab.font = XKRegularFont(12.0);
        _progressValueLab.textColor = HEX_RGB(0x222222);
        _progressValueLab.layer.cornerRadius = 2.0;
        _progressValueLab.layer.shadowRadius = 2.0;
        _progressValueLab.layer.shadowColor = HEX_RGBA(0x000000, 0.17).CGColor;
        _progressValueLab.layer.shadowOffset = CGSizeMake(0.0, 0.5);
        _progressValueLab.layer.shadowOpacity = 1.0;
        _progressValueLab.layer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return _progressValueLab;
}

- (UIView *)timeView {
    if (!_timeView) {
        _timeView = [[UIView alloc] init];
        _timeView.layer.cornerRadius = 4.0;
        _timeView.layer.masksToBounds = YES;
        _timeView.backgroundColor = HEX_RGB(0xFFF4E1);
    }
    return _timeView;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
    }
    return _timeLab;
}

- (UIButton *)detailBtn {
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailBtn.titleLabel.font = XKRegularFont(12.0);
        [_detailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [_detailBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
        [_detailBtn addTarget:self action:@selector(detailBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _detailBtn.layer.cornerRadius = 10.0;
        _detailBtn.layer.masksToBounds = YES;
        _detailBtn.layer.borderWidth = 1.0;
        _detailBtn.layer.borderColor = XKMainTypeColor.CGColor;
    }
    return _detailBtn;
}

@end

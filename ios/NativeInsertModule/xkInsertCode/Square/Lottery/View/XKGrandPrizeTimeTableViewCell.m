//
//  XKGrandPrizeTimeTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/31.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGrandPrizeTimeTableViewCell.h"
#import "XKGrandPrizeModel.h"

@interface XKGrandPrizeTimeTableViewCell()

@property (nonatomic, strong) UIImageView *prizeImgView;

@property (nonatomic, strong) UILabel *prizeTitleLab;

@property (nonatomic, strong) UIView *timeView;

@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, strong) UIButton *detailBtn;


@property (nonatomic, strong) XKGrandPrizeModel *grandPrize;

@property (nonatomic, copy) void(^detailBtnBlock)(void);

@end

@implementation XKGrandPrizeTimeTableViewCell

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
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.prizeTitleLab.mas_bottom).offset(5.0);
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
        _prizeImgView.contentMode = UIViewContentModeScaleAspectFill;
        _prizeImgView.layer.borderWidth = 1.0;
        _prizeImgView.layer.cornerRadius = 10.0;
        _prizeImgView.layer.borderColor = HEX_RGB(0xe7e7e7).CGColor;
        _prizeImgView.layer.masksToBounds = YES;
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

- (UIView *)timeView {
    if (!_timeView) {
        _timeView = [[UIView alloc] init];
        _timeView.layer.cornerRadius = 4.0;
        _timeView.layer.masksToBounds = YES;
        _timeView.backgroundColor = HEX_RGB(0xF0F6FF);
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

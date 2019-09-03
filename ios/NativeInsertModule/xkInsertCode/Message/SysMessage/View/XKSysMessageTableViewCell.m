//
//  XKSysMessageTableViewCell.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSysMessageTableViewCell.h"
#import "XKIMGlobalMethod.h"

@interface XKSysMessageTableViewCell()
@property (nonatomic, strong)UIButton    *choseBtn;
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel     *nameLabel;
@property (nonatomic, strong)UILabel     *contentLabel;
@property (nonatomic, strong)UILabel     *timeLabel;
@property (nonatomic, strong)UIView      *line;
@property (nonatomic, strong)UIView      *redPoint;

/**约束*/
@property(nonatomic, strong) MASConstraint *nameLabelConstraint;

@end

@implementation XKSysMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatUI];
        [self layout];
    }
    return self;
}

- (void)creatUI {
    self.choseBtn.hidden = YES;
    self.contentView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self.contentView addSubview:self.myContentView];
    [self.myContentView addSubview:self.choseBtn];
    [self.myContentView addSubview:self.iconImgView];
    [self.myContentView addSubview:self.nameLabel];
    [self.myContentView addSubview:self.contentLabel];
    [self.myContentView addSubview:self.timeLabel];
    [self.myContentView addSubview:self.line];
    [self.iconImgView addSubview:self.redPoint];

}

- (void)setModel:(XKSysMessageModel *)model {
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:kDefaultHeadImgName]];
    NIMRecentSession *recentSession = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:[NIMSession session:model.accid type:NIMSessionTypeP2P]];
    NIMMessage *message = recentSession.lastMessage;
    _nameLabel.text = model.nickname;
    if (message) {
        NSString *jsonString = [NSString stringWithFormat:@"%@",message.messageObject];
        NSDictionary *dict =  [jsonString xk_jsonToDic];
        _contentLabel.text = dict[@"data"][@"msgContent"];
        [self.nameLabelConstraint deactivate];
    }else {
        [self.nameLabelConstraint activate];
    }
    _timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimestampString:model.createdAt];
    if (recentSession.unreadCount > 0) {
        _redPoint.hidden = NO;
    }else{
        _redPoint.hidden = YES;
    }
}

- (void)updateLayout {
    self.choseBtn.hidden = NO;
    [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myContentView.mas_left).offset(40);
    }];
}

- (void)restoreLayout {
    self.choseBtn.hidden = YES;
    [self.iconImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myContentView.mas_left).offset(15);
    }];
}

- (void)layout {
    [self.myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.myContentView);
        make.width.mas_equalTo(40);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myContentView.mas_left).offset(15);
        make.top.equalTo(self.myContentView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.iconImgView.mas_top).priority(400);
        make.right.equalTo(self.myContentView.mas_right).offset(-60);
        make.height.mas_equalTo(20);
        self.nameLabelConstraint = make.centerY.equalTo(self.myContentView);
    }];
    [self.nameLabelConstraint deactivate];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.myContentView.mas_right).offset(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(15);
    }];
    
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.myContentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(-15);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.iconImgView);
        make.height.width.mas_equalTo(10);
    }];
}

#pragma mark 懒加载

- (UIView *)myContentView {
    if (!_myContentView) {
        _myContentView = [UIView new];
        _myContentView.backgroundColor = [UIColor whiteColor];
    }
    return _myContentView;
}
- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_choseBtn addTarget:self action:@selector(choseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
    }
    return _choseBtn;
}
- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.image = [UIImage imageNamed:@""];
        _iconImgView.clipsToBounds = NO;
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17]];
        _nameLabel.textColor = UIColorFromRGB(0x424242);
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if(!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12]];
        _contentLabel.textColor = UIColorFromRGB(0x999999);
        _contentLabel.numberOfLines = 1;
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:11]];
        _timeLabel.textColor = UIColorFromRGB(0x999999);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.numberOfLines = 1;
    }
    return _timeLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = XKSeparatorLineColor;
    }
    return _line;
}

- (UIView *)redPoint {
    if (!_redPoint) {
        _redPoint = [[UIView alloc]init];
        _redPoint.backgroundColor = XKMainRedColor;
        _redPoint.xk_openClip = YES;
        _redPoint.xk_radius = 5;
        _redPoint.xk_clipType = XKCornerClipTypeAllCorners;
        _redPoint.hidden = YES;
    }
    return _redPoint;
}

- (void)choseAction:(UIButton *)sender {
//    self.model.isSelected = !self.model.isSelected;
//    if (self.block) {
//        self.block();
//    }
}
@end

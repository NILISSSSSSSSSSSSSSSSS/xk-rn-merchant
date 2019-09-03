/*******************************************************************************
 # File        : XKFriendTalkRecordCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/5
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendTalkRecordCell.h"

@interface XKFriendTalkRecordCell ()
@property (nonatomic,strong) UIImageView    *iconImageView;
@property (nonatomic,strong) UILabel        *titleLabel;
@property (nonatomic,strong) UILabel        *desLabel;
@property (nonatomic,strong) UILabel        *timeLabel;
@property (nonatomic,strong) UIImageView    *talkImgView;
@property (nonatomic,strong) UILabel    *talkLabel;
@end

@implementation XKFriendTalkRecordCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化默认数据
        [self createDefaultData];
        // 初始化界面
        [self createUI];
        // 布局界面
        [self createConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {

}

#pragma mark - 初始化界面
- (void)createUI {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.desLabel];
    [self.contentView addSubview:self.timeLabel];
    
    _talkImgView = [[UIImageView alloc] init];
    _talkImgView.contentMode = UIViewContentModeScaleAspectFill;
    _talkImgView.layer.cornerRadius = 5;
    _talkImgView.clipsToBounds = YES;
    [self.contentView addSubview:_talkImgView];
    
    _talkLabel = [[UILabel alloc] init];
    _talkLabel.numberOfLines = 3;
    _talkLabel.textColor = HEX_RGB(0x222222);
    _talkLabel.font = XKNormalFont(12);
    [self.contentView addSubview:_talkLabel];
}


#pragma mark - 布局界面
- (void)createConstraints {
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(48 * 1, 48 * 1));
    }];
    _iconImageView.layer.cornerRadius = 5;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_iconImageView.mas_top);
        make.bottom.mas_equalTo(self->_iconImageView.mas_centerY);
        make.left.mas_equalTo(self->_iconImageView.mas_right).offset(12.5 * ScreenScale);
        make.right.mas_equalTo(self.contentView.mas_right).offset(- SCREEN_WIDTH / 4);
    }];
    
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_titleLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self->_titleLabel.mas_left);
        make.right.mas_equalTo(self->_talkImgView.mas_left).offset(10);
        make.height.greaterThanOrEqualTo(@17);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_titleLabel.mas_left);
        make.top.mas_equalTo(self.desLabel.mas_bottom).offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-13);
    }];
    
    [_talkImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(XKViewSize(60), XKViewSize(60)));
        
    }];
    [self addPlayBtn:_talkImgView];
    [_talkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(self.talkImgView);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setModel:(XKFriendTalkRecordModel *)model {
    _model = model;
    [_iconImageView sd_setImageWithURL:kURL(model.releaseUser.avatar) placeholderImage:kDefaultHeadImg];
    
    _titleLabel.text = model.releaseUser.nickname;
    if ([model.msgLogType isEqualToString:@"comment"]) {
        _desLabel.text = model.commentContent;
    } else {
        [_desLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.appendImage(IMG_NAME(@"ic_btn_msg_circle_noLike"));
        }];
    }
    if ([model.detailType isEqualToString:@"content"]) {
        _talkLabel.text = model.dynamicContent;
        _talkLabel.hidden = NO;
        _talkImgView.hidden = YES;
    } else if ([model.detailType isEqualToString:@"picture"]) {
        _talkLabel.hidden = YES;
        _talkImgView.hidden = NO;
        [_talkImgView viewWithTag:101].hidden = YES;
        [_talkImgView sd_setImageWithURL:kURL(model.dynamicContent) placeholderImage:kDefaultPlaceHolderImg];
    } else if ([model.detailType isEqualToString:@"video"]){
        _talkLabel.hidden = YES;
        _talkImgView.hidden = NO;
        [_talkImgView sd_setImageWithURL:kURL(model.dynamicContent) placeholderImage:kDefaultPlaceHolderImg];
        [_talkImgView viewWithTag:101].hidden = NO;
    } else {
        _talkLabel.text = model.dynamicContent;
        _talkImgView.hidden = YES;
        _talkLabel.hidden = NO;
    }
    _timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimestampString:model.releaseTime];
    
}

- (void)addPlayBtn:(UIImageView *)imageView {
    UIButton *playBtn = [[UIButton alloc] init];
    [playBtn setBackgroundImage:IMG_NAME(@"xk_ic_middlePlay") forState:UIControlStateNormal];
    [imageView addSubview:playBtn];
    playBtn.tag = 101;
    playBtn.userInteractionEnabled = NO;
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}


-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50 * 1, 50 * 1)];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}


-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10] textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor whiteColor]];
        _timeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _timeLabel;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.numberOfLines = 3;
    }
    return _desLabel;
}

@end

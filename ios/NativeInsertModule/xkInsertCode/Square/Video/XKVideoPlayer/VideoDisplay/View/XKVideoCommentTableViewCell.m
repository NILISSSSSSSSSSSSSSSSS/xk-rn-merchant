//
//  XKVideoCommentTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoCommentTableViewCell.h"
#import "YYLabel+xkEmoji.h"
#import "XKVideoCommentModel.h"

@interface XKVideoCommentTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImgView;

@property (nonatomic, strong) UILabel *authorLab;

@property (nonatomic, strong) UILabel *usernameLab;

@property (nonatomic, strong) YYLabel *commentLab;

@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, strong) UIView *likeView;

@property (nonatomic, strong) UIImageView *likeImgView;

@property (nonatomic, strong) UILabel *likeNumLab;


@property (nonatomic, strong) XKVideoCommentModel *comment;

@end

@implementation XKVideoCommentTableViewCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initializeViews];
        [self updateViews];
    }
    return self;
}

- (void)initializeViews {
    [self.contentView addSubview:self.avatarImgView];
    [self.contentView addSubview:self.usernameLab];
    [self.contentView addSubview:self.authorLab];
    [self.contentView addSubview:self.commentLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.likeView];
    [self.likeView addSubview:self.likeImgView];
    [self.likeView addSubview:self.likeNumLab];
}

- (void)updateViews {

    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.0);
        make.leading.mas_equalTo(15.0);
        make.width.height.mas_equalTo(42.0);
    }];
    
    [self.usernameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImgView.mas_right).offset(10.0);
        make.bottom.mas_equalTo(self.avatarImgView.mas_centerY).offset(-5.0);
    }];
    
    [self.authorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.usernameLab.mas_right).offset(9.5);
        make.centerY.mas_equalTo(self.usernameLab);
    }];
    
    [self.commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.usernameLab);
        make.top.mas_equalTo(self.avatarImgView.mas_centerY).offset(5.0);
        make.right.mas_equalTo(self.likeView.mas_left);
        make.height.mas_equalTo(0.0);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commentLab.mas_bottom).offset(4.0);
        make.leading.trailing.mas_equalTo(self.commentLab);
        make.bottom.mas_equalTo(self.contentView).offset(-10.0).priorityMedium();
    }];
    
    [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.usernameLab);
        make.trailing.mas_equalTo(self.contentView);
    }];
    
    [self.likeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.likeView).offset(5.0);
        make.leading.mas_equalTo(15.0);
        make.trailing.mas_equalTo(-15.0);
        make.size.mas_equalTo(self.likeImgView.image.size);
    }];
    
    [self.likeNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.likeImgView.mas_bottom).offset(5.0);
        make.leading.trailing.mas_equalTo(self.likeView);
        make.bottom.mas_equalTo(self.likeView).offset(-5.0);
    }];
}

#pragma mark - public method

- (void)configCellWithCommentModel:(XKVideoCommentModel *)comment {
    _comment = comment;
    if (_comment.commenter.avatar && _comment.commenter.avatar.length) {
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:_comment.commenter.avatar] placeholderImage:kDefaultHeadImg];
    } else {
        self.avatarImgView.image = kDefaultHeadImg;
    }
    self.usernameLab.text = _comment.commenter.nickName;
    self.authorLab.hidden = ![_comment.commenter.id isEqualToString:_comment.videlAuthorId];
    
    [self.commentLab layoutIfNeeded];
    NSMutableAttributedString *commentStr = [self.commentLab getEmojiAttriStr:_comment.content].mutableCopy;
    [self.commentLab.textParser parseText:commentStr selectedRange:NULL];
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(CGRectGetWidth(self.commentLab.frame), CGFLOAT_MAX);
    container.linePositionModifier = self.commentLab.linePositionModifier;
    container.insets = self.commentLab.textContainerInset;
    container.maximumNumberOfRows = self.commentLab.numberOfLines;
    //创建layout
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:commentStr];
    CGFloat contentHeight = layout.textBoundingSize.height;
    [self.commentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];
    self.commentLab.attributedText = commentStr;
    
    self.likeNumLab.text = [NSString stringWithFormat:@"%tu", _comment.praiseCount];
    self.likeImgView.highlighted = _comment.liked;
    self.likeNumLab.highlighted = _comment.liked;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)_comment.createdAt];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.timeLab.text = [XKTimeSeparateHelper customTimeStyleWithTimeString:[dateFormatter stringFromDate:date]];
}

#pragma mark - privite method

- (void)likeTapAction {
    if (self.likeViewBlock) {
        self.likeViewBlock();
    }
}

- (void)avatarImgViewTapAction {
    if (self.userClickedBlock) {
        self.userClickedBlock(self.comment.commenter.id);
    }
}

#pragma mark - getter setter

- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] init];
        _avatarImgView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImgView.xk_radius = 21.0;
        _avatarImgView.xk_clipType = XKCornerClipTypeAllCorners;
        _avatarImgView.xk_openClip = YES;
        UITapGestureRecognizer *avatarImgViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImgViewTapAction)];
        _avatarImgView.userInteractionEnabled = YES;
        [_avatarImgView addGestureRecognizer:avatarImgViewTap];
    }
    return _avatarImgView;
}

- (UILabel *)usernameLab {
    if (!_usernameLab) {
        _usernameLab = [[UILabel alloc] init];
        _usernameLab.text = @"用户名";
        _usernameLab.font = XKRegularFont(12.0);
        _usernameLab.textColor = HEX_RGB(0x999999);
    }
    return _usernameLab;
}

- (UILabel *)authorLab {
    if (!_authorLab) {
        _authorLab = [[UILabel alloc] init];
        _authorLab.text = @" 作者 ";
        _authorLab.font = XKRegularFont(10.0);
        _authorLab.textColor = HEX_RGB(0x000000);
        _authorLab.backgroundColor = HEX_RGB(0xfae66c);
        _authorLab.xk_radius = 2.0;
        _authorLab.xk_openClip = YES;
        _authorLab.xk_clipType = UIRectCornerAllCorners;
    }
    return _authorLab;
}

- (YYLabel *)commentLab {
    if (!_commentLab) {
        _commentLab = [[YYLabel alloc] init];
        _commentLab.numberOfLines = 2;
        _commentLab.font = XKRegularFont(14.0);
        _commentLab.textColor = HEX_RGB(0xffffff);
    }
    return _commentLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.text = @"时间";
        _timeLab.font = XKRegularFont(10.0);
        _timeLab.textColor = HEX_RGBA(0xffffff, 0.25);
    }
    return _timeLab;
}

- (UIView *)likeView {
    if (!_likeView) {
        _likeView = [[UIView alloc] init];
        UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTapAction)];
        [_likeView addGestureRecognizer:likeTap];
    }
    return _likeView;
}

- (UIImageView *)likeImgView {
    if (!_likeImgView) {
        _likeImgView = [[UIImageView alloc] init];
        _likeImgView.image = IMG_NAME(@"xk_ic_video_comment_like_normal");
        _likeImgView.highlightedImage = IMG_NAME(@"xk_ic_video_comment_like_highlighted");
    }
    return _likeImgView;
}

- (UILabel *)likeNumLab {
    if (!_likeNumLab) {
        _likeNumLab = [[UILabel alloc] init];
        _likeNumLab.text = @"0";
        _likeNumLab.font = XKRegularFont(12.0);
        _likeNumLab.textColor = HEX_RGB(0x777777);
        _likeNumLab.textAlignment = NSTextAlignmentCenter;
        _likeNumLab.highlightedTextColor = HEX_RGB(0xff456b);
    }
    return _likeNumLab;
}

@end

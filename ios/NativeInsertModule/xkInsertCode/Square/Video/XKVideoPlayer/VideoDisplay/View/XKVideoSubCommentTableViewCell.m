//
//  XKVideoSubCommentTableViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoSubCommentTableViewCell.h"

#import "XKVideoCommentModel.h"

@interface XKVideoSubCommentTableViewCell ()

@property (nonatomic, strong) UILabel *timeLine;

@property (nonatomic, strong) YYLabel *replyLab;

@property (nonatomic, strong) YYLabel *commentLab;


@property (nonatomic, strong) XKVideoReplyModel *reply;

@end

@implementation XKVideoSubCommentTableViewCell

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
    [self.contentView addSubview:self.timeLine];
    [self.contentView addSubview:self.replyLab];
    [self.contentView addSubview:self.commentLab];
}

- (void)updateViews {
    [self.timeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(57.0);
        make.width.mas_equalTo(1.0);
    }];
    
    [self.replyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.timeLine.mas_right).offset(10.0);
        make.trailing.mas_equalTo(-15.0);
        make.height.mas_equalTo(0.0);
    }];
    
    [self.commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.replyLab.mas_bottom).offset(5.0);
        make.left.mas_equalTo(self.timeLine.mas_right).offset(10.0);
        make.trailing.mas_equalTo(-15.0);
        make.height.mas_equalTo(0.0);
        make.bottom.mas_equalTo(-5.0).priorityMedium();
    }];
}

#pragma mark - public method

- (void)configCellWithReplyModel:(XKVideoReplyModel *)reply {
    _reply = reply;
    if (_reply.creator && _reply.refCreator) {
        self.replyLab.hidden = NO;
        NSMutableAttributedString *replyStr = [[NSMutableAttributedString alloc] init];
        UIImageView *avatarImgView = [[UIImageView alloc] init];
        UITapGestureRecognizer *avatarImgViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImgViewTapAction)];
        avatarImgView.userInteractionEnabled = YES;
        [avatarImgView addGestureRecognizer:avatarImgViewTap];
        if (_reply.creator.nickName && _reply.creator.nickName.length) {
            [avatarImgView sd_setImageWithURL:[NSURL URLWithString:_reply.creator.nickName] placeholderImage:kDefaultHeadImg];
        } else {
            avatarImgView.image = kDefaultHeadImg;
        }
        avatarImgView.frame = CGRectMake(0, 0, 20, 20);
        avatarImgView.xk_radius = 10.0;
        avatarImgView.xk_clipType = XKCornerClipTypeAllCorners;
        avatarImgView.xk_openClip = YES;
//        头像
        NSMutableAttributedString *avatarText = [NSMutableAttributedString yy_attachmentStringWithContent:avatarImgView contentMode:UIViewContentModeScaleAspectFit attachmentSize:avatarImgView.frame.size alignToFont:[UIFont systemFontOfSize:20] alignment:YYTextVerticalAlignmentCenter];
//        回复者
        NSMutableAttributedString *user1Text = [[NSMutableAttributedString alloc] initWithString:_reply.creator.nickName];
        [user1Text addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, user1Text.length)];
        [user1Text addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xFCE76C) range:NSMakeRange(0, user1Text.length)];
//        回复者点击事件
        __weak typeof(self) weakSelf = self;
        [user1Text yy_setTextHighlightRange:[user1Text.string rangeOfString:user1Text.string] color:HEX_RGB(0xFCE76C) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakSelf.userClickedBlock) {
                weakSelf.userClickedBlock(weakSelf.reply.creator.id);
            }
        }];
//        箭头
        UIImageView *arrowImgView = [[UIImageView alloc] initWithImage:IMG_NAME(@"xk_ic_video_comment_more")];
        arrowImgView.frame = CGRectMake(0, 0, 8.0, 10.0);
        NSMutableAttributedString *arrowText = [NSMutableAttributedString yy_attachmentStringWithContent:arrowImgView contentMode:UIViewContentModeScaleAspectFit attachmentSize:arrowImgView.frame.size alignToFont:[UIFont systemFontOfSize:20] alignment:YYTextVerticalAlignmentCenter];
//        被回复者
        NSMutableAttributedString *user2Text = [[NSMutableAttributedString alloc] initWithString:_reply.refCreator.nickName];
        [user2Text addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, user2Text.length)];
        [user2Text addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xFCE76C) range:NSMakeRange(0, user2Text.length)];
//        被回复者点击事件
        [user2Text yy_setTextHighlightRange:[user2Text.string rangeOfString:user2Text.string] color:HEX_RGB(0xFCE76C) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakSelf.userClickedBlock) {
                weakSelf.userClickedBlock(weakSelf.reply.refCreator.id);
            }
        }];
        [replyStr appendAttributedString:avatarText];
        [replyStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
        [replyStr appendAttributedString:user1Text];
        [replyStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  "]];
        [replyStr appendAttributedString:arrowText];
        [replyStr appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"  "]];
        [replyStr appendAttributedString:user2Text];
        
        [self.replyLab layoutIfNeeded];
        [self.replyLab.textParser parseText:replyStr selectedRange:NULL];
        YYTextContainer *replyContainer = [YYTextContainer containerWithSize:CGSizeMake(CGRectGetWidth(self.replyLab.frame), CGFLOAT_MAX)];
        replyContainer.linePositionModifier = self.replyLab.linePositionModifier;
        replyContainer.maximumNumberOfRows = 1;
        //创建layout
        YYTextLayout *replyLayout = [YYTextLayout layoutWithContainer:replyContainer text:replyStr];
        CGFloat replyHeight = replyLayout.textBoundingSize.height;
        [self.replyLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(replyHeight);
        }];
        self.replyLab.attributedText = replyStr;
        
        [self.commentLab layoutIfNeeded];
        NSMutableAttributedString *commentStr = [[NSMutableAttributedString alloc] initWithString:_reply.content];
        [commentStr addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, commentStr.length)];
        [commentStr addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x999999) range:NSMakeRange(0, commentStr.length)];
        [self.commentLab.textParser parseText:commentStr selectedRange:NULL];
        YYTextContainer *commentContainer = [YYTextContainer containerWithSize:CGSizeMake(CGRectGetWidth(self.commentLab.frame), CGFLOAT_MAX)];
        commentContainer.linePositionModifier = self.commentLab.linePositionModifier;
        commentContainer.maximumNumberOfRows = self.commentLab.numberOfLines;
        //创建layout
        YYTextLayout *commentLayout = [YYTextLayout layoutWithContainer:commentContainer text:commentStr];
        CGFloat commentHeight = commentLayout.textBoundingSize.height;
        [self.commentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.replyLab.mas_bottom).offset(5.0);
            make.left.mas_equalTo(self.timeLine.mas_right).offset(10.0);
            make.trailing.mas_equalTo(-15.0);
            make.height.mas_equalTo(commentHeight);
            make.bottom.mas_equalTo(-5.0).priorityMedium();
        }];
        self.commentLab.attributedText = commentStr;
    } else {
        self.replyLab.hidden = YES;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
        NSMutableAttributedString *userText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：", _reply.creator.nickName]];
        [userText addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, userText.length)];
        [userText addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0xFCE76C) range:NSMakeRange(0, userText.length)];
        __weak typeof(self) weakSelf = self;
        [userText yy_setTextHighlightRange:[userText.string rangeOfString:userText.string] color:HEX_RGB(0xFCE76C) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakSelf.userClickedBlock) {
                weakSelf.userClickedBlock(weakSelf.reply.creator.id);
            }
        }];
        NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:_reply.content];
        [commentText addAttribute:NSFontAttributeName value:XKRegularFont(12.0) range:NSMakeRange(0, commentText.length)];
        [commentText addAttribute:NSForegroundColorAttributeName value:HEX_RGB(0x999999) range:NSMakeRange(0, commentText.length)];
        [str appendAttributedString:userText];
        [str appendAttributedString:commentText];
        
        [self.commentLab layoutIfNeeded];
        [self.commentLab.textParser parseText:str selectedRange:NULL];
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(CGRectGetWidth(self.commentLab.frame), CGFLOAT_MAX);
        container.linePositionModifier = self.commentLab.linePositionModifier;
        container.insets = self.commentLab.textContainerInset;
        container.maximumNumberOfRows = self.commentLab.numberOfLines;
        //创建layout
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:str];
        CGFloat contentHeight = layout.textBoundingSize.height;
        [self.commentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.timeLine.mas_right).offset(10.0);
            make.trailing.mas_equalTo(-15.0);
            make.height.mas_equalTo(contentHeight).priorityHigh();
            make.bottom.mas_equalTo(-5.0).priorityMedium();
        }];
        self.commentLab.attributedText = str;
    }
}

#pragma mark - privite method

- (void)avatarImgViewTapAction {
    if (self.userClickedBlock) {
        self.userClickedBlock(self.reply.creator.id);
    }
}

#pragma mark - getter setter

- (UILabel *)timeLine {
    if (!_timeLine) {
        _timeLine = [[UILabel alloc] init];
        _timeLine.backgroundColor = HEX_RGB(0x343434);
    }
    return _timeLine;
}

- (YYLabel *)replyLab {
    if (!_replyLab) {
        _replyLab = [[YYLabel alloc] init];
        _replyLab.numberOfLines = 1;
        _replyLab.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    }
    return _replyLab;
}

- (YYLabel *)commentLab {
    if (!_commentLab) {
        _commentLab = [[YYLabel alloc] init];
        _commentLab.numberOfLines = 2;
    }
    return _commentLab;
}

@end

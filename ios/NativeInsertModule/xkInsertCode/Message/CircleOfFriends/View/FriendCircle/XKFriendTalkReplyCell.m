/*******************************************************************************
 # File        : XKFriendTalkReplyCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/17
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendTalkReplyCell.h"
#import "XKFriendCircleHeader.h"
#import <YYText.h>
#import "UILabel+xkEmoji.h"
#import "YYLabel+xkEmoji.h"

#define kTotalWidth (SCREEN_WIDTH - 2 * kFMargin - 2 * 15)
#define kIconImgLeft  13
#define kIconImgSize 13
#define kIconImgRight 10
#define kHeadImgSize 29
#define kContentTop 10
#define kContentBtm 0
#define kContentBigTop 10
#define kContentLeft 4
#define kContentRight 8

#define kContentX (kIconImgLeft + kIconImgSize + kIconImgRight + kHeadImgSize + kContentLeft)

@interface XKFriendTalkReplyCell ()

/**视图*/
@property(nonatomic, strong) UIView *containView;
/**图片*/
@property(nonatomic, strong) UIImageView *iconView;
/**头像view*/
@property(nonatomic, strong) UIImageView *headerImgView;

@property(nonatomic, strong) YYLabel *nameLabel;
@property(nonatomic, strong) YYLabel *contentLabel;
/**分割线*/
@property(nonatomic, strong) UIView *seperateLine;
/**<##>*/
@property(nonatomic, strong) FriendsCirclelCommentsItem *comment;
@end

@implementation XKFriendTalkReplyCell

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
    __weak typeof(self) weakSelf = self;
    self.contentView.backgroundColor = HEX_RGB(0xEEEEEE);
    _containView = [[UIView alloc] init];
    _containView.backgroundColor = HEX_RGB(0xFFFFFF);
    _containView.xk_openClip = YES;
    _containView.xk_radius = 6;
    [self.contentView addSubview:_containView];
    _totalView = [[UIView alloc] init];
    _totalView.backgroundColor = HEX_RGB(0xF3F3F3);
    [self.containView addSubview:_totalView];
    _totalView.xk_openClip = YES;
    _totalView.xk_radius = 6;
    /**图片*/
    _iconView = [[UIImageView alloc] init];
    _iconView.image = IMG_NAME(@"ic_btn_msg_circle_Comment");
    [self.totalView addSubview:_iconView];
    /**头像view*/
    _headerImgView = [[UIImageView alloc] init];
    _headerImgView.clipsToBounds = YES;
    _headerImgView.layer.cornerRadius = 4;
    _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.totalView addSubview:_headerImgView];
    _headerImgView.userInteractionEnabled = YES;
    [_headerImgView bk_whenTapped:^{
        weakSelf.userClickBlock(weakSelf.indexPath, weakSelf.comment.userId);
    }];
    
    _nameLabel = [[YYLabel alloc] init];
    _nameLabel.font = XKRegularFont(14);
    _nameLabel.textColor = HEX_RGB(0x1B61CC);
    [self.totalView addSubview:_nameLabel];
    _nameLabel.userInteractionEnabled = YES;
    [_nameLabel bk_whenTapped:^{
        weakSelf.userClickBlock(weakSelf.indexPath, weakSelf.comment.userId);
    }];
    
    _contentLabel = [[YYLabel alloc] init];
    _contentLabel.textColor = HEX_RGB(0x555555);
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = XKRegularFont(12);
    [self.totalView addSubview:_contentLabel];

}

#pragma mark - 布局界面
- (void)createConstraints {
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, kFMargin, 0, kFMargin));
    }];

    
    [_totalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containView);
        make.left.equalTo(self.containView.mas_left).offset(15);
        make.right.equalTo(self.containView.mas_right).offset(-15);
        make.bottom.equalTo(self.containView.mas_bottom).priority(200);
        make.height.mas_equalTo(kContentTop + kHeadImgSize + kContentBtm);
    }];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalView.mas_left).offset(kIconImgLeft);
        make.size.mas_equalTo(CGSizeMake(kIconImgSize, kIconImgSize));
        make.centerY.equalTo(self.headerImgView);
    }];
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalView.mas_top).offset(kContentTop);
        make.left.equalTo(self.iconView.mas_right).offset(kIconImgRight);
        make.size.mas_equalTo(CGSizeMake(kHeadImgSize, kHeadImgSize));
    }];
    _nameLabel.frame = CGRectMake(kContentX, kContentTop - 1, kTotalWidth - kContentX - kContentRight, 16);
    _contentLabel.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 2,_nameLabel.width, 18);
    
    _seperateLine = [[UIView alloc] init];
    _seperateLine.backgroundColor = HEX_RGB(0xF0F0F0);
    [self.totalView addSubview:_seperateLine];
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.totalView);
        make.height.equalTo(@1);
    }];
}

- (void)hideSperate:(BOOL)hide {
    self.seperateLine.hidden = hide;
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setModel:(XKFriendTalkModel *)model {
    _model = model;
    FriendsCirclelCommentsItem *comment = model.comments[self.indexPath.row - 1];
    _comment = comment;
    [_headerImgView sd_setImageWithURL:kURL(comment.user.avatar) placeholderImage:kDefaultHeadImg];
    NSString *name = comment.user.displayName;
    _nameLabel.text = name;
    _nameLabel.width = [name getWidthStrWithFontSize:_nameLabel.font.pointSize height:17] + 10;
    
    if (comment.contentMStr == nil) {
        NSAttributedString *contentMStr = [self getCommentAStrWithModel:comment indexPath:self.indexPath];
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(_contentLabel.width, CGFLOAT_MAX) text:contentMStr];
        CGFloat commentHeight = layout.textBoundingSize.height;
        comment.contentMStr = contentMStr;
        comment.contentHeight = commentHeight;
    }

    _contentLabel.height = comment.contentHeight;
    _contentLabel.attributedText = comment.contentMStr;
    [_totalView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.contentLabel.bottom + kContentBtm);
    }];
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (indexPath.row == 1) {
        _iconView.hidden = NO;
    } else {
        _iconView.hidden = YES;
    }
}

- (NSAttributedString *)getCommentAStrWithModel:(FriendsCirclelCommentsItem *)comment indexPath:(NSIndexPath *)indexPath {
    UIFont *font = XKRegularFont(12);
    self.contentLabel.font = font;
    __weak typeof(self) weakSelf = self;;
    NSString *name = comment.replyUser.displayName;
    NSString *word = comment.content;
    NSMutableAttributedString *text = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
        if (name) {
            confer.text(@"回复").font(font).textColor(HEX_RGB(0x555555));
            confer.text(name).font(font).textColor(HEX_RGB(0x1B61CC));
            confer.text(@": ").font(font).textColor(HEX_RGB(0x555555));
        }
    }].mutableCopy;
    [text appendAttributedString:[self.contentLabel getEmojiAttriStr:word]];
    if (name) {
        [text yy_setTextHighlightRange:NSMakeRange(2, name.length) color:nil backgroundColor:[UIColor lightGrayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            weakSelf.userClickBlock(indexPath, comment.replyUserId);
        }];
    }
    return text;
}

- (void)setShortCell:(BOOL)shortCell {
  _shortCell = shortCell;
  [_totalView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.containView.mas_left).offset(10 + 46 + 10);
  }];
  _nameLabel.width = _nameLabel.width - (10 + 46 + 10 - 15);
  _contentLabel.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + 2,_nameLabel.width, 18);
}



- (void)layoutSubviews {
    [super layoutSubviews];
    [_totalView setNeedsLayout];
    [_totalView layoutIfNeeded];
}

@end

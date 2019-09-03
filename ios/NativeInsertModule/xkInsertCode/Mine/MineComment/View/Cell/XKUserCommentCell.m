/*******************************************************************************
 # File        : XKUserCommentCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/13
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKUserCommentCell.h"
#import "UIView+Border.h"
#import "YYLabel+xkEmoji.h"

@interface XKUserCommentCell ()
/**头像*/
@property(nonatomic, strong) UIImageView *headImageView;
/**名字*/
@property(nonatomic, strong) UILabel *nameLabel;
/**时间*/
@property(nonatomic, strong) UILabel *timeLabel;
/**评论内容*/
@property(nonatomic, strong) YYLabel *desLabel;
@end

@implementation XKUserCommentCell

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
    /**头像*/
    __weak typeof(self) weakSelf = self;
    _headImageView = [[UIImageView alloc] init];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_headImageView];
    _headImageView.userInteractionEnabled = YES;
    [_headImageView bk_whenTapped:^{
        [XKGlobleCommonTool jumpUserInfoCenter:weakSelf.replyInfo.creator.userId vc:nil];
    }];
    /**名字*/
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = HEX_RGB(0x222222);
    _nameLabel.font = XKRegularFont(14);
    [self.contentView addSubview:_nameLabel];
    /**时间*/
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = HEX_RGB(0x999999);
    _timeLabel.font = XKRegularFont(10);
    [self.contentView addSubview:_timeLabel];
    
    /**评论内容*/
    _desLabel = [[YYLabel alloc] init];
    _desLabel.font = XKRegularFont(12);
    _desLabel.textColor = HEX_RGB(0x777777);
    _desLabel.numberOfLines = 3;
    [self.contentView addSubview:_desLabel];
}

#pragma mark - 布局界面
- (void)createConstraints {

    /**头像*/
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(46 , 46));
    }];
    _headImageView.layer.cornerRadius = 46 / 2;
    _headImageView.layer.masksToBounds = YES;
    /**名字*/
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(self.headImageView.mas_top).offset(-1);
    }];
   
    // 10 + 15 + 46 + 15 + x + 15 + 10
    /**时间*/
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom);
    }];;
    /**评论内容*/
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.headImageView.mas_bottom).offset(-3);
        make.height.equalTo(@1);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12).priority(200);
    }];
    
    [self.contentView showBorderSite:rzBorderSitePlaceTop];
    self.contentView.topBorder.borderLine.backgroundColor = HEX_RGB(0xEEEEEE);
    self.contentView.topBorder.borderSize = 1;
    [self layoutIfNeeded];
}

- (void)setReplyInfo:(XKReplyBaseInfo *)replyInfo {
    _replyInfo = replyInfo;
    [_headImageView sd_setImageWithURL:kURL(replyInfo.creator.avatar) placeholderImage:kDefaultHeadImg];
    _nameLabel.text = replyInfo.creator.displayName;
    _timeLabel.text = replyInfo.getDisplayTime;
    _desLabel.font = XKRegularFont(12);
    _desLabel.textColor = HEX_RGB(0x777777);
    NSMutableAttributedString *attSttr;
    if (replyInfo.refCreator) {
        attSttr =  [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text(@"回复").font(XKRegularFont(12)).textColor(HEX_RGB(0x777777));
            confer.text(replyInfo.refCreator.displayName).font(XKRegularFont(12)).textColor(XKMainTypeColor);
            confer.text(@"：").font(XKRegularFont(12)).textColor(HEX_RGB(0x777777));
        }].mutableCopy;
       [attSttr appendAttributedString:[self.desLabel getEmojiAttriStr:replyInfo.content]];
       [attSttr yy_setTextHighlightRange:NSMakeRange(2, replyInfo.refCreator.displayName.length) color:nil backgroundColor:[UIColor lightGrayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [XKGlobleCommonTool jumpUserInfoCenter:replyInfo.refCreator.userId vc:self.getCurrentUIVC];
            }];
    
    } else {
        attSttr = [[self.desLabel getEmojiAttriStr:replyInfo.content] mutableCopy];
    }
  
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH - (10 + 15 + 46 + 15 + 15 + 10), CGFLOAT_MAX) text:attSttr];
    CGFloat favorHeight = layout.textBoundingSize.height;
    _desLabel.attributedText = attSttr;
    [_desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(favorHeight);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------

@end

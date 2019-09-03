/*******************************************************************************
 # File        : XKFriendsTalkDateCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/18
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendsTalkDateCell.h"
#import <BlocksKit+UIKit.h>
#import <RZColorful.h>
#import <YYText.h>
#import <SVProgressHUD.h>
#import "XKFriendMenuView.h"
#import "XKFriendCicleToolView.h"
#import "XKFriendTalkContentView.h"
#import "UILabel+xkEmoji.h"

static CGFloat xkFriendTalkContentMaxHeight = 0;

#define kFoldBtnHeight 30

#define kCommentFontSize 14
#define kCommentLineSpace 4

#define kCommentTop 5
#define kCommentleft 13
#define kCommentRight 10
#define kCommentBottom 5

#define kBtmContentWidth (SCREEN_WIDTH - kFMargin * 2 - 15 * 2 - kCommentleft - kCommentRight)

@interface XKFriendsTalkDateCell () {
  UIView *_seperateLine;
}

/**名字*/
@property(nonatomic, strong) UILabel *dateLabel;
/**说说内容视图*/
@property(nonatomic, strong) XKFriendTalkContentView *talkContentView;
/**工具条*/
@property(nonatomic, strong) XKFriendCicleToolView *toolView;
/**底部点赞评论父视图*/
@property(nonatomic, strong) UIView *bottomView;
/**点赞*/
@property(nonatomic, strong) YYLabel *favorLabel;

@end

@implementation XKFriendsTalkDateCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // 初始化默认数据
    [self superCreateDefaultData];
    // 初始化界面
    [self superCreateUI];
    // 布局界面
    [self superCreateConstraints];
    
  }
  return self;
}

#pragma mark - 初始化默认数据
- (void)superCreateDefaultData {
  
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化界面
- (void)superCreateUI {
  __weak typeof(self) weakSelf = self;
  self.contentView.backgroundColor = HEX_RGB(0xEEEEEE);
  _totoalView = [[UIView alloc] init];
  [self.contentView addSubview:_totoalView];
  _totoalView.xk_openClip = YES;
  _totoalView.xk_radius = 8;
  _totoalView.backgroundColor = [UIColor whiteColor];
  /**名字*/
  _dateLabel = [[UILabel alloc] init];
  _dateLabel.font = kFontSize6(14);
  _dateLabel.textAlignment = NSTextAlignmentCenter;
  _dateLabel.textColor = HEX_RGB(0x222222);
  [self.contentView addSubview:_dateLabel];
  /**内容父视图*/
  _talkContentView = [[XKFriendTalkContentView alloc] initWithWidth:SCREEN_WIDTH - 10 * 2 - 82 - 10];
  [_talkContentView setRefreshBlock:^(NSIndexPath *indexPath) {
    weakSelf.refreshBlock(indexPath);
  }];
  _talkContentView.clipsToBounds = YES;
  [self.totoalView addSubview:_talkContentView];
  /**定位信息*/
  _toolView = [[XKFriendCicleToolView alloc] init];
  [_toolView.commentButton addTarget:self action:@selector(replyClick) forControlEvents:UIControlEventTouchUpInside];
  [_toolView.favorButton addTarget:self action:@selector(favorClick) forControlEvents:UIControlEventTouchUpInside];
//  [_toolView.giftButton addTarget:self action:@selector(giftClick) forControlEvents:UIControlEventTouchUpInside];
  
  [self.totoalView addSubview:_toolView];
  /**底部点赞评论父视图*/
  _bottomView = [[UIView alloc] init];
  _bottomView.backgroundColor = HEX_RGB(0xF3F3F3);
  _bottomView.clipsToBounds = YES;
  [self.totoalView addSubview:_bottomView];
  
  _favorLabel = [[YYLabel alloc] init];
  _favorLabel.userInteractionEnabled = YES;
  _favorLabel.numberOfLines = 1;
  _favorLabel.textColor = HEX_RGB(0x1B61CC);
  _favorLabel.font = [UIFont systemFontOfSize:kCommentFontSize];
  
  [self.bottomView addSubview:_favorLabel];
}

#pragma mark - 布局界面
- (void)superCreateConstraints {
  //    CGFloat margin = kFMargin;
  //    CGFloat headerSize = kFHeaderSize;
  [_totoalView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
  }];
  /**名字*/
  [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.totoalView.mas_top).offset(17);
    make.left.equalTo(self.totoalView.mas_left);
    make.width.equalTo(@82);
  }];
  /**说说父视图*/
  [_talkContentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.totoalView.mas_top).offset(20);
    make.left.equalTo(self.dateLabel.mas_right);
    make.right.equalTo(self.totoalView.mas_right).offset(-10);
  }];
  /**工具条*/
  _toolView.hidden = YES;
  
  __weak typeof(self) weakSelf = self;
  [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.talkContentView.mas_left);
    make.right.equalTo(self.totoalView.mas_right).offset(-5);
    make.top.equalTo(self.talkContentView.mas_bottom).offset(8);
    if (weakSelf.toolView.hidden == YES) { // 这里没有送礼物，点赞逻辑 先隐藏 后期要用打开即可
      [weakSelf.toolView clearConsError];
    } else {
      make.height.equalTo(@0);
    }
  }];
  
  /**底部点赞评论父视图*/
  [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.totoalView.mas_left).offset(15);
    make.right.equalTo(self.totoalView.mas_right).offset(-15);
    make.top.equalTo(self.toolView.mas_bottom).offset(10);
    make.height.equalTo(@100);
    make.bottom.equalTo(self.totoalView.mas_bottom).priority(300);
  }];
  _bottomView.xk_openClip = YES;
  _bottomView.xk_radius = 6;
  // 底部分割线
  _seperateLine = [UIView new];
  _seperateLine.backgroundColor = HEX_RGB(0xF1F1F1);
  //    _seperateLine.backgroundColor = [UIColor redColor];
  [self.totoalView addSubview:_seperateLine];
  [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.top.equalTo(self.totoalView);
    make.height.equalTo(@1);
  }];
}

#pragma mark - 回复点击
- (void)replyClick {
  EXECUTE_BLOCK(self.commentClickBlock,self.indexPath,nil,self.model.userId);
}

#pragma mark - 点赞点击
- (void)favorClick {
  EXECUTE_BLOCK(self.favorClickBlock,self.indexPath);
}

#pragma mark - 点赞点击
- (void)giftClick {
  EXECUTE_BLOCK(self.giftClickBlock,self.indexPath);
}


#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setModel:(XKFriendTalkModel *)model {
  _model = model;
  NSArray *dateArr = [[XKTimeSeparateHelper backMonthAndDayStringWithDate:[NSDate dateWithTimeIntervalSince1970:model.createdAt.longLongValue]] componentsSeparatedByString:@"-"];

  [self.dateLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
    confer.text(dateArr.lastObject).font(XKMediumFont(25));
    confer.text([NSString stringWithFormat:@" %ld月",[dateArr.firstObject integerValue]]).font(XKMediumFont(10));
  }];
  self.talkContentView.contentNeedFold = self.contentExistFold;
  self.talkContentView.model = model;
  self.toolView.infoLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimestampString:self.model.createdAt];
  BOOL hasFavor = model.likes.count != 0;
  BOOL hasComent = model.comments.count != 0;
  if (hasFavor) {
    self.favorLabel.attributedText = model.favorAtt;
    if (self.mode == 1) {
      self.favorLabel.userInteractionEnabled = NO;
      self.favorLabel.numberOfLines = 1;
      self.favorLabel.frame = CGRectMake(kCommentleft,8, kBtmContentWidth, 22);
    } else {
      self.favorLabel.numberOfLines = 0;
      self.favorLabel.frame = CGRectMake(kCommentleft,8, kBtmContentWidth, model.favorHeight + 6);
    }
  } else {
    self.favorLabel.height = 0;
  }
  // 这里处理尾部显示细节
  _seperateLine.hidden = NO;
  if (hasFavor) { // 有点赞
    if (hasComent) { // 有评论
      [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.favorLabel.bottom + 6);
        make.bottom.equalTo(self.totoalView.mas_bottom).priority(300);
      }];
      self.bottomView.xk_clipType = XKCornerClipTypeTopBoth;
    } else { // 无评论
      [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.favorLabel.bottom + 6);
        make.bottom.equalTo(self.totoalView.mas_bottom).offset(-10).priority(300);
      }];
      self.bottomView.xk_clipType = XKCornerClipTypeAllCorners;
    }
  } else { // 无点赞
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(0);
      make.bottom.equalTo(self.totoalView.mas_bottom).priority(300);
    }];
    if (!hasComent) {
      //            _seperateLine.hidden = NO;
    }
  }
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
  _indexPath = indexPath;
  self.talkContentView.indexPath = indexPath;
}

#pragma mark - 重新布局
- (void)layoutSubviews {
  [super layoutSubviews];
  [self.totoalView setNeedsLayout];
  [self.totoalView layoutIfNeeded];
  [self.bottomView setNeedsLayout];
  [self.bottomView layoutIfNeeded];
}

#pragma mark - 高度计算相关
/**得到正常说说高度  以及是否可折叠 以及折叠展开后的高度 */
+ (CGFloat)getContentHeight:(XKFriendTalkModel *)model contentAtt:(NSAttributedString **)contentAtt isNeedFold:(BOOL *)needFold totalHeight:(CGFloat *)totalHeight {
  CGFloat lineSpace = 3;
  UIFont *font = kFontSize6(kFriendTalkContentFont);
  NSMutableAttributedString *content = [UILabel getEmojiAttriStr:model.content].mutableCopy;
  content.yy_font = font;
  content.yy_color = HEX_RGB(0x777777);
  content.yy_lineSpacing = lineSpace;
  
  CGFloat fullHeight = ceil([content sizeWithConditionWidth:SCREEN_WIDTH - 10 - 82 - 10 -10].height);
  *totalHeight = fullHeight;
  if (fullHeight < font.pointSize*2) { // 认为是一行 清除表情单行时显示bug
    content = [UILabel getEmojiAttriStr:model.content].mutableCopy;
    content.yy_font = font;
    content.yy_color = HEX_RGB(0x777777);
  }
  * contentAtt = content;
  if (xkFriendTalkContentMaxHeight == 0) {
    xkFriendTalkContentMaxHeight = [self calculateFoldHeightLineSpace:lineSpace font:font];
  }
  if (fullHeight > xkFriendTalkContentMaxHeight) {
    *needFold = YES;
    *totalHeight = fullHeight;
    return ceil(xkFriendTalkContentMaxHeight);
  } else {
    return ceil(fullHeight);
  }
}

+ (CGFloat)calculateFoldHeightLineSpace:(CGFloat)space font:(UIFont *)font {
  UILabel *label = [[UILabel alloc] init];
  label.frame = CGRectMake(0, 0, 30, 10000);
  NSString *max7Str = @"我\n我\n我\n我\n我\n我\n我";
  NSAttributedString *content = [NSAttributedString rz_colorfulConfer:^(RZColorfulConferrer *confer) {
    confer.paragraphStyle.lineSpacing(space);
    confer.text(max7Str).font(font);
  }];
  label.numberOfLines = 0;
  label.attributedText = content;
  [label sizeToFit];
  return ceil(label.height);
}



@end

/*******************************************************************************
 # File        : XKFriendCircleFooterView.m
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

#import "XKFriendCircleFooterView.h"
#import "XKFriendCircleHeader.h"

@interface XKFriendCircleFooterView ()
/**视图*/
@property(nonatomic, strong) UIView *totalView;
/**视图*/

@end

@implementation XKFriendCircleFooterView

#pragma mark - 初始化
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithReuseIdentifier:reuseIdentifier];
  if (self) {
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
  _containView.xk_openClip = YES;
  _containView.xk_radius = 6;
  _containView.backgroundColor = HEX_RGB(0xFFFFFF);
  [self.contentView addSubview:_containView];
  _totalView = [[UIView alloc] init];
  _totalView.backgroundColor = HEX_RGB(0xF3F3F3);
  [self.containView addSubview:_totalView];
  _totalView.xk_openClip = YES;
  _totalView.xk_radius = 6;
  _totalView.xk_clipType = XKCornerClipTypeBottomBoth;
  
  _label = [[UILabel alloc] init];
  [self.totalView addSubview:_label];
  [_label rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
    confer.paragraphStyle.alignment(NSTextAlignmentCenter);
    confer.text(@"点击查看更多 ").textColor(HEX_RGB(0x999999)).font(XKRegularFont(12));
    confer.appendImage(IMG_NAME(@"ic_btn_msg_circle_rightArrow")).bounds(CGRectMake(0, -2, 12, 12));
  }];
  _label.userInteractionEnabled = YES;
  [_totalView bk_whenTapped:^{
    EXECUTE_BLOCK(weakSelf.click,weakSelf.index);
  }];
}

#pragma mark - 布局界面
- (void)createConstraints {
  [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, kFMargin, 0, kFMargin));
  }];
  [_label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.totalView);
    make.bottom.equalTo(self.totalView.mas_bottom).offset(-11);
    
  }];
  [_totalView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.containView).insets(UIEdgeInsetsMake(0, 10+46 +10, 14, 15));
  }];
}

- (void)setShortFooter:(BOOL)shortFooter {
  [_totalView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.containView).insets(UIEdgeInsetsMake(0, 15, 14, 15));
  }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)layoutSubviews {
  [super layoutSubviews];
  [_containView setNeedsLayout];
  [_containView layoutIfNeeded];
}

@end

/*******************************************************************************
 # File        : XKArrowTableViewCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/10
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKArrowTableViewCell.h"
#import "XKSectionHeaderArrowView.h"

@interface XKArrowTableViewCell ()
/**<##>*/
@property(nonatomic, strong) XKSectionHeaderArrowView *arrowView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation XKArrowTableViewCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.backgroundColor = [UIColor clearColor];
      self.contentView.backgroundColor = [UIColor whiteColor];

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
    _arrowView = [[XKSectionHeaderArrowView alloc] init];
    _arrowView.detailLabel.textColor = HEX_RGB(0x777777);
    [self.contentView addSubview:_arrowView];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    

}

#pragma mark ----------------------------- 公用方法 ------------------------------

- (void)clipTopCornerRadius:(CGFloat)cornerRadius {
  self.xk_openClip = YES;
  self.xk_radius = cornerRadius;
  self.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
}

- (void)clipBottomCornerRadius:(CGFloat)cornerRadius {
  self.xk_openClip = YES;
  self.xk_radius = cornerRadius;
  self.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
}

- (void)addCustomSubviews {
  self.lineView = [UIView new];
  self.lineView.hidden = YES;
  self.lineView.backgroundColor = XKSeparatorLineColor;
  [self.contentView addSubview:self.lineView];
}

- (void)addUIConstraint {
  [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.contentView).offset(69);
    make.bottom.equalTo(self.contentView.mas_bottom);
    make.height.mas_equalTo(1);
  }];
  
  [self.arrowView.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.mas_right).offset(-15);
    make.centerY.equalTo(self);
    make.size.mas_equalTo(CGSizeMake(7, 12));
  }];
}

- (void)hiddenSeperateLine:(BOOL)hidden {
  [super hiddenSeperateLine:YES];
  self.lineView.hidden = hidden;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.contentView xk_forceClip];
}


@end

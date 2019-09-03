/*******************************************************************************
 # File        : XKCheckTableViewCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/11
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCheckTableViewCell.h"

@interface XKCheckTableViewCell ()
/**选择按钮*/
@property(nonatomic, strong) UIButton *chooseBtn;
@end

@implementation XKCheckTableViewCell

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
  
  /**选择按钮*/
  _chooseBtn = [[UIButton alloc] init];
  _chooseBtn.userInteractionEnabled = NO;
  [_chooseBtn setImage:IMG_NAME(@"xk_ic_contact_chose") forState:UIControlStateSelected];
  [_chooseBtn setImage:IMG_NAME(@"xk_ic_contact_nochose") forState:UIControlStateNormal];
  [_chooseBtn setImage:IMG_NAME(@"xk_ic_contact_cannotChose") forState:UIControlStateDisabled];
  [self.contentView addSubview:_chooseBtn];
  
  /**名字*/
  _nameLabel = [[UILabel alloc] init];;
  _nameLabel.textColor = HEX_RGB(0x222222);
  _nameLabel.font = XKRegularFont(14);
  [self.contentView addSubview:_nameLabel];
}

#pragma mark - 布局界面
- (void)createConstraints {
  [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView.mas_left).offset(10);
    make.width.equalTo(@30);
    make.height.equalTo(@40);
    make.centerY.equalTo(self.contentView);
  }];
  
  [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView.mas_left).offset(45);
    make.centerY.equalTo(self.contentView);
  }];
}


@end

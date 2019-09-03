/*******************************************************************************
 # File        : XKContactListCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/10
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKContactListCell.h"

@interface XKContactListCell () {
  UIView *_line;
}
/**选择视图*/
@property(nonatomic, strong) UIView *btnView;
/**图片*/
@property(nonatomic, strong) UIImageView *headerImgView;
/**名字*/
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *infoLabel;
@property(nonatomic, strong) UIButton *operationBtn;
@end

@implementation XKContactListCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    // 初始化默认数据
    [self createDefaultData];
    // 初始化界面
    [self createUI];
    // 布局界面
    [self createConstraints];
    
    _line = [UIView new];
    _line.backgroundColor = HEX_RGB(0xF1F1F1);
    [self addSubview:_line];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.right.bottom.equalTo(self);
      make.height.equalTo(@1);
    }];
  }
  return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
  
}

#pragma mark - 初始化界面
- (void)createUI {
  _myContentView = [[UIView alloc] init];
  _myContentView.backgroundColor = [UIColor whiteColor];
  [self addSubview:_myContentView];
  [_myContentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self);
  }];
  /**选择视图*/
  _btnView = [[UIView alloc] init];
  _btnView.clipsToBounds = YES;
  [self.myContentView addSubview:_btnView];
  /**选择按钮*/
  _chooseBtn = [[UIButton alloc] init];
  _chooseBtn.userInteractionEnabled = NO;
  [_chooseBtn setBackgroundImage:IMG_NAME(@"xk_ic_contact_chose") forState:UIControlStateSelected];
  [_chooseBtn setBackgroundImage:IMG_NAME(@"xk_ic_contact_nochose") forState:UIControlStateNormal];
  [_chooseBtn setBackgroundImage:IMG_NAME(@"xk_ic_contact_cannotChose") forState:UIControlStateDisabled];
  [_btnView addSubview:_chooseBtn];
  /**图片*/
  __weak typeof(self) weakSelf = self;
  _headerImgView = [[UIImageView alloc] init];
  _headerImgView.layer.masksToBounds = YES;
  _headerImgView.layer.cornerRadius = 4;
  _headerImgView.contentMode = UIViewContentModeScaleAspectFill;
  _headerImgView.userInteractionEnabled = NO;
  [_headerImgView bk_whenTapped:^{
    EXECUTE_BLOCK(weakSelf.headClick,weakSelf.indexPath,weakSelf.model);
  }];
  [self.myContentView addSubview:_headerImgView];
  /**名字*/
  _nameLabel = [[UILabel alloc] init];;
  _nameLabel.textColor = HEX_RGB(0x222222);
  _nameLabel.font = XKRegularFont(14);
  [self.myContentView addSubview:_nameLabel];
  /**信息*/
  _infoLabel = [[UILabel alloc] init];;
  _infoLabel.textColor = HEX_RGB(0x9999999);
  _infoLabel.font = XKRegularFont(14);
  [self.myContentView addSubview:_infoLabel];
  _operationBtn = [[UIButton alloc] init];
  _operationBtn.titleLabel.font = XKRegularFont(14);
  [_operationBtn setTitle:@"添加" forState:UIControlStateNormal];
  [_operationBtn setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
  _operationBtn.layer.cornerRadius = 6;
  _operationBtn.layer.borderColor = XKMainTypeColor.CGColor;
  _operationBtn.layer.borderWidth = 1;
  [_operationBtn addTarget:self action:@selector(operationBtnClick) forControlEvents:UIControlEventTouchUpInside];
  [self.myContentView addSubview:_operationBtn];
  _operationBtn.hidden = YES;
  _infoLabel.hidden = YES;
  //    _nameLabel.text = @"大大";
  //    _headerImgView.image = IMG_NAME(@"pic3.jpg");
}

#pragma mark - 布局界面
- (void)createConstraints {
  [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.bottom.equalTo(self.contentView);
    make.width.mas_equalTo(30*ScreenScale);
  }];
  [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.btnView);
    make.right.equalTo(self.btnView);
    make.size.mas_equalTo(CGSizeMake(18, 18));
  }];
  [_headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.btnView.mas_right).offset(15);
    make.centerY.equalTo(self.contentView);
    make.size.mas_equalTo(CGSizeMake(ScreenScale * 35, ScreenScale *35));
  }];
  [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.headerImgView.mas_right).offset(10 *ScreenScale);
    make.centerY.equalTo(self.contentView);
    make.right.equalTo(self.contentView.mas_right).offset(-10);
  }];
  [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.contentView.mas_right).offset(-45);
    make.centerY.equalTo(self.contentView);
  }];
  [_operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.infoLabel);
    make.size.mas_equalTo(CGSizeMake(60, 25));
  }];
  _infoLabel.hidden = YES;
  _operationBtn.hidden = YES;
  
}

#pragma mark ----------------------------- 公用方法 ------------------------------


- (void)setShowChooseBtn:(BOOL)showChooseBtn {
  if (showChooseBtn) {
    [_btnView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(30*ScreenScale);
    }];
  } else {
    [_btnView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.width.mas_equalTo(0);
    }];
  }
}

- (void)operationBtnClick {
  EXECUTE_BLOCK(self.operationClick,self.indexPath,self.model);
}

- (void)setModel:(XKContactModel *)model {
  _model = model;
  [_headerImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:kDefaultHeadImg];
  _nameLabel.text = model.nickname;
  if (model.friendRemark.length != 0) {
    _nameLabel.text = model.friendRemark;
  }
  if (model.selected) {
    if (model.defaultSelectedAndDisabale) {
      self.chooseBtn.enabled = NO;
    } else {
      self.chooseBtn.selected = YES;
    }
  } else {
    self.chooseBtn.enabled = YES;
    self.chooseBtn.selected = NO;
  }
}

- (void)setHideSeperate:(BOOL)hideSeperate {
  _line.hidden = hideSeperate;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.myContentView xk_forceClip];
}
@end

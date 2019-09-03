/*******************************************************************************
 # File        : XKNewFriendApplyCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/17
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKNewFriendApplyCell.h"

@interface XKNewFriendApplyCell ()
/**<##>*/
@property(nonatomic, strong) XKBaseHeadTitleDesView *infoView;
@property(nonatomic, strong) UILabel *infoLabel;
@property(nonatomic, strong) UIButton *operationBtn;

@end

@implementation XKNewFriendApplyCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    //        self.backgroundColor = [UIColor clearColor];
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
  self.infoView = [XKBaseHeadTitleDesView new];
  [self.contentView addSubview:self.infoView];
  [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.contentView);
  }];
  self.infoView.backgroundColor = [UIColor clearColor];
  self.infoView.imageView.userInteractionEnabled = YES;
  [self.infoView.imageView bk_whenTapped:^{
    EXECUTE_BLOCK(weakSelf.headClick,weakSelf.indexPath);
  }];
  /**信息*/
  _infoLabel = [[UILabel alloc] init];;
  _infoLabel.textColor = HEX_RGB(0x9999999);
  _infoLabel.font = XKRegularFont(14);
  _infoLabel.text = @"已通过";
  [self.contentView addSubview:_infoLabel];
  _operationBtn = [[UIButton alloc] init];
  _operationBtn.titleLabel.font = XKRegularFont(13);
  _operationBtn.backgroundColor = HEX_RGB(0xEE6161);
  [_operationBtn setTitle:@"接受" forState:UIControlStateNormal];
  [_operationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  _operationBtn.layer.cornerRadius = 5;
  [_operationBtn addTarget:self action:@selector(operationBtnClick) forControlEvents:UIControlEventTouchUpInside];
  [self.contentView addSubview:_operationBtn];
}

#pragma mark - 布局界面
- (void)createConstraints {
  //    __weak typeof(self) weakSelf = self;
  [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.contentView.mas_right).offset(-45);
    make.centerY.equalTo(self.contentView);
  }];
  [self.infoView.desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.infoView.timeLabel.mas_right).offset(-65);
  }];
  [_operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.infoLabel);
    make.size.mas_equalTo(CGSizeMake(60, XKViewSize(26)));
  }];
  _infoLabel.hidden = YES;
  _operationBtn.hidden = YES;
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)operationBtnClick {
  EXECUTE_BLOCK(self.operationClick,self.indexPath);
}

- (void)setModel:(XKNewFriendApplyInfo *)model {
  _model = model;
  self.infoView.titleLabel.text = model.nickname;
  self.infoView.desLabel.text = model.validateMsg;
  [self.infoView.imageView sd_setImageWithURL:kURL(model.avatar) placeholderImage:kDefaultHeadImg];
  if (model.isPass) {
    _operationBtn.hidden = YES;
    _infoLabel.hidden = NO;
  } else {
    _operationBtn.hidden = NO;
    _infoLabel.hidden = YES;
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.contentView xk_forceClip];
}

@end

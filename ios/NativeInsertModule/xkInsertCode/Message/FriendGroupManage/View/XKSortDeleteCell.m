/*******************************************************************************
 # File        : XKSortDeleteCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/9
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSortDeleteCell.h"

@interface XKSortDeleteCell ()

/**删除btn*/
@property(nonatomic, strong) UIButton *deleteBtn;
/**<##>*/
@property(nonatomic, strong) UILabel *titleLabel;
/**<##>*/
@property(nonatomic, strong) UIButton *sortBtn;
/**<##>*/


@end

@implementation XKSortDeleteCell

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
  /**删除btn*/
  _deleteBtn = [[UIButton alloc] init];
  [_deleteBtn setImage:IMG_NAME(@"xk_btn_subscription_delete") forState:UIControlStateNormal];
  [_deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
  [self.contentView addSubview:_deleteBtn];
  /**<##>*/
  _titleLabel = [[UILabel alloc] init];
  _titleLabel.textColor = RGBGRAY(51);
  _titleLabel.font = XKRegularFont(15);
  _titleLabel.text = @"11111";
  [self.contentView addSubview:_titleLabel];
  /**<##>*/
  _sortBtn = [[UIButton alloc] init];
  _sortBtn.adjustsImageWhenHighlighted=NO;
  [_sortBtn setImage:IMG_NAME(@"xk_btn_subscription_move") forState:UIControlStateNormal];
  [self.contentView addSubview:_sortBtn];
}

#pragma mark - 布局界面
- (void)createConstraints {
  [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView.mas_left).offset(10);
    make.width.equalTo(@30);
    make.height.equalTo(@40);
    make.centerY.equalTo(self.contentView);
  }];
  
  [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.left.equalTo(self.contentView.mas_left).offset(-45);
  }];
  
  [_sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.contentView.mas_right).offset(-10);
    make.centerY.equalTo(self.contentView);
    make.size.mas_equalTo(CGSizeMake(30, 25));
  }];
  
  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.contentView xk_forceClip];
}

#pragma mark ----------------------------- 公用方法 ------------------------------

- (void)setCanDelete:(BOOL)canDelete {
  _canDelete = canDelete;
  
  [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.left.mas_equalTo(self.contentView.mas_left).offset(canDelete ? 45 : 15);
  }];
  _deleteBtn.hidden = !canDelete;
  
}

- (void)delete {
  EXECUTE_BLOCK(self.deleteClick,self.indexPath);
}

@end

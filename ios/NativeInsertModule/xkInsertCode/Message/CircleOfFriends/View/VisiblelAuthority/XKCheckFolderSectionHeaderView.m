/*******************************************************************************
 # File        : XKCheckFolderSectionHeaderView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/16
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCheckFolderSectionHeaderView.h"
#import "UIView+Border.h"

@interface XKCheckFolderSectionHeaderView ()

/**checkBtn*/
@property(nonatomic, strong) UIButton *checkBtn;
/**title*/
@property(nonatomic, strong) UILabel *titleLabel;
/**des*/
@property(nonatomic, strong) UILabel *desLabel;
/**arrow*/
@property(nonatomic, strong) UIButton *arrowBtn;

@end

@implementation XKCheckFolderSectionHeaderView


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
    self.contentView.backgroundColor = [UIColor whiteColor];
    /**checkBtn*/
    _checkBtn = [[UIButton alloc] init];
    _checkBtn.userInteractionEnabled = NO;
    [_checkBtn setImage:IMG_NAME(@"xk_ic_contact_nochose") forState:UIControlStateNormal];
    [_checkBtn setImage:IMG_NAME(@"xk_ic_contact_chose") forState:UIControlStateSelected];
    [self.contentView addSubview:_checkBtn];
    /**title*/
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = XKMediumFont(14);
    _titleLabel.textColor = HEX_RGB(0x222222);
    [self.contentView addSubview:_titleLabel];
    /**des*/
    _desLabel = [UILabel new];
    _desLabel.font = XKRegularFont(14);
    _desLabel.textColor = HEX_RGB(0x777777);
    [self.contentView addSubview:_desLabel];
    /**arrow*/
    _arrowBtn = [[UIButton alloc] init];
    [_arrowBtn setImage:IMG_NAME(@"xk_ic_login_down_arrow") forState:UIControlStateNormal];
    [_arrowBtn setImage:IMG_NAME(@"xk_ic_login_up_arrow") forState:UIControlStateSelected];
    [self.contentView addSubview:_arrowBtn];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_top).offset(27.5);
        make.centerX.equalTo(self.contentView.mas_left).offset(15 + 9);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkBtn);
        make.left.equalTo(self.contentView.mas_left).offset(40);
    }];
    
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
    }];
    
    [_arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.desLabel);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.right.equalTo(self.contentView.mas_right).offset(-17);
    }];
    
    [self.contentView showBorderSite:rzBorderSitePlaceTop];
    self.contentView.topBorder.borderLine.backgroundColor = HEX_RGB(0xF1F1F1);
    
    __weak typeof(self) weakSelf = self;
    [self.contentView bk_whenTapped:^{
        EXECUTE_BLOCK(weakSelf.clickBlock,weakSelf.section);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setInfo:(XKVisiblelAuthorityInfo *)info {
    _info = info;
    _titleLabel.text = info.title;
    _desLabel.text = info.describe;
    _checkBtn.selected = info.selected;
    _arrowBtn.selected = info.selected;
  if ([info.title isEqualToString:@"公开"] || [info.title isEqualToString:@"私密"]) {
    _arrowBtn.hidden = YES;
  } else {
    _arrowBtn.hidden = NO;
  }
}

@end

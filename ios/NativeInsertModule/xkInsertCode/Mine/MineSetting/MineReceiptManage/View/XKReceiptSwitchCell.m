/*******************************************************************************
 # File        : XKReceiptSwitchCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKReceiptSwitchCell.h"

@interface XKReceiptSwitchCell ()
/**switch*/
@property(nonatomic, strong) UISwitch *defaultSwitch;
@end

@implementation XKReceiptSwitchCell

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
    self.defaultSwitch = [[UISwitch alloc] init];
    [self.contentView addSubview:self.defaultSwitch];
    [self.defaultSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - 布局界面
- (void)createConstraints {
//    __weak typeof(self) weakSelf = self;

}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setModel:(XKReceiptInfoModel *)model {
    [super setModel:model];
    self.defaultSwitch.on = model.isDefault;
    __weak typeof(self) weakSelf = self;
    [self.defaultSwitch bk_addEventHandler:^(id sender) {
        weakSelf.model.isDefault = weakSelf.defaultSwitch.on;
    } forControlEvents:UIControlEventValueChanged];
}


@end

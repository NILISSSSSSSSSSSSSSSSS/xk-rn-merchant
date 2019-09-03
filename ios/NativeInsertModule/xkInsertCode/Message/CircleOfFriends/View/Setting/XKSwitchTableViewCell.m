/*******************************************************************************
 # File        : XKSwitchTableViewCell.m
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

#import "XKSwitchTableViewCell.h"
#import "XKSectionHeaderSwithView.h"

@interface XKSwitchTableViewCell ()
/**<##>*/
@property(nonatomic, strong) XKSectionHeaderSwithView *switchView;
@end

@implementation XKSwitchTableViewCell

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
    _switchView = [XKSectionHeaderSwithView new];
    [self.contentView addSubview:_switchView];
    [_switchView.mySwitch addTarget:self action:@selector(switchClickAction:)
                forControlEvents:UIControlEventValueChanged];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)switchClickAction:(UISwitch *)myswitch {
    EXECUTE_BLOCK(self.switchClick,myswitch.isOn)
}
@end

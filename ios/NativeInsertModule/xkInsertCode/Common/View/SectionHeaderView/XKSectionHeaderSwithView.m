/*******************************************************************************
 # File        : XKSectionHeaderSwithView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/10
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSectionHeaderSwithView.h"

@interface XKSectionHeaderSwithView ()

@end

@implementation XKSectionHeaderSwithView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = HEX_RGB(0x222222);
    _titleLabel.font = XKRegularFont(14);
    [self addSubview:_titleLabel];
    
    _mySwitch = [[UISwitch alloc] init];
    [self addSubview:_mySwitch];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [_mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------


@end


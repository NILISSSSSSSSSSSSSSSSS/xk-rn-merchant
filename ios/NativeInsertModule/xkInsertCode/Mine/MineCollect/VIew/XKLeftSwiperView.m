/*******************************************************************************
 # File        : XKLeftSwiperView.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/14
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKLeftSwiperView.h"

@interface XKLeftSwiperView ()

@end

@implementation XKLeftSwiperView

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

}

#pragma mark - 布局界面
- (void)createConstraints {


}

#pragma mark ----------------------------- 公用方法 ------------------------------


@end

/*******************************************************************************
 # File        : XKSecretTipCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSecretTipCell.h"

@interface XKSecretTipCell ()

@end

@implementation XKSecretTipCell

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
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {

}

#pragma mark - 初始化界面
- (void)createUI {
    self.infoView = [XKBaseHeadTitleDesView new];
    [self.contentView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}



#pragma mark ----------------------------- 公用方法 ------------------------------

@end

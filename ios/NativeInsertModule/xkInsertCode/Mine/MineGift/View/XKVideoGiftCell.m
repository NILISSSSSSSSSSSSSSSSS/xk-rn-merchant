/*******************************************************************************
 # File        : XKVideoGiftCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/13
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKVideoGiftCell.h"
#import "XKGoodsView.h"

@interface XKVideoGiftCell ()


@end

@implementation XKVideoGiftCell

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
    
    _infoView = [[XKGoodsView alloc] init];
    _infoView.nameLabel.font = XKRegularFont(12);
    _infoView.layer.cornerRadius = 5;
    _infoView.infoLabel.numberOfLines = 2;
    _infoView.backgroundColor = HEX_RGB(0xF8F8F8F8);
    [self.containView addSubview:_infoView];
    __weak typeof(self) weakSelf = self;
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView bk_whenTapped:^{
        [XKGlobleCommonTool jumpUserInfoCenter:weakSelf.topUser vc:nil];
    }];
    self.infoView.nameLabel.userInteractionEnabled = YES;
    [self.infoView.nameLabel bk_whenTapped:^{
        [XKGlobleCommonTool jumpUserInfoCenter:weakSelf.btmUser vc:nil];
    }];
    [self.infoView bk_whenTapped:^{
        EXECUTE_BLOCK(weakSelf.infoViewClick,weakSelf.indexPath);
    }];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(16);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.containView.mas_right).offset(-15);
        make.bottom.equalTo(self.containView.mas_bottom).offset(-15);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------

@end

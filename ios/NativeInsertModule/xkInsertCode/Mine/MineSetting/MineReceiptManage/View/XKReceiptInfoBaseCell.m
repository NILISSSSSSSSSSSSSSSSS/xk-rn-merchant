/*******************************************************************************
 # File        : XKReceiptInfoBaseCell.m
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

#import "XKReceiptInfoBaseCell.h"
#import "XKReceiptInfoModel.h"

@interface XKReceiptInfoBaseCell ()
/**<##>*/
@property(nonatomic, strong) UILabel *starLabel;
/**btmLine*/
@property(nonatomic, strong) UIView *btmLine;
@end

@implementation XKReceiptInfoBaseCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化默认数据
        [self createBaseDefaultData];
        // 初始化界面
        [self createBaseUI];
        // 布局界面
        [self createBaseConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createBaseDefaultData {
    
}

#pragma mark - 初始化界面
- (void)createBaseUI {
    self.starLabel = [UILabel new];
    self.starLabel.text = @"*";
    self.starLabel.textColor = [UIColor redColor];
    self.starLabel.font = XKRegularFont(16);
    [self.contentView addSubview:self.starLabel];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = HEX_RGB(0x222222);
    self.titleLabel.font = XKRegularFont(14);
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.titleLabel];
    [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView).offset(2);
        make.width.mas_equalTo(10 * ScreenScale);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.starLabel.mas_right).offset(1);
        make.width.mas_equalTo(60 * ScreenScale);
    }];
    
    self.btmLine = [UIView new];
    [self.contentView addSubview:self.btmLine];
    self.btmLine.backgroundColor = RGBGRAY(235);
    [self.btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = frame.origin.x + 10;
    frame.size.width = frame.size.width - 20;
    [super setFrame:frame];
}

#pragma mark - 布局界面
- (void)createBaseConstraints {
//    __weak typeof(self) weakSelf = self;
    
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setConfig:(XKReceiptInfoDataConfig *)config {
    _config = config;
    self.titleLabel.text = config.title;
    self.starLabel.hidden = !config.hasStar;
}

- (void)setModel:(XKReceiptInfoModel *)model {
    _model = model;
}

- (void)setHideSeperate:(BOOL)hideSeperate {
    self.btmLine.hidden = hideSeperate;
}


@end

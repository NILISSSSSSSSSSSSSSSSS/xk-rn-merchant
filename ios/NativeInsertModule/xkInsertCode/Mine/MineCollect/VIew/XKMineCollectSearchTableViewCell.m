/*******************************************************************************
 # File        : XKMineCollectSearchTableViewCell.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKMineCollectSearchTableViewCell.h"

@interface XKMineCollectSearchTableViewCell ()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIView *line;

@end

@implementation XKMineCollectSearchTableViewCell

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
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.line];
}

- (void)setLabelText:(NSString *)labelText {
    _labelText = labelText;
    self.label.text = labelText;
    if ([labelText isEqualToString:@"最近搜索"]) {
        self.imageV.hidden = YES;
        [self.imageV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-20);
        }];
        self.label.font = XKFont(XK_PingFangSC_Regular, 15);
        self.label.textColor = [UIColor blackColor];
    }
    else{
        self.imageV.hidden = NO;
    }
}
#pragma mark - 布局界面
- (void)createConstraints {
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(15);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.imageV.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------

- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        _imageV.backgroundColor = [UIColor redColor];
    }
    return _imageV;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = HEX_RGB(0x999999);
        _label.font = XKFont(XK_PingFangSC_Regular, 14);
    }
    return _label;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = XKSeparatorLineColor;
    }
    return _line;
}

- (void)setFrame:(CGRect)frame {
    frame.size.width -= 20;
    frame.origin.x += 10;
    [super setFrame:frame];
}
@end

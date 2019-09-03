/*******************************************************************************
 # File        : XKCommonDiyHeadView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/4
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKCommonDiyHeadView.h"

@interface XKCommonDiyHeadView ()
/**标题*/
@property(nonatomic, strong) UILabel *titleLabel;
/**箭头*/
@property(nonatomic, strong) UIImageView *arrowImgView;
/**右label*/
@property(nonatomic, strong) UILabel *contentLabel;
/**分割线*/
@property(nonatomic, strong) UIView *seperateLine;

@end

@implementation XKCommonDiyHeadView

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
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = XKRegularFont(15);
    self.titleLabel.textColor = RGBGRAY(100);
    [self addSubview:self.titleLabel];
    self.arrowImgView = [[UIImageView alloc] init];
    self.arrowImgView.image = [UIImage imageNamed:kRightBlackArrowImgName];
    [self addSubview:self.arrowImgView];
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = XKRegularFont(17);
    self.contentLabel.textColor = [UIColor redColor];
    [self addSubview:self.contentLabel];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.bottom.equalTo(self);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.bottom.equalTo(self);
    }];
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(10, 16));
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setShowSeparateLine:(BOOL)showSeparateLine {
    if (showSeparateLine) {
        self.seperateLine.hidden = NO;
    } else {
        self.seperateLine.hidden = YES;
    }
}

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = RGBGRAY(240);
        [self addSubview:_seperateLine];
        [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return _seperateLine;
}

@end

/*******************************************************************************
 # File        : XKSectionHeaderArrowView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/8
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSectionHeaderArrowView.h"

@interface XKSectionHeaderArrowView ()
/**图片*/
@property(nonatomic, strong) UIImageView *leftImageView;
/**标题*/
@property(nonatomic, strong) UILabel *titleLabel;
/**箭头文字*/
@property(nonatomic, strong) UILabel *detailLabel;
/**箭头*/
@property(nonatomic, strong) UIImageView *arrowImgView;
@end

@implementation XKSectionHeaderArrowView

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
    _leftImageView = [[UIImageView alloc] init];
    _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_leftImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = HEX_RGB(0x222222);
    _titleLabel.font = XKRegularFont(14);
    [self addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.textColor = HEX_RGB(0x444444);
    _detailLabel.font = XKRegularFont(14);
    [self addSubview:_detailLabel];
    
    _arrowImgView = [[UIImageView alloc] init];
    _arrowImgView.image = IMG_NAME(kRightGrayArrowImgName);
    [self addSubview:_arrowImgView];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    _detailLabel.textAlignment = NSTextAlignmentRight;
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(100);
        make.right.equalTo(self.arrowImgView.mas_left).offset(-4);
    }];
    
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setLeftImage:(UIImage *)leftImage {
    _leftImageView.image = leftImage;
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(leftImage.size.width, leftImage.size.height));
    }];
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(15);
        make.centerY.equalTo(self);
    }];
}

@end

/*******************************************************************************
 # File        : XKGoodsView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/11
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGoodsView.h"

@interface XKGoodsView ()
/**图片*/
@property(nonatomic, strong) UIImageView *imgView;
/**商品名字*/
@property(nonatomic, strong) UILabel *nameLabel;
/**规格*/
@property(nonatomic, strong) UILabel *infoLabel;
@property(nonatomic, strong) UIImageView *smallImgView;

@end

@implementation XKGoodsView

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
    /**图片*/
    _imgView = [[UIImageView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.layer.cornerRadius = 6;
    _imgView.backgroundColor = [UIColor whiteColor];
//    _imgView.layer.borderColor = HEX_RGB(0xE7E7E7).CGColor;
//    _imgView.layer.borderWidth = 1;
    _imgView.layer.masksToBounds = YES;
    [self addSubview:_imgView];
    /**商品名字*/
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = XKRegularFont(10);
    _nameLabel.numberOfLines = 0;
    _nameLabel.textColor = HEX_RGB(0x222222);
    [self addSubview:_nameLabel];
    /**规格*/
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.numberOfLines = 0;
    _infoLabel.textColor = HEX_RGB(0x999999);
    _infoLabel.font = XKRegularFont(10);
    [self addSubview:_infoLabel];
    //
    _smallImgView = [[UIImageView alloc] init];
    _smallImgView.contentMode = UIViewContentModeScaleAspectFill;
    _smallImgView.image = IMG_NAME(@"xk_ic_middlePlay");
    [self addSubview:_smallImgView];
    _smallImgView.hidden = YES;
}

#pragma mark - 布局界面
- (void)createConstraints {
    /**图片*/
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(48 *ScreenScale, 48*ScreenScale));
        make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-10);
    }];;
    /**商品名字*/
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top).offset(2);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-6);
    }];
    /**规格*/
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        make.right.equalTo(self.mas_right).offset(-20);
        make.left.equalTo(self.nameLabel);
        make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-10);
    }];
    
    [_smallImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imgView);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];

}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)setShowSmallImg:(BOOL)showSmallImg {
    _showSmallImg = showSmallImg;
    _smallImgView.hidden = !showSmallImg;
}

@end

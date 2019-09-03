/*******************************************************************************
 # File        : XKBaseHeadTitleDesView.m
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

#import "XKBaseHeadTitleDesView.h"

@interface XKBaseHeadTitleDesView ()

@end

@implementation XKBaseHeadTitleDesView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化默认数据
        [self createSuperDefaultData];
        // 初始化界面
        [self createSuperUI];
        // 布局界面
        [self createSuperConstraints];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createSuperDefaultData {

}

#pragma mark - 初始化界面
- (void)createSuperUI {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.desLabel];
    [self addSubview:self.timeLabel];
}

#pragma mark - 布局界面
- (void)createSuperConstraints {
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(48 * 1, 48 * 1));
    }];
    _imageView.layer.cornerRadius = 5;
    _imageView.layer.masksToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-15 * ScreenScale);
        make.top.mas_equalTo(self.mas_top).offset(10 * 1);
        make.height.mas_equalTo(20 * 1);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_imageView.mas_top);
        make.bottom.mas_equalTo(self->_imageView.mas_centerY);
        make.left.mas_equalTo(self->_imageView.mas_right).offset(12.5 * ScreenScale);
        make.right.mas_equalTo(self.mas_right).offset(- SCREEN_WIDTH / 4);
    }];
    
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_imageView.mas_centerY);
        make.bottom.mas_equalTo(self->_imageView.mas_bottom);
        make.left.mas_equalTo(self->_titleLabel.mas_left);
        make.right.mas_equalTo(self->_timeLabel.mas_right);
    }];
    
}

#pragma mark ----------------------------- 公用方法 ------------------------------

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50 * 1, 50 * 1)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}


-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor whiteColor]];
        _timeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _timeLabel;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor whiteColor]];
        _desLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _desLabel;
}


@end

/*******************************************************************************
 # File        : XKFriendCircleNewTipView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/11/30
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendCircleNewTipView.h"

@interface XKFriendCircleNewTipView ()

/**<##>*/
@property(nonatomic, strong) UIView *containView;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *label;

@end

@implementation XKFriendCircleNewTipView

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
    _containView = [UIView new];
    _containView.backgroundColor = [UIColor whiteColor];
    _containView.layer.cornerRadius = 4;
    _containView.clipsToBounds = YES;
    [self addSubview:_containView];
    
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom);
    }];
    __weak typeof(self) weakSelf = self;
    [_containView bk_whenTapped:^{
        EXECUTE_BLOCK(weakSelf.click);
    }];
    
    _iconImageView = [UIImageView new];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 4;
    [self.containView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(6);
        make.top.equalTo(self.containView.mas_top).offset(6);
        make.bottom.equalTo(self.containView.mas_bottom).offset(-6);
        make.width.equalTo(self.iconImageView.mas_height);
    }];
    
    _label = [[UILabel alloc] init];
    _label.textColor = XKMainTypeColor;
    _label.tintColor = XKMainTypeColor;
    _label.font = XKNormalFont(14);
    [self.containView addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(25);
        make.right.equalTo(self.containView.mas_right).offset(-12);
        make.centerY.equalTo(self.containView);
    }];
}

#pragma mark - 布局界面
- (void)createConstraints {
   // __weak typeof(self) weakSelf = self;
    
}

- (void)updateUI:(XKUnReadTip *)model {
    [_iconImageView sd_setImageWithURL:kURL(model.avatar) placeholderImage:kDefaultHeadImg];
    [_label rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
        confer.text([NSString stringWithFormat:@"%ld条新消息  ",model.count]);
        confer.appendImage([[UIImage imageNamed:@"xk_bg_IM_function_arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]).bounds(CGRectMake(0, -1, 11, 11));
    }];
}



#pragma mark ----------------------------- 公用方法 ------------------------------

@end

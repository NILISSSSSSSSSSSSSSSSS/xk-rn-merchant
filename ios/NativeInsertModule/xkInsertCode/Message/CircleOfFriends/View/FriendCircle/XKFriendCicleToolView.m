/*******************************************************************************
 # File        : XKFriendCicleToolView.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/17
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKFriendCicleToolView.h"

@interface XKFriendCicleToolView ()


@end

@implementation XKFriendCicleToolView

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
    /**信息视图*/
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.textColor = HEX_RGB(0xADADAD);
    _infoLabel.font = XKRegularFont(10);
    _infoLabel.numberOfLines = 2;
    [self addSubview:_infoLabel];
    /**礼物*/
//    _giftButton = [[UIButton alloc] init];
//    [_giftButton setImage:IMG_NAME(@"ic_btn_msg_circle_Gift") forState:UIControlStateNormal];
//    [self addSubview:_giftButton];
//    _giftButton.hidden = YES;
    /**点赞*/
    _favorButton = [[UIButton alloc] init];
    [_favorButton setImage:IMG_NAME(@"ic_btn_msg_circle_noLike") forState:UIControlStateNormal];
    [_favorButton setImage:IMG_NAME(@"ic_btn_msg_circle_Like") forState:UIControlStateSelected];
    [self addSubview:_favorButton];
    /**评论*/
    _commentButton = [[UIButton alloc] init];
    [_commentButton setImage:IMG_NAME(@"ic_btn_msg_circle_Comment") forState:UIControlStateNormal];
    [self addSubview:_commentButton];
    
    
    _authBtn = [[UIButton alloc] init];
    [_authBtn setImage:IMG_NAME(@"xk_ic_auth_cicrle") forState:UIControlStateNormal];
    _authBtn.userInteractionEnabled = NO;
    [self addSubview:_authBtn];
    
    _deleteBtn = [[UIButton alloc] init];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = XKRegularFont(12);
    [self addSubview:_deleteBtn];
}

#pragma mark - 布局界面
- (void)createConstraints {
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(1);
        make.left.equalTo(self.mas_left);
        make.height.greaterThanOrEqualTo(self.commentButton);
    }];
    NSArray *btnsArr = @[_commentButton, _favorButton];
    UIButton *tmpBtn;
    for (int i = 0 ; i < btnsArr.count; i ++) {
        UIButton *btn = btnsArr[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tmpBtn ? tmpBtn.mas_left : self.mas_right);
            make.size.mas_equalTo(CGSizeMake(36 * ScreenScale, 18 * ScreenScale));
            if (i == 1) {
                make.bottom.equalTo(self.mas_bottom).offset(1);
            } else {
                make.bottom.equalTo(self.mas_bottom);
            }
            if (btn) {
                make.top.equalTo(btn.mas_top);
            } else {
                make.top.greaterThanOrEqualTo(self.mas_top);
            }
        }];
        tmpBtn = btn;
    }
    
    
    [_authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tmpBtn).offset(2);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.left.equalTo(self.infoLabel.mas_right).offset(0);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tmpBtn).offset(1.5);
        make.size.mas_equalTo(CGSizeMake(35, 20));
        make.left.equalTo(self.authBtn.mas_right).offset(0);
    }];
    [_authBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0);
    }];
}

- (void)clearConsError {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

#pragma mark ----------------------------- 公用方法 ------------------------------

@end

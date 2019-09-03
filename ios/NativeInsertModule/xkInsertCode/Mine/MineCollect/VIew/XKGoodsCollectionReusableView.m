/*******************************************************************************
 # File        : XKGoodsCollectionReusableView.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/27
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKGoodsCollectionReusableView.h"
#import "XKDropDownButton.h"
@interface XKGoodsCollectionReusableView()
@property(nonatomic, strong) UIButton *autotrophyButton;
@property(nonatomic, strong) UIButton *businessButton;


@end
@implementation XKGoodsCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        XKDropDownButton * button = [[XKDropDownButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
        button.title = @"全部分类";
        button.imageName = @"xk_icon_search_down";
        [button addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
        self.dropDownButton = button;
        UIButton *rbutton = [self setSectionHeaderRightButton];
        UIButton *autotrophyButton = [self creatButtonWithTitle:@"自营商品" Sel:@selector(autotrophyButtonClick:)];
        [autotrophyButton setTitleColor:HEX_RGB(0x4A90FA) forState:UIControlStateNormal];

        autotrophyButton.layer.borderColor = HEX_RGB(0x4A90FA).CGColor;
        UIButton *businessButton = [self creatButtonWithTitle:@"商圈商品" Sel:@selector(businessButtonClick:)];
        [businessButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];

        businessButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
        [self addSubview:button];
        [self addSubview:rbutton];
        [self addSubview:autotrophyButton];
        [self addSubview:businessButton];
        [autotrophyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button.mas_right).offset(20);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(22);
            make.width.mas_equalTo(70);
        }];
        
        [businessButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(autotrophyButton.mas_right).offset(20);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(22);
            make.width.mas_equalTo(70);
        }];
        
        [rbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-25);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(15);
        }];
        self.autotrophyButton = autotrophyButton;
        self.businessButton = businessButton;
    }
    return self;
}

- (UIButton *)setSectionHeaderRightButton {
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"xk_btn_collection-vertical"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"xk_btn_collection-across"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(headerRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.layoutButton = button;
    return button;
}

- (UIButton *)creatButtonWithTitle:(NSString *)title Sel:(SEL)sel  {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = 0.5 ;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius  = 12;
    button.titleLabel.font = XKFont(XK_PingFangSC_Regular, 12);
    return button;
}

- (void)headerRightButtonAction:(UIButton *)sender {
    EXECUTE_BLOCK(self.layoutChangeBlock,sender);
}

- (void)headerAction:(XKDropDownButton *)sender {
    EXECUTE_BLOCK(self.dropDownButtonBlock,sender);
}

- (void)autotrophyButtonClick:(UIButton *)sender {
    
    sender.layer.borderColor = HEX_RGB(0x4A90FA).CGColor;
    [sender setTitleColor:HEX_RGB(0x4A90FA) forState:UIControlStateNormal];
    [self.businessButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
    self.businessButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
    EXECUTE_BLOCK(self.autotrophyButtonBlock,sender);

}

- (void)businessButtonClick:(UIButton *)sender {
    sender.layer.borderColor = HEX_RGB(0x4A90FA).CGColor;
    [sender setTitleColor:HEX_RGB(0x4A90FA) forState:UIControlStateNormal];
    self.autotrophyButton.layer.borderColor = HEX_RGB(0x999999).CGColor;
    [self.autotrophyButton setTitleColor:HEX_RGB(0x999999) forState:UIControlStateNormal];
    EXECUTE_BLOCK(self.businessButtonBlock,sender);
}

- (void)setGoodsButtonHidden:(BOOL)hidden {
    self.businessButton.hidden = hidden;
    self.autotrophyButton.hidden = hidden;
}
@end

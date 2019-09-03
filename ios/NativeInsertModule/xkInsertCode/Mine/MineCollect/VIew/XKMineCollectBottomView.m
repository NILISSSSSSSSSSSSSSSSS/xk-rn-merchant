/*******************************************************************************
 # File        : XKMineCollectBottomView.m
 # Project     : XKSquare
 # Author      : Lin Li
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

#import "XKMineCollectBottomView.h"

@interface XKMineCollectBottomView ()
/**全选/反选*/
@property (nonatomic, strong)UIButton *choseBtn;
/**删除*/
@property (nonatomic, strong)UIButton *deleteBtn;
/**分享*/
@property (nonatomic, strong)UIButton *shareBtn;
@end

@implementation XKMineCollectBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.choseBtn];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.shareBtn];
}

- (void)addUIConstraint {
    [self.choseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight));
        make.width.mas_equalTo(80);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight + 10));
        make.width.mas_equalTo(80);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteBtn.mas_left).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-(kBottomSafeHeight + 10));
        make.width.mas_equalTo(80);
    }];
}

- (UIButton *)choseBtn {
    if(!_choseBtn) {
        _choseBtn = [[UIButton alloc] init];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_buyCar_unchose"] forState:0];
        [_choseBtn setImage:[UIImage imageNamed:@"xk_icon_snatchTreasure_order_chose"] forState:UIControlStateSelected];
        _choseBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 23, 0, 15);
        _choseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_choseBtn setTitle:@"全选" forState:0];
        [_choseBtn setTitle:@"全选" forState:UIControlStateSelected];
        _choseBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
        [_choseBtn addTarget:self action:@selector(choseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_choseBtn setTitleColor:UIColorFromRGB(0x777777) forState:0];
        [_choseBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateSelected];
    }
    return _choseBtn;
}

- (UIButton *)deleteBtn {
    if(!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:0];
        _deleteBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_deleteBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        [_deleteBtn setBackgroundColor:UIColorFromRGB(0xffffff)];
        _deleteBtn.layer.cornerRadius = 10.f;
        _deleteBtn.layer.borderWidth = 0.1;
        _deleteBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.layer.masksToBounds = YES;
    }
    return _deleteBtn;
}

- (UIButton *)shareBtn {
    if(!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setTitle:@"分享" forState:0];
        _shareBtn.hidden = YES;
        _shareBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        [_shareBtn setTitleColor:UIColorFromRGB(0xee6161) forState:0];
        [_shareBtn setBackgroundColor:UIColorFromRGB(0xffffff)];
        _shareBtn.layer.cornerRadius = 10.f;
        _shareBtn.layer.borderWidth = 0.1;
        _shareBtn.layer.borderColor = UIColorFromRGB(0xee6161).CGColor;
        [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.layer.masksToBounds = YES;
    }
    return _shareBtn;
}

- (void)shareBtnClick:(UIButton *)sender {
    if(self.shareBlock) {
        self.shareBlock(sender);
    }
}
- (void)deleteBtnClick:(UIButton *)sender {
    if(self.deleteBlock) {
        self.deleteBlock(sender);
    }
}

- (void)choseBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(self.choseBlock) {
        self.choseBlock(sender);
    }
}

- (void)setAllSelected:(BOOL)allSelected {
    _choseBtn.selected = allSelected;
}

@end


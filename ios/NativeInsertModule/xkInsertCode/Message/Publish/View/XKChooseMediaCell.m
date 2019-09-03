/*******************************************************************************
 # File        : XKChooseMediaCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/8
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKChooseMediaCell.h"
@interface XKChooseMediaCell ()

@property (nonatomic, strong)UIView *containView;
@end

@implementation XKChooseMediaCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.containView];
    [self.containView addSubview:self.iconImgView];
    [self.contentView addSubview:self.deleteBtn];
}

- (void)addUIConstraint {
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
        make.left.equalTo(self.contentView.mas_left);
        make.width.equalTo(self.containView.mas_height);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.containView);
        make.bottom.equalTo(self.containView.mas_bottom);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(22);
        make.top.right.equalTo(self.contentView);
    }];
    _deleteBtn.alpha = 0;
}

- (void)setShowText:(BOOL)showText {
    _showText = showText;
    if (_showText) {
        self.textLabel.hidden = NO;
    } else {
        self.textLabel.hidden = YES;
    }
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        [self.containView addSubview:_textLabel];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = XKNormalFont(12);
        _textLabel.textColor = RGBGRAY(51);
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.containView);
            make.width.equalTo(self.containView);
            make.top.equalTo(self.iconImgView.mas_bottom).offset(4);
        }];
    }
    return _textLabel;
}

- (void)setWithoutDelte:(BOOL)withoutDelte {
    _withoutDelte = withoutDelte;
    [self.containView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    _deleteBtn.hidden = YES;
}

- (void)deleteBtnClick:(UIButton *)sender {
    if(self.deleteClick) {
        if (self.deleteBtn.isHidden) {
            return;
        }
        self.iconImgView.image = nil;
        self.deleteBtn.alpha = 0;
        self.deleteClick(sender,self.indexPath);
    }
}

- (UIImageView *)iconImgView {
    if(!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgView)];
        //        [_iconImgView addGestureRecognizer:tap];
        _iconImgView.image = [UIImage imageNamed:@"xk_btn_friendsCirclePermissions_add"];
        _iconImgView.userInteractionEnabled = YES;
        _iconImgView.layer.cornerRadius = 5;
        _iconImgView.clipsToBounds = YES;
    }
    return _iconImgView;
}

- (UIButton *)deleteBtn {
    if(!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"xk_btn_welfare_delete"] forState:0];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIView *)containView {
    if(!_containView) {
        _containView = [[UIView alloc] init];
        _containView.backgroundColor = [UIColor clearColor];
    }
    return _containView;
}
@end


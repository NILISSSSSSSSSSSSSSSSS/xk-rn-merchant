//
//  XKPickImgCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPickImgCell.h"
@interface XKPickImgCell ()

@property (nonatomic, strong)UIView *containView;
@end

@implementation XKPickImgCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.xk_clipType = YES;
        self.xk_radius = 5;
        self.xk_clipType = XKCornerClipTypeAllCorners;
        self.clipsToBounds = YES;
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
        make.left.top.equalTo(self.contentView).offset(8);
        make.right.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.containView);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.top.equalTo(self.iconImgView).offset(-10);
        make.right.equalTo(self.iconImgView).offset(10);
    }];
    _deleteBtn.alpha = 0;
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
        _iconImgView.image = [UIImage imageNamed:@"xk_btn_order_addImg"];
        _iconImgView.userInteractionEnabled = YES;
        _iconImgView.clipsToBounds = YES;
        _iconImgView.layer.cornerRadius = 5;
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

- (UIButton *)playBtn {
    if (!_playBtn) {
        UIButton *playBtn = [[UIButton alloc] init];
        [playBtn setBackgroundImage:IMG_NAME(@"xk_ic_middlePlay") forState:UIControlStateNormal];
        [self.containView addSubview:playBtn];
        playBtn.userInteractionEnabled = NO;
        [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.containView );
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        _playBtn = playBtn;
    }
    [self.containView bringSubviewToFront:_playBtn];
    return _playBtn;
}

@end

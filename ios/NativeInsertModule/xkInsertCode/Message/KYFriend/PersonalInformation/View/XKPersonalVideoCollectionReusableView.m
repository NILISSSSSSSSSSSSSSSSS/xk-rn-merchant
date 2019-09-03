//
//  XKPersonalVideoCollectionReusableView.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPersonalVideoCollectionReusableView.h"

@interface XKPersonalVideoCollectionReusableView()

@end

@implementation XKPersonalVideoCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createHeaderView];
    }
    return self;
}

- (void)createHeaderView {
    self.headerViewheight = 200;
    self.backImagYOffset = 0;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [self addSubview:headerView];
    [headerView bk_whenTapped:^{
        [KEY_WINDOW endEditing:YES];
    }];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.headerViewheight);
    _backImgView = [[UIImageView alloc] init];
    _backImgView.contentMode = UIViewContentModeScaleAspectFill;
    _backImgView.clipsToBounds = YES;
    self.backImagYOffset = 88;
    _backImgView.frame = CGRectMake(0, -self.backImagYOffset, SCREEN_WIDTH, self.backImagYOffset + headerView.height);
    _backImgView.userInteractionEnabled = YES;
    [_backImgView bk_whenTapped:^{
        [KEY_WINDOW endEditing:YES];
    }];
    
    [headerView addSubview:_backImgView];
    WEAK_TYPES(_backImgView)
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *guassView = [[UIVisualEffectView alloc] initWithEffect:blur];
    guassView.alpha = 0.98f;
    [headerView addSubview:guassView];
    [guassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weak_backImgView);
    }];
  
  UIView *shadowView = [[UIView alloc]init];
  shadowView.backgroundColor = HEX_RGBA(0x000000, 0.4);
  [headerView addSubview:shadowView];
  [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(weak_backImgView);
  }];
    
    UIImageView * headerImg = [[UIImageView alloc] init];
    _headerImg = headerImg;
    
    _headerImg.clipsToBounds = YES;
    _headerImg.layer.cornerRadius = 4;
    _headerImg.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:_headerImg];
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView.mas_bottom).offset(-12);
        make.size.mas_equalTo(CGSizeMake(66, 66));
        make.right.equalTo(headerView.mas_right).offset(-20);
    }];
    _headerImg.userInteractionEnabled = YES;
    [_headerImg bk_whenTapped:^{
        [KEY_WINDOW endEditing:YES];
    }];
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = XKMediumFont(17);
   
    [headerView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImg.mas_top).offset(5);
        make.right.equalTo(headerImg.mas_left).offset(-5);
    }];
    
    _shuoshuoLabel = [[UILabel alloc] init];
    _shuoshuoLabel.textColor = [UIColor whiteColor];
    _shuoshuoLabel.font = XKRegularFont(12);
    _shuoshuoLabel.textAlignment = NSTextAlignmentRight;
    _shuoshuoLabel.numberOfLines = 2;
   
    [headerView addSubview:_shuoshuoLabel];
    [_shuoshuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerImg.mas_bottom).offset(-2);
        make.right.equalTo(headerImg.mas_left).offset(-5);
        make.left.mas_equalTo(10);
    }];
}

@end

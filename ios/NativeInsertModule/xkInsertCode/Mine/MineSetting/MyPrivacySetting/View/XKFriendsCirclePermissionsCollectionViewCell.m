//
//  XKFriendsCirclePermissionsCollectionViewCell.m
//  XKSquare
//
//  Created by hupan on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKFriendsCirclePermissionsCollectionViewCell.h"
#import "XKContactModel.h"

@interface XKFriendsCirclePermissionsCollectionViewCell ()

@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *deleteImgView;

@end


@implementation XKFriendsCirclePermissionsCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self layoutViews];
    }
    
    return self;
}

- (void)initViews {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.deleteImgView];
}


- (void)layoutViews {
    
    [self.deleteImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-3);
        make.height.width.equalTo(@15);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
        make.height.equalTo(self.imgView.mas_width);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(3);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-3);
    }];
}


- (void)setValues:(XKContactModel *)model isDelete:(BOOL)isDelete {
    self.deleteImgView.hidden = !isDelete;
    
    if ([model.userId isEqualToString:@"delete"]) {
        self.nameLabel.text = @"";
        self.imgView.image = [UIImage imageNamed:@"xk_btn_friendsCirclePermissions_delete"];
    } else if ([model.userId isEqualToString:@"add"]) {
        self.nameLabel.text = @"";
        self.imgView.image = [UIImage imageNamed:@"xk_btn_friendsCirclePermissions_add"];
    } else {
        self.nameLabel.text = [model displayName];
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:kDefaultHeadImg];
    }
}

#pragma mark - Setters

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 2;
//        _nameLabel.text = @"张国荣！";
        _nameLabel.textColor = HEX_RGB(0x222222);
        _nameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    }
    
    return _nameLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
//        _imgView.backgroundColor = [UIColor greenColor];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 5;
    }
    return _imgView;
}

- (UIImageView *)deleteImgView {
    if (!_deleteImgView) {
        _deleteImgView = [[UIImageView alloc] init];
//        _deleteImgView.backgroundColor = [UIColor redColor];
        _deleteImgView.userInteractionEnabled = YES;
        _deleteImgView.image = [UIImage imageNamed:@"xk_btn_welfare_delete"];
    }
    return _deleteImgView;
}

@end

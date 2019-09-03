//
//  XKShareItemCollectionViewCell.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKShareItemCollectionViewCell.h"

#import "XKCustomShareView.h"

@interface XKShareItemCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation XKShareItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.imgView = [[UIImageView alloc] init];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.xk_radius = 20.0;
        self.imgView.xk_clipType = XKCornerClipTypeAllCorners;
        self.imgView.xk_openClip = YES;
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8.0);
            make.centerX.mas_equalTo(self.contentView);
            make.width.height.mas_equalTo(40.0 * ScreenScale);
        }];
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.font = XKRegularFont(10.0);
        self.titleLab.textColor = HEX_RGB(0x777777);
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imgView.mas_bottom).offset(4.0);
            make.leading.trailing.mas_equalTo(self.contentView);
            make.height.mas_equalTo(15.0);
        }];
    }
    return self;
}

- (void)configCellWithModel:(XKShareItemModel *)model {
    self.imgView.image = IMG_NAME(model.img);
    self.titleLab.text = model.title;
}

@end

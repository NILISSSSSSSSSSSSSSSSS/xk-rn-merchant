//
//  XKChooseCountyButton.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKChooseCountyButton.h"
@interface XKChooseCountyButton ()
@property (nonatomic, strong) UILabel     *xkLabel;
@property (nonatomic, strong) UIImageView *xkImageView;
@end

@implementation XKChooseCountyButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self titleLabel:frame];
        [self imageView:frame];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.xkLabel.text = title;
    CGRect tempFrame = self.xkLabel.frame;
    tempFrame.size.width = self.frame.size.width - 10;
    self.xkLabel.frame = tempFrame;
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.xkLabel.textColor = titleColor;
}

- (void)setImageName:(NSString *)imageName {
    self.xkImageView.image = [UIImage imageNamed:imageName];
}

- (void)titleLabel:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 10, frame.size.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12];
    [self addSubview:label];
    self.xkLabel = label;
}

- (void)imageView:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(7);
        make.height.offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.xkImageView = imageView;
}



@end

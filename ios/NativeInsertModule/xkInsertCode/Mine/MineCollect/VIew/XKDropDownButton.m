/*******************************************************************************
 # File        : XKDropDownButton.m
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKDropDownButton.h"

@interface XKDropDownButton ()
@property (nonatomic, strong) UILabel     *xkLabel;
@property (nonatomic, strong) UIImageView *xkImageView;
@end

@implementation XKDropDownButton
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
        make.width.offset(20);
        make.height.offset(20);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.xkImageView = imageView;
}



@end

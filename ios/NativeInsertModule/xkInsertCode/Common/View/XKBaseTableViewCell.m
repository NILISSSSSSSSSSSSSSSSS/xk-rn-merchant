/*******************************************************************************
 # File        : XKBaseTableViewCell.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/10
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKBaseTableViewCell.h"

@interface XKBaseTableViewCell () {
    UIView *_line;
}

@end

@implementation XKBaseTableViewCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addCustomSubviews];
        [self addUIConstraint];
        
        _line = [UIView new];
        _line.backgroundColor = HEX_RGB(0xF2F2F2);
        [self.contentView addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (void)addCustomSubviews {
    
}

- (void)addUIConstraint {
    
}
#pragma mark privite
- (void)layoutSubviews {
    [super layoutSubviews];
    [_bgContainView setNeedsLayout];
    [_bgContainView layoutIfNeeded];
}

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)hiddenSeperateLine:(BOOL)hidden {
    _line.hidden = hidden;
    [self.contentView bringSubviewToFront:_line];
}


#pragma mark lazy
- (UIView *)bgContainView {
    if (!_bgContainView) {
        _bgContainView = [[UIView alloc] init];
        _bgContainView.backgroundColor = [UIColor whiteColor];
    }
    return _bgContainView;
}
@end

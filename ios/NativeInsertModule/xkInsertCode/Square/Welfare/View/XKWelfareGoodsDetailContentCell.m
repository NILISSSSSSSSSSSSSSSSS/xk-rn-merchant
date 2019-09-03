//
//  XKWelfareGoodsDetailContentCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareGoodsDetailContentCell.h"
@interface XKWelfareGoodsDetailContentCell ()
@property (nonatomic, strong)UIImageView *detailImgView;
@end

@implementation XKWelfareGoodsDetailContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self.contentView addSubview:self.detailImgView];
}

- (void)addUIConstraint {
    
    [self.detailImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.right.bottom.equalTo(self.contentView).offset(-10);
    }];
}

- (UIImageView *)detailImgView {
    if(!_detailImgView) {
        _detailImgView = [[UIImageView alloc] init];
        _detailImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _detailImgView;
}


@end

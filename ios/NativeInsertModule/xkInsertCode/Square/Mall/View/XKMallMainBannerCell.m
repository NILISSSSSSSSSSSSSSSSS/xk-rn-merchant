//
//  XKMallMainBannerCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallMainBannerCell.h"

@interface XKMallMainBannerCell () <XKAutoScrollViewDelegate>

@end
@implementation XKMallMainBannerCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addCustomSubviews];
        [self addUIConstraint];
//        self.xk_openClip = YES;
//        self.xk_radius = 8;
//        self.xk_clipType = XKCornerClipTypeAllCorners;
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.loopView];
}

//- (void)bindData:(MallGoodsListItem *)item {
//    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:kDefaultPlaceHolderImg];
//    self.nameLabel.text = item.name;
//    self.sellLabel.text = [NSString stringWithFormat:@"月销量:%zd",item.saleQ];
//    self.priceLabel.text = [NSString stringWithFormat:@"¥%zd",item.price];
//}

- (void)addUIConstraint {
    [self.loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

- (XKAutoScrollView *)loopView {
    if (!_loopView) {
        _loopView = [[XKAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 155) delegate:self isShowPageControl:YES isAuto:YES];
//        [_loopView setScrollViewItems:@[@{@"image":@"http://imgsrc.baidu.com/imgad/pic/item/2e2eb9389b504fc2c80cdb11efdde71190ef6d56.jpg"},
//                                        @{@"image":@"http://imgsrc.baidu.com/imgad/pic/item/95eef01f3a292df58b13bb06b6315c6035a873d4.jpg"},
//                                        @{@"image":@"http://imgsrc.baidu.com/imgad/pic/item/14ce36d3d539b600e25f428ae250352ac65cb77e.jpg"},
//                                        @{@"image":@"http://imgsrc.baidu.com/imgad/pic/item/caef76094b36acaf41fc5eee76d98d1001e99c80.jpg"}]];
    }
    return _loopView;
}


- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didScrollIndex:(NSInteger)index {
    
}
- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didSelectItem:(XKAutoScrollImageItem *)item index:(NSInteger)index {
    
}

@end

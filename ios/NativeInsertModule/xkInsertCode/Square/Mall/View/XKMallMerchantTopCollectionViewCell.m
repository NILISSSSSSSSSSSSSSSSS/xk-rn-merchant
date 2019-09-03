//
//  XKMallMerchantTopCollectionViewCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallMerchantTopCollectionViewCell.h"
#import "XKCommonStarView.h"
#import "XKAutoScrollView.h"
#import "XKTradingAreaGoodsInfoModel.h"


@interface XKMallMerchantTopCollectionViewCell ()<XKAutoScrollViewDelegate>

@property (nonatomic, strong) XKAutoScrollView  *loopView;
@property (nonatomic, strong) UILabel           *indexLable;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *desLabel;
@property (nonatomic, strong) GoodsModel        *goodsModel;

@end


@implementation XKMallMerchantTopCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    
    [self.contentView addSubview:self.loopView];
    [self.loopView addSubview:self.indexLable];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.desLabel];
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutViews {
    
    [self.loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@(ScreenScale*180));
    }];
    
    [self.indexLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loopView).offset(-10);
        make.right.equalTo(self.loopView).offset(-8);
        make.width.equalTo(@30);
        make.height.equalTo(@18);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loopView.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.nameLabel.mas_right);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
}



#pragma mark - Setter

- (XKAutoScrollView *)loopView {
    if (!_loopView) {
        _loopView = [[XKAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, ScreenScale*180) delegate:self isShowPageControl:NO isAuto:NO];
        //        [_loopView setScrollViewItems:@[
        //  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"},
        //  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"},
        //  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"},
        //  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"},
        //  @{@"link":@"123.com", @"image":@"http://pic25.photophoto.cn/20121016/0009021124976824_b.jpg"}]];
        //        _loopView.backgroundColor = [UIColor redColor];
    }
    return _loopView;
}


- (UILabel *)indexLable {
    if (!_indexLable) {
        _indexLable = [[UILabel alloc] init];
        _indexLable.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _indexLable.textColor = [UIColor whiteColor];
        _indexLable.textAlignment = NSTextAlignmentCenter;
        _indexLable.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        //        _indexLable.text = @"1/5";
        _indexLable.layer.masksToBounds = YES;
        _indexLable.layer.cornerRadius = 9;
    }
    return _indexLable;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = XKRegularFont(17);
        _nameLabel.textColor = HEX_RGB(0x222222);

    }
    return _nameLabel;
}


- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = XKRegularFont(12);
        _desLabel.textColor = HEX_RGB(0x999999);
    }
    return _desLabel;
}

- (void)setValuesWithModel:(GoodsModel *)model {
    
    self.goodsModel = model;
    
    NSMutableArray *muArr= [NSMutableArray array];
    for (NSString *imgUrl in model.showPics) {
        NSDictionary *dic = @{@"image":imgUrl};
        [muArr addObject:dic];
    }
    [self.loopView setScrollViewItems:muArr.copy];
    
    self.indexLable.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)muArr.count];
    [self.loopView bringSubviewToFront:self.indexLable];
    
    self.nameLabel.text = model.goodsName;

}

#pragma mark - Events


#pragma mark - XKAutoScrollViewDelegate

- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didSelectItem:(XKAutoScrollImageItem *)item index:(NSInteger)index {
    
    if (self.coverItemBlock) {
        self.coverItemBlock(autoScrollView, item, index);
    }
}

- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didScrollIndex:(NSInteger)index {
    
    self.indexLable.text = [NSString stringWithFormat:@"%d/%d",(int)index, (int)self.goodsModel.showPics.count];
}


@end

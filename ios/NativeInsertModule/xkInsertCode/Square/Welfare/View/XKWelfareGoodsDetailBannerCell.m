//
//  XKWelfareGoodsDetailBannerCell.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareGoodsDetailBannerCell.h"
#import "XKAutoScrollView.h"
@interface XKWelfareGoodsDetailBannerCell () <XKAutoScrollViewDelegate>
@property (nonatomic, strong) XKAutoScrollView *loopView;
@property (nonatomic, strong) UIView *pageView;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) NSArray *pageArr;
@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)UIButton *moreBtn;
@end

@implementation XKWelfareGoodsDetailBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addCustomSubviews];
        [self addUIConstraint];
    }
    return self;
}

- (void)addCustomSubviews {
    [self addSubview:self.loopView];
    [self.pageView addSubview:self.pageLabel];
    [self addSubview:self.pageView];
    [self addSubview:self.backBtn];
    [self addSubview:self.moreBtn];
}

- (void)addUIConstraint {
    [self.loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
        make.height.mas_equalTo(ScreenScale * 375);
    }];
    
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pageView.mas_left).offset(10);
        make.right.equalTo(self.pageView.mas_right).offset(-10);
        make.top.bottom.equalTo(self.pageView);
    }];
    
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
        make.height.mas_equalTo(16);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.mas_top).offset(5 + kStatusBarHeight);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(5 + kStatusBarHeight);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
}

- (XKAutoScrollView *)loopView {
    if (!_loopView) {
        _loopView = [[XKAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenScale*375) delegate:self isShowPageControl:NO isAuto:YES];
        _pageArr = @[@{@"link":@"123.com"}, @{@"link":@"123.com"}, @{@"link":@"123.com"}, @{@"link":@"123.com"}];
        [_loopView setScrollViewItems:_pageArr];
        _loopView.backgroundColor = [UIColor redColor];
    }
    return _loopView;
}

- (UIView *)pageView {
    if(!_pageView) {
        _pageView = [[UIView alloc] init];
        _pageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _pageView.layer.cornerRadius = 8.f;
        _pageView.layer.masksToBounds = YES;
    }
    return _pageView;
}

- (UILabel *)pageLabel {
    if(!_pageLabel) {
        _pageLabel = [[UILabel alloc] init];
        _pageLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.text = @"1/5";
    }
    return _pageLabel;
}

- (UIButton *)backBtn {
    if(!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"xk_icon_welfaregoods_detail_back"] forState:0];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)moreBtn {
    if(!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setImage:[UIImage imageNamed:@"xk_icon_welfaregoods_detail_more"] forState:0];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (void)moreBtnClick:(UIButton *)moreBtn {
    if(self.moreBtnBlock) {
        self.moreBtnBlock(moreBtn);
    }
}

- (void)backBtnClick:(UIButton *)backBtn {
    if(self.backBtnBlock) {
        self.backBtnBlock(backBtn);
    }
}
#pragma mark delegate
- (void)autoScrollView:(XKAutoScrollView *)autoScrollView didSelectItem:(XKAutoScrollImageItem *)item {
    _pageLabel.text = [NSString stringWithFormat:@"%zd/%zd",[_pageArr indexOfObject:item],_pageArr.count];
}
@end

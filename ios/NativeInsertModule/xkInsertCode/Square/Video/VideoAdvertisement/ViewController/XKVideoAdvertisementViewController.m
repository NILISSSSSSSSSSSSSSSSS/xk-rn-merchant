//
//  XKVideoAdvertisementViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/10/20.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKVideoAdvertisementViewController.h"
#import "XKVideoGoodsModel.h"
#import "XKCommonStarView.h"

@interface XKVideoAdvertisementViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (retain, nonatomic) UIPageControl *pageControl;
@property (nonatomic , strong) NSArray <XKVideoGoodsModel *> *recomGoodsList;

@end

@implementation XKVideoAdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configVideoAdvertisementViewControllerWithRecomGoodsModel:(NSArray<XKVideoGoodsModel *> *)modelArr {
    
    self.recomGoodsList = modelArr;
    NSInteger numberOfGoods = self.recomGoodsList.count;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // 滑动控制视图
    UIPageControl *pageControl = [UIPageControl new];
//    pageControl.hidesForSinglePage = YES;
    pageControl.numberOfPages = numberOfGoods;
    pageControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:pageControl];
    [pageControl addTarget:self action:@selector(clickPageControl:) forControlEvents:UIControlEventValueChanged];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.offset(40);
    }];
    self.pageControl = pageControl;
    
    // 广告滑动根视图
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * numberOfGoods, 140);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(pageControl.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.offset(140);
    }];
    self.scrollView = scrollView;
    
    for (NSInteger index = 0; index < numberOfGoods; index++) {
        
        // 单个商品视图
        UIView *view = [UIView new];
        view.frame = CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, 155);
        [scrollView addSubview:view];
        
        XKVideoGoodsModel *goodsListItemModel = modelArr[index];
        if ([goodsListItemModel.xkModule isEqualToString:@"mall"]) {
            [self configMallGoodsView:view model:goodsListItemModel index:index];
        } else if ([goodsListItemModel.xkModule isEqualToString:@"shop"]) {
            [self configShopGoodsView:view model:goodsListItemModel index:index];
        }
    }
    
    // 关闭根视图
    UIView *closeRootView = [UIView new];
    closeRootView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self.view addSubview:closeRootView];
    [closeRootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(scrollView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.offset(20);
    }];
    
    // 关闭按钮
    UIButton *closeButton = [UIButton new];
    [closeButton setImage:[UIImage imageNamed:@"xk_btn_TradingArea_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [closeRootView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(closeRootView.mas_top).offset(10);
        make.right.equalTo(closeRootView.mas_right).offset(-10);
        make.width.height.offset(12);
    }];
    
    // 空白区域视图
    UIControl *emptyControl = [UIControl new];
    emptyControl.backgroundColor = [UIColor clearColor];
    [emptyControl addTarget:self action:@selector(clickEmptyControl:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emptyControl];
    [emptyControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(closeRootView.mas_top);
    }];
    
}

// 配置自营商品
- (void)configMallGoodsView:(UIView *)view model:(XKVideoGoodsModel *)model index:(NSInteger)index {
    
    // 商品图片
    UIImageView *goodsImageView = [UIImageView new];
    goodsImageView.xk_openClip = YES;
    goodsImageView.xk_radius = 8;
    goodsImageView.xk_clipType = XKCornerClipTypeAllCorners;
    [view addSubview:goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(60);
        make.top.equalTo(view.mas_top).offset(15);
        make.left.equalTo(view.mas_left).offset(25);
    }];
    NSString *imageUrlString = model.pic;
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
    
    // 商品名称
    UILabel *goodsDescribeLabel = [UILabel new];
    goodsDescribeLabel.textColor = [UIColor whiteColor];
    goodsDescribeLabel.font = XKRegularFont(12);
    goodsDescribeLabel.numberOfLines = 2;
    [view addSubview:goodsDescribeLabel];
    [goodsDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsImageView.mas_top);
        make.left.equalTo(goodsImageView.mas_right).offset(20);
        make.right.equalTo(view.mas_right).offset(-25);
    }];
    goodsDescribeLabel.text = model.name;
    
    // 人民币符号
    UILabel *symbolLabel = [UILabel new];
    symbolLabel.textColor = RGB(232, 73, 79);
    symbolLabel.font = XKMediumFont(12);
    [view addSubview:symbolLabel];
    [symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsDescribeLabel.mas_bottom).offset(10);
        make.left.equalTo(goodsDescribeLabel.mas_left);
        make.width.offset(10);
    }];
    symbolLabel.text = @"¥";
    
    // 商品价格
    UILabel *goodsPriceLabel = [UILabel new];
    goodsPriceLabel.textColor = RGB(232, 73, 79);
    goodsPriceLabel.textAlignment = NSTextAlignmentLeft;
    goodsPriceLabel.font = XKMediumFont(17);
    [view addSubview:goodsPriceLabel];
    [goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(symbolLabel.mas_bottom).offset(2);
        make.left.equalTo(symbolLabel.mas_right).offset(2);
        make.right.equalTo(view.mas_right).offset(-25);
    }];
    NSDecimalNumber *centNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld", model.price]];
    NSDecimalNumber *yuanNum = [centNum decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
    goodsPriceLabel.text = [NSString stringWithFormat:@"%@", yuanNum];
    
    // 去看看按钮
    UIButton *gotoGoodsButton = [UIButton new];
    gotoGoodsButton.tag = 1000 + index;
    [gotoGoodsButton setTitle:@"去看看" forState:UIControlStateNormal];
    [gotoGoodsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    gotoGoodsButton.titleLabel.font = XKMediumFont(14);
    gotoGoodsButton.layer.masksToBounds = YES;
    gotoGoodsButton.layer.cornerRadius = 5;
    gotoGoodsButton.backgroundColor = RGB(232, 73, 79);
    [gotoGoodsButton addTarget:self action:@selector(clickGotoGoodsButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:gotoGoodsButton];
    [gotoGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsImageView.mas_bottom).offset(30);
        make.left.offset(SCREEN_WIDTH / 7);
        make.width.offset(SCREEN_WIDTH / 7 * 2);
        make.height.offset(30);
    }];
    
    // 去下单按钮
    UIButton *placeAnOrderButton = [UIButton new];
    placeAnOrderButton.tag = 2000 + index;
    [placeAnOrderButton setTitle:@"去下单" forState:UIControlStateNormal];
    [placeAnOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    placeAnOrderButton.titleLabel.font = XKMediumFont(14);
    placeAnOrderButton.layer.masksToBounds = YES;
    placeAnOrderButton.layer.cornerRadius = 5;
    placeAnOrderButton.backgroundColor = RGB(232, 73, 79);
    [placeAnOrderButton addTarget:self action:@selector(clickPlaceAnOrderButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:placeAnOrderButton];
    [placeAnOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gotoGoodsButton.mas_top);
        make.left.equalTo(gotoGoodsButton.mas_right).offset(SCREEN_WIDTH / 7);
        make.width.offset(SCREEN_WIDTH / 7 * 2);
        make.height.offset(30);
    }];
    
    BOOL isDown = model.isDown;
    if (isDown) {
        gotoGoodsButton.hidden = YES;
        placeAnOrderButton.hidden = YES;
    } else {
        gotoGoodsButton.hidden = NO;
        placeAnOrderButton.hidden = NO;
    }
}

// 配置店铺商品
- (void)configShopGoodsView:(UIView *)view model:(XKVideoGoodsModel *)model index:(NSInteger)index {
    
    // 商品图片
    UIImageView *goodsImageView = [UIImageView new];
    goodsImageView.xk_openClip = YES;
    goodsImageView.xk_radius = 8;
    goodsImageView.xk_clipType = XKCornerClipTypeAllCorners;
    [view addSubview:goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(60);
        make.top.equalTo(view.mas_top).offset(15);
        make.left.equalTo(view.mas_left).offset(25);
    }];
    NSString *imageUrlString = model.pic;
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
    
    // 商品名称
    UILabel *goodsDescribeLabel = [UILabel new];
    goodsDescribeLabel.textColor = [UIColor whiteColor];
    goodsDescribeLabel.font = XKRegularFont(12);
    goodsDescribeLabel.numberOfLines = 2;
    [view addSubview:goodsDescribeLabel];
    [goodsDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsImageView.mas_top);
        make.left.equalTo(goodsImageView.mas_right).offset(20);
        make.right.equalTo(view.mas_right).offset(-25);
    }];
    goodsDescribeLabel.text = model.name;
    
    // 星级
    XKCommonStarView *commonStarView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(0, 0, 80, 9) numberOfStars:5];
    commonStarView.userInteractionEnabled = NO;
    commonStarView.scorePercent = model.level / 5.0;
    commonStarView.allowIncompleteStar = YES;
    [view addSubview:commonStarView];
    [commonStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsDescribeLabel.mas_bottom).offset(8);
        make.left.equalTo(goodsImageView.mas_right).offset(18);
        make.width.offset(100);
        make.height.offset(10);
    }];
    
    // 评分
    UILabel *gradeLabel = [UILabel new];
    gradeLabel.textColor = [UIColor whiteColor];
    gradeLabel.font = XKRegularFont(12);
    [view addSubview:gradeLabel];
    [gradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commonStarView.mas_centerY);
        make.left.equalTo(commonStarView.mas_right);
    }];
    gradeLabel.text = [NSString stringWithFormat:@"%.1f", model.level];
    
    // 成交量
    UILabel *tradingVolumeLabel = [UILabel new];
    tradingVolumeLabel.textColor = [UIColor whiteColor];
    tradingVolumeLabel.font = XKRegularFont(12);
    [view addSubview:tradingVolumeLabel];
    [tradingVolumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commonStarView.mas_bottom).offset(8);
        make.left.equalTo(goodsImageView.mas_right).offset(20);
    }];
    tradingVolumeLabel.text = [NSString stringWithFormat:@"成交量：%@单", @(model.monthVolume)];
    
    // 去看看按钮
    UIButton *gotoGoodsButton = [UIButton new];
    gotoGoodsButton.tag = 1000 + index;
    [gotoGoodsButton setTitle:@"去看看" forState:UIControlStateNormal];
    [gotoGoodsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    gotoGoodsButton.titleLabel.font = XKMediumFont(14);
    gotoGoodsButton.layer.masksToBounds = YES;
    gotoGoodsButton.layer.cornerRadius = 5;
    gotoGoodsButton.backgroundColor = RGB(232, 73, 79);
    [gotoGoodsButton addTarget:self action:@selector(clickGotoGoodsButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:gotoGoodsButton];
    [gotoGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsImageView.mas_bottom).offset(30);
        make.centerX.equalTo(view.mas_centerX);
        make.width.offset(SCREEN_WIDTH / 6 * 2);
        make.height.offset(30);
    }];
    
}

// 滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger num = self.scrollView.contentOffset.x / SCREEN_WIDTH;
    self.pageControl.currentPage = num;
}

// 点击空白区域
- (void)clickEmptyControl:(UIControl *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 点击关闭按钮
- (void)clickCloseButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 点击去看看
- (void)clickGotoGoodsButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    XKVideoGoodsModel *model = self.recomGoodsList[sender.tag - 1000];
    [self.delegate viewController:self clickGotoGoodsButtonWithModel:model];
}

// 点击去下单
- (void)clickPlaceAnOrderButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    XKVideoGoodsModel *model = self.recomGoodsList[sender.tag - 2000];
    [self.delegate viewController:self clickPlaceAnOrderButtonWithModel:model];
}

// 点击PageControl
- (void)clickPageControl:(UIControl *)sender {
    
    NSInteger currentPage = self.pageControl.currentPage;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * currentPage, 0) animated:YES];
}

@end

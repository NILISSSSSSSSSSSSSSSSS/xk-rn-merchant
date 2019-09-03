//
//  XKEvaluateServiceViewController.m
//  xkMerchant
//
//  Created by RyanYuan on 2018/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKEvaluateServiceViewController.h"
#import "XKCommonStarView.h"

static const CGFloat kEvaluateServiceViewControllerMainViewHeight = 326;
static const CGFloat kEvaluateServiceViewControllerMainViewWidth = 285;
static const CGFloat kEvaluateServiceViewControllerButtonInterval = 15;

@interface XKEvaluateServiceViewController () <XKCommonStarViewDelegate>

@property (nonatomic, assign) NSInteger starCount;

@end

@implementation XKEvaluateServiceViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  [self initializeView];
}

- (void)initializeView {
  
  self.navigationView.hidden = NO;
  [self setNavTitle:@"评价客服" WithColor:[UIColor whiteColor]];
  self.view.backgroundColor = [UIColor redColor];
  
  // 背景图片
  UIImageView *backgroundImageView = [UIImageView new];
  backgroundImageView.userInteractionEnabled = YES;
  [backgroundImageView setImage:[UIImage imageNamed:@"xk_bg_evaluate_service"]];
  backgroundImageView.xk_openClip = YES;
  backgroundImageView.xk_radius = 7;
  backgroundImageView.xk_clipType = XKCornerClipTypeAllCorners;
  [self.view addSubview:backgroundImageView];
  [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view.mas_centerX);
    make.centerY.equalTo(self.view.mas_centerY);
    make.height.offset(kEvaluateServiceViewControllerMainViewHeight);
    make.width.offset(kEvaluateServiceViewControllerMainViewWidth);
  }];
  
  // title
  UILabel *titleLabel = [UILabel new];
  titleLabel.text = @"晓可客服邀请您评价本次服务";
  titleLabel.textColor = [UIColor whiteColor];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.font = XKFont(XK_PingFangSC_Regular, 14);
  [backgroundImageView addSubview:titleLabel];
  [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(backgroundImageView.mas_top).offset(35);
    make.left.equalTo(backgroundImageView.mas_left).offset(10);
    make.right.equalTo(backgroundImageView.mas_right).offset(-10);
  }];
  
  // 星级
  XKCommonStarView *commonStarView = [[XKCommonStarView alloc] initWithFrame:CGRectMake(0, 0, kEvaluateServiceViewControllerMainViewWidth - 4 * kEvaluateServiceViewControllerButtonInterval, 30) numberOfStars:5];
  commonStarView.delegate = self;
  commonStarView.userInteractionEnabled = YES;
  commonStarView.scorePercent = 0;
  commonStarView.allowIncompleteStar = NO;
  commonStarView.hasAnimation = NO;
  [backgroundImageView addSubview:commonStarView];
  [commonStarView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(backgroundImageView.mas_centerX);
    make.centerY.equalTo(backgroundImageView.mas_centerY);
    make.left.equalTo(backgroundImageView.mas_left).offset(2 * kEvaluateServiceViewControllerButtonInterval);
    make.right.equalTo(backgroundImageView.mas_right).offset(-2 * kEvaluateServiceViewControllerButtonInterval);
    make.height.offset(30);
  }];
  
  // 按钮
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
  cancelButton.layer.borderWidth = 1;
  cancelButton.layer.cornerRadius = 3;
  cancelButton.layer.masksToBounds = YES;
  [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
  cancelButton.titleLabel.font = XKFont(XK_PingFangSC_Regular, 16);
  [cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
  [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  [backgroundImageView addSubview:cancelButton];
  [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(backgroundImageView.mas_bottom).offset(-30);
    make.left.equalTo(backgroundImageView.mas_left).offset(kEvaluateServiceViewControllerButtonInterval);
    make.width.offset((kEvaluateServiceViewControllerMainViewWidth - 3 * kEvaluateServiceViewControllerButtonInterval) / 2);
    make.height.offset(40);
  }];
  
  UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
  confirmButton.backgroundColor = XKMainTypeColor;
  [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
  confirmButton.titleLabel.font = XKFont(XK_PingFangSC_Regular, 16);
  confirmButton.layer.cornerRadius = 3;
  confirmButton.layer.masksToBounds = YES;
  [confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
  [backgroundImageView addSubview:confirmButton];
  [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(backgroundImageView.mas_bottom).offset(-30);
    make.right.equalTo(backgroundImageView.mas_right).offset(-kEvaluateServiceViewControllerButtonInterval);
    make.width.offset((kEvaluateServiceViewControllerMainViewWidth - 3 * kEvaluateServiceViewControllerButtonInterval) / 2);
    make.height.offset(40);
  }];
}

- (void)clickCancelButton:(UIButton *)sender {
  [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)clickConfirmButton:(UIButton *)sender {
  [self dismissViewControllerAnimated:NO completion:nil];
  if (self.confirmBtnBlock) {
    self.confirmBtnBlock(self, self.starCount);
  }
}

- (void)starRateView:(XKCommonStarView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
  self.starCount = (NSInteger)(newScorePercent * 5);
}

@end

//
//  XKWinningAnnouncementViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/24.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWinningAnnouncementViewController.h"
#import "XKMyGrandPrizesViewController.h"
#import "XKLatestSecretViewController.h"
#import "XKMyLotteryTicketsViewController.h"
#import "XKGrandPrizeShowOrderViewController.h"
#import "XKMyWinningRecordsViewController.h"
#import "XKWelfareOrderDetailFinishViewController.h"
#import "XKGrandPrizeDetailViewController.h"

@interface XKWinningAnnouncementViewController ()

@end

@implementation XKWinningAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didPopToPreviousController {
    [self removeAllScriptMessageHandler];
}

#pragma mark - privite method

- (void)creatWkWebViewWithMethodNameArray:(NSArray *)methodNameArray requestUrlString:(NSString *)urlStr {
    [super creatWkWebViewWithMethodNameArray:methodNameArray requestUrlString:urlStr];
    self.navStyle = BaseNavWhiteStyle;
    [self setNavTitle:@"中奖公告" WithColor:[UIColor blackColor]];
    [self.view bringSubviewToFront:self.navigationView];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(NavigationAndStatue_Height, 0.0, 0.0, 0.0));
    }];
}
// 我的大奖
- (void)openMyPrize {
    XKMyGrandPrizesViewController *vc = [[XKMyGrandPrizesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
// 最新揭秘
- (void)openRecentPrize {
    XKLatestSecretViewController *vc = [[XKLatestSecretViewController alloc] init];
    vc.vcType = XKLatestSecretVCTypeLatestSecret;
    [self.navigationController pushViewController:vc animated:YES];
}
// 店铺大奖
- (void)openShopsPrize {
    XKLatestSecretViewController *vc = [[XKLatestSecretViewController alloc] init];
    vc.vcType = XKLatestSecretVCTypeShopGrandPrize;
    [self.navigationController pushViewController:vc animated:YES];
}
// 我的奖券
- (void)openMyCoupon {
    XKMyLotteryTicketsViewController *vc = [[XKMyLotteryTicketsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
// 大奖晒单
- (void)openAllPrize {
    XKGrandPrizeShowOrderViewController *vc = [[XKGrandPrizeShowOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
// 我的中奖记录
- (void)checkMyPrize {
    XKMyWinningRecordsViewController *vc = [[XKMyWinningRecordsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
// 点击奖券 跳转到奖券对应的订单详情
- (void)openCouponInfo:(NSDictionary *) dic {
    XKWelfareOrderDetailFinishViewController *vc = [[XKWelfareOrderDetailFinishViewController alloc] init];
    WelfareOrderDataItem *item = [[WelfareOrderDataItem alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
// 抽奖中奖后，查看详情，跳转到大奖详情页面
- (void)openPrizeDetailInfo:(NSDictionary *) dic {
    XKGrandPrizeDetailViewController *vc = [[XKGrandPrizeDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

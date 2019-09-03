//
//  XKGrandPrizeDetailViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/10/29.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKGrandPrizeDetailViewController.h"
#import "XKMenuView.h"
#import "XKGrandPrizeFeedBackViewController.h"
#import "XKContactListController.h"
#import "XKGrandPrizeConfirmOrderViewController.h"

@interface XKGrandPrizeDetailViewController () <XKCustomShareViewDelegate>

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *menuBtn;

@end

@implementation XKGrandPrizeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:self.navigationView];
    for (UIView *tempView in self.navigationView.subviews) {
        [tempView removeFromSuperview];
    }
}

- (void)didPopToPreviousController {
    [self removeAllScriptMessageHandler];
}

- (void)initializeViews {
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.menuBtn];
}

- (void)updateViews {
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight + 4.0);
        make.leading.mas_equalTo(12.0);
        make.width.height.mas_equalTo(36.0);
    }];
    
    [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight + 4.0);
        make.trailing.mas_equalTo(-12.0);
        make.width.height.mas_equalTo(36.0);
    }];
}

- (void)creatWkWebViewWithMethodNameArray:(NSArray *)methodNameArray requestUrlString:(NSString *)urlStr {
    [super creatWkWebViewWithMethodNameArray:methodNameArray requestUrlString:urlStr];
    [self initializeViews];
    [self updateViews];
}

#pragma mark - privite method

- (void)backBtnAction:(UIButton *) sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)menuBtnAction:(UIButton *) sender {
    XKMenuView *moreMenuVuew = [XKMenuView menuWithTitles:@[@"分享      ",@"意见反馈"] images:@[[UIImage imageNamed:@"xk_btn_welfare_share"],[UIImage imageNamed:@"xk_btn_welfare_opinion"]] width:100 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
        if (index == 0) {
            [self showShareSheetView];
        } else {
            XKGrandPrizeFeedBackViewController *vc = [XKGrandPrizeFeedBackViewController new];
            vc.vcType = XKGrandPrizeFeedBackVCTypeFeedBack;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    moreMenuVuew.menuColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    moreMenuVuew.textFont = XKRegularFont(12);
    moreMenuVuew.textColor = [UIColor whiteColor];
    [moreMenuVuew show];
}
// 显示分享视图
- (void)showShareSheetView {
    NSMutableArray *shareItems = [NSMutableArray arrayWithArray:@[
                                                                  XKShareItemTypeCircleOfFriends,
                                                                  XKShareItemTypeWechatFriends,
                                                                  XKShareItemTypeQQ,
                                                                  XKShareItemTypeSinaWeibo,
                                                                  XKShareItemTypeMyFriends,
                                                                  XKShareItemTypeCopyLink,
                                                                  ]
                                  ];
    XKCustomShareView *moreView = [[XKCustomShareView alloc] init];
    moreView.autoThirdShare = YES;
    moreView.delegate = self;
    moreView.layoutType = XKCustomShareViewLayoutTypeBottom;
    moreView.shareItems = shareItems;
    XKShareDataModel *shareData = [[XKShareDataModel alloc] init];
    shareData.title = @"";
    shareData.content = @"";
    shareData.url = @"";
    shareData.img = @"";
    moreView.shareData = shareData;
    [moreView showInView:self.view];
}
// 分享成功后
- (void)openGrandPrizeConfirmOrder {
    XKGrandPrizeConfirmOrderViewController *vc = [[XKGrandPrizeConfirmOrderViewController alloc] init];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark XKCustomShareViewDelegate

/**
 XKShareItemTypeCircleOfFriends, // 朋友圈
 XKShareItemTypeWechatFriends,   // 微信好友
 XKShareItemTypeQQ,              // QQ
 XKShareItemTypeSinaWeibo,       // 微博
 XKShareItemTypeMyFriends,       // 我的朋友
 XKShareItemTypeCopyLink,        // 复制链接
 XKShareItemTypeSaveToLocal,     // 保存至本地
 */

- (void)customShareView:(XKCustomShareView *) customShareView didClickedShareItem:(NSString *) shareItem {
    if ([shareItem isEqualToString:XKShareItemTypeMyFriends]) {
        XKContactListController *vc = [[XKContactListController alloc] init];
        vc.useType = XKContactUseTypeManySelect;
        vc.rightButtonText = @"完成";
        vc.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
            [listVC.navigationController popViewControllerAnimated:YES];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([shareItem isEqualToString:XKShareItemTypeCopyLink]) {
        [UIPasteboard generalPasteboard].string = @"";
        [XKAlertView showCommonAlertViewWithTitle:@"链接已复制"];
    }
}

- (void)customShareView:(XKCustomShareView *)customShareView didAutoThirdShareSucceed:(NSString *)shareItem {
//    调用JS方法，让JS去请求，并修改是否分享状态，待请求成功后，跳转确认订单页面
    XKGrandPrizeConfirmOrderViewController *vc = [[XKGrandPrizeConfirmOrderViewController alloc] init];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter setter

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:IMG_NAME(@"xk_icon_welfaregoods_detail_back") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)menuBtn {
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuBtn setImage:IMG_NAME(@"xk_icon_welfaregoods_detail_more") forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(menuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
}

@end

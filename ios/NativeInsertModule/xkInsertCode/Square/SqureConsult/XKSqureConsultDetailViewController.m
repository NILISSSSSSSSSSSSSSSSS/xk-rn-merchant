//
//  XKSqureConsultDetailViewController.m
//  XKSquare
//
//  Created by hupan on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureConsultDetailViewController.h"
#import "XKSqureConsultBottomToolView.h"
#import "XKContactListController.h"

@interface XKSqureConsultDetailViewController ()<XKCustomShareViewDelegate>

@property (nonatomic, strong) XKSqureConsultBottomToolView  *bottomView;

@end

@implementation XKSqureConsultDetailViewController


#pragma mark - Life Cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];

    [self creatWkWebViewWithMethodNameArray:nil requestUrlString:self.url ? self.url : @"http://www.baidu.com"];
    
    [self configViews];

}

- (void)didPopToPreviousController {
    [self removeAllScriptMessageHandler];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Metheods


- (void)configNavigationBar {
    [self setNavTitle:@"广场资讯" WithColor:[UIColor whiteColor]];
    
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed:@"xk_btn_squreConsult_share"] forState:UIControlStateNormal];
    [self setNaviCustomView:shareBtn withframe:CGRectMake(SCREEN_WIDTH - 45, 0, 40, 40)];
    
}

- (void)configViews {
    
    if (iPhoneX) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = XKSeparatorLineColor;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kBottomSafeHeight, SCREEN_WIDTH, kBottomSafeHeight)];
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:line];
        [self.view addSubview:view];
    }
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height + 10, 10, kBottomSafeHeight, 10));
    }];
    /* 暂时不要下部功能
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.bottomView setValuesWithDictionary:nil];
     */
}

#pragma mark - Events

- (void)shareButtonClicked:(UIButton *)sender {

//    [self ocCallJSWithMethodName:@"login" parameters:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
//        NSLog(@"yyyy");
//    }];
    
    NSMutableArray *shareItems = [NSMutableArray arrayWithArray:@[XKShareItemTypeCircleOfFriends,
                                                                  XKShareItemTypeWechatFriends,
                                                                  XKShareItemTypeQQ,
                                                                  XKShareItemTypeSinaWeibo,
                                                                  XKShareItemTypeMyFriends,
                                                                  XKShareItemTypeReport]];
    XKCustomShareView *moreView = [[XKCustomShareView alloc] init];
    moreView.autoThirdShare = YES;
    moreView.delegate = self;
    moreView.layoutType = XKCustomShareViewLayoutTypeBottom;
    moreView.shareItems = shareItems;
    XKShareDataModel *shareData = [[XKShareDataModel alloc] init];
    shareData.title = self.titleName ? self.titleName : @"广场资讯";
    shareData.content = self.content ? self.content : @"";
    shareData.url = self.url ? self.url : @"";
    shareData.img = self.imgUrl;
    moreView.shareData = shareData;
    [moreView showInView:self.view];
}

#pragma mark - Custom Delegates

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
    }
    else if ([shareItem isEqualToString:XKShareItemTypeCopyLink]) {
    }
}

#pragma mark - Getters and Setters

- (XKSqureConsultBottomToolView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[XKSqureConsultBottomToolView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
@end

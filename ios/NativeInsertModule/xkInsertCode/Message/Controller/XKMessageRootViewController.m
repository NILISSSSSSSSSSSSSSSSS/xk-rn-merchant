//
//  XKMessageRootViewController.m
//  XKSquare
//
//  Created by william on 2018/8/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMessageRootViewController.h"
#import "XKScrollPageMenuView.h"
#import "XKMessageKeFriendRootViewController.h"
#import "XKCustomeSerListViewController.h"
#import "XKFriendsCircleListController.h"
#import "XKBottomAlertSheetView.h"
#import "XKFriendCirclePublishController.h"
#import "XKMenuView.h"
#import "XKSysMessageViewController.h"
#import "XKIMGlobalMethod.h"
#import "XKIMTeamChatManager.h"
#import "XKContactListController.h"
#import "XKAddFriendController.h"
#import "XKQRCodeScanViewController.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKFriendCircleSpecialController.h"
#import "XKGroupManageController.h"
#import "XKFriendTalkMsgRecordController.h"
#import "XKRedPointManager+config.h"
#import "XKSecretOutShowModel.h"
#import "XKSecretFriendRootViewController.h"
#import "xkMerchantEmitterModule.h"


@interface XKMessageRootViewController () {
    UIButton *_moreBtn;
    UIImageView *_moreRedPoint;
}

/*menu 视图*/
@property (nonatomic, strong)XKScrollPageMenuView *pageMenu;
/**当前显示的vc*/
@property(nonatomic, assign) UIViewController *currentVC;
/**<##>*/
@property(nonatomic, weak) XKFriendsCircleListController *cirleList;
/**密友圈外显数组*/
@property(nonatomic, strong)NSMutableArray          *secretOutArr;

@end

@implementation XKMessageRootViewController

/**
 
 请使用 RNMessageRootView
 
 */

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleRedPoint) name:XKRedPointItemForIMNoti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRedPoint) name:XKRedPointForFriendCircleNoti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRedPoint) name:XKRedPointItemForSysNoti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealMoreBtnHidden) name:XKRedPointItemForNewFriendNoti object:nil];
//    [self handleRedPoint];
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self requestRedPoint];
//    [self getOutSecretData];
//
//}
//
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}
//
//#pragma mark -- 获取密友圈外显消息
//-(void)getOutSecretData{
//  _secretOutArr = [NSMutableArray array];
//  [HTTPClient postEncryptRequestWithURLString:@"im/ua/secretCircleOutsideList/1.0" timeoutInterval:10 parameters:@{} success:^(id responseObject) {
//    if (responseObject) {
//      NSArray *arr = [responseObject xk_jsonToDic];
//      if (arr && arr.count > 0) {
//        for (NSDictionary *d in arr) {
//          XKSecretOutShowModel *model = [XKSecretOutShowModel yy_modelWithDictionary:d];
//          [self.secretOutArr addObject:model];
//        }
//      }
//    }
//    else{
//
//    }
//    NSLog(@"");
//  } failure:^(XKHttpErrror *error) {
//    NSLog(@"");
//  }];
//}
//
//
//
////处理可友的红点
//- (void)handleRedPoint{
//
//    XKTabBarMsgRedPointItem *redItem = [XKRedPointManager getMsgTabBarRedPointItem];
//
//    [_pageMenu operationRedTipForIndex:0 isHidden:![redItem.imItem getItemPointStatus]];
//    [_pageMenu operationRedTipForIndex:1 isHidden:![redItem.friendCicleItem getItemPointStatus]];
////    [_pageMenu operationRedTipForIndex:2 isHidden:![redItem.cusServeItem getItemPointStatus]];
//    [_pageMenu operationRedTipForIndex:3 isHidden:![redItem.sysItem getItemPointStatus]];
//}
//
//#pragma mark - 请求朋友圈红点
//- (void)requestRedPoint {
//    [[XKRedPointManager getMsgTabBarRedPointItem].friendCicleItem resetItemRedPointStatus];
//    [[XKRedPointManager getMsgTabBarRedPointItem].newFriendItem resetItemRedPointStatus];
//}
//
//- (void)addCustomSubviews {
//    [self setNavTitle:@"消息" WithColor:[UIColor whiteColor]];
//    [self hiddenBackButton:YES];
//    //
//    UIButton *moreBtn  = [UIButton new];
//    moreBtn.frame = CGRectMake(0, 0, XKViewSize(30), XKViewSize(20));
//    [moreBtn setImage:IMG_NAME(@"xk_ic_msg_moreMsg") forState:UIControlStateNormal];
//    [moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
//    _moreBtn = moreBtn;
//    _moreRedPoint = [[UIImageView alloc] init];
//    _moreRedPoint.image = IMG_NAME(@"xk_ic_msg_tipRed");
//    [_moreBtn addSubview:_moreRedPoint];
//    [_moreRedPoint mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(8, 8));
//        make.right.equalTo(moreBtn.mas_right).offset(-3);
//        make.top.equalTo(moreBtn.mas_top).offset(-3);
//    }];
//
//    [self setRightView:moreBtn withframe:moreBtn.frame];
//
//    [self.view addSubview:self.pageMenu];
//}
//
//#pragma mark - 更多菜单点击
//- (void)moreClick:(UIButton *)sender {
//    __weak typeof(self) weakSelf = self;
//    if ([self.currentVC isKindOfClass:[XKFriendsCircleListController class]]) {
//        NSArray *items = @[@"发动态",@"我的发布",@"消息记录",@"取消"];
//        XKBottomAlertSheetView *view = [[XKBottomAlertSheetView  alloc] initWithBottomSheetViewWithDataSource:items firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
//            if ([choseTitle isEqualToString:@"发动态"]) {
//                XKFriendCirclePublishController *vc = [XKFriendCirclePublishController new];
//                [vc setPublishSuccess:^{
//                    [weakSelf.cirleList refreshList];
//                }];
//                [self.navigationController pushViewController:vc animated:YES];
//            } else if ([choseTitle isEqualToString:@"我的发布"]) {
//                XKFriendCircleSpecialController * vc = [XKFriendCircleSpecialController new];
//                vc.userId = [XKUserInfo getCurrentUserId];
//                [self.navigationController pushViewController:vc animated:YES];
//            } else if ([choseTitle isEqualToString:@"消息记录"]) {
//                XKFriendTalkMsgRecordController *vc = [XKFriendTalkMsgRecordController new];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//        }];
//        [view show];
//    }
//
//    if ([self.currentVC isKindOfClass:[XKMessageKeFriendRootViewController class]]) {
//      NSMutableArray *titleNameArr = [NSMutableArray arrayWithArray:@[@"通讯录   ",@"新建群聊",@"添加可友",@"分组管理",@"扫一扫   ",@"可友主页"]];
//      NSMutableArray *menuImageArr = [NSMutableArray arrayWithArray:@[IMG_NAME(@"xk_btn_secretFriend_contactList"),IMG_NAME(@"xk_btn_secretFriend_creatChatRoom"),IMG_NAME(@"xk_btn_secretFriend_addFriend"),IMG_NAME(@"xk_btn_secretFriend_groupManage"),IMG_NAME(@"xk_btn_keFriend_scan"),IMG_NAME(@"xk_btn_keFriend_keFriendHomePage")]];
//      if (self.secretOutArr && self.secretOutArr.count > 0) {
//        for (XKSecretOutShowModel *model in self.secretOutArr) {
//          [titleNameArr addObject:model.secretName];
//          [menuImageArr addObject:IMG_NAME(@"xk_btn_secretFriend_outShow")];
//        }
//      }
//      XKMenuView *menuView = [XKMenuView menuWithTitles:titleNameArr images:menuImageArr width:120 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
//
//            text = [text removeSpaceChar];
//            NSLog(@"%@",text);
//            if ([text isEqualToString:@"通讯录"]) {
//                XKContactListController *vc = [[XKContactListController alloc]init];
//                vc.useType = XKContactUseTypeNormal;
//                [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
//            } else if ([text isEqualToString:@"新建群聊"]) {
//                XKContactListController *vc = [[XKContactListController alloc]init];
//                vc.useType = XKContactUseTypeManySelect;
//                vc.rightButtonText = @"完成";
//                vc.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
//                    NSMutableArray *UIMIDArr = [NSMutableArray array];
//                    [UIMIDArr addObject:[XKUserInfo getCurrentIMUserID]];
//                    if (contacts.count > 0) {
//                        if (contacts.count < 2) {
//                            [XKHudView showTipMessage:@"至少选择两个好友"];
//                            return ;
//                        }
//                        for (XKContactModel *model in contacts) {
//                            if (model.accid) {
//                                [UIMIDArr addObject:model.accid];
//                            }
//                        }
//
//                        [XKIMTeamChatManager createTeamChatWithUserIDArr:[NSArray arrayWithArray:UIMIDArr]];
//                    }
//
//                };
//                [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
//            } else if ([text isEqualToString:@"添加好友"]) {
//                XKAddFriendController *vc = [[XKAddFriendController alloc]init];
//                vc.isSecret = NO;
//                [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
//            } else if ([text isEqualToString:@"扫一扫"]) {
//                XKQRCodeScanViewController *vc = [[XKQRCodeScanViewController alloc]init];
//                vc.scanResult = ^(NSString *resultString) {
//                    [XKQRCodeResultManager dealResult:resultString];
//                };
//                [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
//            } else if ([text isEqualToString:@"可友主页"]) {
//                XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc]init];
//                vc.userId = [XKUserInfo getCurrentUserId];
//                [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
//            } else if ([text isEqualToString:@"分组管理"]) {
//                XKGroupManageController *vc = [XKGroupManageController new];
//                [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
//            } else {
//              for (XKSecretOutShowModel *model in self.secretOutArr) {
//                if ([model.secretName isEqualToString:text]) {
//                  XKSecretFriendRootViewController *vc = [[XKSecretFriendRootViewController alloc]init];
//                  XKSecretCircleInfo *info = [[XKSecretCircleInfo alloc]init];
//                  info.secretId = model.secretId;
//                  info.secretName = model.secretName;
//                  vc.circleInfoModel = info;
//                  vc.hidesBottomBarWhenPushed = YES;
//                  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
//                }
//              }
//            }
//
//        }];
//        menuView.menuColor = HEX_RGBA(0x2A2A2A, 0.15);
//        menuView.textColor = [UIColor whiteColor];
//        menuView.separatorPadding = 5;
//        menuView.textImgSpace = 10;
//        menuView.maxDisplayCount = 10;
//        // 红点逻辑
//        NSMutableArray *numArr = @[].mutableCopy;
//        if ([[XKRedPointManager getMsgTabBarRedPointItem].newFriendItem getItemPointStatus]) {
//            [numArr addObject:@(0)];
//        }
//        menuView.redPointArray = numArr;
//        [menuView show];
//    }
//    if ([self.currentVC isKindOfClass:[XKSysMessageViewController class]]) {
//        sender.selected = !sender.selected;
//        if(sender.selected) {
//            if ([self.currentVC respondsToSelector:@selector(updateEditLayout)]) {
//                [self.currentVC performSelector:@selector(updateEditLayout)];
//            }else{
//                @throw [NSException exceptionWithName:NSStringFromClass([self.currentVC class]) reason:@"updateEditLayout必须实现" userInfo:nil];
//            }
//        } else {
//            if ([self.currentVC respondsToSelector:@selector(restoreLayout)]) {
//                [self.currentVC performSelector:@selector(restoreLayout)];
//            }else{
//                @throw [NSException exceptionWithName:NSStringFromClass([self.currentVC class]) reason:@"restoreLayout必须实现" userInfo:nil];
//            }
//        }
//    }
//}
//
//#pragma mark - 处理菜单的隐藏显示
//-(void)dealMoreBtnHidden{
//    [self hiddenBackButton:YES];
//    if ([self.currentVC isKindOfClass:[XKMessageKeFriendRootViewController class]]) {
//        [self hiddenRightButton:NO];
//        [_moreBtn setImage:IMG_NAME(@"xk_ic_msg_moreMsg") forState:UIControlStateNormal];
//        // 红点逻辑
//        _moreRedPoint.hidden = ![[XKRedPointManager getMsgTabBarRedPointItem].newFriendItem getItemPointStatus];
//
//    } else  if ([self.currentVC isKindOfClass:[XKFriendsCircleListController class]]) {
//        [self hiddenRightButton:NO];
//        _moreRedPoint.hidden = YES;
//        [_moreBtn setImage:IMG_NAME(@"xk_ic_msg_moreMsg2") forState:UIControlStateNormal];
//    } else {
//        [self hiddenRightButton:YES];
//    }
//}
//#pragma mark 懒加载
//- (XKScrollPageMenuView *)pageMenu {
//    if(!_pageMenu) {
//        XKWeakSelf(ws);
//        _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height  - TabBar_Height)];
//        _pageMenu.scrollView.scrollEnabled = NO;
////        WEAK_TYPES(_pageMenu);
//        XKMessageKeFriendRootViewController *kefriendRoot = [XKMessageKeFriendRootViewController new];
//        XKCustomeSerListViewController *CustomeSerList = [XKCustomeSerListViewController new];
//        XKFriendsCircleListController *cirleList = [XKFriendsCircleListController new];
//        [cirleList setRequestFirstPageSuccess:^{
////            [weak_pageMenu operationRedTipForIndex:1 isHidden:YES];
//        }];
//        XKSysMessageViewController *sysMessageVC = [XKSysMessageViewController new];
//
//        self.cirleList = cirleList;
//
//        [self addChildViewController:sysMessageVC];
//        [self addChildViewController:kefriendRoot];
//        [self addChildViewController:cirleList];
//        [self addChildViewController:CustomeSerList];
//
//
//        _pageMenu.titles = @[@"可友", @"可友圈",@"客服", @"通知"];
//        _pageMenu.childViews = @[kefriendRoot,cirleList, CustomeSerList, sysMessageVC];
//        _pageMenu.sliderSize = CGSizeMake(42, 6);
//        _pageMenu.selectedPageIndex = 0;
//        _pageMenu.titleColor = HEX_RGBA(0xffffff, 0.5);
//        _pageMenu.titleSelectedColor = [UIColor whiteColor];
//        _pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
//        _pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
//        _pageMenu.sliderColor = [UIColor whiteColor];
//
//        _pageMenu.numberOfTitles = 4;
//        _pageMenu.titleBarHeight = 40;
//        _pageMenu.selectedBlock = ^(NSInteger index) {
//            UIViewController *curretVC = ws.pageMenu.childViews[index];
//            ws.currentVC = curretVC;
//            if ([curretVC conformsToProtocol:@protocol(RootChildControllerProtocol)]) {
//                // 点过去才请求的界面
//                id<RootChildControllerProtocol> proVC = (id<RootChildControllerProtocol>)curretVC;
//                [proVC requestFirst];
//            }
//            [ws dealMoreBtnHidden];
//        };
//        self.currentVC = kefriendRoot;
//        [self dealMoreBtnHidden];
//    }
//    return _pageMenu;
//}

@end

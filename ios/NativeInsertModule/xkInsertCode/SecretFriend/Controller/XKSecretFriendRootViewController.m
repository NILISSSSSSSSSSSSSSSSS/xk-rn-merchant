//
//  XKSecretFriendRootViewController.m
//  XKSquare
//
//  Created by william on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSecretFriendRootViewController.h"
#import "XKScrollPageMenuView.h"
#import "XKSecretFriendBaseChatListViewController.h"
#import "XKMenuView.h"

#import "XKSecretContactListController.h"
#import "XKGroupManageController.h"
#import "XKCloseFriendPersonalInformationViewController.h"
#import "XKSecretTipSettingController.h"
#import "XKAddFriendController.h"
#import "XKFriendGroupModel.h"
#import "XKSecretContactCacheManager.h"
#import "XKSecretDataSingleton.h"
#import "XKSecretTipMsgManager.h"
#import "XKSecretCircleDetailModel.h"

#import "XKSecreFriengGroupViewController.h"
#import "XKPerfectPersonalViewController.h"
#import "XKGuidanceManager.h"
#import "XKGuidanceView.h"
#import "XKRelationUserCacheManager.h"
@interface XKSecretFriendRootViewController ()
/*menu 视图*/
@property (nonatomic, strong)XKScrollPageMenuView *pageMenu;
/*导航栏更多按钮 */
@property (nonatomic, strong)UIButton   *navMoreButton;

@property (nonatomic, strong)NSMutableArray *groupArray;
@end

@implementation XKSecretFriendRootViewController

#pragma mark – Life Cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [XKSecretContactCacheManager configCurrentSecretId:self.circleInfoModel.secretId];
  [XKSecretContactCacheManager updateContactsComplete:nil];
  [XKRelationUserCacheManager updateContactsComplete:nil];
  self.navStyle = BaseNavWhiteStyle;
  self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
  [XKSecretDataSingleton sharedManager].currentIMChatModel = XKCurrentIMChatModelSecret;
  [XKSecretDataSingleton sharedManager].secretId = self.circleInfoModel.secretId;
  [[XKSecretTipMsgManager shareManager] updateSecretCircleActiveTime:self.circleInfoModel.secretId];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKSecretFriendGroupChange object:nil];
  //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKSecretFriendListCacheChangeNoti object:nil];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:XKUserCacheChangeNoti object:nil];
  [self loadData];
}


- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [XKGuidanceManager configShowGuidanceViewType:XKGuidanceManagerXKSecretFriendRootViewController2 TransparentRectArr:@[[NSValue valueWithCGRect:self.navMoreButton.getWindowFrame]]];
}

- (void)refreshData {
    [self loadData];
}
#pragma mark 默认加载方法
- (void)handleData {
    [XKSecretContactCacheManager configCurrentSecretId:self.circleInfoModel.secretId];
}

- (void)addCustomSubviews {

    [self hideNavigationSeperateLine];
    [self setNavTitle:_circleInfoModel.secretName ? _circleInfoModel.secretName : @"密友" WithColor:[UIColor whiteColor]];
    [self setRightView:self.navMoreButton withframe:self.navMoreButton.frame];
}

-(void)loadData{
    [XKHudView showLoadingTo:nil animated:YES];
    _groupArray = [NSMutableArray array];
    XKWeakSelf(weakSelf);
  
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"secretId"] = _circleInfoModel.secretId;
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/secretCircleDetail/1.0" timeoutInterval:20.0 parameters:params success:^(id responseObject) {
      XKSecretCircleDetailModel *model = [XKSecretCircleDetailModel yy_modelWithJSON:responseObject];
      [XKSecretDataSingleton sharedManager].currentMySecretInfo = model;
    } failure:^(XKHttpErrror *error) {
      
    }];
  

    [HTTPClient postEncryptRequestWithURLString:@"im/ua/secretGroupList/1.0" timeoutInterval:10 parameters:@{@"secretId":_circleInfoModel.secretId} success:^(id responseObject) {
        NSArray *arr = [NSArray yy_modelArrayWithClass:[XKFriendGroupModel class] json:responseObject];
        [self.groupArray removeAllObjects];
        [weakSelf.groupArray addObjectsFromArray:arr];
        [weakSelf refreshViews];
        NSLog(@"");
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:@"网络错误"];
        NSLog(@"");
    }];
}

-(void)refreshViews{
    [XKHudView hideAllHud];
    if (_pageMenu) {
        [_pageMenu removeFromSuperview];
        _pageMenu = nil;
    }
    [self.view addSubview:self.pageMenu];
}

#pragma mark - Events
-(void)_navMoreButtonClicked:(UIButton *)sender{
    XKMenuView *menuView = [XKMenuView menuWithTitles:@[@"添加密友",@"通讯录   ",@"分组管理",@"提醒设置"] images:@[IMG_NAME(@"xk_btn_secretFriend_addFriend"),IMG_NAME(@"xk_btn_secretFriend_contactList"),IMG_NAME(@"xk_btn_secretFriend_groupManage"),IMG_NAME(@"xk_btn_secretFriend_alertSetting")] width:120 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
        NSString *titleText = [text removeSpaceChar];
        if ([titleText isEqualToString:@"添加密友"]) {
            [self addSecretFriend];
        } else if ([titleText isEqualToString:@"新建群聊"]) {
            [self createNewGroupChat];
        } else if ([titleText isEqualToString:@"通讯录"]) {
            [self gotoContact];
        } else if ([titleText isEqualToString:@"分组管理"]) {
            [self groupManage];
        } else if ([titleText isEqualToString:@"提醒设置"]) {
            [self settingForTip];
        } else if ([titleText isEqualToString:@"个人资料"]) {
            [self personalInfo];
        }
    }];
  menuView.separatorColor = HEX_RGB(0x737373);
  menuView.menuColor = HEX_RGBA(0x606060, 1);
  menuView.textColor = [UIColor whiteColor];
  menuView.separatorPadding = 10;
  menuView.textImgSpace = 18;
  menuView.maxDisplayCount = 10;
    [menuView show];

  //添加引导视图
  
  UITableViewCell *cell = [menuView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
  [XKGuidanceManager configShowGuidanceViewType:XKGuidanceManagerXKSecretFriendRootViewController TransparentRectArr:@[[NSValue valueWithCGRect:cell.getWindowFrame]]];

}

#pragma mark - 添加密友
- (void)addSecretFriend {
    XKAddFriendController *vc = [XKAddFriendController new];
    vc.isSecret = YES;
    vc.secretId = self.circleInfoModel.secretId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 新建群聊
- (void)createNewGroupChat {
//    FIXME_TO_WRITE_FUNCTION;
}

#pragma mark - 通讯录
- (void)gotoContact {
    XKSecretContactListController *vc = [XKSecretContactListController new];
    vc.secretId = self.circleInfoModel.secretId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 分组管理
- (void)groupManage {
    XKGroupManageController *vc = [XKGroupManageController new];
    vc.secretId = self.circleInfoModel.secretId;
    vc.isSecret = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 提醒设置
- (void)settingForTip {
    XKSecretTipSettingController *vc = [XKSecretTipSettingController new];
    vc.secretId = self.circleInfoModel.secretId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 个人资料
- (void)personalInfo {
  XKPerfectPersonalViewController *vc = [XKPerfectPersonalViewController new];
  vc.secretId = self.circleInfoModel.secretId;
  vc.vcType = MYPersonalType;
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark – Private Methods

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - Custom Delegates

#pragma mark – Getters and Setters
- (XKScrollPageMenuView *)pageMenu {
    if(!_pageMenu) {
        XKWeakSelf(ws);
        _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame: CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height)];
        _pageMenu.scrollView.scrollEnabled = NO;
        _pageMenu.selectedBlock = ^(NSInteger index) {
//            if(index == 4) {
               ws.navMoreButton.hidden = NO;
//            } else {
//                ws.navMoreButton.hidden = YES;
//            }
        };
        _pageMenu.backgroundColor = self.navStyle == BaseNavWhiteStyle ? [UIColor whiteColor] : XKMainTypeColor;
        
        XKSecretFriendBaseChatListViewController *groupAllChatList = [XKSecretFriendBaseChatListViewController new];
        groupAllChatList.secretId = self.circleInfoModel.secretId;
        
        NSMutableArray *groupNameArr = [NSMutableArray arrayWithObject:@"全部"];
        NSMutableArray *groupVCArr = [NSMutableArray arrayWithObject:groupAllChatList];
        [self addChildViewController:groupAllChatList];
        
        
        for (XKFriendGroupModel *model in _groupArray) {
            XKSecreFriengGroupViewController *vc = [[XKSecreFriengGroupViewController alloc]init];
            vc.secretId = self.circleInfoModel.secretId;
            vc.groupId = model.groupId;
            [groupNameArr addObject:model.groupName];
            [groupVCArr addObject:vc];
            [self addChildViewController:vc];
        }
        
        _pageMenu.titles = groupNameArr;
        _pageMenu.childViews = groupVCArr;
        _pageMenu.sliderSize = CGSizeMake(42, 6);
        
        _pageMenu.selectedPageIndex = 0;
        _pageMenu.titleColor = self.navStyle == BaseNavWhiteStyle ? RGBA(51, 51, 51, 0.5) : HEX_RGBA(0xffffff, 0.5);
        _pageMenu.titleSelectedColor =  self.navStyle == BaseNavWhiteStyle ? RGBGRAY(51) : [UIColor whiteColor];
        _pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
        _pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
        _pageMenu.sliderColor = self.navStyle == BaseNavWhiteStyle ? RGBGRAY(51) : [UIColor whiteColor];
        
        _pageMenu.numberOfTitles = groupNameArr.count;
        _pageMenu.titleBarHeight = 40;
    }
    return _pageMenu;
}

-(UIButton *)navMoreButton{
    if (!_navMoreButton) {
        _navMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navMoreButton.tintColor = [UIColor whiteColor]; // 为了baseViewController改风格
        [_navMoreButton setImage:[[UIImage imageNamed:@"xk_ic_order_mainDetail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_navMoreButton addTarget:self action:@selector(_navMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _navMoreButton.frame = CGRectMake(0, 0, 40, 30);
    }
    return _navMoreButton;
}

-(void)didPopToPreviousController{
    [XKSecretDataSingleton sharedManager].currentIMChatModel = XKCurrentIMChatModelNormal;
    [XKSecretDataSingleton sharedManager].secretId = nil;
}

- (void)dealloc {
    [XKSecretContactCacheManager configCurrentSecretId:nil];
}

@end

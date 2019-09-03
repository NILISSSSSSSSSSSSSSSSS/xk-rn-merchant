//
//  XKMessageRootViewController.m
//  XKSquare
//
//  Created by william on 2018/8/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "RNMessageRootView.h"
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
#import "XKTestJumpViewController.h"
#import "XKPrivacySettingViewController.h"
#import <XKCrashRecord.h>
#import "xkMerchantEmitterModule.h"
#import "XKSecretOutShowModel.h"
#import "XKSecretFriendRootViewController.h"

@interface RNMessageRootView () {
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
@property(nonatomic, copy)NSArray         *secretOutArr;
@property(nonatomic, strong) UIButton *secretBtn;

@end

@implementation RNMessageRootView


- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self viewDidLoad];
  }
  return self;
}

- (void)viewDidLoad {
  //    [super viewDidLoad];
  // Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleRedPoint) name:XKRedPointItemForIMNoti object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRedPoint) name:XKRedPointForFriendCircleNoti object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRedPoint) name:XKRedPointItemForSysNoti object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealMoreBtnHidden) name:XKRedPointItemForNewFriendNoti object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestSomething) name:@"RNMessageRootViewShow" object:nil];
  [self handleRedPoint];
  [self addCustomSubviews];
  [self creatTestJumpButton];
  [XKCrashRecord showCrashInfo];
}

#pragma mark -- 获取密友圈外显消息
-(void)getOutSecretData{
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/secretCircleOutsideList/1.0" timeoutInterval:10 parameters:@{} success:^(id responseObject) {
    self.secretOutArr = [NSArray yy_modelArrayWithClass:[XKSecretOutShowModel class] json:responseObject];
    self.secretBtn.hidden = self.secretOutArr.count == 0 ? YES : NO;
  } failure:^(XKHttpErrror *error) {
    NSLog(@"");
  }];
}


- (void)secretBtnClick {
  if (self.secretOutArr && self.secretOutArr.count > 0) {
    if (self.secretOutArr.count == 1) { // 直接跳转
      XKSecretOutShowModel *model = self.secretOutArr.firstObject;
      XKSecretFriendRootViewController *vc = [[XKSecretFriendRootViewController alloc]init];
      XKSecretCircleInfo *info = [[XKSecretCircleInfo alloc]init];
      info.secretId = model.secretId;
      info.secretName = model.secretName;
      vc.circleInfoModel = info;
      [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
      return;
    }
    NSMutableArray *titleNameArr = @[].mutableCopy;
    for (XKSecretOutShowModel *model in self.secretOutArr) {
      [titleNameArr addObject:model.secretName];
    }
    XKMenuView *menuView = [XKMenuView menuWithTitles:titleNameArr images:nil width:118 relyonView:self.secretBtn clickBlock:^(NSInteger index, NSString *text) {
      for (XKSecretOutShowModel *model in self.secretOutArr) {
        if ([model.secretName isEqualToString:text]) {
          XKSecretFriendRootViewController *vc = [[XKSecretFriendRootViewController alloc]init];
          XKSecretCircleInfo *info = [[XKSecretCircleInfo alloc]init];
          info.secretId = model.secretId;
          info.secretName = model.secretName;
          vc.circleInfoModel = info;
          [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
          return;
        }
      }
    }];
    menuView.separatorColor = HEX_RGB(0x737373);
    menuView.menuColor = HEX_RGBA(0x606060, 1);
    menuView.textColor = [UIColor whiteColor];
    menuView.separatorPadding = 10;
    menuView.maxDisplayCount = 10;
    menuView.contentPadding = 15;
    menuView.textFont = XKNormalFont(14);
    menuView.contentAlignment = UIControlContentHorizontalAlignmentLeft;
    [menuView show];
  }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)creatTestJumpButton {
#if DEBUG
  UIButton *testJumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [testJumpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [testJumpButton setBackgroundColor:[UIColor clearColor]];
  [testJumpButton addTarget:self action:@selector(clickTestJumpButton:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:testJumpButton];
  [testJumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.navigationView.mas_centerX);
    make.centerY.equalTo(self.navigationView.mas_centerY);
    make.height.width.offset(50);
  }];
#endif
}

- (void)clickTestJumpButton:(UIButton *)sender {
  
  XKTestJumpViewController *testJumpViewController = [XKTestJumpViewController new];
  [self.navigationController pushViewController:testJumpViewController animated:YES];
}

//处理可友的红点
- (void)handleRedPoint{
    
    XKTabBarMsgRedPointItem *redItem = [XKRedPointManager getMsgTabBarRedPointItem];
    
    [_pageMenu operationRedTipForIndex:0 isHidden:![redItem.imItem getItemPointStatus]];
    [_pageMenu operationRedTipForIndex:1 isHidden:![redItem.friendCicleItem getItemPointStatus]];
}

#pragma mark - 请求朋友圈红点
- (void)requestSomething {
    [[XKRedPointManager getMsgTabBarRedPointItem].friendCicleItem resetItemRedPointStatus];
    [[XKRedPointManager getMsgTabBarRedPointItem].newFriendItem resetItemRedPointStatus];
    [self getOutSecretData];
}

- (void)addCustomSubviews {
    [self setNavTitle:@"好友" WithColor:[UIColor whiteColor]];
    [self hiddenBackButton:YES];
    //
    UIButton *moreBtn  = [UIButton new];
    moreBtn.frame = CGRectMake(0, 0, XKViewSize(30), XKViewSize(20));
    [moreBtn setImage:IMG_NAME(@"xk_ic_msg_moreMsg") forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn = moreBtn;
    _moreRedPoint = [[UIImageView alloc] init];
    _moreRedPoint.image = IMG_NAME(@"xk_ic_msg_tipRed");
    [_moreBtn addSubview:_moreRedPoint];
    [_moreRedPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 8));
        make.right.equalTo(moreBtn.mas_right).offset(-3);
        make.top.equalTo(moreBtn.mas_top).offset(-3);
    }];
    
    [self setRightView:moreBtn withframe:moreBtn.frame];
  
  
  UIButton *secretBtn  = [UIButton new];
  secretBtn.frame = CGRectMake(0, 0, XKViewSize(30), XKViewSize(30));
  [secretBtn setImage:IMG_NAME(@"xk_btn_secretFriend_outShow_big") forState:UIControlStateNormal];
  [secretBtn addTarget:self action:@selector(secretBtnClick) forControlEvents:UIControlEventTouchUpInside];
  [self setLeftView:secretBtn withframe:secretBtn.frame];
  [secretBtn mas_updateConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(secretBtn.superview.mas_left).offset(25);
  }];
  self.secretBtn = secretBtn;
  secretBtn.hidden = YES;
  
    [self.view addSubview:self.pageMenu];
}

- (UIView *)view {
  return self;
}

- (UINavigationController *)navigationController {
  UINavigationController *nav =  [NSObject getCurrentUIVC].navigationController;
  return nav;
}

#pragma mark - 更多菜单点击
- (void)moreClick:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if ([self.currentVC isKindOfClass:[XKFriendsCircleListController class]]) {
        NSArray *items = @[@"发动态",@"我的发布",@"消息记录",@"取消"];
        XKBottomAlertSheetView *view = [[XKBottomAlertSheetView  alloc] initWithBottomSheetViewWithDataSource:items firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
            if ([choseTitle isEqualToString:@"发动态"]) {
                XKFriendCirclePublishController *vc = [XKFriendCirclePublishController new];
                [vc setPublishSuccess:^{
                    [weakSelf.cirleList refreshList];
                }];
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([choseTitle isEqualToString:@"我的发布"]) {
                XKFriendCircleSpecialController * vc = [XKFriendCircleSpecialController new];
                vc.userId = [XKUserInfo getCurrentUserId];
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([choseTitle isEqualToString:@"消息记录"]) {
                XKFriendTalkMsgRecordController *vc = [XKFriendTalkMsgRecordController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        [view show];
    }
    
    if ([self.currentVC isKindOfClass:[XKMessageKeFriendRootViewController class]]) {
        XKMenuView *menuView = [XKMenuView menuWithTitles:@[@"通讯录   ",@"新建群聊",@"添加可友",@"分组管理",@"扫一扫   ",@"可友主页",@"隐私设置"] images:@[IMG_NAME(@"xk_btn_secretFriend_contactList"),IMG_NAME(@"xk_btn_secretFriend_creatChatRoom"),IMG_NAME(@"xk_btn_secretFriend_addFriend"),IMG_NAME(@"xk_btn_secretFriend_groupManage"),IMG_NAME(@"xk_btn_keFriend_scan"),IMG_NAME(@"xk_btn_keFriend_keFriendHomePage"),IMG_NAME(@"隐私设置icon")] width:120 relyonView:sender clickBlock:^(NSInteger index, NSString *text) {
            text = [text removeSpaceChar];
            NSLog(@"%@",text);
            if ([text isEqualToString:@"通讯录"]) {
                XKContactListController *vc = [[XKContactListController alloc]init];
                vc.useType = XKContactUseTypeNormal;
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([text isEqualToString:@"新建群聊"]) {
                XKContactListController *vc = [[XKContactListController alloc]init];
                vc.useType = XKContactUseTypeManySelect;
                vc.rightButtonText = @"完成";
                vc.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
                    NSMutableArray *UIMIDArr = [NSMutableArray array];
                    [UIMIDArr addObject:[XKUserInfo getCurrentIMUserID]];
                    if (contacts.count > 0) {
                        if (contacts.count < 2) {
                            [XKHudView showTipMessage:@"至少选择两个好友"];
                            return ;
                        }
                        for (XKContactModel *model in contacts) {
                            if (model.accid) {
                                [UIMIDArr addObject:model.accid];
                            }
                        }
                        
                        [XKIMTeamChatManager createTeamChatWithUserIDArr:[NSArray arrayWithArray:UIMIDArr]];
                    }
                    
                };
                [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
            } else if ([text isEqualToString:@"添加可友"]) {
                XKAddFriendController *vc = [[XKAddFriendController alloc]init];
                vc.isSecret = NO;
                [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
            } else if ([text isEqualToString:@"扫一扫"]) {
                XKQRCodeScanViewController *vc = [[XKQRCodeScanViewController alloc]init];
                vc.scanResult = ^(NSString *resultString) {
                    [XKQRCodeResultManager dealResult:resultString];
                };
                [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
            } else if ([text isEqualToString:@"可友主页"]) {
                XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc]init];
                vc.userId = [XKUserInfo getCurrentIMUserID];
                [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
            } else if ([text isEqualToString:@"分组管理"]) {
                XKGroupManageController *vc = [XKGroupManageController new];
                [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
            } else if ([text isEqualToString:@"隐私设置"]) {
              XKPrivacySettingViewController *vc = [[XKPrivacySettingViewController alloc]init];

               [[self getCurrentUIVC].navigationController  pushViewController:vc animated:YES];
            }
        }];
      menuView.separatorColor = HEX_RGB(0x737373);
      menuView.menuColor = HEX_RGBA(0x606060, 1);
      menuView.textColor = [UIColor whiteColor];
      menuView.separatorPadding = 10;
      menuView.textImgSpace = 18;
      menuView.maxDisplayCount = 10;
        // 红点逻辑
        NSMutableArray *numArr = @[].mutableCopy;
        if ([[XKRedPointManager getMsgTabBarRedPointItem].newFriendItem getItemPointStatus]) {
            [numArr addObject:@(0)];
        }
        menuView.redPointArray = numArr;
        [menuView show];
    }
    if ([self.currentVC isKindOfClass:[XKSysMessageViewController class]]) {
        sender.selected = !sender.selected;
        if(sender.selected) {
            if ([self.currentVC respondsToSelector:@selector(updateEditLayout)]) {
                [self.currentVC performSelector:@selector(updateEditLayout)];
            }else{
                @throw [NSException exceptionWithName:NSStringFromClass([self.currentVC class]) reason:@"updateEditLayout必须实现" userInfo:nil];
            }
        } else {
            if ([self.currentVC respondsToSelector:@selector(restoreLayout)]) {
                [self.currentVC performSelector:@selector(restoreLayout)];
            }else{
                @throw [NSException exceptionWithName:NSStringFromClass([self.currentVC class]) reason:@"restoreLayout必须实现" userInfo:nil];
            }
        }
    }
}

#pragma mark - 处理菜单的隐藏显示
-(void)dealMoreBtnHidden{
    [self hiddenBackButton:YES];
    if ([self.currentVC isKindOfClass:[XKMessageKeFriendRootViewController class]]) {
        [self hiddenRightButton:NO];
        [_moreBtn setImage:IMG_NAME(@"xk_ic_msg_moreMsg") forState:UIControlStateNormal];
        // 红点逻辑
        _moreRedPoint.hidden = ![[XKRedPointManager getMsgTabBarRedPointItem].newFriendItem getItemPointStatus];

    } else  if ([self.currentVC isKindOfClass:[XKFriendsCircleListController class]]) {
        [self hiddenRightButton:NO];
        _moreRedPoint.hidden = YES;
        [_moreBtn setImage:IMG_NAME(@"xk_ic_msg_moreMsg2") forState:UIControlStateNormal];
    } else {
        [self hiddenRightButton:YES];
    }
}
#pragma mark 懒加载
- (XKScrollPageMenuView *)pageMenu {
    if(!_pageMenu) {
        XKWeakSelf(ws);
        _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height  - TabBar_Height)];
        _pageMenu.scrollView.scrollEnabled = NO;
//        WEAK_TYPES(_pageMenu);
        XKMessageKeFriendRootViewController *kefriendRoot = [XKMessageKeFriendRootViewController new];
//        XKCustomeSerListViewController *CustomeSerList = [XKCustomeSerListViewController new];
        XKFriendsCircleListController *cirleList = [XKFriendsCircleListController new];
        [cirleList setRequestFirstPageSuccess:^{
//            [weak_pageMenu operationRedTipForIndex:1 isHidden:YES];
        }];
//        XKSysMessageViewController *sysMessageVC = [XKSysMessageViewController new];
      
        self.cirleList = cirleList;
        
//        [self addChildViewController:sysMessageVC];
//        [self addChildViewController:kefriendRoot];
//        [self addChildViewController:cirleList];
//        [self addChildViewController:CustomeSerList];
      

        _pageMenu.titles = @[@"可友", @"可友圈"];
        _pageMenu.childViews = @[kefriendRoot,cirleList];
        _pageMenu.sliderSize = CGSizeMake(42, 6);
        _pageMenu.selectedPageIndex = 0;
        _pageMenu.titleColor = HEX_RGBA(0xffffff, 0.5);
        _pageMenu.titleSelectedColor = [UIColor whiteColor];
        _pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
        _pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Semibold andSize:14];
        _pageMenu.sliderColor = [UIColor whiteColor];
        
        _pageMenu.numberOfTitles = 2;
        _pageMenu.titleBarHeight = 40;
        _pageMenu.selectedBlock = ^(NSInteger index) {
            UIViewController *curretVC = ws.pageMenu.childViews[index];
            ws.currentVC = curretVC;
            if ([curretVC conformsToProtocol:@protocol(RootChildControllerProtocol)]) {
                // 点过去才请求的界面
                id<RootChildControllerProtocol> proVC = (id<RootChildControllerProtocol>)curretVC;
                [proVC requestFirst];
            }
            [ws dealMoreBtnHidden];
        };
        self.currentVC = kefriendRoot;
        [self dealMoreBtnHidden];
    }
    return _pageMenu;
}

@end

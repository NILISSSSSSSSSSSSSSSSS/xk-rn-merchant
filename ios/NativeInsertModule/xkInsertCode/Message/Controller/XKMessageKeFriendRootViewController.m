//
//  XKMessageKeFriendRootViewController.m
//  XKSquare
//
//  Created by william on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMessageKeFriendRootViewController.h"
#import "XKScrollPageMenuView.h"
#import "XKFriendChatListViewController.h"
#import "XKTeamChatListViewController.h"
#import "XKKYFriendListViewController.h"
#import "XKIMGlobalMethod.h"
#import "XKGlobalSearchController.h"
#import "XKTabBarMsgRedPointItem.h"
@interface XKMessageKeFriendRootViewController ()<UISearchBarDelegate>

/*搜索框*/
@property (nonatomic,strong) UISearchBar *chatListSearchBar;

/*menu 视图*/
@property (nonatomic, strong) XKScrollPageMenuView *pageMenu;

/**当前显示的vc*/
@property(nonatomic, assign) UIViewController *currentVC;
@end

@implementation XKMessageKeFriendRootViewController

#pragma mark – Life Cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
  // 添加业务相关通知
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRedPoint) name:XKRedPointItemForIMNoti object:nil];
  [self configView];
  [self handleRedPoint];
}

- (void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark – Private Methods
// 处理红点
- (void)handleRedPoint{
  XKRedPointItemForIM *imRed = [XKRedPointManager getMsgTabBarRedPointItem].imItem;
  [_pageMenu operationRedTipForIndex:0 isHidden:!imRed.getItemPointStatus];
  [_pageMenu operationRedTipForIndex:1 isHidden:!imRed.groupRedStatus];
}
// 页面布局
- (void)configView{
  self.navigationView.hidden = YES;
  [self.view addSubview:self.chatListSearchBar];
  [self.view addSubview:self.pageMenu];
  
  [self.chatListSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.view.mas_top).offset(11 * ScreenScale);
    make.centerX.mas_equalTo(self.view.mas_centerX);
    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 4, 38 * ScreenScale));
  }];
}
// 添加标签分割线
- (void)setPageMenuLine{
  XKWeakSelf(weakSelf);
  UIView *centerLineOne = [[UIView alloc]init];
  UIView *centerLineTwo = [[UIView alloc]init];
  UIView *bottomLine = [[UIView alloc]init];
  
  centerLineOne.backgroundColor = UIColorFromRGB(0xf1f1f1);
  centerLineTwo.backgroundColor = UIColorFromRGB(0xf1f1f1);
  bottomLine.backgroundColor = UIColorFromRGB(0xf1f1f1);
  
  [_pageMenu addSubview:centerLineOne];
  [_pageMenu addSubview:centerLineTwo];
  [_pageMenu addSubview:bottomLine];
  
  [centerLineOne mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(weakSelf.pageMenu.mas_left).offset((SCREEN_WIDTH - 20) / 3);
    make.centerY.equalTo(weakSelf.pageMenu.topView.mas_centerY);
    make.height.mas_equalTo(20);
    make.width.mas_equalTo(1);
  }];
  
  [centerLineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(weakSelf.pageMenu.mas_left).offset((SCREEN_WIDTH - 20) / 3 * 2);
    make.centerY.equalTo(centerLineOne.mas_centerY);
    make.height.mas_equalTo(20);
    make.width.mas_equalTo(1);
  }];
  
  [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.and.right.mas_equalTo(weakSelf.pageMenu);
    make.top.mas_equalTo(weakSelf.pageMenu.topView.mas_bottom);
    make.height.mas_equalTo(1);
  }];
  
  [_pageMenu bringSubviewToFront:centerLineOne];
  [_pageMenu bringSubviewToFront:centerLineTwo];
  [_pageMenu bringSubviewToFront:bottomLine];
}

#pragma mark - Custom Delegates
// 搜索框进入编辑模式
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
  XKGlobalSearchController *vc = [XKGlobalSearchController new];
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
  return NO;
}

#pragma mark – Getters and Setters
- (UISearchBar *)chatListSearchBar {
  if (!_chatListSearchBar) {
    _chatListSearchBar = [[UISearchBar alloc]init];
    _chatListSearchBar.barTintColor = UIColorFromRGB(0xf6f6f6);
    _chatListSearchBar.searchBarStyle = UISearchBarStyleDefault;
    [_chatListSearchBar setImage:[UIImage imageNamed:@"xk_ic_contact_search"]
                forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    for (UIView *view in _chatListSearchBar.subviews) {
      if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
        [[view.subviews objectAtIndex:0] removeFromSuperview];
        break;
      }
    }
    _chatListSearchBar.delegate = self;
  }
  return _chatListSearchBar;
}

- (XKScrollPageMenuView *)pageMenu {
  if(!_pageMenu) {
    XKWeakSelf(ws);
    _pageMenu = [[XKScrollPageMenuView alloc] initWithFrame:CGRectMake(10, 60 * ScreenScale, SCREEN_WIDTH - 20, SCREEN_HEIGHT - NavigationAndStatue_Height - 40.0 - 60.0 * ScreenScale - TabBar_Height)];
    _pageMenu.scrollView.scrollEnabled = NO;
    XKFriendChatListViewController *kefriendRoot = [XKFriendChatListViewController new];
    XKTeamChatListViewController *teamChatList = [XKTeamChatListViewController new];
    XKKYFriendListViewController *kefriendGroup = [XKKYFriendListViewController new];
    [self addChildViewController:kefriendRoot];
    [self addChildViewController:teamChatList];
    [self addChildViewController:kefriendGroup];
    
    _pageMenu.titles = @[@"消息", @"群聊",@"分组"];
    _pageMenu.childViews = @[kefriendRoot, teamChatList, kefriendGroup];
    _pageMenu.sliderSize = CGSizeMake(62, 6);
    
    _pageMenu.selectedPageIndex = 0;
    _pageMenu.titleColor = UIColorFromRGB(0x777777);
    _pageMenu.titleSelectedColor = XKMainTypeColor;
    _pageMenu.titleFont = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    _pageMenu.titleSelectedFont = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
    _pageMenu.sliderColor = XKMainTypeColor;
    _pageMenu.topBgColor = [UIColor whiteColor];
    
    _pageMenu.numberOfTitles = 3;
    _pageMenu.titleBarHeight = 40;
    
    _pageMenu.xk_openClip = YES;
    _pageMenu.xk_clipType = XKCornerClipTypeTopBoth;
    _pageMenu.xk_radius = 8;
    
    _pageMenu.selectedBlock = ^(NSInteger index) {
      ws.currentVC = ws.pageMenu.childViews[index];
//      [ws dealMoreBtnHidden];
    };
    self.currentVC = kefriendRoot;
//    [self dealMoreBtnHidden];
    
    [self setPageMenuLine];
  }
  return _pageMenu;
}
@end

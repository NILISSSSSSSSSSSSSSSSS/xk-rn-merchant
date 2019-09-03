//
//  XKP2PChatViewController.m
//  XKSquare
//
//  Created by william on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKP2PChatViewController.h"
#import "XKIMBaseChatViewController.h"
#import <NIMKitUtil.h>
#import "XKP2PChatSettingViewController.h"
#import "XKGroupChatSettingViewController.h"
#import "XKIMTeamChatManager.h"
#import "XKSecretDataSingleton.h"
#import "XKRelationUserCacheManager.h"
#import "XKContactCacheManager.h"
@interface XKP2PChatViewController () <XKIMMultipleSelectionDelegate>

@property (nonatomic, strong) UIImageView *earImgView;

@end

@implementation XKP2PChatViewController

#pragma mark – Life Cycle
- (instancetype)initWithSession:(NIMSession *)session{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _session = session;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [XKSecretDataSingleton sharedManager].currentIMChatModel = XKCurrentIMChatModelNormal;
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBackButton) name:XKRedPointItemForIMNoti object:nil];
  [self configViews];
  //    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[_session.sessionId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
  //        [self configViews];
  //    }];
}

-(void)dealloc{
  [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self setNavTitle:[self sessionTitle] WithColor:[UIColor whiteColor]];
  [self refreshEarImgViewStatus];
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [[UIApplication sharedApplication].keyWindow addSubview:self.navigationView];
  
  XKContactModel *model = [XKContactCacheManager queryContactWithUserId:_session.sessionId];
  if (model.friendRelation == XKRelationNoting && model.secretRelation == XKRelationNoting && _session.sessionType == NIMSessionTypeP2P) {
    NSLog(@"已不是好友");
    [XKAlertView showCommonAlertViewWithTitle:@"对方已不是你的好友,请重新添加!" block:^{
      [self.navigationController popViewControllerAnimated:YES];
    }];
  }
  
  [self refreshBackButton];
}

-(void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self.navigationView removeFromSuperview];
  [self.view addSubview:self.navigationView];
}

#pragma mark – Private Methods
-(void)configViews{
  //设置nav
  [self setNav];
  
  //设置聊天controller
  [self setChatCon];
}

-(void)setNav{
  [self setNavTitle:[self sessionTitle] WithColor:[UIColor whiteColor]];
  UILabel *titleLab = (UILabel *)[self valueForKey:@"_titleLabel"];
  self.earImgView = [[UIImageView alloc] init];
  self.earImgView.image = IMG_NAME(@"xk_img_IM_earpiece");
  [self.navigationView addSubview:self.earImgView];
  [self.earImgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(titleLab.mas_right).offset(5.0);
    make.centerY.mas_equalTo(titleLab);
    make.size.mas_equalTo(self.earImgView.image.size);
  }];
  
  UIButton *moreBtn  = [UIButton new];
  moreBtn.frame = CGRectMake(0, 0, XKViewSize(30), XKViewSize(20));
  [moreBtn setImage:IMG_NAME(@"xk_ic_order_mainDetail") forState:UIControlStateNormal];
  [moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
  [self setRightView:moreBtn withframe:moreBtn.frame];
  
}

-(void)setChatCon{
  XKIMBaseChatViewController *vc = [[XKIMBaseChatViewController alloc]initWithSession:_session];
  vc.multipleSelectionDelegate = self;
  vc.searchMessage = _searchMessage;
  vc.view.frame = CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationAndStatue_Height);
  [self addChildViewController:vc];
  [self.view addSubview:vc.view];
}

-(void)refreshBackButton{
  
  BOOL isShow = [XKRedPointManager getMsgTabBarRedPointItem].imItem.hasRedPoint;
  if (isShow) {
    [self setBackButton:[UIImage imageNamed:@""] andName:@" 消息"];
  }
}
#pragma mark - 会话title
- (NSString *)sessionTitle
{
  NSString *title = @"";
  NIMSessionType type = self.session.sessionType;
  NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
  if (type == NIMSessionTypeTeam && team.teamName) {
    if ([XKIMTeamChatManager isDefaultTeamName:team.teamName]) {
      return [NSString stringWithFormat:@"群聊(%tu)",team.memberNumber];
    }else{
      return [NSString stringWithFormat:@"%@(%tu)",team.teamName,team.memberNumber];
    }
  }
  switch (type) {
    case NIMSessionTypeTeam:{
      NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
      [XKIMTeamChatManager getTeamNameWithTeamID:team complete:^(NSString *nameString) {
        if ([XKIMTeamChatManager isDefaultTeamName:team.teamName]) {
          [self setNavTitle:[NSString stringWithFormat:@"群聊(%tu)",team.memberNumber] WithColor:[UIColor whiteColor]];
          
        }else{
          [self setNavTitle:[NSString stringWithFormat:@"%@(%tu)",nameString,team.memberNumber] WithColor:[UIColor whiteColor]];
        }
        
      }];
    }
      break;
    case NIMSessionTypeP2P:{
      //            title = [NIMKitUtil showNick:self.session.sessionId inSession:self.session];
      XKContactModel *model = [XKRelationUserCacheManager queryContactWithUserId:self.session.sessionId];
      title = model.displayName;
    }
      break;
    default:
      break;
  }
  return title;
}
#pragma mark - Events

- (void)refreshEarImgViewStatus {
  self.earImgView.hidden = [AVAudioSession sharedInstance].category != AVAudioSessionCategoryPlayAndRecord;
}

-(void)moreClick:(UIButton *)sender{
  NIMSessionType type = self.session.sessionType;
  switch (type) {
    case NIMSessionTypeTeam:{
      XKGroupChatSettingViewController *vc = [[XKGroupChatSettingViewController alloc]init];
      vc.session = self.session;
      if (_isOfficialTeam) {
        vc.isOffical = YES;
        vc.merchantType = self.merchantType;
      }
      [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
      break;
    case NIMSessionTypeP2P:{
      XKP2PChatSettingViewController *vc = [[XKP2PChatSettingViewController alloc]init];
      vc.session = self.session;
      [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
      break;
    default:
      break;
  }
}

- (void)cancelBtnAction:(UIButton *) sender {
  XKIMBaseChatViewController *vc = (XKIMBaseChatViewController *)self.childViewControllers.firstObject;
  [vc quitMultipleSelection];
}

#pragma mark - XKIMMultipleSelectionDelegate

- (void)chatViewControllerDidEnterMultipleSelection:(XKIMBaseChatViewController *)chatVC {
  [self hiddenBackButton:YES];
  UIButton *cancelBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelBtn.titleLabel.font = XKMediumFont(17.0);
  [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
  [cancelBtn setTitleColor:HEX_RGB(0xFFFFFF) forState:UIControlStateNormal];
  [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
  [cancelBtn sizeToFit];
  [self setRightView:cancelBtn withframe:cancelBtn.frame];
}

- (void)chatViewControllerDidQuitMultipleSelection:(XKIMBaseChatViewController *)chatVC {
  [self hiddenBackButton:NO];
  UIButton *moreBtn  = [UIButton new];
  moreBtn.frame = CGRectMake(0, 0, XKViewSize(30), XKViewSize(20));
  [moreBtn setImage:IMG_NAME(@"xk_ic_order_mainDetail") forState:UIControlStateNormal];
  [moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
  [self setRightView:moreBtn withframe:moreBtn.frame];
}

- (void)chatViewControllerDidMultipleSelectionNumChanged:(NSUInteger)multipleSelectionNum {
  
}


@end

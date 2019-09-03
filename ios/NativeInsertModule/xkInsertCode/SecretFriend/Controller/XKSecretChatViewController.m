//
//  XKSecretChatViewController.m
//  XKSquare
//
//  Created by william on 2018/11/20.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKSecretChatViewController.h"
#import "XKIMBaseChatViewController.h"
#import <NIMKitUtil.h>
#import "XKSecretChatSettingViewController.h"
#import "XKGroupChatSettingViewController.h"
#import "XKIMTeamChatManager.h"
#import "XKSecretDataSingleton.h"
#import "XKRelationUserCacheManager.h"
#import "XKSecretContactCacheManager.h"
#import "XKSecretFrientManager.h"
#import "XKGuidanceManager.h"
#import "XKGuidanceView.h"

@interface XKSecretChatViewController() <XKIMMultipleSelectionDelegate>

@property (nonatomic, strong) UIImageView *earImgView;
/**更多按钮*/
@property(nonatomic, strong) UIButton *moreButton;

@end

@implementation XKSecretChatViewController

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
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBackButton:) name:XKSecretChatListViewControllerrRefreshDataNotification object:nil];

    [XKSecretDataSingleton sharedManager].currentIMChatModel = XKCurrentIMChatModelSecret;
    [self configViews];
    //    [[NIMSDK sharedSDK].userManager fetchUserInfos:@[_session.sessionId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
    //        [self configViews];
    //    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavTitle:[self sessionTitle] WithColor:[UIColor whiteColor]];
    [self refreshEarImgViewStatus];
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self refreshBackButton:nil];
  //添加引导视图
  [XKGuidanceManager configShowGuidanceViewType:XKGuidanceManagerXKSecretChatViewController TransparentRectArr:@[[NSValue valueWithCGRect:self.moreButton.getWindowFrame]]];
}

-(void)dealloc{
  [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationView removeFromSuperview];
    [self.view addSubview:self.navigationView];
}


-(void)refreshBackButton:(NSNotification *)noti{
  
  NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
  NIMRecentSession *recentSession = (NIMRecentSession *)noti.object;
  
  if (recentSession.session.sessionId && ![recentSession.session.sessionId isEqualToString:_session.sessionId]) {
    
    option.limit = recentSession.unreadCount;
    option.order = NIMMessageSearchOrderDesc;
    option.messageTypes = @[@(NIMMessageTypeCustom)];
    [[NIMSDK sharedSDK].conversationManager searchMessages:recentSession.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
      if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:messages];
        for (NIMMessage *message in messages) {
          if ([XKSecretFrientManager showMessagesSceneWithUserID:message.from] == XKShowMessagesSceneNomal) {
            [arr removeObject:message];
          }
          if ([XKSecretFrientManager showMessagesSceneWithUserID:message.from] == XKShowMessagesSceneRespective) {
            if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
              [arr removeObject:message];
            }
          }
        }
        
        if (arr.count > 0) {
          [self setBackButton:[UIImage imageNamed:kleftBlackArrowImgName] andName:@" 消息"];
          
        }
      }
    }];
  }
  
}



#pragma mark – Private Methods
-(void)configViews{
    //设置nav
    [self setNav];
    
    //设置聊天controller
    [self setChatCon];
}

-(void)setNav{
    self.navStyle = BaseNavWhiteStyle;
    [self hideNavigationSeperateLine];
    [self setNavTitle:[self sessionTitle] WithColor:[UIColor blackColor]];
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
    moreBtn.tintColor = [UIColor whiteColor]; // 为了baseViewController改风格
    [moreBtn setImage:[[UIImage imageNamed:@"xk_ic_order_mainDetail"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    self.moreButton = moreBtn;
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
                [self setNavTitle:[NSString stringWithFormat:@"%@(%ld)",nameString,team.memberNumber] WithColor:[UIColor whiteColor]];
            }];
        }
            break;
        case NIMSessionTypeP2P:{
            title = [NIMKitUtil showNick:self.session.sessionId inSession:self.session];
            XKContactModel *model = [XKSecretContactCacheManager queryContactWithUserId:self.session.sessionId];
            if (model.secretRemark) {
                title = model.secretRemark;
            }
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
            [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }
            break;
        case NIMSessionTypeP2P:{
            XKSecretChatSettingViewController *vc = [[XKSecretChatSettingViewController alloc]init];
            vc.session = self.session;
            vc.secretID = _secretID;
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
    [cancelBtn setTitleColor:HEX_RGB(0x222222) forState:UIControlStateNormal];
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

#pragma mark - UITextFieldDelegate

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - Custom Delegates

#pragma mark – Getters and Setters
@end

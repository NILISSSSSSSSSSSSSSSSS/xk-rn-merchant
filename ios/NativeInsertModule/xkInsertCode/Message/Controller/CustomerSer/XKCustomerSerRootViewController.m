//
//  XKCustomerSerRootViewController.m
//  XKSquare
//
//  Created by william on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomerSerRootViewController.h"
#import <NIMKitUtil.h>
#import "XKCustomerSerHomeViewController.h"
#import "XKBaseCustomerChatViewController.h"
#import "XKTransformHelper.h"
#import "XKIMCustomerState.h"
#import "XKCustomerSerHistoryConsultationViewController.h"

@interface XKCustomerSerRootViewController (){
  UIButton *customerSerInfoButton;
  UIView *rightView;
  UIButton *historyButton;
  UIButton *closeButton;
}

@property (nonatomic, strong) UIView *scrollViewContainerView;

@property(nonatomic, strong) XKBaseCustomerChatViewController *customerChatVC;

@property (nonatomic, assign) XKCustomerSerRootVCType vcType;

@property (nonatomic, assign) XKIMType IMType;

@end

@implementation XKCustomerSerRootViewController

#pragma mark – Life Cycle
- (instancetype)initWithSession:(NIMSession *)session{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _session = session;
    _IMType = XKIMTypeNone;
  }
  return self;
}

- (instancetype)initWithSession:(NIMSession *)session vcType:(XKCustomerSerRootVCType)vcType {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _session = session;
    _vcType = vcType;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (self.shopID && self.shopID.length > 0) {
    [XKIMCustomerState sharedManager].shopID = self.shopID;
  }
  [self configViews];
  [self loadData];
}

-(void)dealloc{
  [XKIMCustomerState sharedManager].shopID = nil;
}
#pragma mark – Private Methods
-(void)configViews{
  
  //设置nav
  [self setNav];
  
  //设置聊天controller
  [self setChatCon];
}

-(void)setNav{
  
  if (self.vcType == XKCustomerSerRootVCTypeUserContactCustomerService) {
    // 客户咨询客服
    if (self.title && self.title.length) {
      [self setNavTitle:self.title WithColor:[UIColor whiteColor]];
    } else {
      NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:_session.sessionId];
      [self setNavTitle:team.teamName WithColor:[UIColor whiteColor]];
    }
    customerSerInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customerSerInfoButton setBackgroundImage:[UIImage imageNamed:@"xk_btn_IM_NavigationBar_CustomerSer"] forState:UIControlStateNormal];
    [customerSerInfoButton addTarget:self action:@selector(customerSerInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:customerSerInfoButton];
    [customerSerInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_equalTo(self.navigationView.mas_right).offset(-23 * ScreenScale);
      make.bottom.mas_equalTo(self.navigationView.mas_bottom).offset(-13 * ScreenScale);
      make.size.mas_equalTo(CGSizeMake(20 * ScreenScale, 20 * ScreenScale));
    }];
    customerSerInfoButton.hidden = YES;
  } else if (self.vcType == XKCustomerSerRootVCTypeCustomerServiceContactUser) {
    // 客服联系客户
  } else if (self.vcType == XKCustomerSerRootVCTypeCurrentConsultations) {
    // 当前咨询
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.session.sessionId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
      if (!error) {
        for (NIMTeamMember *member in members) {
          if (![member.userId isEqualToString:[XKUserInfo currentUser].userId]) {
            [[NIMSDK sharedSDK].userManager fetchUserInfos:@[member.userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
              if (!error) {
                if (users.count) {
                  NIMUser *theUser = users.firstObject;
                  [self setNavTitle:theUser.userInfo.nickName WithColor:[UIColor whiteColor]];
                }
              }
            }];
            break;
          }
        }
      }
    }];
    
    rightView = [[UIView alloc] init];
    [self.navigationView addSubview:rightView];
    
    historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyButton setBackgroundImage:IMG_NAME(@"xk_sh_ic_customerService_history") forState:UIControlStateNormal];
    [historyButton addTarget:self action:@selector(historyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:historyButton];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.titleLabel.font = XKMediumFont(17.0);
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:HEX_RGB(0xFFFFFF) forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:closeButton];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_equalTo(self.navigationView.mas_right).offset(-23 * ScreenScale);
      make.bottom.mas_equalTo(self.navigationView.mas_bottom);
      make.height.mas_equalTo(NavigationBar_HEIGHT);
    }];
    
    [historyButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.mas_equalTo(self->rightView);
      make.centerY.mas_equalTo(self->rightView);
      make.size.mas_equalTo(self->historyButton.currentBackgroundImage.size);
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self->historyButton.mas_right).offset(10.0);
      make.centerY.mas_equalTo(self->rightView);
      make.right.mas_equalTo(self->rightView.mas_right);
    }];
  }
}

-(void)setChatCon{
  
  self.scrollViewContainerView = [[UIView alloc] init];
  self.bgScrollView.bounces = NO;
  [self.bgScrollView addSubview:self.scrollViewContainerView];
  [self.scrollViewContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(self.bgScrollView);
    make.width.mas_equalTo(self.bgScrollView);
  }];
  
  self.customerChatVC = [[XKBaseCustomerChatViewController alloc]initWithSession:_session];
  [self addChildViewController:self.customerChatVC];
  [self.scrollViewContainerView addSubview:self.customerChatVC.view];
  [self.customerChatVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.leading.trailing.mas_equalTo(self.scrollViewContainerView);
    make.height.mas_equalTo(self.bgScrollView);
    make.bottom.mas_equalTo(self.scrollViewContainerView);
  }];
}

-(void)hideInputView{
  [self.customerChatVC.sessionInputView endEditing:YES];
}

-(void)loadData{
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/findShopIdByTid/1.0"
                              timeoutInterval:10
                                   parameters:@{@"userId":[XKUserInfo getCurrentUserId],
                                                @"tid":_session.sessionId
                                                }
                                      success:^(id responseObject)
   {
     NSString *jsonStr = [NSString stringWithFormat:@"%@",responseObject];
     NSDictionary *dic = [XKTransformHelper dictByJsonString:jsonStr];
     NSLog(@"");
     if (dic[@"shopId"] && [dic[@"shopId"] isEqualToString:@""]) {
       self->customerSerInfoButton.hidden = NO;
     }
     if (dic[@"shopId"]) {
       NSString *shopID = dic[@"shopId"];
       if (shopID.length > 0) {
         self.shopID = shopID;
         [XKIMCustomerState sharedManager].shopID = shopID;
       }
     }
   } failure:^(XKHttpErrror *error) {
     NSLog(@"");
   }];
}

#pragma mark - 会话title
- (NSString *)sessionTitle
{
  NSString *title = @"";
  NIMSessionType type = self.session.sessionType;
  switch (type) {
    case NIMSessionTypeTeam:{
      NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
      title = [NSString stringWithFormat:@"%@(%zd)",[team teamName],[team memberNumber]];
    }
      break;
    case NIMSessionTypeP2P:{
      title = [NIMKitUtil showNick:self.session.sessionId inSession:self.session];
    }
      break;
    default:
      break;
  }
  return title;
}
#pragma mark - Events

-(void)customerSerInfoButtonClicked:(UIButton *)sender{
  XKCustomerSerHomeViewController *vc = [[XKCustomerSerHomeViewController alloc]init];
  vc.mySession = _session;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)historyButtonAction {
  XKCustomerSerHistoryConsultationViewController *vc = [[XKCustomerSerHistoryConsultationViewController alloc] init];
  [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.session.sessionId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
    for (NIMTeamMember *member in members) {
      if (![member.userId isEqualToString:[XKUserInfo currentUser].userId]) {
        [[NIMSDK sharedSDK].userManager fetchUserInfos:@[member.userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
          if (!error) {
            if (users.count) {
              NIMUser *theUser = users.firstObject;
              vc.title = theUser.userInfo.nickName;
            }
          }
        }];
        vc.vcType = XKCustomerSerHistoryConsultationVCTypeFull;
        vc.customerId = self.session.sessionId;
        [self.navigationController pushViewController:vc animated:YES];
        break;
      }
    }
  }];
}

- (void)closeButtonAction {
  XKCommonAlertView *alert = [[XKCommonAlertView alloc] initWithTitle:@"提示" message:@"确定对话结束？" leftButton:@"否" rightButton:@"是" leftBlock:nil rightBlock:^{
    [self finishCustomerService];
  } textAlignment:NSTextAlignmentCenter];
  [alert show];
}

#pragma mark - POST

- (void)finishCustomerService {
  NSMutableDictionary *para = [NSMutableDictionary dictionary];
  para[@"shopId"] = [XKUserInfo currentUser].currentShopId;
  __block NSString *customerId;
  [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.session.sessionId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
    if (!error) {
      for (NIMTeamMember *member in members) {
        if (![member.userId isEqualToString:[XKUserInfo currentUser].userId]) {
          customerId = member.userId;
          break;
        }
      }
    }
  }];
  para[@"customerId"] = customerId;
  [XKHudView showLoadingTo:self.customerChatVC.view animated:YES];
  [HTTPClient postEncryptRequestWithURLString:@"im/ma/mCustomerServiceFinish/1.0" timeoutInterval:20.0 parameters:para success:^(id responseObject) {
    [XKHudView hideHUDForView:self.customerChatVC.view];
    if (self.finishCustomerServiceBlock) {
      self.finishCustomerServiceBlock();
    }
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.customerChatVC.view];
    [XKHudView showErrorMessage:error.message];
  }];
}

@end

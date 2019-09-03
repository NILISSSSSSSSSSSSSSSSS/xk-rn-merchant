/*******************************************************************************
 # File        : XKPersonDetailInfoViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/18
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKPersonDetailInfoViewModel.h"
#import "XKBottomAlertSheetView.h"
#import "XKBottomBtnsSheetView.h"
#import "XKSecretFriendSettingController.h"
#import "XKFriendSettingController.h"
#import "XKIMGlobalMethod.h"
#import "XKContactCacheManager.h"
#import "XKRelationUserCacheManager.h"
#import "XKCustomShareView.h"
#import "XKContactListController.h"
#import "XKIMGlobalMethod.h"
#import "XKSecretChatViewController.h"
#import "XKOfficialGroupChatDisableSendMsgViewController.h"
#import "XKUnionPersonalInfoViewController.h"
#import "xkMerchantEmitterModule.h"
@interface XKPersonDetailInfoViewModel()<YYModel,XKCustomShareViewDelegate>

@end

@implementation XKPersonDetailInfoViewModel


#pragma mark - 请求数据更新
- (void)updateData {
    [self requestInfoComplete:^(NSString *error, id data) {
        if (!error) {
            self.updateStatusUI();
        }
    }];
}

#pragma mark - 接收申请点击  接收都是接收的好友申请，对方发起的密友申请 对于自己也是可友申请。
- (void)acceptApplyButtonClick {
    __weak typeof(self) weakSelf = self;
    [XKHudView showLoadingTo:self.vc.containView animated:YES];
    [XKFriendshipManager requestOperateFriendApply:YES applyId:self.vc.applyId complete:^(NSString *error, id data) {
        [XKHudView hideHUDForView:weakSelf.vc.containView animated:NO];
        if (error) {
            [XKHudView showErrorMessage:error to:weakSelf.vc.containView animated:YES];
        } else {
            // 本地设为好友
            weakSelf.personalInfo.friendRelation = XKRelationOneWay;
            // 本地切换模式
            weakSelf.acceptApplySuccess();
            weakSelf.updateStatusUI();
            // 再网络请求一波看对不对
            [weakSelf updateData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                           ^{
                               NIMSession *Session = [NIMSession session:weakSelf.personalInfo.userId type:NIMSessionTypeP2P];
                               [XKIMGlobalMethod sendTextMessage:@"我通过了你的好友验证，现在我们可以聊天了。" session:Session];
                           });
        }
    }];
}

- (void)requestInfoComplete:(void(^)(NSString *error,id data))complete {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    params[@"rid"] = self.userId;
    [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserHomePage/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        self.personalInfo = [XKPesonalDetailInfoModel yy_modelWithJSON:responseObject];
        [XKContactCacheManager updateUser:self.personalInfo.userId updateJob:^(XKContactModel *contact) {
            contact.avatar = self.personalInfo.avatar;
            contact.nickname = self.personalInfo.nickname;
            contact.signature = self.personalInfo.signature;
            contact.friendRemark = self.personalInfo.friendRemark;
            contact.secretRemark = self.personalInfo.secretRemark;
        }];
        [XKRelationUserCacheManager updateUser:self.personalInfo.userId updateJob:^(XKContactModel *contact) {
            contact.avatar = self.personalInfo.avatar;
            contact.nickname = self.personalInfo.nickname;
            contact.signature = self.personalInfo.signature;
            contact.friendRemark = self.personalInfo.friendRemark;
            contact.secretRemark = self.personalInfo.secretRemark;
        }];
        [[NSNotificationCenter defaultCenter]postNotificationName:XKFriendChatListViewControllerRefreshDataNotification object:nil];
        EXECUTE_BLOCK(complete,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(complete,error.message,nil);
    }];
}

#pragma mark - -----------事件处理

#pragma mark - 处理按钮点击
- (void)dealMoreBtnClick:(UIButton *)btn {
    if (self.vc_useForApply) {
        [self alertBottomAction];
    } else { // 非申请状态
        if (self.vc_useForFriendAndIsFriend) {
          [self friendEditingAlertBottomAction];
        } else if (self.vc_useForFriendAndIsNotFriend) {
            [self alertBottomAction];
        } else if (self.vc_useForSecretAndIsFriend) {
            [self enterSecretEditing];
        } else if (self.vc_useForSecretAndIsNotFriend) {
            // 无操作 按钮都没有显示 目前不会进来
        }
    }
}

#pragma mark - 可友资料弹框
- (void)friendEditingAlertBottomAction {
  NSArray * arr = @[@"可友设置",@"Ta的资料",@"取消"];
  XKBottomAlertSheetView *view = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:arr firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
    if ([choseTitle isEqualToString:@"可友设置"]) {
      [self enterFriendEditing];
    } else if ([choseTitle isEqualToString:@"Ta的资料"]) {
      [self friendInfomation];
    }
  }];
  [view show];
}

#pragma mark - 底部分享举报等弹框
- (void)alertBottomAction {
  NSArray *arr;
  if (self.vc.isOfficalTeam) {
    arr = @[@"设置禁言",@"分享",@"举报",@"加入黑名单",@"取消"];
  } else {
    arr = @[@"举报",@"加入黑名单",@"取消"];
  }
    XKBottomAlertSheetView *view = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:arr firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
        if ([choseTitle isEqualToString:@"分享"]) {
            [self share];
        } else if ([choseTitle isEqualToString:@"举报"]) {
            [self report];
        } else if ([choseTitle isEqualToString:@"加入黑名单"]) {
            [self addToBlackList];
        } else if ([choseTitle isEqualToString:@"设置禁言"]) {
            [self forbidSay];
        }
    }];
    [view show];
}

#pragma mark - 进入密友编辑界面
- (void)enterSecretEditing {
    __weak typeof(self) weakSelf = self;
    XKSecretFriendSettingController *vc = [[XKSecretFriendSettingController alloc] init];
    vc.userId = self.userId;
    vc.secretId = self.vc.secretId;
    [vc setChangeInfo:^(UIViewController *settingVC) {
        [weakSelf updateData];
    }];
    [vc setDeleteBlock:^(UIViewController *settingVC) {
        // 移除详情页 返回
        [NSObject removeVCFromCurrentStack:weakSelf.vc];
        [settingVC.navigationController popViewControllerAnimated:YES];
    }];
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark - 进入可友编辑界面
- (void)enterFriendEditing {
  __weak typeof(self) weakSelf = self;
  XKFriendSettingController *vc = [[XKFriendSettingController alloc] init];
  vc.userId = self.userId;
  vc.isOfficalTeam = self.vc.isOfficalTeam;
  vc.teamId = self.vc.teamId;
  [vc setChangeInfo:^(UIViewController *settingVC) {
    [weakSelf updateData];
  }];
  [vc setDeleteBlock:^(UIViewController *settingVC) {
    if (weakSelf.vc.deleteBlock) {
      weakSelf.vc.deleteBlock(self.userId);
    } else {
      // 移除详情页 返回
      [NSObject removeVCFromCurrentStack:weakSelf.vc];
      [settingVC.navigationController popViewControllerAnimated:YES];
    }
  }];
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark - 关注按钮点击
- (void)attentionButtonClick {
    __weak typeof(self) weakSelf = self;
    // 当前关注状态
    [XKHudView showLoadingTo:self.vc.containView animated:YES];
    BOOL currentFocusStatus = self.personalInfo.followRelation == XKRelationNoting ? NO : YES;
    [XKFriendshipManager requestFocus:!currentFocusStatus userId:self.userId complete:^(NSString *error, id data) {
        [XKHudView hideHUDForView:weakSelf.vc.containView animated:NO];
        if (error) {
            [XKHudView showErrorMessage:error to:weakSelf.vc.containView animated:YES];
        } else {
            // 本地设置逻辑先更新一波
            if (currentFocusStatus) { // 之前是关注
                self.personalInfo.followRelation = XKRelationNoting;
            } else { // 设置成关注 XKRelationOneWay XKRelationTwoWay 是一致的界面显示
                self.personalInfo.followRelation = XKRelationOneWay;
            }
            self.hasStatusChanged = YES;
            weakSelf.updateStatusUI();
            // 再网络请求一波看对不对
            [weakSelf updateData];
        }
    }];
}
#pragma mark - ta的资料

- (void)friendInfomation {
  [xkMerchantEmitterModule RNJumpToPersonalVcUserId:self.userId];
}

#pragma mark - 设置禁言
- (void)forbidSay {
  XKOfficialGroupChatDisableSendMsgViewController *vc = [XKOfficialGroupChatDisableSendMsgViewController new];
  vc.teamId = self.vc.teamId;
  vc.userId = self.userId;
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

#pragma mark - 添加可友点击
- (void)addXKFriendButtonClick {
  // 如果存在密友关系 直接添加
  if (self.personalInfo.secretRelation != XKRelationNoting) { // 有密友关系
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userId"] = [XKUserInfo getCurrentUserId];
    params[@"rid"] = self.personalInfo.userId;
    
    [XKHudView showLoadingTo:self.vc.containView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/friendsApply/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
      [XKHudView hideHUDForView:self.vc.containView];
      [XKHudView showTipMessage:@"已添加为可友" to:self.vc.containView time:2 animated:YES completion:^{
        
      }];
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                     ^{
                       // 再网络请求一波看对不对
                       [self updateData];
                     });
    } failure:^(XKHttpErrror *error) {
      [XKHudView hideHUDForView:self.vc.containView];
    }];
  } else {
    [XKFriendshipManager addFriend:self.personalInfo.userId successApply:^{
      //
    }];
  }
}

#pragma mark - 添加密友点击
- (void)addSecretFriendButtonClick {
    // 逻辑：如果已经是可友  没有任何密友关系 就直接添加密友
    // 逻辑：如果已经是可友  有其他密友关系 也直接添加密友相当于迁移  进行提示
    // 逻辑：如果不是可友  有其他密友关系 也直接添加密友相当于迁移  进行提示
    // 逻辑：既不是可友， 不是其他密友前的密友 走申请流程

    if (self.personalInfo.friendRelation == XKRelationNoting) { // 不是可友
        if (self.personalInfo.secretRelation != XKRelationNoting) { // 有密友关系
            [self requestAddSecretFriendWithoutAgreeNeedDeleteFriend:NO];
        } else { // 没有任何关系
            [XKFriendshipManager addSecretFriend:self.personalInfo.userId withSecretId:self.vc.secretId successApply:^{
                //
            }];
        }
    } else { // 是可友
        //
        [XKAlertView showAlertViewWithCloseBtnWithTitle:@"提示" message:@"是否保留可友？\n(选择\"否\"将删除可友，\n选择\"是\"将保留可友)" leftText:@"否" rightText:@"是" textColor:XKMainTypeColor leftBlock:^{
            [self requestAddSecretFriendWithoutAgreeNeedDeleteFriend:YES];
        } rightBlock:^{
            [self requestAddSecretFriendWithoutAgreeNeedDeleteFriend:NO];
        } textAlignment:NSTextAlignmentCenter];
    }
}

- (void)requestAddSecretFriendWithoutAgreeNeedDeleteFriend:(BOOL)delete {
    [XKHudView showLoadingTo:self.vc.containView animated:YES];
    [XKFriendshipManager addSecretFriendWithoutAgree:self.personalInfo.userId needDeleteFriend:delete   withSecretId:self.vc.secretId complete:^(NSString *error, id data) {
        [XKHudView hideHUDForView:self.vc.containView];
        if (error) {
            [XKHudView showErrorMessage:error to:self.vc.containView  animated:YES];
        } else {
            if (delete) { // 删除了可友
                self.personalInfo.friendRelation = XKRelationNoting;
            }
            self.personalInfo.secretRelation = XKRelationOneWay;
            self.personalInfo.secretId = self.vc.secretId;
            [XKHudView showSuccessMessage:@"已添加为密友" to:self.vc.containView animated:YES];
            self.updateStatusUI();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                           ^{
                               // 再网络请求一波看对不对
                               [self updateData];
                           });
        }
    }];
}

#pragma mark - 发送消息点击
- (void)sendMessageButtonClick {
    if (self.vc.isSecret) { // 密友
        [self sendMessgeToSecretFriend];
    } else {
        [XKIMGlobalMethod createP2PChatWithNIMID:self.personalInfo.userId];
    }
}

#pragma mark - 发送密友消息
- (void)sendMessgeToSecretFriend {
    NIMSession *session = [NIMSession session:self.personalInfo.userId type:NIMSessionTypeP2P];
    XKSecretChatViewController *vc = [[XKSecretChatViewController alloc] initWithSession:session];
    vc.secretID = self.vc.secretId;
    [self.vc.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 分享
- (void)share {
//    XKWeakSelf(ws);
    
    XKCustomShareView *shareView = [[XKCustomShareView alloc] init];
    shareView.autoThirdShare = YES;
    shareView.shareItems = [@[XKShareItemTypeCircleOfFriends,
                              XKShareItemTypeWechatFriends,
                              XKShareItemTypeQQ,
                              XKShareItemTypeSinaWeibo,
                              XKShareItemTypeMyFriends,
                              XKShareItemTypeCopyLink
                              ] mutableCopy];
    shareView.delegate = self;
    shareView.layoutType = XKCustomShareViewLayoutTypeBottom;
    XKShareDataModel *shareData = [[XKShareDataModel alloc] init];
    shareData.title = self.personalInfo.nickname;
    shareData.content = @"可友主页";
 
    shareData.url = [self getShareUrl];
    shareData.img = self.personalInfo.avatar;
    shareView.shareData = shareData;
    [shareView showInView:[UIApplication sharedApplication].keyWindow.window];
}

- (NSString *)getShareUrl {
  // 开发环境
  NSInteger status = [XKAPPNetworkConfig getDEBUG_MODE];
  NSString *url = nil;
  switch (status) {
    case 0:  // 生产环境
      url = @"https://xkadmin.xksquare.com/share/#/user";
      break;
    case 1:   // 本地开发环境
      url = @"https://dev.xksquare.com/share/#/user";
      break;
    case 2:    // 公司测试服务器
      url = @"https://test.xksquare.com/share/#/user";
      break;
    case 3:     // 灰度测试环境
      url = @"https://xkadmin.xksquare.com/share/#/user";
      break;
    default:
      url = @"https://xkadmin.xksquare.com/share/#/user";
      break;
  }
  url = [NSString stringWithFormat:@"%@?userId=%@&client=sh",url,self.userId];
  return url;
}

// 未开启第三方自动分享或者开启第三方自动分享，但点击项不支持自动分享 点击事件
- (void)customShareView:(XKCustomShareView *) customShareView didClickedShareItem:(NSString *) shareItem {
    if ([shareItem isEqualToString:XKShareItemTypeMyFriends]) {
        __weak typeof(self) weakSelf = self;
        XKContactListController *vc = [[XKContactListController alloc]init];
        vc.useType = XKContactUseTypeManySelect;
        vc.rightButtonText = @"发送";
        vc.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
            [listVC.navigationController popViewControllerAnimated:YES];
            XKIMMessageFirendCardAttachment *attachment = [[XKIMMessageFirendCardAttachment alloc]init];
            attachment.businessUserAvatarUrl = weakSelf.personalInfo.avatar;
            attachment.businessUserNickname = weakSelf.personalInfo.nickname;
            attachment.businessUserId = weakSelf.userId;
            for (XKContactModel *model  in contacts) {
                NIMSession *sesson =  [NIMSession session:model.userId type:NIMSessionTypeP2P];
                [XKIMGlobalMethod sendFriendCard:attachment session:sesson];
            }
            
        };
        [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
    if ([shareItem isEqualToString:XKShareItemTypeCopyLink]) {
        [UIPasteboard generalPasteboard].string = [self getShareUrl];
        [XKHudView showTipMessage:@"已复制链接"];
    }
}

#pragma mark - 举报
- (void)report {
    XKBottomBtnsSheetView * view = [[XKBottomBtnsSheetView alloc] initWithContents:@[@"违法违规",@"涉黄      ",@"赌博欺诈",@"垃圾广告",@"其他    "] title:nil completeBlock:^(XKBottomBtnsSheetView *complaintView, NSArray<NSNumber *> *indexs) {
        // FIXME: sy 产品说先这么做 😆
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                       ^{
                           [XKHudView showTipMessage:@"举报成功"];
                       });
    }];
    [view show];
}

#pragma mark - 加入黑名单
- (void)addToBlackList {
    [XKAlertView showCommonAlertViewWithTitle:@"确认要加入黑名单吗？" message:@"加入黑名单后对方无法向你发送消息，也无法添加你为好友" leftText:@"否" rightText:@"是" leftBlock:^{
    } rightBlock:^{
        [XKHudView showLoadingTo:self.vc.containView animated:YES];
        [XKFriendshipManager requestAddBlackList:self.userId complete:^(NSString *error, id data) {
            [XKHudView hideHUDForView:self.vc.containView animated:YES];
            if (error) {
                [XKHudView showErrorMessage:error to:self.vc.containView animated:YES];
            } else {
                EXECUTE_BLOCK(self.vc.addBlackList,self.userId);
                [XKHudView showTipMessage:@"已加入黑名单" to:self.vc.containView time:1.5 animated:YES completion:^{
                    [self.vc.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    } textAlignment:NSTextAlignmentCenter];
}

#pragma mark - ------------------逻辑

#pragma mark - 申请界面
- (BOOL)vc_useForApply {
    return self.vc.isAcceptApply;
}

#pragma mark - 密友主页  已是密友
- (BOOL)vc_useForSecretAndIsFriend {
    return  self.vc.isSecret == YES && self.personalInfo.secretRelation != XKRelationNoting && [self.vc.secretId isEqualToString:self.personalInfo.secretId];
}

#pragma mark - 密友主页  还未是密友
- (BOOL)vc_useForSecretAndIsNotFriend {
    return  self.vc.isSecret == YES && self.personalInfo.secretRelation == XKRelationNoting;
}
#pragma mark - 可友主页 也是可友
- (BOOL)vc_useForFriendAndIsFriend {
    return  self.vc.isSecret == NO && self.personalInfo.friendRelation != XKRelationNoting;
}
#pragma mark - 可友主页 未是可友
- (BOOL)vc_useForFriendAndIsNotFriend {
    return  self.vc.isSecret == NO && self.personalInfo.friendRelation == XKRelationNoting;
}

@end

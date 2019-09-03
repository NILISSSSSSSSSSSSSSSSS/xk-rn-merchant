//
//  XKFriendMessageListTableViewCell.m
//  XKSquare
//
//  Created by william on 2018/8/23.
//  Copyright © 2018年 xk. All rights reserved.
//
#import "XKRNMerchantCustomerConsultationModel.h"
#import "XKFriendMessageListTableViewCell.h"
#import "XKIM.h"
#import "XKTimeSeparateHelper.h"
#import "XKTransformHelper.h"
#import "XKIMGlobalMethod.h"
#import "XKIMTeamChatManager.h"
#import "XKIMSecretChatLastMessageModel.h"
#import "XKSecretDataSingleton.h"
#import "XKSecretFrientManager.h"
#import "XKRelationUserCacheManager.h"
#import "XKSecretContactCacheManager.h"
#import "XKContactCacheManager.h"
@interface XKFriendMessageListTableViewCell()
/**<##>*/
@property(nonatomic, assign) XKCurrentIMChatModel imChatModel;
@property (nonatomic, assign) XKIMType IMType;
@end
@implementation XKFriendMessageListTableViewCell
#pragma mark – Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.imChatModel = [XKSecretDataSingleton sharedManager].currentIMChatModel;
    [self initViews];
    [self layoutViews];
  }
  return self;
}

#pragma mark - Events

#pragma mark – Private Methods
- (void)initViews {
  [self.contentView addSubview:self.userAvatorImageView];
  [self.contentView addSubview:self.messageCountLabel];
  [self.contentView addSubview:self.userNameLabel];
  [self.contentView addSubview:self.lastMessageLabel];
  [self.contentView addSubview:self.timeLabel];
  [self.contentView addSubview:self.bottomLineView];
  [self.contentView addSubview:self.remindImageView];
}

- (void)layoutViews {
  [_userAvatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.mas_equalTo(self.contentView.mas_centerY);
    make.left.mas_equalTo(self.contentView.mas_left).offset(15);
    make.size.mas_equalTo(CGSizeMake(45 * ScreenScale, 45 * ScreenScale));
  }];
  
  [_messageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.userAvatorImageView.mas_right);
    make.centerY.mas_equalTo(self.userAvatorImageView.mas_top).offset(0);
    make.size.mas_equalTo(CGSizeMake(10 * ScreenScale, 10 * ScreenScale));
  }];
  
  [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.contentView.mas_right).offset(-15 * ScreenScale);
    make.top.mas_equalTo(self.contentView.mas_top).offset(10 * ScreenScale);
    make.height.mas_equalTo(20 * ScreenScale);
  }];
  
  [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.userAvatorImageView.mas_top);
    make.bottom.mas_equalTo(self.userAvatorImageView.mas_centerY);
    make.left.mas_equalTo(self.userAvatorImageView.mas_right).offset(12.5 * ScreenScale);
    make.right.mas_equalTo(self.contentView.mas_right).offset(- SCREEN_WIDTH / 4);
  }];
  _lastMessageLabel.numberOfLines = 0;
  [_lastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.userAvatorImageView.mas_centerY);
    make.bottom.mas_equalTo(self.userAvatorImageView.mas_bottom);
    make.left.mas_equalTo(self.userNameLabel.mas_left);
    make.right.mas_equalTo(self.timeLabel.mas_right).offset(-25 * ScreenScale);
  }];
  [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.and.right.and.bottom.mas_equalTo(self.contentView);
    make.height.mas_equalTo(1);
  }];
  
  [_remindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.mas_equalTo(self.lastMessageLabel.mas_centerY);
    make.right.mas_equalTo(self.contentView.mas_right).offset(- 15 * ScreenScale);
    make.size.mas_equalTo(CGSizeMake(20 * ScreenScale, 20 * ScreenScale));
  }];
}

- (void)setTopChat:(BOOL)isTop {
  if (isTop) {
    self.contentView.backgroundColor = UIColorFromRGB(0xefeff3);
    _bottomLineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
  }
  else{
    self.contentView.backgroundColor = [UIColor whiteColor];
    _bottomLineView.backgroundColor = XKSeparatorLineColor;
  }
}

#pragma mark – Getters and Setters

- (UIImageView *)userAvatorImageView {
  if (!_userAvatorImageView) {
    _userAvatorImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45 * ScreenScale, 45 * ScreenScale)];
    [_userAvatorImageView cutCornerWithRadius:5 color:[UIColor whiteColor] lineWidth:0];
  }
  return _userAvatorImageView;
}

- (UILabel *)messageCountLabel {
  if (!_messageCountLabel) {
    _messageCountLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 10 * ScreenScale, 10 * ScreenScale) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:10] textColor:[UIColor whiteColor] backgroundColor:UIColorFromRGB(0xee6161)];
    _messageCountLabel.textAlignment = NSTextAlignmentCenter;
    [_messageCountLabel cutRoundCornerWithColor:UIColorFromRGB(0xee6161) lineWidth:0];
  }
  return _messageCountLabel;
}

- (UILabel *)timeLabel {
  if (!_timeLabel) {
    _timeLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor clearColor]];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
  }
  return _timeLabel;
}

- (UILabel *)userNameLabel {
  if (!_userNameLabel) {
    _userNameLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:16] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor clearColor]];
    _userNameLabel.textAlignment = NSTextAlignmentLeft;
  }
  return _userNameLabel;
}

- (UILabel *)lastMessageLabel {
  if (!_lastMessageLabel) {
    _lastMessageLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKNormalFont(12) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor clearColor]];
    _lastMessageLabel.textAlignment = NSTextAlignmentLeft;
  }
  return _lastMessageLabel;
}

- (UIView *)bottomLineView {
  if (!_bottomLineView) {
    _bottomLineView = [[UIView alloc]init];
    _bottomLineView.backgroundColor = XKSeparatorLineColor;
  }
  return _bottomLineView;
}

- (UIImageView *)remindImageView {
  if (!_remindImageView) {
    _remindImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_btn_keFriend_remindBell"]];
    _remindImageView.hidden = YES;
  }
  return _remindImageView;
}

#pragma mark -- 最近聊天列表显示
- (void)setRecentSession:(NIMRecentSession *)recentSession {
  _recentSession = recentSession;
  //判断聊天类型
  if (recentSession.session.sessionType == NIMSessionTypeP2P) {
    [self setP2PChatCell];
    if (self.imChatModel == XKCurrentIMChatModelNormal) {
      [self setNomalChat];
    } else {
      [self setSecretChat];
    }
  } else if (recentSession.session.sessionType == NIMSessionTypeTeam) {
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:recentSession.session.sessionId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
      if ([XKIMGlobalMethod isCutomerServerSession:team]) {
        // 客服
        [self setCustomerSerCellWithNIMTeam:team];
      } else {
        // 群聊
        [self setTeamChatCellWithNIMTeam:team];
      }
      if (recentSession.lastMessage.messageType == NIMMessageTypeCustom) {
        self.lastMessageLabel.text = [self getLastMessageContentWithMessage:recentSession.lastMessage];
        // 设置消息发送时间
        NSString *Timestring = [XKTimeSeparateHelper backYMDHMSStringByVirguleSegmentWithTimestampString:[NSString stringWithFormat:@"%tu",(NSInteger)(recentSession.lastMessage.timestamp)]];
        self.timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimeString:Timestring];
      } else {
        self.lastMessageLabel.text = @"";
        self.timeLabel.text = @"";
      }
    }];
  }
  // 设置用户未读消息条数
  [self setUnreadCountWithRecentSession:recentSession];
}

- (void)setSecretChat{
  XKIMSecretChatLastMessageModel *model = [XKSecretFrientManager getLastMessageInDBWithSessionID:self.recentSession.session.sessionId];
  if (model) {
    NSArray *Arr = [[NIMSDK sharedSDK].conversationManager messagesInSession:self.recentSession.session messageIds:@[model.messageId]];
    if (Arr.count > 0) {
      NIMMessage *message = Arr[0];
      if (message) {
        //设置最后一条消息显示
        if (message.messageType == NIMMessageTypeCustom) {
          self.lastMessageLabel.text = [self getLastMessageContentWithMessage:message];
        } else {
          self.lastMessageLabel.text = message.text;
        }
        
        //设置消息发送时间
        NSString *Timestring = [XKTimeSeparateHelper backYMDHMSStringByVirguleSegmentWithTimestampString:[NSString stringWithFormat:@"%ld",(long)(message.timestamp)]];
        
        self.timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimeString:Timestring];
      }
    }
  } else {
    self.lastMessageLabel.text = @"";
    self.timeLabel.text = @"";
  }
}

- (void)setNomalChat{
  //设置最后一条消息显示
  if (self.recentSession.lastMessage.messageType == NIMMessageTypeCustom) {
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
    option.limit = 0;
    option.order = NIMMessageSearchOrderDesc;
    option.messageTypes = @[@(NIMMessageTypeCustom)];
    [[NIMSDK sharedSDK].conversationManager searchMessages:self.recentSession.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
      NIMMessage *resultMessage;
      NSArray *arr = [[messages reverseObjectEnumerator] allObjects];
      for (NIMMessage *message in arr) {
        if (message.isOutgoingMsg) {
          if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
            resultMessage = message;
            break;
          }
        } else {
          if ([XKSecretFrientManager showMessagesSceneWithUserID:message.from] == XKShowMessagesSceneAll ||
              [XKSecretFrientManager showMessagesSceneWithUserID:message.from] == XKShowMessagesSceneNomal) {
            resultMessage = message;
            break;
          }
          if ([XKSecretFrientManager showMessagesSceneWithUserID:message.from] == XKShowMessagesSceneRespective) {
            if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
              resultMessage = message;
              break;
            }
          }
        }
        if (message.messageType == NIMMessageTypeCustom) {
          NIMCustomObject *object = message.messageObject;
          if ([object.attachment isKindOfClass:[XKIMMessageBaseAttachment class]]) {
            XKIMMessageBaseAttachment *baseAtt = object.attachment;
            if (baseAtt.group == 3 && resultMessage == nil) {
              resultMessage = message;
              break;
            }
          }
        }
        
        if ([XKIMGlobalMethod isSecretTipMsgType:message]) {
          resultMessage = message;
          break;
        }
      }
      if (resultMessage) {
        self.lastMessageLabel.text = [self getLastMessageContentWithMessage:resultMessage];
        
        //设置消息发送时间
        NSString *Timestring = [XKTimeSeparateHelper backYMDHMSStringByVirguleSegmentWithTimestampString:[NSString stringWithFormat:@"%tu",(NSInteger)(resultMessage.timestamp)]];
        
        self.timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimeString:Timestring];
      } else {
        self.timeLabel.text = nil;
        self.lastMessageLabel.text = nil;
      }
    }];
  } else {
    //设置消息发送时间
    self.timeLabel.text = nil;
    self.lastMessageLabel.text = nil;
  }
}

- (NSString *)getLastMessageContentWithMessage:(NIMMessage *)msg {
  if ([msg.messageObject isKindOfClass:[NIMCustomObject class]]) {
    NIMCustomObject *object = msg.messageObject;
    if ([object.attachment isKindOfClass:[XKIMMessageBaseAttachment class]]) {
      XKIMMessageBaseAttachment *baseAtt = object.attachment;
      return [baseAtt getAttachmentMsgContent];
    }
  }
  return @"";
}

//设置p2p单聊
- (void)setP2PChatCell{
  //先加载本地缓存
  [self configUserInfo];
  
  //网络成功以后刷新
  [[NIMSDK sharedSDK].userManager fetchUserInfos:@[self.recentSession.session.sessionId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
    [self configUserInfo];
  }];
}

- (void)configUserInfo{
  //网易云托管设置用户头像和昵称
  NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:self.recentSession.session.sessionId];
  self.userNameLabel.text = user.userInfo.nickName ? user.userInfo.nickName : @"未知";
  //可友有备注显示备注
  if (self.imChatModel == XKCurrentIMChatModelNormal) {
    XKContactModel *model = [XKContactCacheManager queryContactWithUserId:user.userId];
    if (model.friendRemark) {
      self.userNameLabel.text = model.friendRemark;
    }
    [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:kDefaultHeadImg];
  }
  //密友有备注显示备注
  if (self.imChatModel == XKCurrentIMChatModelSecret) {
    XKContactModel *model = [XKSecretContactCacheManager queryContactWithUserId:user.userId];
    self.userNameLabel.text = model.nickname;
    if (model.secretRemark) {
      self.userNameLabel.text = model.secretRemark;
    }
    [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:kDefaultHeadImg];
  }
  
  
  //设置是否提醒
  if (self.imChatModel == XKCurrentIMChatModelNormal) {
    if (user.notifyForNewMsg) {
      self.remindImageView.hidden = YES;
    } else {
      self.remindImageView.hidden = NO;
    }
  } else {
    self.remindImageView.hidden = YES;
    if ([[XKDataBase instance] existsTable:XKIMSecretSilenceChatDataBaseTable]) {
      NSString *jsonString = [[XKDataBase instance] select:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
      NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
      if (idArr && idArr.count > 0) {
        if ([idArr containsObject:self.recentSession.session.sessionId]) {
          self.remindImageView.hidden = NO;
        }
      }
    }
  }
  
}

//设置客服
//- (void)setCustomerSerCellWithNIMTeam:(NIMTeam *)team{
//  self.userNameLabel.text = team.teamName ? team.teamName : @"未知";
//  [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:team.avatarUrl] placeholderImage:kDefaultHeadImg];
//
//  //设置是否提醒
//  if (team.notifyStateForNewMsg == NIMTeamNotifyStateAll) {
//    self.remindImageView.hidden = YES;
//  } else {
//    self.remindImageView.hidden = NO;
//  }
//}

//设置群聊
- (void)setTeamChatCellWithNIMTeam:(NIMTeam *)team{
  [XKIMTeamChatManager getTeamNameWithTeamID:team complete:^(NSString *nameString) {
    self.userNameLabel.text = nameString;
  }];
  [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:team.avatarUrl] placeholderImage:kDefaultHeadImg];
  
  //设置是否提醒
  if (team.notifyStateForNewMsg == NIMTeamNotifyStateAll) {
    self.remindImageView.hidden = YES;
  } else {
    self.remindImageView.hidden = NO;
  }
}

#pragma mark -- 消息历史列表展示
- (void)setMessage:(NIMMessage *)message{
  _message = message;
  _messageCountLabel.hidden = YES;
  _remindImageView.hidden = YES;
  NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:message.from];
  _userNameLabel.text = user.userInfo.nickName ? user.userInfo.nickName:@"未知";
  [_userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:user.userInfo.avatarUrl] placeholderImage:kDefaultHeadImg];
  if (message.messageType == NIMMessageTypeCustom) {
    NIMCustomObject *object = message.messageObject;
    if ([object.attachment isKindOfClass:[XKIMMessageBaseAttachment class]]) {
      XKIMMessageBaseAttachment *baseAtt = object.attachment;
      NSString *contentString = [baseAtt getAttachmentMsgContent];
      NSMutableAttributedString *attString = [self stringWithHighLightSubstring:contentString substring:_searchKeyWord];
      _lastMessageLabel.attributedText = attString;
    }
  }
}

//设置搜索高亮
- (NSMutableAttributedString *)stringWithHighLightSubstring:(NSString *)totalString substring:(NSString *)substring{
  NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:totalString];
  NSString * copyTotalString = totalString;
  NSMutableString * replaceString = [NSMutableString stringWithCapacity:0];
  for (int i = 0; i < substring.length; i ++) {
    [replaceString appendString:@" "];
  }
  while ([copyTotalString rangeOfString:substring].location != NSNotFound) {
    NSRange range = [copyTotalString rangeOfString:substring];
    //颜色如果统一的话可写在这里，如果颜色根据内容在改变，可把颜色作为参数，调用方法的时候传入
    [attributedString addAttribute:NSForegroundColorAttributeName value:XKMainTypeColor range:range];
    copyTotalString = [copyTotalString stringByReplacingCharactersInRange:range withString:replaceString];
  }
  return attributedString;
}

//根据关系获取是否有未读
- (void)setUnreadCountWithRecentSession:(NIMRecentSession *)recentSession{
  if (recentSession.session.sessionType == NIMSessionTypeP2P) {
    if (recentSession.unreadCount == 0) {
      _messageCountLabel.hidden = YES;
      return;
    }
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
    option.limit = recentSession.unreadCount;
    option.order = NIMMessageSearchOrderDesc;
    option.messageTypes = @[@(NIMMessageTypeCustom)];
    [[NIMSDK sharedSDK].conversationManager searchMessages:recentSession.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
      if (self.imChatModel == XKCurrentIMChatModelNormal) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:messages];
        for (NIMMessage *message in messages) {
          if ([XKSecretFrientManager showMessagesSceneWithUserID:message.from] == XKShowMessagesSceneSecret) {
            [arr removeObject:message];
          }
          if ([XKSecretFrientManager showMessagesSceneWithUserID:message.from] == XKShowMessagesSceneRespective) {
            if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
              [arr removeObject:message];
            }
          }
          if (message.messageType == NIMMessageTypeCustom) {
            NIMCustomObject *object = message.messageObject;
            if ([object.attachment isKindOfClass:[XKIMMessageBaseAttachment class]]) {
              XKIMMessageBaseAttachment *baseAtt = object.attachment;
              if (baseAtt.group == 3 && ![arr containsObject:message]) {
                [arr addObject: message];
              }
              if (baseAtt.extraType == XKIMExtraAttachmentSecretTipMsgType) {
                [arr addObject: message];
              }
            }
          }
        }
        
        if (arr.count > 0) {
          self.messageCountLabel.hidden = NO;
        } else {
          self.messageCountLabel.hidden = YES;
        }
      } else {
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
          self.messageCountLabel.hidden = NO;
        } else {
          self.messageCountLabel.hidden = YES;
        }
      }
    }];
  } else {
    if (recentSession.unreadCount == 0) {
      _messageCountLabel.hidden = YES;
    } else {
      _messageCountLabel.hidden = NO;
    }
  }
}

#pragma mark – Public Methods

- (void)configCellWithIMType:(XKIMType)IMType recentSession:(NIMRecentSession *)recentSession {
  _IMType = IMType;
  _recentSession = recentSession;
  //判断聊天类型
  if (recentSession.session.sessionType == NIMSessionTypeP2P) {
    [self setP2PChatCell];
    if (self.imChatModel == XKCurrentIMChatModelNormal) {
      [self setNomalChat];
    } else {
      [self setSecretChat];
    }
  } else if (recentSession.session.sessionType == NIMSessionTypeTeam) {
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:recentSession.session.sessionId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
      if ([XKIMGlobalMethod isCutomerServerSession:team]) {
        // 客服
        [self setCustomerSerCellWithNIMTeam:team];
      } else {
        // 群聊
        [self setTeamChatCellWithNIMTeam:team];
      }
      if (recentSession.lastMessage.messageType == NIMMessageTypeCustom) {
        self.lastMessageLabel.text = [self getLastMessageContentWithMessage:recentSession.lastMessage];
        // 设置消息发送时间
        NSString *Timestring = [XKTimeSeparateHelper backYMDHMSStringByVirguleSegmentWithTimestampString:[NSString stringWithFormat:@"%tu",(NSInteger)(recentSession.lastMessage.timestamp)]];
        self.timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimeString:Timestring];
      } else {
        self.lastMessageLabel.text = @"";
        self.timeLabel.text = @"";
      }
    }];
  }
  // 设置用户未读消息条数
  [self setUnreadCountWithRecentSession:recentSession];
}

- (void)configCellWithCustomerConsultationModel:(XKRNMerchantCustomerConsultationModel *)customerConsultationModel {
  self.messageCountLabel.hidden = YES;
  if (customerConsultationModel.avatar && customerConsultationModel.avatar.length) {
    [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:customerConsultationModel.avatar] placeholderImage:[UIImage imageNamed:@"xk_ic_home_default_header"]];
  } else {
    self.userAvatorImageView.image = [UIImage imageNamed:@"xk_ic_home_default_header"];
  }
  self.userNameLabel.text = customerConsultationModel.nickname;
  if (customerConsultationModel.msg) {
    NSString *Timestring = [XKTimeSeparateHelper backYMDHMSStringByVirguleSegmentWithTimestampString:[NSString stringWithFormat:@"%tu",(NSInteger)(customerConsultationModel.msg.sendTime / 1000.0)]];
    self.timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimeString:Timestring];
    self.lastMessageLabel.text = customerConsultationModel.msg.messageObject.msgContent;
  } else {
    self.timeLabel.text = @"";
    self.lastMessageLabel.text = @"";
  }
}

- (void)setCustomerSerCellWithNIMTeam:(NIMTeam *)team {
  if (self.IMType == XKIMTypeNone) {
    self.userNameLabel.text = team.teamName ? team.teamName : @"未知";
    [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:team.avatarUrl] placeholderImage:[UIImage imageNamed:@"xk_ic_home_default_header"]];
  } else if (self.IMType == XKIMTypeMerchantCustomerService) {
    // 在商户APP客服聊天时，需要显示咨询的用户的头像，此时需要特殊处理
    self.userNameLabel.text = @"未知";
    self.userAvatorImageView.image = [UIImage imageNamed:@"xk_ic_home_default_header"];
    [[NIMSDK sharedSDK].teamManager fetchTeamMembers:self.recentSession.session.sessionId completion:^(NSError * _Nullable error, NSArray<NIMTeamMember *> * _Nullable members) {
      if (!error) {
        for (NIMTeamMember *member in members) {
          if (![member.userId isEqualToString:[XKUserInfo currentUser].userId]) {
            [[NIMSDK sharedSDK].userManager fetchUserInfos:@[member.userId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
              if (!error) {
                if (users.count) {
                  NIMUser *theUser = users.firstObject;
                  self.userNameLabel.text = theUser.userInfo.nickName;
                  [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:theUser.userInfo.avatarUrl] placeholderImage:[UIImage imageNamed:@"xk_ic_home_default_header"]];
                }
              }
            }];
            break;
          }
        }
      }
    }];
  }
  
  //设置是否提醒
  if (team.notifyStateForNewMsg == NIMTeamNotifyStateAll) {
    self.remindImageView.hidden = YES;
  } else {
    self.remindImageView.hidden = NO;
  }
}

@end

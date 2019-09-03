//
//  XKCustomerSerciveHistoryCell.m
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKCustomerSerciveHistoryCell.h"
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
#import "XKRNMerchantCustomerConsultationModel.h"
@interface XKCustomerSerciveHistoryCell()
@property (nonatomic,strong) UIView         *bottomLineView;

@end
@implementation XKCustomerSerciveHistoryCell
#pragma mark – Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self initViews];
    [self layoutViews];
  }
  return self;
}

#pragma mark - Events

#pragma mark – Private Methods
-(void)initViews{
  [self.contentView addSubview:self.userAvatorImageView];
  [self.contentView addSubview:self.messageCountLabel];
  [self.contentView addSubview:self.userNameLabel];
  [self.contentView addSubview:self.lastMessageLabel];
  [self.contentView addSubview:self.timeLabel];
  [self.contentView addSubview:self.bottomLineView];
  [self.contentView addSubview:self.remindImageView];
  [self.contentView addSubview:self.reasonLabel];
}

-(void)layoutViews{
  [_userAvatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.mas_equalTo(self.contentView.mas_centerY);
    make.left.mas_equalTo(self.contentView.mas_left).offset(10);
    make.size.mas_equalTo(CGSizeMake(45 * ScreenScale, 45 * ScreenScale));
  }];
  
  [_messageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self->_userAvatorImageView.mas_right);
    make.centerY.mas_equalTo(self->_userAvatorImageView.mas_top).offset(0);
    make.size.mas_equalTo(CGSizeMake(10 * ScreenScale, 10 * ScreenScale));
  }];
  
  [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(self.contentView.mas_right).offset(-15 * ScreenScale);
    make.top.mas_equalTo(self.contentView.mas_top).offset(10 * ScreenScale);
    make.height.mas_equalTo(20 * ScreenScale);
  }];
  
  [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self->_userAvatorImageView.mas_top);
    make.bottom.mas_equalTo(self->_userAvatorImageView.mas_centerY);
    make.left.mas_equalTo(self->_userAvatorImageView.mas_right).offset(12.5 * ScreenScale);
    make.right.mas_equalTo(self.contentView.mas_right).offset(- SCREEN_WIDTH / 4);
  }];
  _lastMessageLabel.numberOfLines = 0;
  [_lastMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self->_userAvatorImageView.mas_centerY);
    make.bottom.mas_equalTo(self->_userAvatorImageView.mas_bottom);
    make.left.mas_equalTo(self->_userNameLabel.mas_left);
    make.right.mas_equalTo(self->_timeLabel.mas_right).offset(-25 * ScreenScale);
  }];
  
  [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    make.left.right.equalTo(self.lastMessageLabel);
  }];
  
  [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.and.right.and.bottom.mas_equalTo(self.contentView);
    make.height.mas_equalTo(1);
  }];
  
  [_remindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.mas_equalTo(self->_lastMessageLabel.mas_centerY);
    make.right.mas_equalTo(self.contentView.mas_right).offset(- 15 * ScreenScale);
    make.size.mas_equalTo(CGSizeMake(20 * ScreenScale, 20 * ScreenScale));
  }];
}

-(void)setTopChat:(BOOL)isTop{
  if (isTop) {
    self.backgroundColor = UIColorFromRGB(0xefeff3);
    _bottomLineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
  }
  else{
    self.backgroundColor = [UIColor whiteColor];
    _bottomLineView.backgroundColor = XKSeparatorLineColor;
  }
}

-(void)test{
  [_userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534254111904&di=1e487e3d79ef4a654278b05f5280d38c&imgtype=0&src=http%3A%2F%2Fwww.qqzhi.com%2Fuploadpic%2F2015-01-11%2F050001550.jpg"] placeholderImage:kDefaultHeadImg];
  _messageCountLabel.text = @"1";
  _timeLabel.text = @"3分钟前";
  _userNameLabel.text = @"一叶知秋";
  _lastMessageLabel.text = @"晚上一起去看电影？";
  _reasonLabel.text = @"一分钟未应答，已转其他客服处理";
}

#pragma mark – Getters and Setters

-(UIImageView *)userAvatorImageView{
  if (!_userAvatorImageView) {
    _userAvatorImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45 * ScreenScale, 45 * ScreenScale)];
    [_userAvatorImageView cutCornerWithRadius:5 color:[UIColor whiteColor] lineWidth:0];
  }
  return _userAvatorImageView;
}

-(UILabel *)messageCountLabel{
  if (!_messageCountLabel) {
    _messageCountLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 10 * ScreenScale, 10 * ScreenScale) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:10] textColor:[UIColor whiteColor] backgroundColor:UIColorFromRGB(0xee6161)];
    _messageCountLabel.textAlignment = NSTextAlignmentCenter;
    [_messageCountLabel cutRoundCornerWithColor:UIColorFromRGB(0xee6161) lineWidth:0];
  }
  return _messageCountLabel;
}

-(UILabel *)timeLabel{
  if (!_timeLabel) {
    _timeLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] textColor:UIColorFromRGB(0x999999) backgroundColor:[UIColor clearColor]];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
  }
  return _timeLabel;
}

-(UILabel *)userNameLabel{
  if (!_userNameLabel) {
    _userNameLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:16] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor clearColor]];
    _userNameLabel.textAlignment = NSTextAlignmentLeft;
  }
  return _userNameLabel;
}

-(UILabel *)reasonLabel {
  if (!_reasonLabel) {
    _reasonLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:[UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:12] textColor:XKMainRedColor backgroundColor:[UIColor clearColor]];
    _reasonLabel.textAlignment = NSTextAlignmentLeft;
  }
  return _reasonLabel;
}

-(UILabel *)lastMessageLabel{
  if (!_lastMessageLabel) {
    _lastMessageLabel = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:@"" font:XKNormalFont(12) textColor:UIColorFromRGB(0x777777) backgroundColor:[UIColor clearColor]];
    _lastMessageLabel.textAlignment = NSTextAlignmentLeft;
  }
  return _lastMessageLabel;
}

-(UIView *)bottomLineView{
  if (!_bottomLineView) {
    _bottomLineView = [[UIView alloc]init];
    _bottomLineView.backgroundColor = XKSeparatorLineColor;
  }
  return _bottomLineView;
}

-(UIImageView *)remindImageView{
  if (!_remindImageView) {
    _remindImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_btn_keFriend_remindBell"]];
    _remindImageView.hidden = YES;
  }
  return _remindImageView;
}

#pragma mark -- 设置圆角
-(void)setIndexPath:(NSIndexPath *)indexPath allRow:(NSInteger)allRow{
  if (indexPath.row == 0) {
    self.layer.mask = nil;
    [self cutCornerWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 20, 70 * ScreenScale) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
  }
  else if (indexPath.row == (allRow - 1)){
    self.layer.mask = nil;
    [self cutCornerWithRoundedRect:CGRectMake(0, 0, SCREEN_WIDTH - 20, 70 * ScreenScale) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
  }
  else{
    self.layer.mask = nil;
  }
}

#pragma mark -- 最近聊天列表显示
-(void)setRecentSession:(NIMRecentSession *)recentSession{
  _recentSession = recentSession;
  XKWeakSelf(weakSelf);
  //判断聊天类型
  if (recentSession.session.sessionType == 0) {
    [self setP2PChatCell];
    if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelNormal) {
      [self setNomalChat];
    }
    else{
      [self setSecretChat];
    }
  }
  else if(recentSession.session.sessionType == 1){
    [[NIMSDK sharedSDK].teamManager fetchTeamInfo:recentSession.session.sessionId completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
      
      if ([XKIMGlobalMethod isCutomerServerSession:team]) {
        //客服
        [self setCustomerSerCellWithNIMTeam:team];
      }
      else{
        //群聊
        [self setTeamChatCellWithNIMTeam:team];
      }
      NSDictionary *dict = [XKTransformHelper dictByJsonString:[NSString stringWithFormat:@"%@",recentSession.lastMessage.messageObject]];
      weakSelf.lastMessageLabel.text = [self getLastMessageContentWithMessage:dict];
      
      //设置消息发送时间
      NSString *Timestring = [XKTimeSeparateHelper backYMDHMSStringByVirguleSegmentWithTimestampString:[NSString stringWithFormat:@"%tu",(NSInteger)(recentSession.lastMessage.timestamp)]];
      weakSelf.timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimeString:Timestring];
    }];
  }
  else{
    
  }
  
  //设置用户未读消息条数
  [self setUnreadCountWithRecentSession:recentSession];
  
  
}

-(void)setSecretChat{
  XKIMSecretChatLastMessageModel *model = [XKSecretFrientManager getLastMessageInDBWithSessionID:_recentSession.session.sessionId];
  if (model) {
    NSArray *Arr = [[NIMSDK sharedSDK].conversationManager messagesInSession:_recentSession.session messageIds:@[model.messageId]];
    NIMMessage *message = Arr[0];
    if (message) {
      //设置最后一条消息显示
      if (message.messageType == NIMMessageTypeCustom) {
        NSDictionary *dict = [XKTransformHelper dictByJsonString:[NSString stringWithFormat:@"%@",message.messageObject]];
        _lastMessageLabel.text = [self getLastMessageContentWithMessage:dict];
      }
      else{
        _lastMessageLabel.text =message.text;
      }
      
      //设置消息发送时间
      NSString *Timestring = [XKTimeSeparateHelper backYMDHMSStringByVirguleSegmentWithTimestampString:[NSString stringWithFormat:@"%ld",(long)(message.timestamp)]];
      
      _timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimeString:Timestring];
    }
  }
  
}

-(void)setNomalChat{
  //设置最后一条消息显示
  if (_recentSession.lastMessage.messageType == NIMMessageTypeCustom) {
    
    XKWeakSelf(weakSelf);
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
    option.limit = 0;
    option.order = NIMMessageSearchOrderDesc;
    option.messageTypes = @[@(NIMMessageTypeCustom)];
    [[NIMSDK sharedSDK].conversationManager searchMessages:weakSelf.recentSession.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
      NIMMessage *resultMessage;
      NSArray *arr = [[messages reverseObjectEnumerator]allObjects];
      for (NIMMessage *message in arr) {
        if (message.isOutgoingMsg) {
          if (![XKSecretFrientManager messageIsFromSecretFriend:message]) {
            resultMessage = message;
            break;
          }
        }
        else{
          if ([XKSecretFrientManager showMessagesSceneWithUserID:message.from] == XKShowMessagesSceneAll
              || [XKSecretFrientManager showMessagesSceneWithUserID:message.from] == XKShowMessagesSceneNomal)
          {
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
      }
      
      NSDictionary *dict = [XKTransformHelper dictByJsonString:[NSString stringWithFormat:@"%@",resultMessage.messageObject]];
      weakSelf.lastMessageLabel.text = [self getLastMessageContentWithMessage:dict];
      
      //设置消息发送时间
      NSString *Timestring = [XKTimeSeparateHelper backYMDHMSStringByVirguleSegmentWithTimestampString:[NSString stringWithFormat:@"%tu",(NSInteger)(resultMessage.timestamp)]];
      
      weakSelf.timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimeString:Timestring];
    }];
  }
  else{
    _lastMessageLabel.text =_recentSession.lastMessage.text;
    //设置消息发送时间
    NSString *Timestring = [XKTimeSeparateHelper backYMDHMSStringByVirguleSegmentWithTimestampString:[NSString stringWithFormat:@"%tu",(NSInteger)(_recentSession.lastMessage.timestamp)]];
    _timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimeString:Timestring];
  }
}

-(NSString *)getLastMessageContentWithMessage:(NSDictionary *)dict{
  return dict[@"data"][@"msgContent"];
  //    NSString *string = @"";
  //
  //    switch ([dict[@"type"]integerValue]) {
  //        case XK_NORMAL_TEXT:
  //            string = dict[@"data"][@"msgContent"];
  //            break;
  //        case 2:
  //            string = @"[图片]";
  //            break;
  //        case 3:
  //            string = @"[语音]";
  //            break;
  //        case 4:
  //            string = @"[视频]";
  //            break;
  //        case 9:
  //            string = @"[商品]";
  //            break;
  //        case 11:
  //            string = @"[名片]";
  //            break;
  //        case 13:
  //            string = @"[订单]";
  //            break;
  //        case 14:
  //            string = dict[@"data"][@"msgContent"];
  //            break;
  //        case 15:
  //            string = @"[小视频]";
  //            break;
  //        case 16:
  //            string = @"[店铺]";
  //            break;
  //        case 17:
  //            string = @"[游戏]";
  //            break;
  //        case 18:
  //            string = @"[小视频]";
  //            break;
  //        case 19:
  //            string = @"[福利]";
  //            break;
  //        case 20:
  //            string = @"[礼物]";
  //            break;
  //        case 21:
  //            string = @"[红包]";
  //        case 22:
  //            string = @"[红包]";
  //            break;
  //        default:
  //            string = @"[未知类型消息]";
  //            break;
  //    }
  //    return string;
}

//设置p2p单聊
-(void)setP2PChatCell{
  //先加载本地缓存
  [self configUserInfo];
  
  //网络成功以后刷新
  [[NIMSDK sharedSDK].userManager fetchUserInfos:@[_recentSession.session.sessionId] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
    [self configUserInfo];
  }];
}

-(void)configUserInfo{
  //网易云托管设置用户头像和昵称
  NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:self->_recentSession.session.sessionId];
  self->_userNameLabel.text = user.userInfo.nickName ? user.userInfo.nickName:@"未知";
  [self->_userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:user.userInfo.avatarUrl] placeholderImage:kDefaultHeadImg];
  //可友有备注显示备注
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelNormal) {
    XKContactModel *model = [XKRelationUserCacheManager queryContactWithUserId:user.userId];
    if (model.friendRemark) {
      self->_userNameLabel.text = model.friendRemark;
    }
  }
  //密友有备注显示备注
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret) {
    XKContactModel *model = [XKSecretContactCacheManager queryContactWithUserId:user.userId];
    self->_userNameLabel.text = model.nickname;
    if (model.secretRemark) {
      self->_userNameLabel.text = model.secretRemark;
    }
  }
  
  
  //设置是否提醒
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelNormal) {
    if (user.notifyForNewMsg) {
      self->_remindImageView.hidden = YES;
    }
    else{
      self->_remindImageView.hidden = NO;
    }
  }
  else{
    self->_remindImageView.hidden = YES;
    if ([[XKDataBase instance]existsTable:XKIMSecretSilenceChatDataBaseTable]) {
      NSString *jsonString = [[XKDataBase instance]select:XKIMSecretSilenceChatDataBaseTable key:[XKUserInfo getCurrentUserId]];
      NSArray *idArr = [XKTransformHelper jsonStringToArr:jsonString];
      if (idArr && idArr.count > 0) {
        if ([idArr containsObject:_recentSession.session.sessionId]) {
          self->_remindImageView.hidden = NO;
        }
      }
    }
  }
  
}

//设置客服
-(void)setCustomerSerCellWithNIMTeam:(NIMTeam *)team{
  self->_userNameLabel.text = team.teamName ? team.teamName:@"未知";
  [self->_userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:team.avatarUrl] placeholderImage:kDefaultHeadImg];
  
  //设置是否提醒
  if (team.notifyStateForNewMsg == NIMTeamNotifyStateAll) {
    self->_remindImageView.hidden = YES;
  }
  else{
    self->_remindImageView.hidden = NO;
  }
}

//设置群聊
-(void)setTeamChatCellWithNIMTeam:(NIMTeam *)team{
  [XKIMTeamChatManager getTeamNameWithTeamID:team complete:^(NSString *nameString) {
    self->_userNameLabel.text = nameString;
  }];
  [self->_userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:team.avatarUrl] placeholderImage:kDefaultHeadImg];
  
  //设置是否提醒
  if (team.notifyStateForNewMsg == NIMTeamNotifyStateAll) {
    self->_remindImageView.hidden = YES;
  }
  else{
    self->_remindImageView.hidden = NO;
  }
}

#pragma mark -- 消息历史列表展示
-(void)setMessage:(NIMMessage *)message{
  _message = message;
  _messageCountLabel.hidden = YES;
  _remindImageView.hidden = YES;
  NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:message.from];
  _userNameLabel.text = user.userInfo.nickName ? user.userInfo.nickName:@"未知";
  [_userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:user.userInfo.avatarUrl] placeholderImage:kDefaultHeadImg];
  NSDictionary *dict = [XKTransformHelper dictByJsonString:[NSString stringWithFormat:@"%@",message.messageObject]];
  NSString *contentString = dict[@"data"][@"msgContent"];
  NSMutableAttributedString *attString = [self stringWithHighLightSubstring:contentString substring:_searchKeyWord];
  _lastMessageLabel.attributedText = attString;
}

//设置搜索高亮
-(NSMutableAttributedString *)stringWithHighLightSubstring:(NSString *)totalString substring:(NSString *)substring{
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
-(void)setUnreadCountWithRecentSession:(NIMRecentSession *)recentSession{
  if (recentSession.session.sessionType == NIMSessionTypeP2P) {
    if (recentSession.unreadCount == 0) {
      _messageCountLabel.hidden = YES;
      return;
    }
    XKWeakSelf(weakSelf);
    NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
    option.limit = recentSession.unreadCount;
    option.order = NIMMessageSearchOrderDesc;
    option.messageTypes = @[@(NIMMessageTypeCustom)];
    [[NIMSDK sharedSDK].conversationManager searchMessages:recentSession.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
      if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelNormal) {
        
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
        }
        
        if (arr.count > 0) {
          weakSelf.messageCountLabel.hidden = NO;
        }
        else{
          weakSelf.messageCountLabel.height = YES;
        }
        
      }else{
        
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
          weakSelf.messageCountLabel.hidden = NO;
        }
        else{
          weakSelf.messageCountLabel.height = YES;
        }
        
      }
    }];
  }
  else{
    if (recentSession.unreadCount == 0) {
      _messageCountLabel.hidden = YES;
    }
    else{
      _messageCountLabel.hidden = NO;
      //        _messageCountLabel.text = [NSString stringWithFormat:@"%ld",(long)recentSession.unreadCount];
    }
  }
}

- (void)configCellWithCustomerConsultationModel:(XKRNMerchantCustomerConsultationModel *)customerConsultationModel {
  self.messageCountLabel.hidden = YES;
  if (customerConsultationModel.avatar && customerConsultationModel.avatar.length) {
    [self.userAvatorImageView sd_setImageWithURL:[NSURL URLWithString:customerConsultationModel.avatar] placeholderImage:kDefaultHeadImg];
  } else {
    self.userAvatorImageView.image = kDefaultHeadImg;
  }
  self.userNameLabel.text = customerConsultationModel.nickname;
  if (customerConsultationModel.msg) {
    self.timeLabel.hidden = NO;
    self.lastMessageLabel.hidden = NO;
  } else {
    self.timeLabel.hidden = YES;
    self.lastMessageLabel.hidden = YES;
    self.timeLabel.text = [XKTimeSeparateHelper customTimeStyleWithTimeString:[NSString stringWithFormat:@"%tu", customerConsultationModel.msg.sendTime]];
    self.lastMessageLabel.text = customerConsultationModel.msg.messageObject.msgContent;
  }
  self.reasonLabel.text = @"一分钟未应答，已转其他客服处理";
}

@end

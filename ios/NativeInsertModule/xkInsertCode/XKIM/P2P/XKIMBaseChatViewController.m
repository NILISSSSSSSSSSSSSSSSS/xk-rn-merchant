//
//  XKIMBaseChatViewController.m
//  XKSquare
//
//  Created by william on 2018/8/29.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKIMBaseChatViewController.h"
#import "XKIM.h"
#import <NIMKitUtil.h>
#import <NIMCustomLeftBarView.h>
#import <NIMBadgeView.h>
#import <UITableView+NIMScrollToBottom.h>
#import <NIMMessageMaker.h>
#import <UIView+NIM.h>
#import <NIMSessionConfigurator.h>
#import <NIMKitInfoFetchOption.h>
#import <NIMKitTitleView.h>
#import <NIMKitKeyboardInfo.h>
//#import "XKTeamChatMoreContainerView.h"
//#import "XKP2PChatMoreContainerView.h"
#import "XKIMSDKChatToolView.h"
#import "XKIMGlobalMethod.h"
#import "XKPersonDetailInfoViewController.h"
#import "XKIMMessageRedEnvelopeContentView.h"
#import "XKRedPacketDetailViewController.h"
#import "XKContactListController.h"
#import "XKIMMessageNomalAudioContentView.h"
#import "XKVideoDisplayMediator.h"
#import "NIMMessageCell.h"
#import "XKIMMessageCustomConfig.h"
#import "XKIMMultipleSelectionOperationView.h"
#import "XKSecretFrientManager.h"
#import "XKSecretDataSingleton.h"
#import "XKRedEnvelopeViewController.h"
//#import "XKRedEnvelopeManager.h"

@interface XKIMBaseChatViewController ()<NIMMediaManagerDelegate, XKIMBaseChatInputDelegate>
// 长按对应的message
@property (nonatomic,readwrite) NIMMessage *messageForMenu;
// 长按对应的ContentView
@property (nonatomic, strong) NIMSessionMessageContentView *messageContentView;
// 大标题
@property (nonatomic,strong)    UILabel *titleLabel;
// 小标题
@property (nonatomic,strong)    UILabel *subTitleLabel;
// 屏幕旋转前可以看见的最后一条消息位置
@property (nonatomic,strong)    NSIndexPath *lastVisibleIndexPathBeforeRotation;
// 会话配置器
@property (nonatomic,strong)  NIMSessionConfigurator *configurator;
// 会话交互器
@property (nonatomic,weak)    id<NIMSessionInteractor> interactor;

// 多选模式操作视图
@property (nonatomic, strong) XKIMMultipleSelectionOperationView *operationView;
// 是否为多选模式
@property (nonatomic, assign) BOOL isMultipleSelectionMode;
// 多选模式下选中的消息
@property (nonatomic, strong) NSMutableArray <NIMMessage *>*selectedMessages;
//是否处理过搜索
@property (nonatomic, assign) BOOL isSearched;
@end

@implementation XKIMBaseChatViewController

#pragma mark - life cycle

- (instancetype)initWithSession:(NIMSession *)session{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _session = session;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //导航栏
  [self setupNav];
  //消息 tableView
  [self setupTableView];
  //输入框 inputView
  [self setupInputView];
  //会话相关逻辑配置器安装
  [self setupConfigurator];
  //添加监听
  [self addListener];
  //进入会话时，标记所有消息已读，并发送已读回执
  [self markRead];
  //更新已读位置
  [self uiCheckReceipts:nil];
  
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView) name:XKIMBaseChatViewControllrtRefreshViewNotification object:nil];
  
  _isSearched = NO;
  if (_searchMessage) {
    //        self.tableView.hidden = YES;
    [XKHudView showLoadingTo:self.view animated:YES];
  }
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret) {
    self.navStyle = BaseNavWhiteStyle;
  } else {
    self.navStyle = BaseNavBlueStyle;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.interactor onViewWillAppear];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  //如果是搜索记录进入 跳转到对应记录
  if (_searchMessage && _isSearched==NO) {
    NSInteger index = [_interactor findMessageIndex:_searchMessage];
    do {
      [_interactor loadMessages:^(NSArray *messages, NSError *error) {
      }];
      index = [_interactor findMessageIndex:_searchMessage];
      
    } while (index < 0);
    //数据初始化后 延迟执行跳转
    XKWeakSelf(weakSelf);
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
      NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
      [weakSelf.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
      [XKHudView hideAllHud];
      weakSelf.tableView.hidden = NO;
      weakSelf.isSearched = YES;
    });
    
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.sessionInputView endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.interactor onViewDidDisappear];
}


- (void)viewDidLayoutSubviews {
  [self changeLeftBarBadge:self.conversationManager.allUnreadCount];
  [self.interactor resetLayout];
}

- (void)dealloc {
  [self removeListener];
  [[NIMKit sharedKit].robotTemplateParser clean];
  
  _tableView.delegate = nil;
  _tableView.dataSource = nil;
}

#pragma mark - 初始化
//刷新消息tableview
-(void)refreshView{
  [self.interactor resetMessages:nil];
  [self.tableView reloadData];
}

- (void)setupNav {
  self.navigationController.navigationBar.hidden = YES;
  [self hideNavigation];
}

- (void)setupTableView {
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.tableView.backgroundColor = UIColorFromRGB(0xEEEEEE);
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.estimatedRowHeight = 0;
  self.tableView.estimatedSectionHeaderHeight = 0;
  self.tableView.estimatedSectionFooterHeight = 0;
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  if ([self.sessionConfig respondsToSelector:@selector(sessionBackgroundImage)] && [self.sessionConfig sessionBackgroundImage]) {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.image = [self.sessionConfig sessionBackgroundImage];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = imgView;
  }
  [self.view addSubview:self.tableView];
}

- (void)setupInputView {
  if ([self shouldShowInputView]) {
    self.sessionInputView = [[XKIMBaseChatInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.nim_width,0) config:self.sessionConfig];
    self.sessionInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.sessionInputView setSession:self.session];
    [self.sessionInputView setInputDelegate:self];
    [self.sessionInputView setInputActionDelegate:self];
    [self.sessionInputView refreshStatus:XKIMInputStatusText];
    
    XKIMSDKChatToolView *moreContainer = [[XKIMSDKChatToolView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 227)];
    moreContainer.session = self.session;
    if (self.session.sessionType == NIMSessionTypeP2P) {
      moreContainer.toolType = XKIMSDKChatToolViewTypeP2P;
      [moreContainer prepareWithTools:@[camera, photo, friendCard]];
    } else {
      moreContainer.toolType = XKIMSDKChatToolViewTypeTeam;
      [moreContainer prepareWithTools:@[camera, photo, friendCard]];
    }
    self.sessionInputView.moreContainer = moreContainer;
    [self.view addSubview:_sessionInputView];
  }
}

- (void)setupConfigurator {
  _configurator = [[NIMSessionConfigurator alloc] init];
  [_configurator setup:(NIMSessionViewController *)self];
  
  BOOL needProximityMonitor = [self needProximityMonitor];
  [[NIMSDK sharedSDK].mediaManager setNeedProximityMonitor:needProximityMonitor];
}

#pragma mark - 消息收发接口
- (void)sendMessage:(NIMMessage *)message {
  [self.interactor sendMessage:message];
}


#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  [_sessionInputView endEditing:YES];
}


#pragma mark - NIMSessionInteractorDelegate

- (void)didFetchMessageData {
  [self uiCheckReceipts:nil];
  [self.tableView reloadData];
  [self.tableView nim_scrollToBottom:NO];
}

- (void)didRefreshMessageData {
  [self refreshSessionTitle:self.sessionTitle];
  [self refreshSessionSubTitle:self.sessionSubTitle];
  [self.tableView reloadData];
}

- (void)didPullUpMessageData {}

#pragma mark - 会话title
- (NSString *)sessionTitle {
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

- (NSString *)sessionSubTitle{
  return @"";
}

#pragma mark - NIMChatManagerDelegate
//开始发送
- (void)willSendMessage:(NIMMessage *)message {
  id<NIMSessionInteractor> interactor = self.interactor;
  
  if ([message.session isEqual:self.session]) {
    if ([interactor findMessageModel:message]) {
      [interactor updateMessage:message];
    }else{
      [interactor addMessages:@[message]];
    }
  }
}
//上传资源文件成功
- (void)uploadAttachmentSuccess:(NSString *)urlString
                     forMessage:(NIMMessage *)message {
  //如果需要使用富文本推送，可以在这里进行 message apns payload 的设置
}
//发送结果
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error {
  if ([message.session isEqual:_session])
  {
    [self.interactor updateMessage:message];
    if (message.session.sessionType == NIMSessionTypeTeam)
    {
      //如果是群的话需要检查一下回执显示情况
      NIMMessageReceipt *receipt = [[NIMMessageReceipt alloc] initWithMessage:message];
      [self.interactor checkReceipts:@[receipt]];
    }
  }
}
//发送进度
-(void)sendMessage:(NIMMessage *)message progress:(float)progress {
  if ([message.session isEqual:_session]) {
    [self.interactor updateMessage:message];
  }
}
//接收消息
- (void)onRecvMessages:(NSArray *)messages {
  // 有设置监听
  if ([self shouldAddListenerForNewMsg]) {
    messages = [self filterMessages:messages];
    NIMMessage *message = messages.firstObject;
    NIMSession *session = message.session;
    if (![session isEqual:self.session] || !messages.count) {
      return;
    }
    // 撤回消息时，需要在对应的位置插入一条撤回提示消息（成功后会调用该方法），故此时应使用insert方式，以保证提示消息位置正确
    [self uiInsertMessages:messages];
    [self.interactor markRead];
  }
}
// 消息过滤
- (NSArray *)filterMessages:(NSArray *)messages {
  NSMutableArray *array = [NSMutableArray array];
  for (NIMMessage *message in messages) {
    if ([self checkRedEnvelopeTip:message] && ![self shouldSaveMessageRedEnvelopeTip:message]) {
      [[[NIMSDK sharedSDK] conversationManager] deleteMessage:message];
      [self uiDeleteMessage:message];
      continue;
    }
    [array addObject:message];
  }
  return [array copy];
}
// 判断消息是不是红包提示消息类型
- (BOOL)checkRedEnvelopeTip:(NIMMessage *)message {
  if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
    NIMCustomObject *object = message.messageObject;
    if ([object.attachment isKindOfClass:[XKIMMessageRedEnvelopeTipAttachment class]]) {
      return YES;
    }
    return NO;
  }
  return NO;
}
// 判断是否保存该红包提示消息
- (BOOL)shouldSaveMessageRedEnvelopeTip:(NIMMessage *)message {
  if (([message.messageObject isKindOfClass:[NIMCustomObject class]])) {
    NIMCustomObject *object = message.messageObject;
    if ([object.attachment isKindOfClass:[XKIMMessageRedEnvelopeTipAttachment class]]) {
      XKIMMessageRedEnvelopeTipAttachment *attach = object.attachment;
      NSString *me = [NIMSDK sharedSDK].loginManager.currentAccount;
      return [attach.redEnvelopeSenderId isEqualToString:me] || [attach.redEnvelopeReceiverId isEqualToString:me];
    }
  }
  return YES;
}

// 文件下载进度
- (void)fetchMessageAttachment:(NIMMessage *)message progress:(float)progress {
  if ([message.session isEqual:_session]) {
    [self.interactor updateMessage:message];
  }
}
// 文件下载完成
- (void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error {
  if ([message.session isEqual:_session])
  {
    NIMMessageModel *model = [self.interactor findMessageModel:message];
    //下完缩略图之后，因为比例有变化，重新刷下宽高。
    [model cleanCache];
    [self.interactor updateMessage:message];
  }
}
// 消息已读回调事件
- (void)onRecvMessageReceipts:(NSArray<NIMMessageReceipt *> *)receipts
{
  if ([self shouldAddListenerForNewMsg])
  {
    NSMutableArray *handledReceipts = [[NSMutableArray alloc] init];
    for (NIMMessageReceipt *receipt in receipts) {
      if ([receipt.session isEqual:self.session])
      {
        [handledReceipts addObject:receipt];
      }
    }
    if (handledReceipts.count)
    {
      [self uiCheckReceipts:handledReceipts];
    }
  }
}

#pragma mark - NIMConversationManagerDelegate 会话管理器代理事件
- (void)messagesDeletedInSession:(NIMSession *)session {
  [self.interactor resetMessages:nil];
  [self.tableView reloadData];
}

- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount {
  [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
  [self.tableView reloadData];
  
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount {
  [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
  [self.interactor resetMessages:nil];
  [self.tableView reloadData];
  
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount {
  [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
  [self.interactor resetMessages:nil];
  [self.tableView reloadData];
  
}


- (void)changeUnreadCount:(NIMRecentSession *)recentSession
         totalUnreadCount:(NSInteger)totalUnreadCount {
  [[NSNotificationCenter defaultCenter]postNotificationName:XKTabbarMessageP2PRedPointChangeNotification object:nil];
  if ([recentSession.session isEqual:self.session]) {
    return;
  }
  [self changeLeftBarBadge:totalUnreadCount];
}

#pragma mark - NIMMediaManagerDelegate
// 录音开始
- (void)recordAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
  if (!filePath || error) {
    _sessionInputView.recording = NO;
    [self onRecordFailed:error];
  }
}
// 录音结束
- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error {
  if(!error) {
    if ([self recordFileCanBeSend:filePath]) {
      [XKIMGlobalMethod sendAudioMessage:filePath session:self.session];
    } else {
      [self showRecordFileNotSendReason];
    }
  } else {
    [self onRecordFailed:error];
  }
  _sessionInputView.recording = NO;
}
// 录音取消
- (void)recordAudioDidCancelled {
  _sessionInputView.recording = NO;
}
// 录音进度
- (void)recordAudioProgress:(NSTimeInterval)currentTime {
  [_sessionInputView updateAudioRecordTime:currentTime];
}
// 录音中断
- (void)recordAudioInterruptionBegin {
  [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

#pragma mark - 录音相关接口
// 录音失败
- (void)onRecordFailed:(NSError *)error{
  
}
// 录音文件是否可以发送
- (BOOL)recordFileCanBeSend:(NSString *)filepath {
  return YES;
}
//
- (void)showRecordFileNotSendReason{
  
}

#pragma mark - NIMInputDelegate

- (void)didChangeInputHeight:(CGFloat)inputHeight {
  [self.interactor changeLayout:inputHeight];
}

#pragma mark - NIMInputActionDelegate
- (BOOL)onTapMediaItem:(NIMMediaItem *)item {
  SEL sel = item.selctor;
  BOOL handled = sel && [self respondsToSelector:sel];
  if (handled) {
    NIMKit_SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:item]);
    handled = YES;
  }
  return handled;
}

- (void)onTextChanged:(id)sender{
  
}

- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers {
  NSMutableArray *users = [NSMutableArray arrayWithArray:atUsers];
  if (self.session.sessionType == NIMSessionTypeP2P) {
    [users addObject:self.session.sessionId];
  }
  NSString *robotsToSend = [self robotsToSend:users];
  
  NIMMessage *message = nil;
  if (robotsToSend.length) {
    message = [NIMMessageMaker msgWithRobotQuery:text toRobot:robotsToSend];
  } else {
    message = [NIMMessageMaker msgWithText:text];
  }
  
  if (atUsers.count) {
    NIMMessageApnsMemberOption *apnsOption = [[NIMMessageApnsMemberOption alloc] init];
    apnsOption.userIds = atUsers;
    apnsOption.forcePush = YES;
    
    NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
    option.session = self.session;
    
    NSString *me = [[NIMKit sharedKit].provider infoByUser:[NIMSDK sharedSDK].loginManager.currentAccount option:option].showName;
    apnsOption.apnsContent = [NSString stringWithFormat:@"%@在群里@了你",me];
    message.apnsMemberOption = apnsOption;
  }
  [self sendMessage:message];
}

- (NSString *)robotsToSend:(NSArray *)atUsers {
  for (NSString *userId in atUsers) {
    if ([[NIMSDK sharedSDK].robotManager isValidRobot:userId]) {
      return userId;
    }
  }
  return nil;
}


- (void)onSelectChartlet:(NSString *)chartletId
                 catalog:(NSString *)catalogId{}

- (void)onCancelRecording {
  [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

- (void)onStopRecording {
  [[NIMSDK sharedSDK].mediaManager stopRecord];
}

- (void)onStartRecording {
  _sessionInputView.recording = YES;
  
  NIMAudioType type = [self recordAudioType];
  NSTimeInterval duration = [NIMKit sharedKit].config.recordMaxDuration;
  
  [[NIMSDK sharedSDK].mediaManager addDelegate:self];
  
  [[NIMSDK sharedSDK].mediaManager record:type
                                 duration:duration];
}

#pragma mark - NIMMessageCellDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([[self.interactor items][indexPath.row] isKindOfClass:[NIMMessageModel class]]) {
    NIMMessageModel *model = (NIMMessageModel *)[self.interactor items][indexPath.row];
    NIMMessage *message = model.message;
    // 为自定义消息，且当前为多选模式
    if (message && message.messageObject && [message.messageObject isKindOfClass:[NIMCustomObject class]] && self.isMultipleSelectionMode) {
      // 移除无关视图
      for (UIView *view in cell.subviews) {
        if (view != cell.contentView) {
          [view removeFromSuperview];
        }
      }
      // 添加标示视图
      UIImageView *imgView = [[UIImageView alloc] init];
      imgView.contentMode = UIViewContentModeCenter;
      imgView.image = [self.selectedMessages containsObject:message] ? IMG_NAME(@"xk_ic_contact_chose") : IMG_NAME(@"xk_ic_contact_chose_gray");
      [cell addSubview:imgView];
      [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        XKIMMessageCustomConfig *config = [[XKIMMessageCustomConfig alloc] init];
        make.top.mas_equalTo([config avatarMargin:model].y);
        make.leading.mas_equalTo(cell);
        make.width.mas_equalTo(30.0);
        make.height.mas_equalTo([config avatarSize:model].width);
      }];
      [cell.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(30.0);
        make.top.trailing.bottom.mas_equalTo(cell);
      }];
      // 添加手势响应视图
      UIView *tempView = [[UIView alloc] init];
      [cell addSubview:tempView];
      [tempView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(cell);
      }];
      XKWeakSelf(weakSelf);
      [tempView bk_whenTapped:^{
        if (![weakSelf.selectedMessages containsObject:message]) {
          [weakSelf.selectedMessages addObject:message];
          [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
          [weakSelf.selectedMessages removeObject:message];
          [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.operationView setOperationsEnabled:self.selectedMessages.count > 0];
        if (self.multipleSelectionDelegate && [self.multipleSelectionDelegate respondsToSelector:@selector(chatViewControllerDidMultipleSelectionNumChanged:)]) {
          [self.multipleSelectionDelegate chatViewControllerDidMultipleSelectionNumChanged:self.selectedMessages.count];
        }
      }];
    } else {
      for (UIView *view in cell.subviews) {
        if (view != cell.contentView) {
          [view removeFromSuperview];
        }
      }
      [cell.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(cell);
      }];
    }
  }
}

- (BOOL)onTapCell:(NIMKitEvent *)event{
  BOOL handle = NO;
  NSString *eventName = event.eventName;
  if ([eventName isEqualToString:NIMKitEventNameTapAudio])
  {
    [self.interactor mediaAudioPressed:event.messageModel];
    handle = YES;
  }
  if ([eventName isEqualToString:NIMKitEventNameTapRobotBlock]) {
    NSDictionary *param = event.data;
    NIMMessage *message = [NIMMessageMaker msgWithRobotSelect:param[@"text"] target:param[@"target"] params:param[@"param"] toRobot:param[@"robotId"]];
    [self sendMessage:message];
    handle = YES;
  }
  if ([eventName isEqualToString:NIMKitEventNameTapRobotContinueSession]) {
    NIMRobotObject *robotObject = (NIMRobotObject *)event.messageModel.message.messageObject;
    NIMRobot *robot = [[NIMSDK sharedSDK].robotManager robotInfo:robotObject.robotId];
    NSString *text = [NSString stringWithFormat:@"%@%@%@",NIMInputAtStartChar,robot.nickname,NIMInputAtEndChar];
    
    NIMInputAtItem *item = [[NIMInputAtItem alloc] init];
    item.uid  = robot.userId;
    item.name = robot.nickname;
    [self.sessionInputView.atCache addAtItem:item];
    
    [self.sessionInputView.toolBar insertText:text];
    
    handle = YES;
  }
//  if ([eventName isEqualToString:XKRedRedEnvelopeOpenEvent]) {
//    // 拆红包
//    NIMCustomObject *obj = event.messageModel.message.messageObject;
//    XKIMMessageRedEnvelopeAttachment *redEnvelope = obj.attachment;
//    [XKRedEnvelopeManager receiveRedEnvelope:redEnvelope.redEnvelopeId animationView:self.view overdueBlock:^(BOOL isMyRedPacket) {
//      // 红包已过期
//      // 更新本地消息 更新红包过期时间(将红包过期时间戳改为0)
//      redEnvelope.redEnvelopeEndTime = redEnvelope.redEnvelopeStartTime;
//      [[NIMSDK sharedSDK].conversationManager updateMessage:event.messageModel.message forSession:event.messageModel.message.session completion:^(NSError * _Nullable error) {
//
//      }];
//    } hasReceivedBlock:^(XKRedEnvelopeDetailModel * _Nonnull redEnvelopeDetail) {
//      // 已经领取过该红包
//      // 更新本地消息 为消息添加本地扩展，标记该红包我已拆开
//      NSMutableDictionary *localExt = [NSMutableDictionary dictionary];
//      [localExt setObject:[NSNumber numberWithBool:YES] forKey:@"isReceived"];
//      event.messageModel.message.localExt = localExt;
//      [[NIMSDK sharedSDK].conversationManager updateMessage:event.messageModel.message forSession:event.messageModel.message.session completion:^(NSError * _Nullable error) {
//
//      }];
//      // 跳转到红包详情页面，只显示我领取的红包
//      XKRedEnvelopeViewController *vc = [[XKRedEnvelopeViewController alloc] init];
//      vc.vcType = XKRedEnvelopeVCTypeOpened;
//      vc.redEnvelopeDetail = redEnvelopeDetail;
//      [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
//    } succeedBlock:^(BOOL isLastReceived, XKRedEnvelopeDetailModel * _Nonnull redEnvelopeDetail) {
//      // 红包领取成功
//      // 更新本地消息 为消息添加本地扩展，标记该红包我已拆开
//      NSMutableDictionary *localExt = [NSMutableDictionary dictionary];
//      [localExt setObject:[NSNumber numberWithBool:YES] forKey:@"isReceived"];
//      event.messageModel.message.localExt = localExt;
//      [[NIMSDK sharedSDK].conversationManager updateMessage:event.messageModel.message forSession:event.messageModel.message.session completion:^(NSError * _Nullable error) {
//        if (!error && redEnvelopeDetail.mineReceivedList.count) {
//          // 红包领取成功，发送一条红包提示消息
//          XKIMMessageRedEnvelopeTipAttachment *tipAttachment = [[XKIMMessageRedEnvelopeTipAttachment alloc] init];
//          tipAttachment.redEnvelopeId = redEnvelope.redEnvelopeId;
//          tipAttachment.redEnvelopeMessageId = event.messageModel.message.messageId;
//          tipAttachment.redEnvelopeSenderId = redEnvelope.redEnvelopeSenderId;
//          tipAttachment.redEnvelopeReceiverId = [[NIMSDK sharedSDK].loginManager currentAccount];
//          tipAttachment.isLastReceived = isLastReceived;
//          [XKIMGlobalMethod sendRedEnvelopeTip:tipAttachment session:event.messageModel.message.session];
//        }
//      }];
//      // 跳转到红包详情页面，只显示我领取的红包
//      XKRedEnvelopeViewController *vc = [[XKRedEnvelopeViewController alloc] init];
//      vc.vcType = redEnvelopeDetail.mineReceivedList.count ? XKRedEnvelopeVCTypeOpened : XKRedEnvelopeVCTypeGetDone;
//      vc.redEnvelopeDetail = redEnvelopeDetail;
//      [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
//    } failedBlock:^(NSString * _Nonnull errorMessage) {
//
//    }];
//    handle = YES;
//  }
//  if ([eventName isEqualToString:XKRedRedEnvelopeDetailEvent]) {
//    // 红包详情
//    NIMCustomObject *obj = event.messageModel.message.messageObject;
//    XKIMMessageRedEnvelopeAttachment *redEnvelope = obj.attachment;
//    [XKRedEnvelopeManager redEnvelopeDetail:redEnvelope.redEnvelopeId animationView:self.view succeedBlock:^(XKRedEnvelopeDetailModel * _Nonnull redEnvelopeDetail) {
//      XKRedEnvelopeViewController *vc = [[XKRedEnvelopeViewController alloc] init];
//      vc.vcType = XKRedEnvelopeVCTypeDetail;
//      vc.redEnvelopeDetail = redEnvelopeDetail;
//      [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
//    } failedBlock:^(NSString * _Nonnull errorMessage) {
//
//    }];
//    handle = YES;
//  }
  return handle;
}

- (void)onRetryMessage:(NIMMessage *)message {
  if (message.isReceivedMsg) {
    [[[NIMSDK sharedSDK] chatManager] fetchMessageAttachment:message
                                                       error:nil];
  } else {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"重发该消息?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *resendAction = [UIAlertAction actionWithTitle:@"重发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      [XKIMGlobalMethod resendMessage:message];
//      if (success) {
//        [self uiDeleteMessage:message];
//        [self.conversationManager deleteMessage:message];
//      }
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:resendAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
  }
}

- (BOOL)onLongPressCell:(NIMMessage *)message
                 inView:(UIView *)view {
  if (self.isMultipleSelectionMode) {
    return NO;
  }
  BOOL handle = NO;
  NSArray *items = [self menusItems:message];
  if ([items count] && [self becomeFirstResponder]) {
    UIMenuController *controller = [UIMenuController sharedMenuController];
    controller.menuItems = items;
    _messageForMenu = message;
    _messageContentView = (NIMSessionMessageContentView *)view;
    [controller setTargetRect:view.bounds inView:view];
    [controller setMenuVisible:YES animated:YES];
    handle = YES;
  }
  return handle;
}

- (BOOL)disableAudioPlayedStatusIcon:(NIMMessage *)message {
  BOOL disable = NO;
  if ([self.sessionConfig respondsToSelector:@selector(disableAudioPlayedStatusIcon)]) {
    disable = [self.sessionConfig disableAudioPlayedStatusIcon];
  }
  return disable;
}

#pragma mark - 配置项
- (id<NIMSessionConfig>)sessionConfig {
  return nil; //使用默认配置
}

#pragma mark - 配置项列表
//是否需要监听新消息通知 : 某些场景不需要监听新消息，如浏览服务器消息历史界面
- (BOOL)shouldAddListenerForNewMsg {
  BOOL should = YES;
  if ([self.sessionConfig respondsToSelector:@selector(disableReceiveNewMessages)]) {
    should = ![self.sessionConfig disableReceiveNewMessages];
  }
  return should;
}



//是否需要显示输入框 : 某些场景不需要显示输入框，如使用 3D touch 的场景预览会话界面内容
- (BOOL)shouldShowInputView {
  BOOL should = YES;
  if ([self.sessionConfig respondsToSelector:@selector(disableInputView)]) {
    should = ![self.sessionConfig disableInputView];
  }
  return should;
}


//当前录音格式 : NIMSDK 支持 aac 和 amr 两种格式
- (NIMAudioType)recordAudioType {
  NIMAudioType type = NIMAudioTypeAAC;
  if ([self.sessionConfig respondsToSelector:@selector(recordType)]) {
    type = [self.sessionConfig recordType];
  }
  return type;
}

//是否需要监听感应器事件
- (BOOL)needProximityMonitor {
  BOOL needProximityMonitor = YES;
  if ([self.sessionConfig respondsToSelector:@selector(disableProximityMonitor)]) {
    needProximityMonitor = !self.sessionConfig.disableProximityMonitor;
  }
  return needProximityMonitor;
}


#pragma mark - 菜单
- (NSArray *)menusItems:(NIMMessage *)message {
  UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction:)];
  UIMenuItem *forwardItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardAction:)];
  UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteAction:)];
  UIMenuItem *withdrawItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(withdrawAction:)];
//  UIMenuItem *remindItem = [[UIMenuItem alloc] initWithTitle:@"提醒" action:@selector(remindAction:)];
  UIMenuItem *multipleSelectionItem = [[UIMenuItem alloc] initWithTitle:@"多选" action:@selector(multipleSelectionAction:)];
  UIMenuItem *speakerPlayItem = [[UIMenuItem alloc] initWithTitle:@"扬声器播放" action:@selector(speakerPlayAction:)];
  UIMenuItem *earpiecePlayItem = [[UIMenuItem alloc] initWithTitle:@"听筒播放" action:@selector(earpiecePlayAction:)];
//  UIMenuItem *audioToTextItem = [[UIMenuItem alloc] initWithTitle:@"转文字" action:@selector(audioToTextAction:)];
  UIMenuItem *playItem = [[UIMenuItem alloc] initWithTitle:@"播放" action:@selector(playAction:)];
  
  if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
    NIMCustomObject *customItem = message.messageObject;
    // 文字
    if ([customItem.attachment isKindOfClass:[XKIMMessageNomalTextAttachment class]]) {
      if (message.isOutgoingMsg && [[NSDate date] timeIntervalSince1970] - message.timestamp <= 60.0 * 2) {
        // 可撤回
        return @[
                 copyItem,
                 forwardItem,
                 withdrawItem,
                 //                         remindItem,
                 multipleSelectionItem,
                 ];
      } else {
        // 可删除
        return @[
                 copyItem,
                 forwardItem,
                 deleteItem,
                 //                         remindItem,
                 multipleSelectionItem,
                 ];
      }
    }
    // 图片
    if ([customItem.attachment isKindOfClass:[XKIMMessageNomalImageAttachment class]]) {
      return @[
               forwardItem,
               deleteItem,
               //                     remindItem,
               multipleSelectionItem,
               ];
    }
    // 语音
    if ([customItem.attachment isKindOfClass:[XKIMMessageAudioAttachment class]]) {
      return @[
               speakerPlayItem,
               earpiecePlayItem,
               //                     audioToTextItem,
               deleteItem,
               //                     remindItem,
               multipleSelectionItem,
               ];
    }
    // 视频
    if ([customItem.attachment isKindOfClass:[XKIMMessageNomalVideoAttachment class]]) {
      return @[
               playItem,
               forwardItem,
               deleteItem,
               //                     remindItem,
               multipleSelectionItem,
               ];
    }
    // 红包提示消息
    if ([customItem.attachment isKindOfClass:[XKIMMessageRedEnvelopeTipAttachment class]]) {
      return [NSArray array];
    }
    // 自定义消息默认可删除
    return @[
             deleteItem,
             ];
  }
  return [NSArray array];
  
}

- (NIMMessage *)messageForMenu {
  return _messageForMenu;
}

- (BOOL)canBecomeFirstResponder
{
  return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  NSArray *items = [[UIMenuController sharedMenuController] menuItems];
  for (UIMenuItem *item in items) {
    if (action == [item action]) {
      return YES;
    }
  }
  return NO;
}

#pragma mark - 菜单操作

// 复制
- (void)copyAction:(UIMenuItem *) sender {
  NIMCustomObject *object = [self messageForMenu].messageObject;
  XKIMMessageNomalTextAttachment *attachment = object.attachment;
  if (attachment.msgContent.length) {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:attachment.msgContent];
  }
}
// 转发
- (void)forwardAction:(UIMenuItem *) sender {
  XKWeakSelf(weakSelf);
  XKContactListController *vc = [[XKContactListController alloc] init];
  vc.useType = XKContactUseTypeSingleSelect;
  vc.rightButtonText = @"完成";
  vc.sureBtnIsGrayWhenNoChoose = YES;
  vc.sureClickBlock = ^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
    NSError *error = nil;
    // 直接使用消息体转发消息
    [[NIMSDK sharedSDK].chatManager forwardMessage:[weakSelf messageForMenu] toSession:[NIMSession session:contacts.firstObject.userId type:NIMSessionTypeP2P] error:&error];
    [listVC.navigationController popViewControllerAnimated:YES];
  };
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
// 删除
- (void)deleteAction:(UIMenuItem *) sender {
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelNormal) {
    // 普通可友
    [[NIMSDK sharedSDK].conversationManager deleteMessage:[self messageForMenu]];
    [self uiDeleteMessage:[self messageForMenu]];
  } else {
    // 密友
    [XKSecretFrientManager deleteSecretMessage:@[[self messageForMenu]] session:self.session complete:^(BOOL success) {
      if (success) {
        NSLog(@"密友消息删除成功");
        [self uiDeleteMessage:[self messageForMenu]];
      } else {
        NSLog(@"密友消息删除失败");
      }
    }];
  }
}
// 撤回
- (void)withdrawAction:(UIMenuItem *) sender {
  [[NIMSDK sharedSDK].chatManager revokeMessage:[self messageForMenu] completion:^(NSError * _Nullable error) {
    if (error) {
      // 删除失败
      if (error.code == NIMRemoteErrorCodeDomainExpireOld) {
        [XKHudView showErrorMessage:@"发送时间超过2分钟的消息，不能被撤回"];
      } else{
        [XKHudView showErrorMessage:@"消息撤回失败，请重试"];
      }
    } else {
      // 删除聊天记录
      [self uiDeleteMessage:[self messageForMenu]];
      [self.conversationManager deleteMessage:[self messageForMenu]];
      // 新建一个撤回消息
      NSMutableDictionary *dic = [NSMutableDictionary dictionary];
      [dic setObject:@(1) forKey:@"group"];
      NIMMessage *message = [[NIMMessage alloc] init];
      message.messageObject = [[NIMTipObject alloc] init];
      message.text = @"你撤回了一条消息";
      message.timestamp = [self messageForMenu].timestamp;
      message.remoteExt = [dic copy];
      // 在界面上插入撤回的消息
      [self uiInsertMessages:@[message]];
      // 在聊天记录里面插入撤回的消息
      [[NIMSDK sharedSDK].conversationManager saveMessage:message forSession:self.session completion:^(NSError * _Nullable error) {
        
      }];
    }
  }];
}

// 提醒
- (void)remindAction:(UIMenuItem *) sender {
  // 暂不做
}
// 多选
- (void)multipleSelectionAction:(UIMenuItem *) sender {
  [self.selectedMessages addObject:[self messageForMenu]];
  [self enterMultipleSelection];
  XKWeakSelf(weakSelf);
  self.operationView.deleteBtnBlock = ^{
    XKCommonAlertView *alertView = [[XKCommonAlertView alloc] initWithTitle:@"温馨提示" message:@"是否要删除" leftButton:@"取消" rightButton:@"删除" leftBlock:nil rightBlock:^{
      if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelNormal) {
        // 普通可友
        for (NIMMessage *message in weakSelf.selectedMessages) {
          [weakSelf uiDeleteMessage:message];
          [[weakSelf conversationManager] deleteMessage:message];
        }
      } else {
        // 密友
        [XKSecretFrientManager deleteSecretMessage:weakSelf.selectedMessages session:weakSelf.session complete:^(BOOL success) {
          for (NIMMessage *msg in weakSelf.selectedMessages) {
            [weakSelf uiDeleteMessage:msg];
          }

          if (success) {
            NSLog(@"密友消息批量删除成功");
          } else {
            NSLog(@"密友消息批量删除失败");
          }
        }];
      }
      [weakSelf quitMultipleSelection];
    } textAlignment:NSTextAlignmentCenter];
    [alertView show];
  };
}
// 扬声器播放
- (void)speakerPlayAction:(UIMenuItem *) sender {
  [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
  if ([self.messageContentView isKindOfClass:[XKIMMessageNomalAudioContentView class]]) {
    [self.messageContentView onTouchUpInside:self.messageContentView];
  }
}
// 听筒播放
- (void)earpiecePlayAction:(UIMenuItem *) sender {
  [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
  if ([self.messageContentView isKindOfClass:[XKIMMessageNomalAudioContentView class]]) {
    [self.messageContentView onTouchUpInside:self.messageContentView];
  }
}
// 语音转文字
- (void)audioToTextAction:(UIMenuItem *) sender {
  // 暂不做，网易云信SDK内无法实现，后期需要实现可使用讯飞的技术
}
// 播放视频
- (void)playAction:(UIMenuItem *) sender {
//  NIMCustomObject *object = [self messageForMenu].messageObject;
//  XKIMMessageLittleVideoAttachment *attachment = object.attachment;
//  [XKVideoDisplayMediator displaySelectedVideoIdWithViewController:[self getCurrentUIVC] videoId:attachment.videoId];
}

- (void)menuDidHide:(NSNotification *)notification
{
  [UIMenuController sharedMenuController].menuItems = nil;
}


#pragma mark - 操作接口

- (void)uiAddMessages:(NSArray *)messages {
  BOOL showInKeFriend = [self newMessageIsShowInKeFriend:messages];
  BOOL showInSecretFriend = [self newMessageIsShowInSecret:messages];
  
  if (_session.sessionType == NIMSessionTypeP2P) {
    if (showInKeFriend) {
      // 撤回消息时，需要在对应的位置插入一条撤回提示消息（成功后会调用该方法），故此时应使用insert方式，以保证提示消息位置正确
      [self.interactor addMessages:messages];
    }
    if (showInSecretFriend) {
      // 撤回消息时，需要在对应的位置插入一条撤回提示消息（成功后会调用该方法），故此时应使用insert方式，以保证提示消息位置正确
      [self.interactor addMessages:messages];
    }
  }else{
    [self.interactor addMessages:messages];
  }
}

- (void)uiInsertMessages:(NSArray *)messages {
  BOOL showInKeFriend = [self newMessageIsShowInKeFriend:messages];
  BOOL showInSecretFriend = [self newMessageIsShowInSecret:messages];
  
  if (_session.sessionType == NIMSessionTypeP2P) {
    if (showInKeFriend) {
      // 撤回消息时，需要在对应的位置插入一条撤回提示消息（成功后会调用该方法），故此时应使用insert方式，以保证提示消息位置正确
      [self.interactor insertMessages:messages];
    }
    if (showInSecretFriend) {
      // 撤回消息时，需要在对应的位置插入一条撤回提示消息（成功后会调用该方法），故此时应使用insert方式，以保证提示消息位置正确
      [self.interactor insertMessages:messages];
    }
  }else{
    [self.interactor insertMessages:messages];
  }
}

- (NIMMessageModel *)uiDeleteMessage:(NIMMessage *)message{
  NIMMessageModel *model = [self.interactor deleteMessage:message];
  if (model.shouldShowReadLabel && model.message.session.sessionType == NIMSessionTypeP2P) {
    [self uiCheckReceipts:nil];
  }
  return model;
}

- (void)uiUpdateMessage:(NIMMessage *)message{
  BOOL showInKeFriend = [self newMessageIsShowInKeFriend:@[message]];
  BOOL showInSecretFriend = [self newMessageIsShowInSecret:@[message]];
  
  if (_session.sessionType == NIMSessionTypeP2P) {
    if (showInKeFriend) {
      // 撤回消息时，需要在对应的位置插入一条撤回提示消息（成功后会调用该方法），故此时应使用insert方式，以保证提示消息位置正确
      [self.interactor updateMessage:message];
    }
    if (showInSecretFriend) {
      // 撤回消息时，需要在对应的位置插入一条撤回提示消息（成功后会调用该方法），故此时应使用insert方式，以保证提示消息位置正确
      [self.interactor updateMessage:message];
    }
  }else{
    [self.interactor updateMessage:message];
  }
}

- (void)uiCheckReceipts:(NSArray<NIMMessageReceipt *> *)receipts {
  [self.interactor checkReceipts:receipts];
}

- (BOOL)newMessageIsShowInKeFriend:(NSArray *)messages{
  //判断显示在密友还是可友
  BOOL showInKeFriend = NO;
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelNormal) {
    if ([XKSecretFrientManager showMessagesSceneWithUserID:_session.sessionId] == XKShowMessagesSceneNomal) {
      showInKeFriend = YES;
    } else if([XKSecretFrientManager showMessagesSceneWithUserID:_session.sessionId] == XKShowMessagesSceneSecret){
      showInKeFriend = NO;
    }
    else{
      for (NIMMessage *message in messages) {
        if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
          showInKeFriend = NO;
        } else {
          showInKeFriend = YES;
        }
      }
    }
  } else {
    showInKeFriend = NO;
  }
  return showInKeFriend;
}

-(BOOL)newMessageIsShowInSecret:(NSArray *)messages{
  BOOL showInSecretFriend = NO;
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret) {
    if ([XKSecretFrientManager showMessagesSceneWithUserID:_session.sessionId] == XKShowMessagesSceneSecret) {
      showInSecretFriend = YES;
    } else if([XKSecretFrientManager showMessagesSceneWithUserID:_session.sessionId] == XKShowMessagesSceneNomal) {
      showInSecretFriend = NO;
    }else{
      for (NIMMessage *message in messages) {
        if ([XKSecretFrientManager messageIsFromSecretFriend:message]) {
          showInSecretFriend = YES;
        } else {
          showInSecretFriend = NO;
        }
      }
    }
  } else {
    showInSecretFriend = NO;
  }
  return showInSecretFriend;
}

#pragma mark - NIMMeidaButton
- (void)onTapMediaItemPicture:(NIMMediaItem *)item {
  [self.interactor mediaPicturePressed];
}

- (void)onTapMediaItemShoot:(NIMMediaItem *)item {
  [self.interactor mediaShootPressed];
}

- (void)onTapMediaItemLocation:(NIMMediaItem *)item {
  [self.interactor mediaLocationPressed];
}

#pragma mark - 旋转处理 (iOS8 or above)
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  self.lastVisibleIndexPathBeforeRotation = [self.tableView indexPathsForVisibleRows].lastObject;
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  if (self.view.window) {
    __weak typeof(self) wself = self;
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
      [[NIMSDK sharedSDK].mediaManager cancelRecord];
      [wself.interactor cleanCache];
      [wself.sessionInputView reset];
      [wself.tableView reloadData];
      [wself.tableView scrollToRowAtIndexPath:wself.lastVisibleIndexPathBeforeRotation atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    } completion:nil];
  }
}


#pragma mark - 标记已读
- (void)markRead {
  [self.interactor markRead];
}


#pragma mark - Private

- (void)addListener {
  [[NIMSDK sharedSDK].chatManager addDelegate:self];
  [[NIMSDK sharedSDK].conversationManager addDelegate:self];
}

- (void)removeListener {
  [[NIMSDK sharedSDK].chatManager removeDelegate:self];
  [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}

- (void)changeLeftBarBadge:(NSInteger)unreadCount {
  NIMCustomLeftBarView *leftBarView = (NIMCustomLeftBarView *)self.navigationItem.leftBarButtonItem.customView;
  leftBarView.badgeView.badgeValue = @(unreadCount).stringValue;
  leftBarView.badgeView.hidden = !unreadCount;
}


- (id<NIMConversationManager>)conversationManager{
  switch (self.session.sessionType) {
    case NIMSessionTypeChatroom:
      return nil;
      break;
    case NIMSessionTypeP2P:
    case NIMSessionTypeTeam:
    default:
      return [NIMSDK sharedSDK].conversationManager;
  }
}


- (void)setUpTitleView {
  NIMKitTitleView *titleView = (NIMKitTitleView *)self.navigationItem.titleView;
  if (!titleView || ![titleView isKindOfClass:[NIMKitTitleView class]]) {
    titleView = [[NIMKitTitleView alloc] initWithFrame:CGRectZero];
    self.navigationItem.titleView = titleView;
    
    titleView.titleLabel.text = self.sessionTitle;
    titleView.subtitleLabel.text = self.sessionSubTitle;
    
    self.titleLabel    = titleView.titleLabel;
    self.subTitleLabel = titleView.subtitleLabel;
  }
  
  [titleView sizeToFit];
}

- (void)refreshSessionTitle:(NSString *)title
{
  self.titleLabel.text = title;
  [self setUpTitleView];
}


- (void)refreshSessionSubTitle:(NSString *)title
{
  self.subTitleLabel.text = title;
  [self setUpTitleView];
}

- (BOOL)onTapAvatar:(NIMMessage *)message{
  NSLog(@"头像被点击");
  XKPersonDetailInfoViewController *vc = [[XKPersonDetailInfoViewController alloc]init];
  if ([XKSecretDataSingleton sharedManager].currentIMChatModel == XKCurrentIMChatModelSecret) {
    vc.isSecret = YES;
    vc.secretId = [XKSecretDataSingleton sharedManager].secretId;
  }else {
    vc.isSecret = NO;
  }
  vc.userId = message.from;
  vc.deleteBlock = ^(NSString *userId) {
    [[self getCurrentUIVC].navigationController popToRootViewControllerAnimated:YES];
  };
  [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
  return YES;
}

#pragma mark - 自定义方法

// 进入多选模式
- (void)enterMultipleSelection {
  // 多选选择的数组移除数据
  [self.selectedMessages removeAllObjects];

  [self getCurrentUIVC].navigationController.interactivePopGestureRecognizer.enabled = NO;
  self.isMultipleSelectionMode = YES;
  [self.tableView reloadData];
  self.sessionInputView.hidden = YES;
  [self.view addSubview:self.operationView];
  if ([self shouldShowInputView]) {
    [self.operationView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.edges.mas_equalTo(self.sessionInputView);
    }];
  } else {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.edges.mas_equalTo(UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0));
    }];
    
    [self.operationView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self.tableView.mas_bottom);
      make.leading.bottom.trailing.mas_equalTo(self.view);
    }];
  }
  if (self.multipleSelectionDelegate && [self.multipleSelectionDelegate respondsToSelector:@selector(chatViewControllerDidEnterMultipleSelection:)]) {
    [self.multipleSelectionDelegate chatViewControllerDidEnterMultipleSelection:self];
  }
}

// 退出多选模式
- (void)quitMultipleSelection {
  [self getCurrentUIVC].navigationController.interactivePopGestureRecognizer.enabled = YES;
  self.isMultipleSelectionMode = NO;
  [self.tableView reloadData];
  self.sessionInputView.hidden = NO;
  [self.operationView removeFromSuperview];
  if (self.multipleSelectionDelegate && [self.multipleSelectionDelegate respondsToSelector:@selector(chatViewControllerDidQuitMultipleSelection:)]) {
    [self.multipleSelectionDelegate chatViewControllerDidQuitMultipleSelection:self];
  }
}

#pragma mark - getter setter

- (XKIMMultipleSelectionOperationView *)operationView {
  if (!_operationView) {
    _operationView = [[XKIMMultipleSelectionOperationView alloc] init];
  }
  return _operationView;
}

- (NSMutableArray<NIMMessage *> *)selectedMessages {
  if (!_selectedMessages) {
    _selectedMessages = [NSMutableArray array];
  }
  return _selectedMessages;
}

// 消息撤回回调
- (void)onRecvRevokeMessageNotification:(NIMRevokeMessageNotification *)notification {
  // 删除界面中的消息
  [self uiDeleteMessage:notification.message];
}

@end

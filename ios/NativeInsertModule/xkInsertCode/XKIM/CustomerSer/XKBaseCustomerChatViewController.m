//
//  XKBaseCustomerChatViewController.m
//  XKSquare
//
//  Created by william on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKBaseCustomerChatViewController.h"
#import <NIMSessionConfigurateProtocol.h>
#import <NIMKit.h>
#import <NIMMessageCellProtocol.h>
#import <NIMMessageModel.h>
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
#import "XKIMSDKChatToolView.h"
#import "XKTransformHelper.h"
#import "XKCustomeSerMessageManager.h"
#import "XKIMGlobalMethod.h"
#import "XKEvaluateServiceViewController.h"

@interface XKBaseCustomerChatViewController ()
<NIMMediaManagerDelegate,XKIMBaseChatInputDelegate>

@property (nonatomic,readwrite) NIMMessage *messageForMenu;

@property (nonatomic,strong)    UILabel *titleLabel;

@property (nonatomic,strong)    UILabel *subTitleLabel;

@property (nonatomic,strong)    NSIndexPath *lastVisibleIndexPathBeforeRotation;

@property (nonatomic,strong)  NIMSessionConfigurator *configurator;

@property (nonatomic,weak)    id<NIMSessionInteractor> interactor;
@end

@implementation XKBaseCustomerChatViewController

- (instancetype)initWithSession:(NIMSession *)session{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _session = session;
    [self deleteSystemNotiMessage];
  }
  return self;
}

- (void)dealloc {
  [self removeListener];
  [[NIMKit sharedKit].robotTemplateParser clean];
  
  self.tableView.delegate = nil;
  self.tableView.dataSource = nil;
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
}

- (void)setupNav {
  self.navigationController.navigationBar.hidden = YES;
  [self hideNavigation];
}

- (void)setupTableView {
  self.view.backgroundColor = [UIColor whiteColor];
  self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.tableView.backgroundColor = UIColorFromRGB(0xeeeeee);
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
    XKIMSDKChatToolView *toolView = [[XKIMSDKChatToolView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 227)];
    toolView.session = self.session;
    toolView.toolType = XKIMSDKChatToolViewTypeCustomerSer;
    
//    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
//    if ([team.intro isEqualToString:@"4"]) {
//      // 店铺客服
//      [toolView prepareWithTools:@[photo, camera, complain]];
//    } else if ([team.intro isEqualToString:@"3"]) {
//      // 平台客服
      [toolView prepareWithTools:@[photo]];
//    }
    self.sessionInputView.moreContainer = toolView;
    [self.view addSubview:_sessionInputView];
  }
}

- (void)setupConfigurator {
  self.configurator = [[NIMSessionConfigurator alloc] init];
  [self.configurator setup:(NIMSessionViewController *)self];
  
  BOOL needProximityMonitor = [self needProximityMonitor];
  [[NIMSDK sharedSDK].mediaManager setNeedProximityMonitor:needProximityMonitor];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.interactor onViewWillAppear];
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

#pragma mark - 消息收发接口
- (void)sendMessage:(NIMMessage *)message {
  [self.interactor sendMessage:message];
}

#pragma mark POST

- (void)postAddCustomerServiceEvaluationWithStarCount:(NSUInteger)starCount {
  NSMutableDictionary *para = [NSMutableDictionary dictionary];
  [HTTPClient postEncryptRequestWithURLString:@"im/ua/lastCustomerServiceInfo/1.0" timeoutInterval:10.0 parameters:para success:^(id responseObject) {
    if (responseObject) {
      NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
      NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
      if (dict.count == 0) {
        [XKHudView showErrorMessage:@"还没有客服接单，请等待"];
        return;
      }
      if (dict[@"workOrderId"]){
        NSMutableDictionary *evaluatePara = [NSMutableDictionary dictionary];
        evaluatePara[@"id"] = dict[@"workOrderId"];
        evaluatePara[@"level"] = [NSNumber numberWithUnsignedInteger:starCount];
        [HTTPClient postEncryptRequestWithURLString:@"sys/ua/workOrderEvaluate/1.0" timeoutInterval:10.0 parameters:evaluatePara success:^(id responseObject) {
          [XKHudView showSuccessMessage:@"感谢您的评价"];
        } failure:^(XKHttpErrror *error) {
          [XKHudView showErrorMessage:@"网络错误"];
        }];
      }
      else {
        [XKHudView showErrorMessage:@"网络错误"];
      }
    } else {
      [XKHudView showErrorMessage:@"网络错误"];
    }
  } failure:^(XKHttpErrror *error) {
    [XKHudView showErrorMessage:@"网络错误"];
  }];
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  [self.sessionInputView endEditing:YES];
}

#pragma mark - NIMSessionConfiguratorDelegate

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

- (NSString *)sessionSubTitle {
  return @"";
}

#pragma mark - NIMChatManagerDelegate
//开始发送
- (void)willSendMessage:(NIMMessage *)message {
  id<NIMSessionInteractor> interactor = self.interactor;
  
  if ([message.session isEqual:self.session]) {
    if ([interactor findMessageModel:message]) {
      [interactor updateMessage:message];
    } else {
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
  if ([message.session isEqual:self.session]) {
    [self.interactor updateMessage:message];
    if (message.session.sessionType == NIMSessionTypeTeam) {
      //如果是群的话需要检查一下回执显示情况
      NIMMessageReceipt *receipt = [[NIMMessageReceipt alloc] initWithMessage:message];
      [self.interactor checkReceipts:@[receipt]];
    }
  }
}

//发送进度
- (void)sendMessage:(NIMMessage *)message progress:(float)progress {
  if ([message.session isEqual:self.session]) {
    [self.interactor updateMessage:message];
  }
}

//接收消息
- (void)onRecvMessages:(NSArray *)messages {
  if ([self shouldAddListenerForNewMsg]) {
    NIMMessage *message = messages.firstObject;
    NIMSession *session = message.session;
    if (![session isEqual:self.session] || !messages.count) {
      return;
    }
    NSArray <NIMMessage *>*theMessages = [self filterMessages:messages];
    [self uiAddMessages:theMessages];
    [self.interactor markRead];
  }
}

- (void)fetchMessageAttachment:(NIMMessage *)message progress:(float)progress {
  if ([message.session isEqual:self.session]) {
    [self.interactor updateMessage:message];
  }
}

- (void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error {
  if ([message.session isEqual:self.session]) {
    NIMMessageModel *model = [self.interactor findMessageModel:message];
    // 下完缩略图之后，因为比例有变化，重新刷下宽高。
    [model cleanCache];
    [self.interactor updateMessage:message];
  }
}

- (void)onRecvMessageReceipts:(NSArray<NIMMessageReceipt *> *)receipts {
  if ([self shouldAddListenerForNewMsg]) {
    NSMutableArray *handledReceipts = [[NSMutableArray alloc] init];
    for (NIMMessageReceipt *receipt in receipts) {
      if ([receipt.session isEqual:self.session]) {
        [handledReceipts addObject:receipt];
      }
    }
    if (handledReceipts.count) {
      [self uiCheckReceipts:handledReceipts];
    }
  }
}

#pragma mark - NIMConversationManagerDelegate
- (void)messagesDeletedInSession:(NIMSession *)session {
  [self.interactor resetMessages:nil];
  [self.tableView reloadData];
}

- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount {
  [self deleteNewNotiMessageWithMessage:recentSession];
  [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount {
  [self deleteNewNotiMessageWithMessage:recentSession];
  [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount {
  [self deleteNewNotiMessageWithMessage:recentSession];
  [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
}

- (void)changeUnreadCount:(NIMRecentSession *)recentSession
         totalUnreadCount:(NSInteger)totalUnreadCount {
  if ([recentSession.session isEqual:self.session]) {
    return;
  }
  [self changeLeftBarBadge:totalUnreadCount];
}

#pragma mark - NIMMediaManagerDelegate
- (void)recordAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
  if (!filePath || error) {
    self.sessionInputView.recording = NO;
    [self onRecordFailed:error];
  }
}

- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error {
  if(!error) {
    if ([self recordFileCanBeSend:filePath]) {
      [XKCustomeSerMessageManager senSerAudioMessageWithPath:filePath session:self.session];
    } else {
      [self showRecordFileNotSendReason];
    }
  } else {
    [self onRecordFailed:error];
  }
  self.sessionInputView.recording = NO;
}

- (void)recordAudioDidCancelled {
  self.sessionInputView.recording = NO;
}

- (void)recordAudioProgress:(NSTimeInterval)currentTime {
  [self.sessionInputView updateAudioRecordTime:currentTime];
}

- (void)recordAudioInterruptionBegin {
  [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

#pragma mark - 录音相关接口
- (void)onRecordFailed:(NSError *)error{
  
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath {
  return YES;
}

- (void)showRecordFileNotSendReason{
  
}

#pragma mark - NIMInputDelegate

- (void)didChangeInputHeight:(CGFloat)inputHeight {
  [self.interactor changeLayout:inputHeight];
}

#pragma mark - NIMInputActionDelegate
- (BOOL)onTapMediaItem:(NIMMediaItem *)item{
  SEL sel = item.selctor;
  BOOL handled = sel && [self respondsToSelector:sel];
  if (handled) {
    NIMKit_SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:item]);
    handled = YES;
  }
  return handled;
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
                 catalog:(NSString *)catalogId {
  
}

- (void)onCancelRecording {
  [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

- (void)onStopRecording {
  [[NIMSDK sharedSDK].mediaManager stopRecord];
}

- (void)onStartRecording {
  self.sessionInputView.recording = YES;
  
  NIMAudioType type = [self recordAudioType];
  NSTimeInterval duration = [NIMKit sharedKit].config.recordMaxDuration;
  
  [[NIMSDK sharedSDK].mediaManager addDelegate:self];
  
  [[NIMSDK sharedSDK].mediaManager record:type
                                 duration:duration];
}

#pragma mark - NIMMessageCellDelegate
- (BOOL)onTapCell:(NIMKitEvent *)event{
  BOOL handle = NO;
  NSString *eventName = event.eventName;
  if ([eventName isEqualToString:NIMKitEventNameTapAudio]) {
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
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:resendAction];
    [self presentViewController:alertVC animated:YES completion:nil];
  }
}

- (BOOL)onLongPressCell:(NIMMessage *)message
                 inView:(UIView *)view {
  BOOL handle = NO;
  NSArray *items = [self menusItems:message];
  if ([items count] && [self becomeFirstResponder]) {
    UIMenuController *controller = [UIMenuController sharedMenuController];
    controller.menuItems = items;
    _messageForMenu = message;
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
  NSMutableArray *items = [NSMutableArray array];
  
  if (([message.messageObject isKindOfClass:[NIMCustomObject class]])) {
    NIMCustomObject *obj = message.messageObject;
    if (![obj.attachment isKindOfClass:[XKIMMessageCustomTipAttachment class]]) {
      if ([obj.attachment isKindOfClass:[XKIMMessageNomalTextAttachment class]]) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"复制"
                                                    action:@selector(copyText:)]];
      }
      [items addObject:[[UIMenuItem alloc] initWithTitle:@"删除"
                                                  action:@selector(deleteMsg:)]];
    }
  }
  return items;
}

- (NIMMessage *)messageForMenu {
  return _messageForMenu;
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  NSArray *items = [[UIMenuController sharedMenuController] menuItems];
  for (UIMenuItem *item in items) {
    if (action == [item action]){
      return YES;
    }
  }
  return NO;
}

- (void)copyText:(id)sender {
  if ([[self messageForMenu].messageObject isKindOfClass:[NIMCustomObject class]]) {
    NIMCustomObject *object = [self messageForMenu].messageObject;
    if ([object.attachment isKindOfClass:[XKIMMessageNomalTextAttachment class]]) {
      XKIMMessageNomalTextAttachment *attachment = object.attachment;
      if (attachment.msgContent.length) {
        [UIPasteboard generalPasteboard].string = attachment.msgContent;
      }
    }
  }
}

- (void)deleteMsg:(id)sender {
  NIMMessage *message = [self messageForMenu];
  [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
  [self uiDeleteMessage:message];
}

- (void)menuDidHide:(NSNotification *)notification {
  [UIMenuController sharedMenuController].menuItems = nil;
}

#pragma mark - 操作接口
- (void)uiAddMessages:(NSArray *)messages {
  [self.interactor addMessages:messages];
}

- (void)uiInsertMessages:(NSArray *)messages {
  [self.interactor insertMessages:messages];
}

- (NIMMessageModel *)uiDeleteMessage:(NIMMessage *)message{
  NIMMessageModel *model = [self.interactor deleteMessage:message];
  if (model.shouldShowReadLabel && model.message.session.sessionType == NIMSessionTypeP2P)
  {
    [self uiCheckReceipts:nil];
  }
  return model;
}

- (void)uiUpdateMessage:(NIMMessage *)message{
  [self.interactor updateMessage:message];
}

- (void)uiCheckReceipts:(NSArray<NIMMessageReceipt *> *)receipts {
  [self.interactor checkReceipts:receipts];
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
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
  self.lastVisibleIndexPathBeforeRotation = [self.tableView indexPathsForVisibleRows].lastObject;
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  if (self.view.window) {
    __weak typeof(self) wself = self;
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context)
     {
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

- (id<NIMConversationManager>)conversationManager {
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

- (void)refreshSessionTitle:(NSString *)title {
  self.titleLabel.text = title;
  [self setUpTitleView];
}


- (void)refreshSessionSubTitle:(NSString *)title {
  self.subTitleLabel.text = title;
  [self setUpTitleView];
}

// 删除客服进入通知、客服退出通知、发送的询问问题(避免二次发送)，以及本地暂存的客服邀请评分消息
- (void)deleteSystemNotiMessage {
  NIMMessageSearchOption *option = [[NIMMessageSearchOption alloc]init];
  option.messageTypes = @[@(NIMMessageTypeNotification)];
  [[NIMSDK sharedSDK].conversationManager searchMessages:self.session option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
    for (NIMMessage *message in messages) {
      [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
      [self uiDeleteMessage:message];
    }
  }];
  
  NIMMessageSearchOption *optionS = [[NIMMessageSearchOption alloc]init];
  optionS.messageTypes = @[@(NIMMessageTypeCustom)];
  [[NIMSDK sharedSDK].conversationManager searchMessages:self.session option:optionS result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
    for (NIMMessage *message in messages) {
      // 删除问题类型消息
      if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
        NIMCustomObject *object = message.messageObject;
        if ([object.attachment isKindOfClass:[XKIMMessageCustomerSerQuestionAttachment class]]) {
          XKIMMessageCustomerSerQuestionAttachment *quesAtt = object.attachment;
          if (quesAtt.question.integerValue == 1 &&
              [message.from isEqualToString:[XKUserInfo currentUser].userImAccount.accid]) {
            [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
            [self uiDeleteMessage:message];
          }
        }
      }
    }
    // 过滤消息
    [self filterMessages:messages];
  }];
}

//收到新消息判断是否是客服进入或者退出
- (void)deleteNewNotiMessageWithMessage:(NIMRecentSession *)recentSession{
  if (recentSession.lastMessage.messageType == NIMMessageTypeNotification) {
    NIMMessage *messageToDelete = recentSession.lastMessage;
    [[NIMSDK sharedSDK].conversationManager deleteMessage:messageToDelete];
    [self uiDeleteMessage:messageToDelete];
  }
  NIMCustomObject *object = recentSession.lastMessage.messageObject;
  if ([object.attachment isKindOfClass:[XKIMMessageCustomerSerQuestionAttachment class]]) {
    XKIMMessageCustomerSerQuestionAttachment *quesAtt = object.attachment;
    if ([quesAtt.question integerValue] == 1 &&
        [recentSession.lastMessage.from isEqualToString:[XKUserInfo currentUser].userImAccount.accid]) {
      NIMMessage *messageToDelete = recentSession.lastMessage;
      [[NIMSDK sharedSDK].conversationManager deleteMessage:messageToDelete];
      [self uiDeleteMessage:messageToDelete];
    }
    
  }
}

/**
 处理消息
 
 @param messages 目标消息
 @return 处理后的消息
 */
- (NSArray <NIMMessage *>*)filterMessages:(NSArray <NIMMessage *>*)messages {
  // 是否存在邀请评价的消息
  BOOL hasInviteEvaluationMessage = NO;
  NSMutableArray *theMessages = [NSMutableArray arrayWithArray:messages];
  for (NIMMessage *message in [theMessages copy]) {
    if ([message.messageObject isKindOfClass:[NIMCustomObject class]]) {
      NIMCustomObject *obj = message.messageObject;
      if ([obj.attachment isKindOfClass:[XKIMMessageCustomerSerInviteEvaluateAttachment class]]) {
        // 标记存在邀请评价消息，并删除这一条消息
        hasInviteEvaluationMessage = YES;
        [theMessages removeObject:message];
        [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
        [self uiDeleteMessage:message];
        continue;
      }
    }
  }
  if (hasInviteEvaluationMessage && !self.parentViewController.presentedViewController) {
    // 未弹出邀请评价页面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      __weak typeof(self) weakSelf = self;
      XKEvaluateServiceViewController *vc = [[XKEvaluateServiceViewController alloc] init];
      vc.confirmBtnBlock = ^(XKEvaluateServiceViewController * _Nonnull evaluateVC, NSUInteger starCount) {
        [weakSelf postAddCustomerServiceEvaluationWithStarCount:starCount];
      };
      vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
      self.parentViewController.definesPresentationContext = YES;
      [self.parentViewController presentViewController:vc animated:NO completion:^{
        vc.view.backgroundColor = HEX_RGBA(0x000000, 0.5);
      }];
    });
  }
  return [theMessages copy];
}

@end

/*******************************************************************************
 # File        : XKSecretClockMsgSetController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/12
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSecretClockMsgSetController.h"
#import "XKArrowTableViewCell.h"
#import "XKSectionHeaderSwithView.h"
#import "XKSecretClockMsgEditController.h"
#import "XKSecretClockMsg.h"


@interface XKSecretClockMsgSetController () <UITableViewDelegate, UITableViewDataSource>

/**<##>*/
@property(nonatomic, strong) XKSectionHeaderSwithView *switchView;
/**<##>*/
@property(nonatomic, strong) UITableView *tableView;
/**<##>*/
@property(nonatomic, strong) UIDatePicker *picker;

/**<##>*/
@property(nonatomic, strong) XKSecretClockMsg *msgInfo;
@end

@implementation XKSecretClockMsgSetController

#pragma mark ----------------------------- 生命周期 ------------------------------
- (void)viewDidLoad {
  [super viewDidLoad];
  // 初始化默认数据
  [self createDefaultData];
  // 初始化界面
  [self createUI];
  
  [self requestNeedTip:YES];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
}

- (void)dealloc {
  NSLog(@"=====%@被销毁了=====", [self class]);
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
  
}

#pragma mark - 初始化界面
- (void)createUI {
  //    __weak typeof(self) weakSelf = self;
  self.navStyle = BaseNavWhiteStyle;
  [self setNavTitle:@"设置定时消息" WithColor:[UIColor whiteColor]];
  UIButton *rightBtn = [[UIButton alloc] init];
  [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
  rightBtn.titleLabel.font = XKRegularFont(17);
  [rightBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
  [rightBtn setFrame:CGRectMake(0, 0, XKViewSize(35), XKViewSize(25))];
  [self setRightView:rightBtn withframe:rightBtn.bounds];
  
  _switchView = [XKSectionHeaderSwithView new];
  _switchView.backgroundColor = [UIColor whiteColor];
  _switchView.titleLabel.text = @"定制消息提示";
  _switchView.mySwitch.on = NO;
  [_switchView.mySwitch addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
  _switchView.layer.cornerRadius = 6;
  _switchView.clipsToBounds = YES;
  
  [self.containView addSubview:_switchView];
  [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.navigationView.mas_bottom).offset(15);
    make.left.equalTo(self.containView.mas_left).offset(15);
    make.right.equalTo(self.containView.mas_right).offset(-15);
    make.height.equalTo(@50);
  }];
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  self.tableView.backgroundColor = HEX_RGB(0xEEEEEE);
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.showsVerticalScrollIndicator = NO;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.containView addSubview:self.tableView];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.switchView.mas_bottom).offset(16);
    make.left.right.equalTo(self.switchView);
    make.bottom.equalTo(self.containView);
  }];
  // 注册cell
  [self.tableView registerClass:[XKArrowTableViewCell class] forCellReuseIdentifier:@"cell"];
  
}

#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------
- (void)addClick {
  __weak typeof(self) weakSelf = self;
  XKSecretClockMsgEditController *vc = [XKSecretClockMsgEditController new];
  vc.secretId = self.secretId;
  [vc setEditSuccess:^{
    [weakSelf requestNeedTip:NO];
  }];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteMsg:(NSIndexPath *)indexPath {
  [XKHudView showLoadingTo:self.containView animated:YES];
  XKSecretTipMsg *msg = self.msgInfo.mappingMsgs[indexPath.row];
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"msgId"] = msg.msgId;
  [HTTPClient getEncryptRequestWithURLString:@"im/ua/timerMsgDelete/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
    [XKHudView hideHUDForView:self.containView animated:YES];
    [self.msgInfo.mappingMsgs removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.containView animated:YES];
    [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
  }];
  
}

#pragma mark ----------------------------- 网络请求 ------------------------------

- (void)requestNeedTip:(BOOL)needTip {
  if (needTip) {
    [XKHudView showLoadingTo:self.containView animated:YES];
  }
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"secretId"] = self.secretId;
  
  [HTTPClient getEncryptRequestWithURLString:@"im/ua/timerMsgList/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
    self.msgInfo = [XKSecretClockMsg yy_modelWithJSON:responseObject];
    [XKHudView hideHUDForView:self.containView animated:YES];
    [self updateUI];
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.containView animated:YES];
    [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
  }];
}

- (void)switchChange {
  NSMutableDictionary *params = @{}.mutableCopy;
  params[@"secretId"] = self.secretId;
  params[@"action"] = self.switchView.mySwitch.isOn ? @"1" : @"0";
  __weak typeof(self) weakSelf = self;
  [HTTPClient getEncryptRequestWithURLString:@"im/ua/timerMsgSwitchUpdate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
    [weakSelf requestNeedTip:NO];
  } failure:^(XKHttpErrror *error) {
    
  }];
}

- (void)updateUI {
  [self.tableView reloadData];
  _switchView.mySwitch.on = self.msgInfo.timerSwitch;
}

#pragma mark ----------------------------- 代理方法 ------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.msgInfo.mappingMsgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XKArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  XKSecretTipMsg *msg = self.msgInfo.mappingMsgs[indexPath.row];
  cell.arrowView.titleLabel.numberOfLines = 0;
  [cell.arrowView.titleLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
    confer.paragraphStyle.lineSpacing(5);
    confer.text(msg.msgContent);
    confer.text(@"\n");
    confer.text(msg.displayTime).textColor(HEX_RGB(0x7777777)).font(XKRegularFont(12));
  }];
  cell.arrowView.detailLabel.text = msg.timerMsgStatus ? @"已提醒" : @"";
  
  cell.contentView.xk_openClip = YES;
  cell.contentView.xk_radius = 6;
  if (indexPath.row == 0) {
    cell.contentView.xk_clipType = XKCornerClipTypeTopBoth;
    [cell hiddenSeperateLine:NO];;
    if (self.msgInfo.mappingMsgs.count == 1) {
      cell.contentView.xk_clipType = XKCornerClipTypeAllCorners;
    }
  } else if (indexPath.row != self.msgInfo.mappingMsgs.count - 1) { // 不是最后一个
    cell.contentView.xk_clipType = XKCornerClipTypeNone;
  } else { // 最后一个
    [cell hiddenSeperateLine:YES];
    cell.contentView.xk_clipType = XKCornerClipTypeBottomBoth;
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak typeof(self) weakSelf = self;
  XKSecretClockMsgEditController *vc = [XKSecretClockMsgEditController new];
  vc.secretId = self.secretId;
  vc.msgClockInfo = self.msgInfo.mappingMsgs[indexPath.row];
  [vc setEditSuccess:^{
    [weakSelf requestNeedTip:NO];
  }];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 侧滑
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
  __weak typeof(self) weakSelf = self;
  UITableViewRowAction *removeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    [weakSelf deleteMsg:indexPath];
  }];
  return @[removeAction];
}


#pragma mark --------------------------- setter&getter -------------------------


@end

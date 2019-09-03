//
//  XKOfficialGroupChatDisableSendMsgViewController.m
//  xkMerchant
//
//  Created by RyanYuan on 2018/12/25.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKOfficialGroupChatDisableSendMsgViewController.h"
#import "XKOfficialGroupChatDisableSendMsgTableViewCell.h"
#import "XKTimeDurationPickerViewController.h"

static const CGFloat kXKOfficialGroupChatDisableSendMsgViewControllerCellHeight = 44;

@interface XKOfficialGroupChatDisableSendMsgViewController () <UITableViewDataSource, UITableViewDelegate, XKOfficialGroupChatDisableSendMsgTableViewCellDelegate, XKTimeDurationPickerViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *timeArr;
@property (nonatomic, strong) NSString *customTimeString;
@property (nonatomic, strong) NSArray *selectedCustomTimeArr;

@end

@implementation XKOfficialGroupChatDisableSendMsgViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSMutableDictionary *timeDictOne = @{@"title": @"10分钟", @"number": @"600", @"isSelected": @"0"}.mutableCopy;
  NSMutableDictionary *timeDictTwo = @{@"title": @"1小时", @"number": @"3600", @"isSelected": @"0"}.mutableCopy;
  NSMutableDictionary *timeDictThree = @{@"title": @"12小时", @"number": @"43200", @"isSelected": @"0"}.mutableCopy;
  NSMutableDictionary *timeDictFour = @{@"title": @"1天", @"number": @"86400", @"isSelected": @"0"}.mutableCopy;
  NSMutableDictionary *timeDictFive = @{@"title": @"自定义", @"number": @"0", @"isSelected": @"0"}.mutableCopy;
  self.timeArr = @[timeDictOne, timeDictTwo, timeDictThree, timeDictFour, timeDictFive].mutableCopy;
  
  self.customTimeString = @"";
  
  [self initializeView];
}

- (void)initializeView {
  
  self.navigationView.hidden = NO;
  [self setNavTitle:@"禁言时长" WithColor:[UIColor whiteColor]];
  self.view.backgroundColor = HEX_RGB(0xF6F6F6);
  
  // 描述文本
  UILabel *describeLabel = [UILabel new];
  describeLabel.text = @"设置禁言的时长";
  describeLabel.font = XKFont(XK_PingFangSC_Regular, 14);
  describeLabel.textColor = [UIColor lightGrayColor];
  describeLabel.textAlignment = NSTextAlignmentLeft;
  [self.containView addSubview:describeLabel];
  [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.offset(22);
    make.top.equalTo(self.containView.mas_top).offset(10);
  }];
  
  // 列表视图
  UITableView *tableView = [UITableView new];
  tableView.backgroundColor = [UIColor whiteColor];
  tableView.layer.masksToBounds = YES;
  tableView.layer.cornerRadius = 8;
  tableView.delegate = self;
  tableView.dataSource = self;
  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  tableView.showsVerticalScrollIndicator = NO;
  tableView.showsHorizontalScrollIndicator = NO;
  tableView.scrollEnabled = NO;
  [self.containView addSubview:tableView];
  [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.offset(12);
    make.top.equalTo(describeLabel.mas_bottom).offset(10);
    make.height.offset(kXKOfficialGroupChatDisableSendMsgViewControllerCellHeight * 5);
    make.right.offset(-12);
  }];
  [tableView registerClass:[XKOfficialGroupChatDisableSendMsgTableViewCell class] forCellReuseIdentifier:@"XKOfficialGroupChatDisableSendMsgTableViewCell"];
  self.tableView = tableView;
  
  // 确定按钮
  UIButton *confirmButton = [UIButton new];
  [confirmButton setTitle:@"确 定" forState:UIControlStateNormal];
  [confirmButton setTintColor:[UIColor whiteColor]];
  [confirmButton setBackgroundColor:XKMainTypeColor];
  confirmButton.layer.masksToBounds = YES;
  confirmButton.layer.cornerRadius = 8;
  [confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
  [self.containView addSubview:confirmButton];
  [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.offset(12);
    make.top.equalTo(tableView.mas_bottom).offset(20);
    make.height.offset(kXKOfficialGroupChatDisableSendMsgViewControllerCellHeight);
    make.right.offset(-12);
  }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.timeArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kXKOfficialGroupChatDisableSendMsgViewControllerCellHeight;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSMutableDictionary *timeDict = self.timeArr[indexPath.row];
  XKOfficialGroupChatDisableSendMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKOfficialGroupChatDisableSendMsgTableViewCell" forIndexPath:indexPath];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.delegate = self;
  [cell configTableViewCellWithDictionary:timeDict];
  if (indexPath.row == self.timeArr.count - 1) {
    [cell hiddenCellSeparator];
    [cell showCustomTimeLabel];
    [cell configTableViewCellWithCustomTimeString:self.customTimeString];
  } else {
    [cell showCellSeparator];
    [cell hiddenCustomTimeLabel];
  }
  return cell;
}

#pragma mark - XKOfficialGroupChatDisableSendMsgTableViewCellDelegate

- (void)tableViewCell:(XKOfficialGroupChatDisableSendMsgTableViewCell *)cell selectedTime:(NSMutableDictionary *)dict {
  
  // 单选
  for (NSMutableDictionary *timeDict in self.timeArr) {
    if (timeDict != dict) {
      timeDict[@"isSelected"] = @"0";
    }
  }
  
  // 弹窗
  if ([dict[@"title"] isEqualToString:@"自定义"]) {
    
    XKTimeDurationPickerViewController *timeDurationPickerViewController = [XKTimeDurationPickerViewController new];
    timeDurationPickerViewController.delegate = self;
    timeDurationPickerViewController.selectedTimeArr = self.selectedCustomTimeArr;
    timeDurationPickerViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:timeDurationPickerViewController animated:NO completion:nil];
  }
  
  [self.tableView reloadData];
}

#pragma mark - XKTimeDurationPickerViewControllerDelegate

- (void)viewController:(XKTimeDurationPickerViewController *)viewController selectedTimeArr:(NSArray *)selectedTimeArr {
  
  self.selectedCustomTimeArr = selectedTimeArr;
  NSDictionary *dayDict = selectedTimeArr[0];
  NSDictionary *hourDict = selectedTimeArr[1];
  NSDictionary *minuteDict = selectedTimeArr[2];
  NSString *dayString = dayDict[@"title"];
  NSString *hourString = hourDict[@"title"];
  NSString *minuteString = minuteDict[@"title"];
  NSString *customTimeString = [NSString stringWithFormat:@"%@%@%@", dayString, hourString, minuteString];
  self.customTimeString = customTimeString;
  [self.tableView reloadData];
  
  NSNumber *dayNum = dayDict[@"number"];
  NSNumber *hourNum = hourDict[@"number"];
  NSNumber *minuteNum = minuteDict[@"number"];
  NSInteger customTime = dayNum.intValue + hourNum.intValue + minuteNum.intValue;
  NSNumber *customTimeNum = @(customTime);
  NSMutableDictionary *timeDict = self.timeArr[self.timeArr.count - 1];
  timeDict[@"number"] = customTimeNum;
}

#pragma mark - events

- (void)clickConfirmButton:(UIControl *)sender {
  
  NSDictionary *selectedDict = @{};
  for (NSDictionary *timeDict in self.timeArr) {
    if ([timeDict[@"isSelected"] isEqualToString:@"1"]) {
      selectedDict = timeDict;
    }
  }
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
//  tid  是  String  培训群ID
//  rid  是  String  禁言的目标用户id
//  timer
  params[@"tid"] = self.teamId;
  params[@"rid"] = self.userId;
  params[@"timer"] = selectedDict[@"number"];
  [XKHudView showLoadingTo:self.containView animated:YES];
  [HTTPClient postEncryptRequestWithURLString:@"im/ma/muteSetting/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
    [XKHudView hideHUDForView:self.containView];
    [XKHudView showSuccessMessage:@"禁言成功" to:self.containView time:2 animated:YES completion:^{
      [self.navigationController popViewControllerAnimated:YES];
    }];
  } failure:^(XKHttpErrror *error) {
    [XKHudView hideHUDForView:self.containView];
    [XKHudView showErrorMessage:error.message to:self.containView animated:YES];
  }];
}

#pragma mark - setter and getter


@end

//
//  XKTestJumpViewController.m
//  xkMerchant
//
//  Created by RyanYuan on 2018/12/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "XKTestJumpViewController.h"
#import "IAPCenter+XK.h"

@interface XKTestJumpViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation XKTestJumpViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  // 初始化默认数据
  [self createDefaultData];
  
  // 初始化界面
  [self createUI];
}

- (void)createDefaultData {
  
  self.dataArray = [NSMutableArray array];
  [self.dataArray addObject:@[@"评价客服", @"XKEvaluateServiceViewController"]];
  [self.dataArray addObject:@[@"官方群列表", @"XKOfficialGroupChatMainViewController"]];
  [self.dataArray addObject:@[@"IM客服", @"XKCustomerServiceViewController"]];
  [self.dataArray addObject:@[@"管理员", @"XKGroupChatManageListViewController"]];
  [self.dataArray addObject:@[@"禁言时长", @"XKOfficialGroupChatDisableSendMsgViewController"]];
  [self.dataArray addObject:@[@"内购", @"pay"]];
}

- (void)createUI {
  
  self.navigationView.hidden = NO;
  [self setNavTitle:@"测试入口" WithColor:[UIColor whiteColor]];
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  [self.view addSubview:self.tableView];
  self.tableView.tableFooterView = [UIView new];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.equalTo(self.view);
    make.top.equalTo(self.navigationView.mas_bottom);
  }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *rid = @"1";
  UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
  if(cell==nil){
    cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:rid];
  }
  cell.textLabel.text = [self.dataArray[indexPath.row] firstObject];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSString *str = self.dataArray[indexPath.row][1];
  
  if ([str isEqualToString:@"pay"]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [[IAPCenter shareCenter] xk_PayWithProductId:@"XKSHOPcom.xkshop_50" orderId:@"123" tradeId:@"1231241" validateResult:^(NSInteger status, AppleProductSuccessCacheModel * _Nonnull info) {
        if (status == 0) {
//          resolve(@{@"status":@"0",@"msg":@"内购支付成功+自己服务器验证订单成功"});
          NSLog(@"内购支付成功+自己服务器验证成功");
        } else if (status == 1) {
//          resolve(@{@"status":@"1",@"msg":@"内购支付成功+自己服务器验证订单失败"});
          NSLog(@"内购支付成功+自己服务器验证失败");
        } else if (status == 2) {
//          resolve(@{@"status":@"2",@"msg":@"内购支付成功+自己服务器验证还未响应"});
          NSLog(@"支付成功+未等待验证结果");
        }
      } failWithoutPurchase:^(NSString * _Nonnull err) {
//        resolve(@{@"status":@"4",@"msg":[NSString stringWithFormat:@"内购失败：%@",err]});
        NSLog(@"支付失败 -%@",err);
      } failWithPurchase:^(NSString * _Nonnull err) {
//        resolve(@{@"status":@"3",@"msg":@"内购支付成功+发送验证结果给服务器失败"});
        NSLog(@"支付成功，通知自己服务器失败 -%@",err);
      }];
    });
    return;
  }
  

  
  NSDictionary *params;
  if ([self.dataArray[indexPath.row] count] == 3) {
    params = self.dataArray[indexPath.row][2];
  }
  NSString *router = [[XKRouter sharedInstance] urlDynamicTargetClassName:str Storyboard:nil Identifier:nil XibName:nil Params:params];
  [[XKRouter sharedInstance] runRemoteUrl:router ParentVC:self];
}


@end

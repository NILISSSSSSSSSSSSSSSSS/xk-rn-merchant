//
//  XKUnionPersonalInfoViewController.m
//  XKSquare
//
//  Created by Lin Li on 2019/5/6.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKUnionPersonalInfoViewController.h"
#import "XKUnionPersonalInfoViewModel.h"

@interface XKUnionPersonalInfoViewController ()

@property (nonatomic, strong) UITableView                    *tableView;
/**viewModel*/
@property (nonatomic, strong) XKUnionPersonalInfoViewModel   *viewModel;

@property(nonatomic, strong) XKEmptyPlaceView *emptyView;

@end

@implementation XKUnionPersonalInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"个人资料" WithColor:[UIColor whiteColor]];
    self.navStyle = BaseNavWhiteStyle;
    [self creatTableView];
  // 空视图
  XMEmptyViewConfig *config = [[XMEmptyViewConfig alloc] init];
  config.viewAllowTap = NO;
  config.backgroundColor =  HEX_RGB(0xf1f1f1);
  config.btnFont = XKRegularFont(14);
  config.btnColor = XKMainTypeColor;
  config.descriptionColor = HEX_RGB(0x777777);
  config.descriptionFont = XKRegularFont(15);
  config.spaceHeight = 5;
  _emptyView = [XKEmptyPlaceView configScrollView:self.tableView config:config];
}

- (void)creatTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tableView.contentInset = UIEdgeInsetsMake(1, 0, 10, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    self.tableView.bounces = NO;
    [self.viewModel registerCellForTableView:self.tableView];
    [self.viewModel loadData];
    XKWeakSelf(ws);
    self.viewModel.loadBlock = ^(BOOL showInfomation) {
      if (!showInfomation) {
        [ws.emptyView showWithImgName:@"xk_ic_msg_noInfomation" title:nil des:@"对方隐藏了个人资料" btnText:@"" btnImg:nil tapClick:^{
        }];
      }
      [ws.tableView reloadData];
    };
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(@(NavigationAndStatue_Height));
    }];
}

- (NSString *)currentDateForString {
    NSDate *date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}
/**
 tableView点击方法的回调
 
 @param tableView tableview
 @param indexPath indexPath
 */
- (void)didselectTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath  {
   
}

- (XKUnionPersonalInfoViewModel *)viewModel {
    if (!_viewModel) {
        XKWeakSelf(ws);
        _viewModel = [[XKUnionPersonalInfoViewModel alloc]init];
        _viewModel.selectBlock = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            [ws didselectTableView:tableView indexPath:indexPath];
        };
    }
    return _viewModel;
}
@end

//
//  XKSysMessageViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/8.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSysMessageViewController.h"
#import "XKSysMessageViewModel.h"
#import "XKSysMessageModel.h"
#import "XKMessageSysAndPraiseViewController.h"
#import "XKMessageShoppingMallViewController.h"
#import "XKMessageActivityAndSpecialViewController.h"
#import <NIMSDK/NIMSDK.h>
@interface XKSysMessageViewController ()
/**tableview*/
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) XKSysMessageViewModel *viewModel;
@end

@implementation XKSysMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTable];
    [self.viewModel loadNetWork];
}

- (void)dealloc {
    [self.viewModel viewModeldealloc];
}
- (void)creatTable {
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self.viewModel;
    _tableView.dataSource = self.viewModel;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    _tableView.estimatedRowHeight = 100;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.viewModel registerCellForTableView:_tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

- (XKSysMessageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XKSysMessageViewModel alloc]init];
        XKWeakSelf(ws);
        //刷新tableView并检查权限按钮的状态
        _viewModel.loadBlock = ^{
            [ws.tableView reloadData];
        };
        _viewModel.selectBlock = ^(NSIndexPath *indexPath){
            XKSysMessageModel *model = ws.viewModel.dataArray[indexPath.row];
           [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:[NIMSession session:model.accid type:NIMSessionTypeP2P]];
            //活动
            if ([model.code isEqualToString:SysMessageActivityCode]) {
                XKMessageActivityAndSpecialViewController *vc = [[XKMessageActivityAndSpecialViewController alloc]init];
                vc.type = XKActivitySysMessageControllerType;
                [ws.navigationController pushViewController:vc animated:YES];
              
            }
            //专题
            else if ([model.code isEqualToString:SysMessageSpecialCode]){
                XKMessageActivityAndSpecialViewController *vc = [[XKMessageActivityAndSpecialViewController alloc]init];
                vc.type = XKSpecialSysMessageControllerType;
                [ws.navigationController pushViewController:vc animated:YES];
                
            }
            //自营
            else if ([model.code isEqualToString:SysMessageShoppingCode]){
                XKMessageShoppingMallViewController *vc = [[XKMessageShoppingMallViewController alloc]init];
                vc.type = XKShoppingSysMessageControllerType;
                [ws.navigationController pushViewController:vc animated:YES];
            }
            //福利
            else if ([model.code isEqualToString:SysMessageMallCode]){
                XKMessageShoppingMallViewController *vc = [[XKMessageShoppingMallViewController alloc]init];
                vc.type = XKMallSysMessageControllerType;
                [ws.navigationController pushViewController:vc animated:YES];
            }
            //周边
            else if ([model.code isEqualToString:SysMessageAreaCode]){
                XKMessageShoppingMallViewController *vc = [[XKMessageShoppingMallViewController alloc]init];
                vc.type = XKAreaSysMessageControllerType;
                [ws.navigationController pushViewController:vc animated:YES];
            }
            //抽奖
            else if ([model.code isEqualToString:SysMessagepPraiseCode]){
                XKMessageSysAndPraiseViewController *vc = [[XKMessageSysAndPraiseViewController alloc]init];
                vc.type = XKPraiseSysMessageControllerType;
                [ws.navigationController pushViewController:vc animated:YES];
            }
            //系统
            else if ([model.code isEqualToString:SysMessageCode]){
                XKMessageSysAndPraiseViewController *vc = [[XKMessageSysAndPraiseViewController alloc]init];
                vc.type = XKSysSysMessageControllerType;
                [ws.navigationController pushViewController:vc animated:YES];
            }
          
        };
    }
    return _viewModel;
}

@end

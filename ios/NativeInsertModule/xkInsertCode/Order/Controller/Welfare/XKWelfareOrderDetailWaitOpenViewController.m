//
//  XKWelfareOrderDetailWaitOpenViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/8/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailWaitOpenViewController.h"
#import "XKWelfareOrderDetailWaitOpenTopCell.h"
#import "XKCustomNavBar.h"
#import "XKWelfareOrderFinishCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKWelfareOrderDetailBottomView.h"
#import "XKWelfareOrderWaitOpendDetailAddressCell.h"
#import "XKWelfareOrderWaitOpendDetailInfoCell.h"
#import "XKWelfareOrderDetailViewModel.h"
#import "XKWelfareGoodsDetailNumberInfoCell.h"
#import "XKCustomeSerMessageManager.h"
@interface XKWelfareOrderDetailWaitOpenViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)WelfareOrderDataItem  *item;
@property (nonatomic, strong)XKWelfareOrderDetailViewModel *viewModel;
@property (nonatomic, strong)NSArray *listNameArr;
@property (nonatomic, strong)NSArray *listValueArr;
@property (nonatomic, strong)NSMutableArray *goodsTmpArr;
@property (nonatomic, strong)XKWelfareOrderDetailBottomView *bottomView;
@end

@implementation XKWelfareOrderDetailWaitOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)handleData {
    [super handleData];
    _goodsTmpArr = [NSMutableArray array];
    _listNameArr = @[@"剩余兑奖笔数：",@"兑奖方式："];
    if ([_item.drawType isEqualToString:@"bytime"]) {
         _listNameArr = @[@"兑奖方式："];
    }
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.titleString = @"订单详情";
    [_navBar customBaseNavigationBar];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

- (void)chatBtnClick:(UIButton *)sender {
    
}

- (void)handleOrderItemModel:(WelfareOrderDataItem *)item {
    _item = item;
    [self requestWithTip:YES];
}
#pragma mark 网络请求
- (void)requestWithTip:(BOOL)tip {
    if(tip) {
        [XKHudView showLoadingTo:self.view animated:YES];
    }
    NSDictionary *dic = @{
                          @"orderId" : _item.orderId ?:@"",
                          };
    [XKWelfareOrderDetailViewModel requestWelfareOrderDetailWithParamDic:dic Success:^(XKWelfareOrderDetailViewModel *model) {
        [self handleSuccessDataWithModel:model];
    } failed:^(NSString *failedReason, NSInteger code) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

- (void)handleSuccessDataWithModel:(XKWelfareOrderDetailViewModel *)model {
    [XKHudView hideAllHud];
    _viewModel = model;
    NSInteger extraCount = model.maxStake - model.joinCount;
    NSString *way = [_viewModel.drawType isEqualToString:@"bymember"] ? @"按人数" : @"按时间";
    _listValueArr = @[@(extraCount).stringValue,way ?: @""];
    if ([_viewModel.drawType isEqualToString:@"bytime"]) {
        _listValueArr = @[way ?: @""];
    }

    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    [XKHudView showErrorMessage:reason];
}

#pragma mark tableview代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel == nil ? 0 : 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 4 ? _listValueArr.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
         if ([_viewModel.drawType isEqualToString:@"bytime"]) {
              return 45;
         } else  if ([_viewModel.drawType isEqualToString:@"bymember"]) {
              return 45;
         } else  if ([_viewModel.drawType isEqualToString:@"bytime_or_bymember"]) {
              return 100;
         } else  if ([_viewModel.drawType isEqualToString:@"bytime_and_bymember"]) {
              return 100;
         }
         return 45;
    }
    
    if(indexPath.section == 1) {
           NSString *address = [NSString stringWithFormat:@"地址：%@",_viewModel.userAddress];
           CGFloat addressH = [address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12)} context:nil].size.height;
           return 40 + addressH;
       }
    
    if(indexPath.section == 2) {
         return 108;
      }
    
    if(indexPath.section == 3) {
        NSString *number = @"";
        for (XKWelfareOrderNumberItem * item in _viewModel.lotteryNumbers) {
           number =  [number stringByAppendingString:item.lotteryNumber];
           number =  [number stringByAppendingString:@"\n"];
        }
        NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc] initWithString:number];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];
        [contentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentString length])];
        CGFloat numberH = [number boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12),NSParagraphStyleAttributeName:paragraphStyle} context:nil].size.height;
        return 40 + numberH;
    }
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            {
                XKWelfareOrderDetailWaitOpenTopCell *cell = [[XKWelfareOrderDetailWaitOpenTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell bindDataModel:_viewModel withOrderItem:_item];
                return cell;
            }
            break;
        case 1:
            {
                XKWelfareOrderWaitOpendDetailAddressCell *cell = [[XKWelfareOrderWaitOpendDetailAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell bindDataModel:_viewModel];
                return cell;
            }
            break;
        case 2:
        {
            XKWelfareOrderWaitOpendDetailInfoCell *cell = [[XKWelfareOrderWaitOpendDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell bindDataModel:_viewModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
            break;
        case 3:
        {
            XKWelfareGoodsDetailNumberInfoCell *cell = [[XKWelfareGoodsDetailNumberInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell bindDataModel:_viewModel];
            return cell;
        }
              break;
        case 4:
        {
            XKOrderInputTableViewCell *inputCell = [[XKOrderInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            inputCell.rightTf.enabled = NO;
            inputCell.leftLabel.text = _listNameArr[indexPath.row];
             inputCell.rightTf.text = _listValueArr[indexPath.row];
            if(_listNameArr.count == 1) {
                inputCell.xk_clipType = XKCornerClipTypeAllCorners;
            } else {
                if(indexPath.row == 0) {
                    inputCell.xk_clipType = XKCornerClipTypeTopBoth;
                    [inputCell hiddenSeperateLine:NO];
                } else {
                    inputCell.xk_clipType = XKCornerClipTypeBottomBoth;
                    [inputCell hiddenSeperateLine:YES];
                }
            }
            return inputCell;
        }
            break;
   
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20,  SCREEN_HEIGHT - kIphoneXNavi(64) - 50 - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[XKWelfareOrderDetailWaitOpenTopCell class] forCellReuseIdentifier:@"XKWelfareOrderDetailWaitOpenTopCell"];
        [_tableView registerClass:[XKWelfareOrderWaitOpendDetailAddressCell class] forCellReuseIdentifier:@"XKWelfareOrderWaitOpendDetailAddressCell"];
        [_tableView registerClass:[XKWelfareOrderFinishCell class] forCellReuseIdentifier:@"XKWelfareOrderFinishCell"];
        [_tableView registerClass:[XKOrderInputTableViewCell class] forCellReuseIdentifier:@"XKOrderInputTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (XKWelfareOrderDetailBottomView *)bottomView {
    if(!_bottomView) {
        _bottomView = [XKWelfareOrderDetailBottomView WelfareOrderDetailBottomViewWithType:WelfareOrderDetailBottomViewWaitOpen];
        _bottomView.frame = CGRectMake(0,SCREEN_HEIGHT - kBottomSafeHeight - 50, SCREEN_WIDTH, 50 + kBottomSafeHeight);
        _bottomView.tipBtnBlock = ^(UIButton *sender) {
             [XKCustomeSerMessageManager createXKCustomerSerChat];
        };
    }
    return _bottomView;
}
@end

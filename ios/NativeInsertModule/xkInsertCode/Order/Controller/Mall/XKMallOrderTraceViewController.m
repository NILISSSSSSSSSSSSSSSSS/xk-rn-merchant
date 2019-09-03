//
//  XKMallOrderTraceViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallOrderTraceViewController.h"
#import "XKMallOrderTraceViewTopCell.h"
#import "XKMallOrderTraceProgressCell.h"
#import "UIView+XKCornerRadius.h"
#import "XKOrderTransportInfoModel.h"
@interface XKMallOrderTraceViewController ()<UITableViewDelegate, UITableViewDataSource>
/*导航栏*/
@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) XKOrderTransportInfoModel  *model;
@end

@implementation XKMallOrderTraceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 默认加载方法
- (void)handleData {
    [super handleData];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [_navBar customNaviBarWithTitle:@"订单追踪" andRightButtonImageTitle:@""];
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
    
    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.tableView config:nil];
}

- (void)requestDataWithTip:(BOOL)tip {
    if (tip) {
        [XKHudView showLoadingTo:self.tableView animated:YES];
    }
    NSDictionary *dic = @{
                          @"orderId" : _orderId
                          };
    [XKOrderTransportInfoModel requestTransportInfoWithParm:dic Success:^(id  _Nonnull data) {
         [self handleSuccessDataWithModel:[XKOrderTransportInfoModel yy_modelWithJSON:data]];
    } failed:^(NSString * _Nonnull failedReason, NSInteger code) {
          [self handleErrorDataWithReason:failedReason];
    }];
    
}

- (void)handleSuccessDataWithModel:(XKOrderTransportInfoModel *)model {
    self.model = model;
    [XKHudView hideAllHud];
    [self.emptyTipView hide];
    [self.tableView.mj_header endRefreshing];
    if (model == nil) {//没数据
        self.emptyTipView.config.viewAllowTap = YES;
        [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据，点击屏幕刷新" tapClick:^{
            [self.tableView.mj_header beginRefreshing];
        }];
    }
    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    XKWeakSelf(ws);
    [self.tableView.mj_header endRefreshing];
    self.emptyTipView.config.viewAllowTap = YES;
    [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
        [ws requestDataWithTip:YES];
    }];
}
#pragma mark delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _model == nil ? 0 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : _model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 0) {
        XKMallOrderTraceViewTopCell *top = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderTraceViewTopCell" forIndexPath:indexPath];
        [top bindModel:_model withOrderId:_orderId];
        return top;
    } else {
        XKMallOrderTraceProgressCell *progress = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderTraceProgressCell" forIndexPath:indexPath];
        XKOrderTransportInfoObj *obj = _model.list[indexPath.row];

        if(_dataArr.count == 1) {
            [progress bindModel:obj isFirst:YES isLast:YES];
            progress.xk_clipType = XKCornerClipTypeAllCorners;
        } else {
            if(indexPath.row == 0) {
                [progress bindModel:obj isFirst:YES isLast:NO];
                progress.xk_clipType = XKCornerClipTypeTopBoth;
                
            } else if(indexPath.row == _dataArr.count - 1){
                [progress bindModel:obj isFirst:NO isLast:YES];
                progress.xk_clipType = XKCornerClipTypeBottomBoth;
            } else {
               [progress bindModel:obj isFirst:NO isLast:NO];
                progress.xk_clipType = XKCornerClipTypeNone;
            }
        }

        return progress;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return  self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        XKWeakSelf(ws);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20,  SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        //_tableView.allowsSelection = NO;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        [_tableView registerClass:[XKMallOrderTraceViewTopCell class] forCellReuseIdentifier:@"XKMallOrderTraceViewTopCell"];
        [_tableView registerClass:[XKMallOrderTraceProgressCell class] forCellReuseIdentifier:@"XKMallOrderTraceProgressCell"];
        
        MJRefreshNormalHeader *narmalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         
            [ws requestDataWithTip:NO];
        }];
        _tableView.mj_header = narmalHeader;
    }
    return _tableView;
}

@end

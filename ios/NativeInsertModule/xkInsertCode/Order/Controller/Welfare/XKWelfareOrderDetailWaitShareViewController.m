//
//  XKWelfareOrderDetailWaitShareViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKWelfareOrderDetailWaitShareViewController.h"
#import "XKWelfareOrderDetailTopCell.h"
#import "XKCustomNavBar.h"
#import "XKWelfareOrderWaitOpendDetailInfoCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKWelfareOrderDetailBottomView.h"
#import "XKWelfareGoodsDestoryReportViewController.h"
#import "XKCustomeSerMessageManager.h"
#import "XKWelfareGoodsDetailNumberInfoCell.h"
#import "XKWelfareShareView.h"
#import "XKCommonSheetView.h"
#import "XKGoodsShareView.h"
#import "XKContactListController.h"
#import "XKIMGlobalMethod.h"
#import "XKWelfareOrderDetailWaitAcceptViewController.h"
#import "XKCollectWelfareModel.h"
@interface XKWelfareOrderDetailWaitShareViewController () <UITableViewDelegate,UITableViewDataSource,XKCustomShareViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)XKCustomNavBar *navBar;
@property (nonatomic, strong)XKWelfareOrderDetailBottomView *bottomView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)UIView *sectionHeaderView;
@property (nonatomic, strong)UILabel *trackNameLabel;
@property (nonatomic, strong)NSArray *listNameArr;
@property (nonatomic, strong)NSArray *listValueArr;
@property (nonatomic, strong) WelfareOrderDataItem  *item;
@property (nonatomic, strong) XKWelfareOrderDetailViewModel  *viewModel;
@property (nonatomic, strong) XKWelfareShareView  *shareView;
@property (nonatomic, strong) XKCommonSheetView  *shareBgView;
@end

@implementation XKWelfareOrderDetailWaitShareViewController

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
    _page = 0;
    _listNameArr = @[@"兑奖方式：",@"中奖时间：",];
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

//联系客服
- (void)chatBtnClick:(UIButton *)sender {
    [XKCustomeSerMessageManager createXKCustomerSerChat];
}

//提醒发货
- (void)tipBtnClick:(UIButton *)sender {
     [XKHudView showSuccessMessage:@"已成功提醒发货！"];
}

- (void)handleOrderItemModel:(WelfareOrderDataItem *)item {
    _item = item;
    [self requestWithTip:YES];
}
//去分享
- (void)shareAction {
    XKCustomShareView *shareView = [[XKCustomShareView alloc] init];
    shareView.autoThirdShare = NO;
    shareView.shareItems = [@[XKShareItemTypeCircleOfFriends,
                              XKShareItemTypeWechatFriends,
                              XKShareItemTypeQQ,
                              XKShareItemTypeSinaWeibo,
                              XKShareItemTypeMyFriends,
                              XKShareItemTypeCopyLink
                              ] mutableCopy];
    shareView.delegate = self;
    shareView.layoutType = XKCustomShareViewLayoutTypeBottom;
    XKShareDataModel *shareData = [[XKShareDataModel alloc] init];
    shareData.title = _viewModel.goodsName;
    shareData.content = @"福利商品分享";
    NSString *path = [NSString stringWithFormat:@"share/#/goodsdetail?id=%@&client=xk&securityCode=undefined",_viewModel.goodsId];
    NSString *server = [BaseWebUrl stringByAppendingString:path];
    shareData.url = server;
    shareData.img = _viewModel.mainUrl;
    shareView.shareData = shareData;
    [shareView showInView:[UIApplication sharedApplication].keyWindow.window];
}
#pragma mark 网络请求
- (void)shareGoods {
   //  [XKHudView showLoadingTo:self.view animated:YES];
    NSDictionary *dic = @{
                          @"orderId" : _item.orderId ?:@"",
                          };
    [XKWelfareOrderDetailViewModel requestWelfareOrderSureShareWithParamDic:dic Success:^(XKWelfareOrderDetailViewModel *model) {
        [XKHudView hideAllHud];
        XKWelfareOrderDetailWaitAcceptViewController * accept = [XKWelfareOrderDetailWaitAcceptViewController new];
        [accept handleOrderItemModel:self.item];
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [tmpArr removeLastObject];
        [tmpArr addObject:accept];
        self.navigationController.viewControllers = tmpArr;
    } failed:^(NSString *failedReason, NSInteger code) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

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
    self.shareView.urlStr = model.mainUrl;
    [self.shareBgView show];

     NSString *winDate = [XKTimeSeparateHelper backYMDHMStringByChineseSegmentWithTimestampString:@(_viewModel.lotteryTime).stringValue];
    _listValueArr = @[@"积分兑奖", winDate ?:@""];

    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    [XKHudView showErrorMessage:reason];
}

#pragma mark tableview代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel == nil ? 0 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 3 ? _listValueArr.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            NSString *address = [NSString stringWithFormat:@"地址：%@",_viewModel.userAddress];
            CGFloat addressH = [address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XKRegularFont(12)} context:nil].size.height;
            return  addressH + 75 + 5;
        }
            break;
        case 1:
            return 110;
            break;
        case 2:
        {
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
            break;
        case 3:
            return 42;
        case 4:
            return 42;
            break;
            
        default: return 0;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            XKWelfareOrderDetailTopCell *cell = [[XKWelfareOrderDetailTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell handleWelfareOrderDetailWithType:WelfareOrderTypeNotShare dataModel:_viewModel];
            return cell;
        }
            break;
        case 1:
        {
            XKWelfareOrderWaitOpendDetailInfoCell *cell = [[XKWelfareOrderWaitOpendDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell bindDataModel:_viewModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            break;
        case 2:{
            XKWelfareGoodsDetailNumberInfoCell *cell = [[XKWelfareGoodsDetailNumberInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell bindDataModel:_viewModel];
            return cell;
        }
        case 3:
        {
            XKOrderInputTableViewCell *inputCell = [[XKOrderInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            inputCell.rightTf.enabled = NO;
            inputCell.leftLabel.text = _listNameArr[indexPath.row];
            if(_listNameArr.count == 1) {
                [inputCell cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 42)];
            } else {
                if(indexPath.row == 0) {
                    [inputCell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 42)];
                } else if(indexPath.row == _listNameArr.count - 1) {
                    [inputCell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 42)];
                } else {
                    [inputCell restoreFromCorner];
                }
            }
            inputCell.rightTf.text = _listValueArr[indexPath.row];
            return inputCell;
            
        }
            break;

            
        default: return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  section == 3 ? 10 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return  self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// 未开启第三方自动分享或者开启第三方自动分享，但点击项不支持自动分享 点击事件
- (void)customShareView:(XKCustomShareView *) customShareView didClickedShareItem:(NSString *) shareItem {
    if ([shareItem isEqualToString:XKShareItemTypeMyFriends]) {
     
        XKContactListController *vc = [[XKContactListController alloc]init];
        vc.useType = XKContactUseTypeSingleSelectWithoutCheck;
        vc.rightButtonText = @"发送";
        [vc setSureClickBlock:^(NSArray<XKContactModel *> *contacts, XKContactListController *listVC) {
            [listVC.navigationController popViewControllerAnimated:YES];
            if (contacts.count) {
                XKContactModel *contact = contacts.firstObject;
                Target *target = [[Target alloc] init];
                XKCollectWelfareDataItem *welfare = [[XKCollectWelfareDataItem alloc] init];
                target.targetId = self.viewModel.goodsId;
                target.showPics = self.viewModel.mainUrl;
                target.name = self.viewModel.goodsName;
                target.showAttr = self.viewModel.showSkuName;
                target.perPrice = self.viewModel.price.integerValue;
                welfare.target = target;
                
                NSMutableArray *tempArray = [NSMutableArray array];
                [tempArray addObject:welfare];
                
                [XKIMGlobalMethod sendShareWithShareArray:tempArray session:[NIMSession session:contact.userId type:NIMSessionTypeP2P]];

                [self shareGoods];
            }
        }];
        [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
    if ([shareItem isEqualToString:XKShareItemTypeCopyLink]) {
        NSString *path = [NSString stringWithFormat:@"share/#/goodsdetail?id=%@&client=xk&securityCode=undefined",_viewModel.goodsId];
        NSString *server = [BaseWebUrl stringByAppendingString:path];
        [UIPasteboard generalPasteboard].string = server;
        [XKHudView showTipMessage:@"已复制链接"];
    }
}

// 第三方自动分享成功
- (void)customShareView:(XKCustomShareView *) customShareView didAutoThirdShareSucceed:(NSString *) shareItem {
    [self shareGoods];
}
#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10,kIphoneXNavi(64), SCREEN_WIDTH - 20,  SCREEN_HEIGHT - kIphoneXNavi(64) - 50 - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[XKWelfareOrderDetailTopCell class] forCellReuseIdentifier:@"XKWelfareOrderDetailTopCell"];
        [_tableView registerClass:[XKOrderInputTableViewCell class] forCellReuseIdentifier:@"XKOrderInputTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (XKWelfareOrderDetailBottomView *)bottomView {
    if(!_bottomView) {
        XKWeakSelf(ws);
        _bottomView = [XKWelfareOrderDetailBottomView WelfareOrderDetailBottomViewWithType:WelfareOrderDetailBottomViewWaitShare];
        _bottomView.shareBlock = ^(UIButton *sender) {
            [ws.shareBgView show];
        };
        _bottomView.frame = CGRectMake(0,SCREEN_HEIGHT - kBottomSafeHeight - 50, SCREEN_WIDTH, 50 + kBottomSafeHeight);
    }
    return _bottomView;
}

- (XKWelfareShareView *)shareView {
    if (!_shareView) {
        XKWeakSelf(ws);
        _shareView = [[XKWelfareShareView alloc] initWithFrame:CGRectMake(42,217 * SCREEN_HEIGHT /667, SCREEN_WIDTH - 84 , 325 * SCREEN_WIDTH / 375)];
        _shareView.closeBlock = ^(UIButton *sender) {
            [ws.shareBgView dismiss];
        };
        _shareView.shareBlock = ^(UIButton *sender) {
            [ws shareAction];
            [ws.shareBgView dismiss];
        };
    }
    return _shareView;
}

- (XKCommonSheetView *)shareBgView {
    if (!_shareBgView) {
        _shareBgView = [[XKCommonSheetView alloc] init];
        _shareBgView.contentView = self.shareView;
        _shareBgView.animationWay = AnimationWay_centerShow;
        [_shareBgView addSubview:self.shareView];
    }
    return _shareBgView;
}
@end

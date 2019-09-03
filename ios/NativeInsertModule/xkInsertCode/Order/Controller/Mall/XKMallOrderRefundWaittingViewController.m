//
//  XKMallOrderRefundWaittingViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/7.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallOrderRefundWaittingViewController.h"
#import "XKMallOrderApplyRefundCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKBottomAlertSheetView.h"
#import "XKRefundProgressViewController.h"
#import "XKMainMallOrderViewController.h"
#import "XKMallOrderRefundGoodsCell.h"

@interface XKMallOrderRefundWaittingViewController ()<UITableViewDelegate, UITableViewDataSource>
/*导航栏*/
@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIView  *submitView;
@property (nonatomic, strong) XKBottomAlertSheetView *bottomView;
@property (nonatomic, strong) NSArray  *nameArr;
@property (nonatomic, strong) XKMallOrderDetailViewModel  *viewModel;
@property (nonatomic, strong) UIView  *statusHeaderView;
@property (nonatomic, strong) NSTimer  *timer;
@property (nonatomic, strong) XKFriendCirclePublishViewModel  *picModel;
@end

@implementation XKMallOrderRefundWaittingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark 默认加载方法
- (void)handleData {
    [super handleData];
    _nameArr = @[@"退货退款原因：", @"退款金额：", @"退货退款说明：", @"退货退款时间："];

}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [_navBar customNaviBarWithTitle:@"退货退款中" andRightButtonImageTitle:@""];
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
    
  
    [self.submitView addSubview:self.submitBtn];
    [self requestData];
}

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(nextTime)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)nextTime {
    NSString *title =  [self compareTwoTime:_viewModel.refundTime endTime:_viewModel.refundAutoAcceptTime];
    [_submitBtn setTitle:title forState:0];
    _viewModel.refundAutoAcceptTime -- ;
    if (_viewModel.refundAutoAcceptTime == 0) {
        [self.timer invalidate];
        self.timer = nil;
        XKRefundProgressViewController *progress = [XKRefundProgressViewController new];
        [self.navigationController pushViewController:progress animated:YES];
    }
}

- (void)requestData {
    [XKHudView showLoadingTo:self.view animated:YES];
    NSDictionary *dic = @{
                          @"refundId" : _item.refundId
                          };
    [XKMallOrderDetailViewModel requestMallAfterSaleOrderDetailWithParamDic:dic Success:^(XKMallOrderDetailViewModel *model) {
        [self handleSuccessDataWithModel:model];
    } failed:^(NSString *failedReason, NSInteger code) {
        [self handleErrorDataWithReason:failedReason];
    }];
    
}

- (void)handleSuccessDataWithModel:(XKMallOrderDetailViewModel *)model {
    [XKHudView hideAllHud];
    _viewModel = model;
    _picModel = [XKFriendCirclePublishViewModel new];
    [_picModel.mediaInfoArr removeAllObjects];
    
    for (XKMallRefundEvidenceItem * item in model.refundEvidence) {
        XKUploadMediaInfo * info = [XKUploadMediaInfo new];
        info.isAdd = NO;
        if (item.refundVideo.length > 1) {
            info.isVideo = YES;
            info.videoNetAddr = item.refundVideo;
            info.videoFirstImgNetAddr = item.refundPic;
        } else {
            info.isVideo = NO;
            info.imageNetAddr = item.refundPic;
        }
        [_picModel.mediaInfoArr addObject:info];
    }
    [self addTimer];
    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    [XKHudView showErrorMessage:reason];
}

- (NSString*)compareTwoTime:(NSInteger)startTime endTime:(NSInteger)endTime {
    
    NSInteger balance = endTime  - startTime;

   
    NSInteger hour = balance / 3600;
    NSInteger mint = balance % 3600 / 60;
    NSInteger secs = balance % 3600 % 60;
  
   
    return [NSString stringWithFormat:@"等待卖家同意%.2zd:%.2zd:%.2zd",hour,mint,secs];;
    
}

#pragma mark delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? _viewModel.goodsInfo.count : section == 1 ? 4 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 100;
            break;
        case 1:
            return 45;
            break;
        case 2:
        {
            NSInteger lines = ceil(_picModel.mediaInfoArr.count / 4.0);
            CGFloat newHeight = lines * ((SCREEN_WIDTH - 2 * 10 - 2 * 15) / 4);
            return newHeight + 40;
        }
            break;
        default:return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        XKMallOrderApplyRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderApplyRefundCell" forIndexPath:indexPath];
        [cell handleWaitPayOrderDetailModel:_viewModel.goodsInfo[indexPath.row]];
        if(indexPath.row == 0) {
            [cell hiddenSeperateLine:NO];
            [cell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 100)];
        } else if(indexPath.row == _item.goods.count - 1) {
            [cell hiddenSeperateLine:YES];
            [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 100)];
        } else {
            [cell hiddenSeperateLine:NO];
            cell.layer.mask = nil;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1 ) {
        XKOrderInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKOrderInputTableViewCell" forIndexPath:indexPath];
        cell.leftLabel.text = _nameArr[indexPath.row];
        cell.leftLabel.textColor = UIColorFromRGB(0x222222);
        cell.leftLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        
        cell.rightLabel.textColor = UIColorFromRGB(0x222222);
        cell.rightLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        cell.rightTf.enabled = NO;
        
        switch (indexPath.row) {
            case 0:
                {
                    cell.rightLabel.text = _viewModel.refundReason;
                    cell.xk_clipType = XKCornerClipTypeTopBoth;
                }
                break;
            case 1:
            {
                cell.rightLabel.text = [NSString stringWithFormat:@"¥ %@",@(_viewModel.refundAmount / 100).stringValue];
                cell.xk_clipType = XKCornerClipTypeNone;
            }
                break;
            case 2:
            {
                if (_viewModel.refundMessage == nil || _viewModel.refundMessage.length < 1)
                    cell.rightLabel.text =  @"无";
                else  cell.rightLabel.text =  _viewModel.refundMessage;
                 cell.xk_clipType = XKCornerClipTypeNone;
            }
                break;
            case 3:
            {
                cell.rightLabel.text = [XKTimeSeparateHelper backYMDHMStringByStrigulaSegmentWithTimestampString:@(_viewModel.refundTime).stringValue];
                 cell.xk_clipType = XKCornerClipTypeBottomBoth;
            }
                break;
                
            default:
                break;
        }
      
        return cell;
    } else if (indexPath.section == 2 ) {
        XKMallOrderRefundGoodsCell *cell = [[XKMallOrderRefundGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.indexPath = indexPath;
        cell.picModel = self.picModel;
        cell.entryType = 1;
        [cell setRefreshTableView:^{
            //    [ws.tableView reloadData];
        }];
        cell.xk_clipType = XKCornerClipTypeAllCorners;
        return cell;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2 ? 110 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return section == 2 ? self.submitView : self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return   self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20, SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = XKSeparatorLineColor;
        [_tableView registerClass:[XKMallOrderApplyRefundCell class] forCellReuseIdentifier:@"XKMallOrderApplyRefundCell"];
        [_tableView registerClass:[XKOrderInputTableViewCell class] forCellReuseIdentifier:@"XKOrderInputTableViewCell"];
        
    }
    return _tableView;
}

- (UIButton *)submitBtn {
    if(!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH - 20, 44)];
        [_submitBtn setTitle:@"等待卖家同意 48:00:00" forState:0];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
        _submitBtn.titleLabel.font = XKRegularFont(17);
        [_submitBtn setBackgroundColor:XKMainTypeColor];
        _submitBtn.layer.cornerRadius = 8.f;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.userInteractionEnabled = NO;
    }
    return _submitBtn;
}

- (UIView *)submitView {
    if (!_submitView) {
        _submitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 110)];
        _submitView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, SCREEN_WIDTH - 50, 15)];
        titleLabel.textColor = UIColorFromRGB(0xEE6161);
        titleLabel.font = XKRegularFont(12);
        titleLabel.text = @"若卖家在规定时间内未处理，系统将自动为您退款";
        [_submitView addSubview:titleLabel];
    }
    return _submitView;
}

@end

//
//  XKWelfareChangeGoodsWaitSendViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/12/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareChangeGoodsWaitSendViewController.h"
#import "XKMallOrderApplyRefundCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKBottomAlertSheetView.h"
#import "XKMainMallOrderViewController.h"
#import "XKMallOrderRefundGoodsCell.h"
#import "XKMallOrderApplyRefundAddressCell.h"
#import "XKWelfareOrderDetailViewModel.h"
@interface XKWelfareChangeGoodsWaitSendViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
/*导航栏*/
@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIView  *submitView;
@property (nonatomic, strong) XKBottomAlertSheetView *bottomView;
@property (nonatomic, strong) NSArray  *nameArr;
@property (nonatomic, copy) NSString  *transName;
@property (nonatomic, copy) NSString  *transNameId;
@property (nonatomic, copy) NSString  *transID;
@property (nonatomic, strong) UIView  *statusHeaderView;
@property (nonatomic, strong) XKMallOrderDetailViewModel  *viewModel;
@property (nonatomic, strong) XKFriendCirclePublishViewModel  *picModel;
@end

@implementation XKWelfareChangeGoodsWaitSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
}

#pragma mark 默认加载方法
- (void)handleData {
    [super handleData];
    _nameArr = @[@"报损原因：",@"报损时间："];
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
    
    _submitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    _submitView.backgroundColor = [UIColor clearColor];
    [self.submitView addSubview:self.submitBtn];
    
}


- (void)requestData {
    [XKHudView showLoadingTo:self.view animated:YES];
    NSDictionary *dic = @{
                          @"refundId" : _orderId
                          };
    [XKWelfareOrderDetailViewModel requestWelfareOrderChangeDetailWithParamDic:dic Success:^(XKWelfareOrderDetailViewModel *model) {
        [self handleSuccessDataWithModel:model];
    } failed:^(NSString *failedReason, NSInteger code) {
        [self handleErrorDataWithReason:failedReason];
    }];
    
}


- (void)submitBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (!self.transID) {
        [XKHudView showErrorMessage:@"请填写快递单号"];
        return;
    }
    
    if (!self.transName) {
        [XKHudView showErrorMessage:@"请填写快递公司"];
        return;
    }
    
    NSDictionary *dic = @{
                          @"logisticsName" : _transNameId,
                          @"refundId" : _orderId,
                          @"logisticsNo" : _transID
                          };
    [XKMallOrderViewModel uploadTransInfoWithParm:dic Success:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failed:^(NSString *failedReason, NSInteger code) {
        [XKHudView showErrorMessage:failedReason];
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
    [self.tableView reloadData];
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    [XKHudView showErrorMessage:reason];
}
#pragma mark delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1003) {
        _transID = textField.text;
    } else if (textField.tag == 1004) {
        _transName = textField.text;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    XKWeakSelf(ws);
    if (textField.tag == 1003) {
        return  YES;
    } else if (textField.tag == 1004) {
        NSArray *nameArr = @[@"小可自营物流",@"顺丰",@"韵达",@"中通",@"申通",@"圆通",@"百世汇通",@"用户自行配送"];
        NSArray *valueArr = @[@"XK",@"SF",@"YD",@"ZT",@"ST",@"YT",@"BSHT",@"HIMSELF"];
        XKBottomAlertSheetView *alert =  [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:nameArr firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
            ws.transName = choseTitle;
            ws.transNameId = valueArr[index];
            [ws.tableView reloadData];
        }];
        [alert show];
        return NO;
    }
    return YES;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
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
        case 3:
            return 65;
            break;
        case 4:
            return 40;
            break;
        case 5:
            return 40;
            break;
            
        default:return 0;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            return  1;
        }
            break;
        case 1:
        {
            return 4;
        }
            break;
        case 2:
        {
            return 1;
        }
            break;
        case 3:
        {
            return 1;
        }
            break;
        case 4:
        {
            return 1;
        }
            break;
        case 5:
        {
            return 1;
        }
            break;
        default:return 0;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        
        XKMallOrderApplyRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderApplyRefundCell" forIndexPath:indexPath];
//        [cell handleOrderObj:_item.goods[indexPath.row]];
//        if (_item.goods.count == 1) {
//            [cell hiddenSeperateLine:YES];
//            cell.xk_clipType = XKCornerClipTypeAllCorners;
//        } else {
//            if(indexPath.row == 0) {
//                [cell hiddenSeperateLine:NO];
//                cell.xk_clipType = XKCornerClipTypeTopBoth;
//            } else if(indexPath.row == _item.goods.count - 1) {
//                [cell hiddenSeperateLine:YES];
//                cell.xk_clipType = XKCornerClipTypeBottomBoth;
//            } else {
//                [cell hiddenSeperateLine:NO];
//                cell.xk_clipType = XKCornerClipTypeNone;
//            }
//        }
        
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
        
        XKMallOrderRefundGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderRefundGoodsCell" forIndexPath:indexPath];
        cell.picModel = _picModel;
        cell.entryType = 1;
        cell.indexPath = indexPath;
        return cell;
        
    } else if (indexPath.section == 3 ) {
        XKMallOrderApplyRefundAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderApplyRefundAddressCell" forIndexPath:indexPath];
        cell.rightLabel.text = [NSString stringWithFormat:@"%@\n %@ %@",_viewModel.refundAddress?:@"",_viewModel.refundPhone?:@"",_viewModel.refundReceiver?:@""];
        return cell;
        
    } else if (indexPath.section == 4 ) {
        
        XKOrderInputTableViewCell *cell = [[XKOrderInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.leftLabel.text = @"快递单号：";
        cell.leftLabel.textColor = UIColorFromRGB(0x222222);
        cell.leftLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        
        cell.rightTf.textColor = UIColorFromRGB(0x222222);
        cell.rightTf.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        cell.rightTf.placeholder = @"请填写";
        [cell cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 40)];
        cell.rightTf.delegate = self;
        cell.rightTf.tag = 1000 + indexPath.section;
        cell.rightTf.text = _transID;
        return cell;
        
    } else if (indexPath.section == 5 ) {
        
        XKOrderInputTableViewCell *cell = [[XKOrderInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.leftLabel.text = @"快递公司：";
        cell.leftLabel.textColor = UIColorFromRGB(0x222222);
        cell.leftLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        
        cell.rightTf.textColor = UIColorFromRGB(0x222222);
        cell.rightTf.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        cell.rightTf.placeholder = @"请选择";
        cell.rightTf.text = _transName;
        //        cell.rightTf.textAlignment = NSTextAlignmentRight;
        cell.rightImgView.hidden = NO;
        cell.rightTf.delegate = self;
        cell.rightTf.tag = 1000 + indexPath.section;
        [cell cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 40)];
        return cell;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 5 ? 85 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return section == 5 ? self.submitView : self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 3 ? 44 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  section == 3 ? self.statusHeaderView :  self.clearHeaderView;
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
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.estimatedRowHeight = 40;
        _tableView.separatorColor = XKSeparatorLineColor;
        [_tableView registerClass:[XKMallOrderApplyRefundCell class] forCellReuseIdentifier:@"XKMallOrderApplyRefundCell"];
        [_tableView registerClass:[XKOrderInputTableViewCell class] forCellReuseIdentifier:@"XKOrderInputTableViewCell"];
        [_tableView registerClass:[XKMallOrderRefundGoodsCell class] forCellReuseIdentifier:@"XKMallOrderRefundGoodsCell"];
        [_tableView registerClass:[XKMallOrderApplyRefundAddressCell class] forCellReuseIdentifier:@"XKMallOrderApplyRefundAddressCell"];
    }
    return _tableView;
}

- (UIButton *)submitBtn {
    if(!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,  20, SCREEN_WIDTH - 20, 44)];
        [_submitBtn setTitle:@"申请退款" forState:0];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
        _submitBtn.titleLabel.font = XKRegularFont(17);
        [_submitBtn setBackgroundColor:XKMainTypeColor];
        _submitBtn.layer.cornerRadius = 8.f;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UIView *)statusHeaderView {
    if (!_statusHeaderView) {
        _statusHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 44)];
        _statusHeaderView.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 44)];
        titleLabel.textColor = UIColorFromRGB(0x777777);
        titleLabel.font = XKRegularFont(14);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"卖家已经同意您的申请";
        [_statusHeaderView addSubview:titleLabel];
    }
    return _statusHeaderView;
}

@end

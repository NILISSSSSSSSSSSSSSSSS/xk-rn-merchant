//
//  XKMallOrderApplyRefundGoodsViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/7.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMallOrderApplyRefundGoodsViewController.h"
#import "XKMallOrderApplyRefundCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKBottomAlertSheetView.h"
#import "XKMainMallOrderViewController.h"
#import "XKMallOrderRefundGoodsCell.h"
@interface XKMallOrderApplyRefundGoodsViewController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
/*导航栏*/
@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIView  *submitView;
@property (nonatomic, strong) XKBottomAlertSheetView *bottomView;
@property (nonatomic, strong) NSArray  *reasonArr;
@property (nonatomic, copy) NSString  *reason;
@property (nonatomic, copy) NSString  *reasonId;
@property (nonatomic, copy) NSString  *inputText;
@property (nonatomic, strong) XKFriendCirclePublishViewModel  *picModel;
@end

@implementation XKMallOrderApplyRefundGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark 默认加载方法
- (void)handleData {
    [super handleData];
    for (MallOrderListObj *obj in self.goodsArr) {
        _totalPrice += obj.price;
    }
    _totalPrice = _totalPrice / 100;
    _picModel = [XKFriendCirclePublishViewModel new];
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [_navBar customNaviBarWithTitle:@"退货退款申请" andRightButtonImageTitle:@""];
    [self.view addSubview:_navBar];
    [self.view addSubview:self.tableView];
    
    _submitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    _submitView.backgroundColor = [UIColor clearColor];
    [self.submitView addSubview:self.submitBtn];
    // 注册cell
    [self.tableView registerClass:[XKMallOrderRefundGoodsCell class] forCellReuseIdentifier:@"XKMallOrderRefundGoodsCell"];
}

- (void)reasonChose {
    XKWeakSelf(ws);
    [XKMallOrderViewModel requestMallRefundReasonSuccess:^(NSArray *modelArr) {
        ws.reasonArr = modelArr;
        NSMutableArray  *tmp = [NSMutableArray array];
        for (XKMallOrderViewModel *model in modelArr) {
            [tmp addObject:model.refundReason];
        }
        [tmp addObject:@"取消"];
        self.bottomView = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:tmp firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
            if ([choseTitle isEqualToString:@"取消"]) {
                ws.reason = @"";
            } else {
                
                ws.reason = choseTitle;
                XKMallOrderViewModel *model = ws.reasonArr[index];
                ws.reasonId = model.refundReasonId;
                
            }
            [ws.tableView reloadData];
        }];
        [self.bottomView show];
    } failed:^(NSString *failedReason, NSInteger code) {
        [XKHudView showErrorMessage:failedReason];
    }];
}

- (void)submitBtnClick:(UIButton *)sender {
    if (!self.reasonId) {
        [XKHudView showErrorMessage:@"请选择退货退款原因"];
        return;
    }
    [XKHudView showLoadingTo:self.view animated:YES];
    XKWeakSelf(ws);
    BOOL chose = NO;
    for (XKUploadMediaInfo *info in _picModel.mediaInfoArr) {
        if (!info.isAdd) {
            chose = YES;
        }
    }
    if (_picModel.mediaInfoArr.count > 0 && chose) {
        [XKUploadMediaInfo uploadMediaWithMediaArr:_picModel.mediaInfoArr Complete:^(NSString *error, id data) {
          BOOL finish =  [XKUploadMediaInfo checkMediaAllUploadWithMediaArr:ws.picModel.mediaInfoArr];
            if (!finish) {
                [XKHudView hideAllHud];
                [XKAlertView showCommonAlertViewWithTitle:@"图片上传失败，是否重新开始上传" leftText:@"取消" rightText:@"重试" leftBlock:^{
                    
                } rightBlock:^{
                    [ws commitClick:sender];
                }];
            } else {
                [ws commitClick:sender];
            }
        }];
    } else {
        [XKHudView showErrorMessage:@"请上传退货凭证"];
    }
}

- (void)commitClick:(UIButton *)sender {
    NSMutableArray *tmp = [NSMutableArray array];
    for (MallOrderListObj *obj in self.goodsArr) {
        NSDictionary *dic = @{
                              @"goodsId" : obj.goodsId,
                              @"goodsSkuCode" : obj.goodsSkuCode
                              };
        [tmp addObject:dic];
    }
    NSMutableArray *picArr = [NSMutableArray array];

    for (XKUploadMediaInfo *info in _picModel.mediaInfoArr) {
        if (!info.isAdd) {
            if (!info.isVideo) {
                [picArr addObject:@{@"refundPic" : info.imageNetAddr}];
            } else {
                [picArr addObject:@{@"refundVideo" : info.videoNetAddr,
                                    @"refundPic"   : info.videoFirstImgNetAddr
                                    }];
            };
        }
        
    }

    NSDictionary *dic = @{@"mallRefundOrderParams" : @{
                                  @"refundType" : _refundType,
                                  @"refundGoods" : tmp,
                                  @"orderId" : self.orderId,
                                  @"refundReasonId" : _reasonId,
                                  @"refundMessage" : _inputText ?:@"",
                                  @"refundEvidence" : picArr
                                  }
                          };
    
    
    [XKMallOrderViewModel requestMallRefundWithParm:dic Success:^(id data) {
        [XKHudView showSuccessMessage:@"提交成功"];
        XKMainMallOrderViewController *controller = self.navigationController.viewControllers[0];
        if (controller.refreshListBlock) {
            controller.refreshListBlock();
        }
        [self.navigationController popToViewController:controller animated:YES];
        
    } failed:^(NSString *failedReason, NSInteger code) {
        [XKHudView showErrorMessage:failedReason];
    }];
}

#pragma mark delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _inputText = textField.text;
    
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? _goodsArr.count : section == 1 ? 3 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    if(indexPath.section == 0) {
        XKMallOrderApplyRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderApplyRefundCell" forIndexPath:indexPath];
        [cell handleOrderObj:_goodsArr[indexPath.row]];
        if (_goodsArr.count == 1) {
            [cell hiddenSeperateLine:YES];
            cell.xk_clipType = XKCornerClipTypeAllCorners;
        } else {
            if(indexPath.row == 0) {
                [cell hiddenSeperateLine:NO];
                cell.xk_clipType = XKCornerClipTypeTopBoth;
            } else if(indexPath.row == _goodsArr.count - 1) {
                [cell hiddenSeperateLine:YES];
                cell.xk_clipType = XKCornerClipTypeBottomBoth;
            } else {
                [cell hiddenSeperateLine:NO];
                cell.layer.mask = nil;
            }
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.textColor = UIColorFromRGB(0x222222);
        cell.textLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
        cell.xk_openClip = YES;
        cell.xk_radius = 6.f;
         
        if(indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"退货退款原因：%@",_reason ?:@""];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.xk_clipType = XKCornerClipTypeTopBoth;
            return cell;
        } else  if(indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"退款金额：¥ %@",@(_totalPrice).stringValue];
             cell.xk_clipType = XKCornerClipTypeNone;
            return cell;
        } else {
            XKOrderInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKOrderInputTableViewCell" forIndexPath:indexPath];
            [cell updateLayout];
            cell.leftLabel.text = @"退货退款说明:";
            cell.leftLabel.textColor = UIColorFromRGB(0x222222);
            cell.leftLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
            
            cell.rightTf.textColor = UIColorFromRGB(0x222222);
            cell.rightTf.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14];
            cell.rightTf.text = _inputText ?:@"";
            cell.rightTf.placeholder = @"选填";
             cell.xk_clipType = XKCornerClipTypeBottomBoth;
            return cell;
        }
    } else {
        XKMallOrderRefundGoodsCell *refund = [tableView dequeueReusableCellWithIdentifier:@"XKMallOrderRefundGoodsCell" forIndexPath:indexPath];
        refund.indexPath = indexPath;
        [refund setRefreshTableView:^{
            [ws.tableView reloadData];
        }];
        refund.picModel = _picModel;
        return refund;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2 ? 85 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return section == 2 ? self.submitView : self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  self.clearHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 1 && indexPath.row == 0) {
        [self reasonChose];
    }
}

#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, kIphoneXNavi(64), SCREEN_WIDTH - 20, SCREEN_HEIGHT - kIphoneXNavi(64) - kBottomSafeHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.separatorColor = XKSeparatorLineColor;
        [_tableView registerClass:[XKMallOrderApplyRefundCell class] forCellReuseIdentifier:@"XKMallOrderApplyRefundCell"];
        [_tableView registerClass:[XKOrderInputTableViewCell class] forCellReuseIdentifier:@"XKOrderInputTableViewCell"];
        
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
@end

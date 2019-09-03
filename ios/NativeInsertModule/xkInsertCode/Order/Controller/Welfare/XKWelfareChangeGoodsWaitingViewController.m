//
//  XKWelfareChangeGoodsWaitingViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/12/12.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKWelfareChangeGoodsWaitingViewController.h"
#import "XKWelfareOrderDetailViewModel.h"
#import "XKMallOrderApplyRefundCell.h"
#import "XKOrderInputTableViewCell.h"
#import "XKBottomAlertSheetView.h"
#import "XKMainMallOrderViewController.h"
#import "XKMallOrderRefundGoodsCell.h"

@interface XKWelfareChangeGoodsWaitingViewController ()<UITableViewDelegate, UITableViewDataSource>
/*导航栏*/
@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) XKBottomAlertSheetView *bottomView;
@property (nonatomic, strong) NSArray  *nameArr;
@property (nonatomic, strong) XKMallOrderDetailViewModel  *viewModel;
@property (nonatomic, strong) UIView  *statusHeaderView;

@property (nonatomic, strong) XKFriendCirclePublishViewModel  *picModel;
@end

@implementation XKWelfareChangeGoodsWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark 默认加载方法
- (void)handleData {
    [super handleData];
    _nameArr = @[@"报损原因：", @"报损时间："];
    
}

- (void)addCustomSubviews {
    [self hideNavigation];
    XKWeakSelf(ws);
    _navBar =  [[XKCustomNavBar alloc] init];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    [_navBar customNaviBarWithTitle:@"报损详情" andRightButtonImageTitle:@""];
    [self.view addSubview:_navBar];
    
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(- kBottomSafeHeight);
        make.height.mas_equalTo(44);
    }];
    [self.view addSubview:self.tableView];
    [self requestData];
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

- (void)handleSuccessDataWithModel:(XKMallOrderDetailViewModel *)model {
    [XKHudView hideAllHud];
    _viewModel = model;
    _picModel = [XKFriendCirclePublishViewModel new];
    [_picModel.mediaInfoArr removeAllObjects];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel == nil ? 0 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  section == 1 ? 4 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 100;
            break;
        case 1: {
            if (indexPath.row == 1) {
                CGFloat height = [_viewModel.refundReason boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :  XKRegularFont(14)} context:nil].size.height;
                return height;
            } else {
                return 45;
            }
        }
           
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
        cell.xk_clipType = XKCornerClipTypeAllCorners;
        [cell handleWaitPayOrderDetailModel:_viewModel.goodsInfo[indexPath.row]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1 ) {
        XKOrderInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKOrderInputTableViewCell" forIndexPath:indexPath];
        cell.leftLabel.text = _nameArr[indexPath.row];
        cell.leftLabel.textColor = UIColorFromRGB(0x222222);
        cell.leftLabel.font =  XKRegularFont(14);
        
        cell.rightLabel.textColor = UIColorFromRGB(0x222222);
        cell.rightLabel.font = XKRegularFont(14);
        cell.rightTf.enabled = NO;
        
        switch (indexPath.row) {
            case 0:
            {
                [cell updateLayout];
                cell.rightLabel.text = _viewModel.refundReason;
                cell.xk_clipType = XKCornerClipTypeTopBoth;
                
            }
                break;
            case 1:
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
    return  self.clearFooterView;
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
        [_submitBtn setTitle:@"等待客服处理" forState:0];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:0];
        _submitBtn.titleLabel.font = XKRegularFont(17);
        [_submitBtn setBackgroundColor:XKMainTypeColor];
        _submitBtn.layer.cornerRadius = 8.f;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.userInteractionEnabled = NO;
    }
    return _submitBtn;
}



@end

//
//  XKPerfectPersonalViewController.m
//  XKSquare
//
//  Created by Lin Li on 2019/4/28.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKPerfectPersonalViewController.h"
#import "XKPersonalDataTableViewCell.h"
#import "XKChangeNicknameViewController.h"
#import "XKChangePhonenumViewController.h"
#import "XKChangephoneNumSecViewController.h"
#import "XKBottomAlertSheetView.h"
#import "XKDatePickerView.h"
#import "XKSignatureViewController.h"
#import "XKQRCodeCardController.h"
#import "XKShowHeaderViewController.h"
#import "XKRegionPickerViewController.h"
#import "XKPushMessageTableViewCell.h"
#import "XKPerfectPersonalViewModel.h"
#import "XKPhotoPickHelper.h"

@interface XKPerfectPersonalViewController ()<XKDatePickerViewDelegate,
XKRegionPickerViewControllerDelegate>
@property (nonatomic, strong) UITableView                     *tableView;
@property (nonatomic, strong) XKPerfectPersonalViewModel      *viewModel;

@property (nonatomic, strong) XKDatePickerView                *dateView;
/**签名，完整*/
@property (nonatomic, copy) NSString *allSignature;

@property (nonatomic, strong) XKPhotoPickHelper               *bottomSheetView;

@property(nonatomic, assign) BOOL infoChangeStatus;

@end

@implementation XKPerfectPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"个人资料" WithColor:[UIColor whiteColor]];
    [self creatTableView];
    if (self.vcType == MYPersonalType) {
        self.navStyle = BaseNavWhiteStyle;
    }else{
        self.navStyle = BaseNavBlueStyle;
    }
    //电话号码更改的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneNot:) name:XKChangephoneNumSecViewPhone object:nil];
    [self.viewModel getData];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.vcType == MYPersonalType) {
//        //添加引导视图
//        [XKGuidanceManager configShowGuidanceViewType:XKGuidanceManagerXKCloseFriendPersonalInformationViewController TransparentRectArr:@[[NSValue valueWithCGRect:self.viewModel.currentGuidanceCell.getWindowFrame]]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.infoChangeStatus) {
        EXECUTE_BLOCK(self.infoChange);
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:XKChangephoneNumSecViewPhone object:nil];
}

- (void)creatTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    self.tableView.bounces = NO;
    XKWeakSelf(ws);
    self.viewModel.loadBlock = ^{
        ws.infoChangeStatus = YES;
        ws.allSignature = ws.viewModel.model.signature;
        ws.dateView.CurrentDate = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:ws.viewModel.model.birthday ? : [ws currentDateForString]];
        [ws.tableView reloadData];
    };
    self.viewModel.upSwitchChangeBLock = ^(BOOL isOn){
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if (isOn) {
            parameters[@"outside"] = @(1);
        }else {
            parameters[@"outside"] = @(0);
        }
        [ws updateWithParameters:parameters];
    };
    [self.viewModel registerCellForTableView:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(@(NavigationAndStatue_Height));
    }];
}

- (XKPerfectPersonalViewModel *)viewModel {
    if (!_viewModel) {
        XKWeakSelf(ws);
        _viewModel = [[XKPerfectPersonalViewModel alloc]init];
        _viewModel.secretId = self.secretId;
        _viewModel.vcType = self.vcType;
        _viewModel.selectBlock = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            [ws didselectTableView:tableView indexPath:indexPath];
        };
    }
    return _viewModel;
}

- (XKDatePickerView *)dateView {
    if (!_dateView) {
        _dateView = [[XKDatePickerView alloc] init];
        _dateView.delegate = self;
    }
    return _dateView;
}

/**
 tableView点击方法的回调
 
 @param tableView tableview
 @param indexPath indexPath
 */
- (void)didselectTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString * title = self.viewModel.cellNameArr[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"昵称"]) {
        [self cellForTheName];
    }else if ([title isEqualToString:@"手机号码"]){
        XKChangePhonenumViewController *vc = [[XKChangePhonenumViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([title isEqualToString:@"性别"]){
        [self cellForTheSex];
    }else if ([title isEqualToString:@"生日"]){
        if (self.viewModel.model.birthday) {
            self.dateView.CurrentDate = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:self.viewModel.model.birthday];
        }else {
            self.dateView.CurrentDate = [self currentDateForString];
        }
        [self.dateView show];
    }else if ([title isEqualToString:@"个性签名"]){
        [self cellForTheSignature];
    }else if ([title isEqualToString:@"地址"]){
        
        XKRegionPickerViewController *regionPickerViewController = [XKRegionPickerViewController showRegionPickerViewWithController:self];
        regionPickerViewController.delegate = self;
        
    }else if ([title isEqualToString:@"我的二维码"]){
        XKQRCodeCardController *vc = [[XKQRCodeCardController alloc]init];
        vc.canSave = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"头像"]){
        XKWeakSelf(ws);
        if (self.vcType == personalType) {
            [self.bottomSheetView showView];
        }else if (self.vcType == MYPersonalType) {
            XKShowHeaderViewController *vc = [[XKShowHeaderViewController alloc]init];
            vc.headerUrl = self.viewModel.model.avatar;
            vc.secretId = self.secretId;
            vc.navStyle = BaseNavWhiteStyle;
            vc.type = XKMYHeaderControllerType;
            vc.headerBlock = ^(NSString * _Nonnull imageUrl) {
                ws.viewModel.model.avatar = imageUrl;
                [ws.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.vcType == KYPersonalType){
            XKShowHeaderViewController *vc = [[XKShowHeaderViewController alloc]init];
            vc.navStyle = BaseNavBlueStyle;
            vc.headerBlock = ^(NSString * _Nonnull imageUrl) {
                ws.viewModel.model.avatar = imageUrl;
                [ws.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
        
}
#pragma mark - cell的点击事件

- (NSString *)currentDateForString {
    NSDate *date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

- (void)cellForTheName {
    XKWeakSelf(ws);
    XKChangeNicknameViewController *vc = [[XKChangeNicknameViewController alloc]init];
    vc.nickName = self.viewModel.model.nickname;
    [vc setNicknameBlock:^(NSString *nickName) {
        ws.viewModel.model.nickname = nickName;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"nickname"] = nickName;
        [self updateWithParameters:parameters];
        [ws.tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cellForTheSignature {
    XKWeakSelf(ws);
    XKSignatureViewController *vc = [[XKSignatureViewController alloc]init];
    vc.signatureStr = self.allSignature;
    [vc setBlock:^(NSString *signature) {
        if (signature.length >= 14) {
            NSString * signatureStr = [signature substringWithRange: NSMakeRange(0, 14)];
            ws.viewModel.model.signature = [NSString stringWithFormat:@"%@",signatureStr];
        }else{
            ws.viewModel.model.signature = signature;
        }
        self.allSignature = signature;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"signature"] = signature;
        [ws updateWithParameters:parameters];
        [ws.tableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)cellForTheSex {
    XKWeakSelf(ws);
    XKBottomAlertSheetView *sheet = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"保密",@"男",@"女",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
        NSLog(@"%ld%@", (long)index,choseTitle);
        NSString *str = @"";
        if ([choseTitle isEqualToString:@"男"]) {
            str = @"male";
        }else if (([choseTitle isEqualToString:@"女"])) {
            str = @"female";
        }else {
            str = @"unknown";
        }
        ws.viewModel.model.sex = str;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"sex"] = str;
        [self updateWithParameters:parameters];
        [ws.tableView reloadData];
    }];
    [sheet show];
    
}

/**
 电话号码更改的通知
 
 @param noti 通知
 */
- (void)phoneNot:(NSNotification *)noti {
    self.viewModel.model.phone = noti.userInfo[@"phone"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"] = noti.userInfo[@"phone"];
    [self updateWithParameters:parameters];
    [self.tableView reloadData];
    NSLog(@"%@", noti.userInfo[@"phone"]);
}
#pragma mark - THDatePickerViewDelegate
/**
 保存按钮代理方法
 
 @param time 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)time{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date =[dateFormat dateFromString:time];
    NSString *aStr = [XKTimeSeparateHelper backTimestampSecondStringWithDate:date];
    self.viewModel.model.birthday = aStr;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"birthday"] = aStr;
    [self updateWithParameters:parameters];
    if (self.vcType == MYPersonalType) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:2];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - XKRegionPickerViewControllerDelegate

/** 选择地区回调 */
- (void)regionPickerViewController:(XKRegionPickerViewController *)pickerViewController didSelectedRegion:(XKRegionPickerModel *)model {
    NSString *aStr = [NSString stringWithFormat:@"%@%@%@",model.provinceName,model.cityName,model.districtName];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"provinceCode"] = model.provinceCode;
    parameters[@"cityCode"] = model.cityCode;
    parameters[@"districtCode"] = model.districtCode;
    [self updateWithParameters:parameters];
    self.viewModel.model.address = aStr;
    [self.tableView reloadData];
}

#pragma mark - netWork --
- (void)updateWithParameters:(NSMutableDictionary *)parameters{
    NSString *url;
    if (self.vcType == MYPersonalType) {
        url = @"im/ua/secretCircleDetailUpdate/1.0";
        parameters[@"secretId"] = self.secretId;
    }else{
        url = GetXkUserUpdateUrl;
    }
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:url timeoutInterval:20.0 parameters:[parameters copy] success:^(id responseObject) {
        if (self.vcType == MYPersonalType) {
        }else{
            if (parameters[@"nickname"]) {
                [XKUserInfo currentUser].nickname = parameters[@"nickname"];
                XKUserSynchronize;
            }
            if (parameters[@"sex"]) {
                [XKUserInfo currentUser].sex = parameters[@"sex"];
                XKUserSynchronize;
            }
            if (parameters[@"signature"]) {
                [XKUserInfo currentUser].signature =  parameters[@"signature"] ;
                XKUserSynchronize;
            }
            if (parameters[@"signature"]) {
                [XKUserInfo currentUser].birthday = parameters[@"birthday"];
                XKUserSynchronize;
            }
            if (parameters[@"signature"]) {
                [XKUserInfo currentUser].avatar = parameters[@"avatar"];
                XKUserSynchronize;
            }
        }
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [XKHudView showSuccessMessage:@"更新成功"];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
    }];
}

- (XKPhotoPickHelper *)bottomSheetView {
    if(!_bottomSheetView) {
        XKWeakSelf(ws);
        _bottomSheetView = [[XKPhotoPickHelper alloc] init];
        _bottomSheetView.allowCrop = YES;
        _bottomSheetView.maxCount = 1;
        [_bottomSheetView handleVideoChoseWithNeeded:NO];
        _bottomSheetView.choseImageBlcok = ^(NSArray<UIImage *> * _Nullable images) {
            for (UIImage *image in images) {
                [[XKUploadManager shareManager]uploadImage:image withKey:@"headerImage" progress:^(CGFloat progress) {
                } success:^(NSString *url) {
                    NSString *imageUrl = kQNPrefix(url);
                    ws.viewModel.model.avatar = imageUrl;
                    [ws.tableView reloadData];
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                    parameters[@"avatar"] = imageUrl;
                    [ws updateWithParameters:parameters];
                } failure:^(id data) {
                }];
            }
        };
        
    }
    return _bottomSheetView;
}
@end

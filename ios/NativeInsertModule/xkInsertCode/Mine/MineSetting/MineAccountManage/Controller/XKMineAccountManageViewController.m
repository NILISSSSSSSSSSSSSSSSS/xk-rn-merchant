//
//  XKMineAccountManageViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineAccountManageViewController.h"
#import "XKMineAccountManageTableViewCell.h"
#import "XKMineAccountManageModel.h"
#import "XKMineChangeLoginPasswordViewController.h"
#import "XKMineEditPayPasswordViewController.h"
#import "XKMineFingerprintPaymentViewController.h"
#import "XKVerifyPhoneNumberViewController.h"
#import "XKAlertUtil.h"
#import "XKResetLoginPasswordViewController.h"
#import "XKChangePhonenumViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

static const CGFloat kAccountManageTableViewEdge = 10.0;
static const CGFloat kAccountManageTableViewCellHight = 44.0;
static const CGFloat kAccountManageTableViewHeaderHight = 5.0;
static const CGFloat kAccountManageTableViewFooterHight = 10.0;
NSString *const kAccountManageTableViewCellIdentifier = @"XKMineAccountManageTableViewCell";

@interface XKMineAccountManageViewController () <UITableViewDataSource, UITableViewDelegate, XKAccountManageTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) BOOL hasGetPasswordStatus;
@property (nonatomic, assign) BOOL isSupportFaceId;
@property (nonatomic, assign) BOOL hasSetLoginPassword;
@property (nonatomic, assign) BOOL hasSetPayPassword;
@property (nonatomic, assign) BOOL hasSetTouchId;
@property (nonatomic, assign) BOOL hasSetFaceId;

@end

@implementation XKMineAccountManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeViews];
    self.hasGetPasswordStatus = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 获取密码开通状态
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetPaySecurityStatusUrl timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {

        [XKHudView hideHUDForView:self.tableView animated:YES];
        self.hasGetPasswordStatus = YES;
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        // 判断FaceID / TouchID
        self.isSupportFaceId = NO;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            
            LAContext *context = [[LAContext alloc] init];
            if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil] ||
                [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:nil]) {
                
                if (@available(iOS 11.0, *)) {
                    if (context.biometryType == LABiometryTypeFaceID) {
                        self.isSupportFaceId = YES;
                    }
                }
            }
        }
        
        self.hasSetLoginPassword = [dict[@"loginPwdIsSet"] boolValue];
        self.hasSetPayPassword = [dict[@"textPwdIsSet"] boolValue];
//        self.hasSetTouchId = [dict[@"fingerPwdIsSet"] boolValue];
//        self.hasSetFaceId = [dict[@"faceRecognitionIsSet"] boolValue];
        
        // 根据本地serverCheckKey判断 FaceID/TouchID 开通状态
        NSString *serverCheckCode = @"";
        NSString *userId = [XKUserInfo getCurrentUserId];
        if ([[XKDataBase instance] existsTable:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable]) {
            if ([[XKDataBase instance] exists:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable key:userId]) {
                serverCheckCode = [[XKDataBase instance] select:XKTouchIdOrFaceIdServerCheckCodeDataBaseTable key:userId];
            }
        }
        if (serverCheckCode && serverCheckCode.length > 0) {
            self.hasSetFaceId = YES;
            self.hasSetTouchId = YES;
        }
        
        [self.dataArr removeAllObjects];
        XKMineAccountManageModel *loginPasswordModel = [XKMineAccountManageModel new];
        XKMineAccountManageModel *payPasswordModel = [XKMineAccountManageModel new];
        XKMineAccountManageModel *biologicalRecognitionModel = [XKMineAccountManageModel new];
        
        if (self.hasSetLoginPassword == YES) {
            loginPasswordModel.describeString = @"修改密码";
        } else {
            loginPasswordModel.describeString = @"未设置";
        }
        loginPasswordModel.titleString = @"登录密码";
        [self.dataArr addObject:loginPasswordModel];
        
        if (self.hasSetPayPassword == YES) {
            payPasswordModel.describeString = @"修改密码";
        } else {
            payPasswordModel.describeString = @"未设置";
        }
        payPasswordModel.titleString = @"支付密码";
        [self.dataArr addObject:payPasswordModel];
        
        // Face ID
        if (self.isSupportFaceId) {
            if (self.hasSetFaceId == YES) {
                biologicalRecognitionModel.describeString = @"已开通";
            } else {
                biologicalRecognitionModel.describeString = @"未设置";
            }
            biologicalRecognitionModel.titleString = @"Face ID支付";
            
        // Touch ID
        } else {
            if (self.hasSetTouchId == YES) {
                biologicalRecognitionModel.describeString = @"已开通";
            } else {
                biologicalRecognitionModel.describeString = @"未设置";
            }
            biologicalRecognitionModel.titleString = @"指纹支付";
        }
        [self.dataArr addObject:biologicalRecognitionModel];
        
        [self.tableView reloadData];
        
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 5)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    [tableHeaderView cutCornerWithRoundedRect:tableHeaderView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    return tableHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 5)];
    tableFooterView.backgroundColor = [UIColor whiteColor];
    [tableFooterView cutCornerWithRoundedRect:tableFooterView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    return tableFooterView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKMineAccountManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAccountManageTableViewCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell configAccountManageTableViewCellWithModel:self.dataArr[indexPath.row]];
    if (indexPath.row == 2) {
        [cell hiddenCellSeparator];
    } else {
        [cell showCellSeparator];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kAccountManageTableViewHeaderHight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kAccountManageTableViewFooterHight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kAccountManageTableViewCellHight;
}

#pragma mark - XKAccountManageTableViewCellDelegate

- (void)accountManageCellDidSelected:(XKMineAccountManageTableViewCell *)cell {
    
    if (!self.hasGetPasswordStatus) {
        return;
    }
    
    if (cell.indexPath.row == 0) {
        
        // 已设置登录密码
        if (self.hasSetLoginPassword) {
            XKMineChangeLoginPasswordViewController *changeLoginPasswordViewController = [XKMineChangeLoginPasswordViewController new];
            [self.navigationController pushViewController:changeLoginPasswordViewController animated:YES];
            
        // 未设置登录密码
        } else {
            
            // 验证是否绑定手机号
            NSString *phoneNum = [XKUserInfo currentUser].realPhone;
            if (!phoneNum || phoneNum.length == 0) {
                [XKAlertUtil presentAlertViewWithTitle:nil message:@"您还未绑定手机号，是否立即绑定" cancelTitle:@"取消" defaultTitle:@"去绑定" distinct:NO cancel:^{
                    return;
                } confirm:^{
                    XKChangePhonenumViewController *changePhoncenumViewController = [XKChangePhonenumViewController new];
                    changePhoncenumViewController.type = XKChangePhonenumViewControllerTypeSetPhoneNum;
                    [self.navigationController pushViewController:changePhoncenumViewController animated:YES];
                }];
            } else {
                XKResetLoginPasswordViewController *resetLoginPasswordViewController = [XKResetLoginPasswordViewController new];
                resetLoginPasswordViewController.phoneNum = phoneNum;
                [self.navigationController pushViewController:resetLoginPasswordViewController animated:YES];
            }
        }
    }
    else if (cell.indexPath.row == 1) {
        
        if (self.hasSetPayPassword) {
            // 已设置支付密码
            XKMineEditPayPasswordViewController *editPayPasswordViewController = [XKMineEditPayPasswordViewController new];
            editPayPasswordViewController.state = XKMineEditPayPasswordViewControllerStateVerifyPayPassword;
            [self.navigationController pushViewController:editPayPasswordViewController animated:YES];
        } else {
            // 未设置支付密码，验证手机号
            NSString *phoneNum = [XKUserInfo currentUser].phone;
            if (!phoneNum || phoneNum.length == 0) {
                // 未绑定手机号
                [XKAlertUtil presentAlertViewWithTitle:nil message:@"您还未绑定手机号，是否立即绑定" cancelTitle:@"取消" defaultTitle:@"去绑定" distinct:NO cancel:^{
                    return;
                } confirm:^{
                    XKChangePhonenumViewController *changePhoncenumViewController = [XKChangePhonenumViewController new];
                    changePhoncenumViewController.type = XKChangePhonenumViewControllerTypeSetPhoneNum;
                    [self.navigationController pushViewController:changePhoncenumViewController animated:YES];
                }];
            } else {
                // 已绑定手机号
                XKVerifyPhoneNumberViewController *verifyPhoneNumberViewController = [XKVerifyPhoneNumberViewController new];
                verifyPhoneNumberViewController.state = XKVerifyPhoneNumberViewControllerStateSetPayPassword;
                verifyPhoneNumberViewController.phoneNum = phoneNum;
                [self.navigationController pushViewController:verifyPhoneNumberViewController animated:YES];
            }
        }
    }
    else {
        // 已设置支付密码
        if (self.hasSetPayPassword) {
            XKMineFingerprintPaymentViewController *fingerprintPaymentViewController = [XKMineFingerprintPaymentViewController new];
            
            BOOL hasSetBiologicalRecognition = self.isSupportFaceId ? self.hasSetFaceId : self.hasSetTouchId;
            if (hasSetBiologicalRecognition) {
                // 已设置生物识别
                fingerprintPaymentViewController.state = XKMineFingerprintPaymentViewControllerStateOpened;
            } else {
                // 未设置生物识别
                fingerprintPaymentViewController.state = XKMineFingerprintPaymentViewControllerStateNotAvailable;
            }
            if (self.isSupportFaceId) {
                // FaceID
                fingerprintPaymentViewController.type = XKMineFingerprintPaymentViewControllerTypeFaceId;
            } else {
                // TouchID
                fingerprintPaymentViewController.type = XKMineFingerprintPaymentViewControllerTypeTouchId;
            }
            [self.navigationController pushViewController:fingerprintPaymentViewController animated:YES];
        } else {
            
            // 未设置支付密码
            [XKHudView showErrorMessage:@"请先设置支付密码" to:self.view animated:YES];
            return;
        }
    }
}

#pragma mark - private methods

- (void)initializeViews {
    
    [self setNavTitle:@"账号安全" WithColor:[UIColor whiteColor]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height + kAccountManageTableViewEdge, kAccountManageTableViewEdge, 0, kAccountManageTableViewEdge));
    }];
    [self.tableView registerClass:[XKMineAccountManageTableViewCell class] forCellReuseIdentifier:kAccountManageTableViewCellIdentifier];
}

#pragma mark - setter and getter

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        _dataArr = @[].mutableCopy;
    }
    return _dataArr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

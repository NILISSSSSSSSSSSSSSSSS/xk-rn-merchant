//
//  XKPersonalInformationViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/9.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPersonalInformationViewController.h"
#import "XKPersonalInformationViewModel.h"
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

@interface XKPersonalInformationViewController ()
<XKDatePickerViewDelegate,
XKRegionPickerViewControllerDelegate>

@property (nonatomic, strong) UITableView                    *tableView;
/**viewModel*/
@property (nonatomic, strong) XKPersonalInformationViewModel *viewModel;
@property (nonatomic, strong) XKDatePickerView               *dateView;
@property (nonatomic, strong) XKRegionPickerViewController   *regionPickerViewController;
/**<##>*/
@property(nonatomic, assign) BOOL infoChangeStatus;
/**签名，完整*/
@property(nonatomic, copy) NSString *allSignature;
@end

@implementation XKPersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"个人资料" WithColor:[UIColor whiteColor]];
    [self creatTableView];
    //电话号码更改的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneNot:) name:XKChangephoneNumSecViewPhone object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:XKChangephoneNumSecViewPhone object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.infoChangeStatus) {
        EXECUTE_BLOCK(self.infoChange);
    }
}

- (void)creatTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xf0f0f0);
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self.viewModel;
    self.tableView.dataSource = self.viewModel;
    self.tableView.bounces = NO;
    [self.viewModel registerCellForTableView:self.tableView];
    [self.viewModel loadData];
    
    XKWeakSelf(ws);
    self.viewModel.loadBlock = ^{
        ws.infoChangeStatus = YES;
        [ws.tableView reloadData];
        ws.dateView.CurrentDate = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:ws.viewModel.model.birthday ? : [ws currentDateForString]];
         ws.allSignature = ws.viewModel.model.signature;
    };
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(@(NavigationAndStatue_Height));
    }];
}

- (XKPersonalInformationViewModel *)viewModel {
    if (!_viewModel) {
        XKWeakSelf(ws);
        _viewModel = [[XKPersonalInformationViewModel alloc]init];
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

- (NSString *)currentDateForString {
    NSDate *date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

- (void)updateWithNickname:(NSString *)nickname Avatar:(NSString *)avatar Sex:(NSString *)sex Birthday:(NSNumber *)birthday Signature:(NSString *)signature provinceCode:(NSString *)provinceCode cityCode:(NSString *)cityCode districtCode:(NSString *)districtCode{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"nickname"] = nickname;
    parameters[@"avatar"] = avatar;
    parameters[@"sex"] = sex;
    parameters[@"birthday"] = birthday;
    parameters[@"signature"] = signature;
    parameters[@"provinceCode"] = provinceCode;
    parameters[@"cityCode"] = cityCode;
    parameters[@"districtCode"] = districtCode;
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetXkUserUpdateUrl timeoutInterval:20.0 parameters:[parameters copy] success:^(id responseObject) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        if (nickname) {
            [XKUserInfo currentUser].nickname = nickname;
            XKUserSynchronize;
        }
        if (sex) {
            [XKUserInfo currentUser].sex = sex;
            XKUserSynchronize;
        }
        if (signature) {
            [XKUserInfo currentUser].signature = signature;
            XKUserSynchronize;
        }
        [XKHudView showSuccessMessage:@"更新成功"];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.tableView animated:YES];
    }];
}

/**
 tableView点击方法的回调

 @param tableView tableview
 @param indexPath indexPath
 */
- (void)didselectTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    if (indexPath.section == 0) {
        XKShowHeaderViewController *vc = [[XKShowHeaderViewController alloc]init];
        vc.headerBlock = ^(NSString * _Nonnull imageUrl) {
            ws.viewModel.model.avatar = imageUrl;
            [ws.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        XKPersonalDataTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.titleLabel.text isEqualToString:@"昵称"]) {
            XKChangeNicknameViewController *vc = [[XKChangeNicknameViewController alloc]init];
            vc.nickName = self.viewModel.model.nickname;
            [vc setNicknameBlock:^(NSString *nickName) {
                ws.viewModel.model.nickname = nickName;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                [ws updateWithNickname:nickName Avatar:nil Sex:nil Birthday:nil Signature:nil provinceCode:nil cityCode:nil districtCode:nil];
                [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([cell.titleLabel.text isEqualToString:@"手机号码"]){
            XKChangePhonenumViewController *vc = [[XKChangePhonenumViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([cell.titleLabel.text isEqualToString:@"性别"]){
            XKBottomAlertSheetView *sheet = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"保密",@"男",@"女",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
                NSLog(@"%ld%@", (long)index,choseTitle);
                NSString *str = @"";
                if ([choseTitle isEqualToString:@"男"]) {
                    str = XKSexMale;
                }else if (([choseTitle isEqualToString:@"女"])) {
                    str = XKSexFemale;
                }else {
                    str = XKSexUnknow;
                }
                ws.viewModel.model.sex = str;
                [self updateWithNickname:nil Avatar:nil Sex:str Birthday:nil Signature:nil provinceCode:nil cityCode:nil districtCode:nil];

                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
                [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [sheet show];
            
        }else if ([cell.titleLabel.text isEqualToString:@"生日"]){
            if (self.viewModel.model.birthday) {
                self.dateView.CurrentDate = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:self.viewModel.model.birthday];
            }else {
                self.dateView.CurrentDate = [self currentDateForString];
            }
            [self.dateView show];
        }else if ([cell.titleLabel.text isEqualToString:@"个性签名"]){
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
                [ws updateWithNickname:nil Avatar:nil Sex:nil Birthday:nil Signature:signature provinceCode:nil cityCode:nil districtCode:nil];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:1];
                [ws.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.titleLabel.text isEqualToString:@"地址"]){
            
            self.regionPickerViewController = [XKRegionPickerViewController showRegionPickerViewWithController:self];
            self.regionPickerViewController.delegate = self;
            
        }else if ([cell.titleLabel.text isEqualToString:@"我的二维码"]){
            XKQRCodeCardController *vc = [[XKQRCodeCardController alloc]init];
            vc.canSave = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


/**
 电话号码更改的通知

 @param noti 通知
 */
- (void)phoneNot:(NSNotification *)noti {
    self.viewModel.model.phone = noti.userInfo[@"phone"];
    [XKUserInfo currentUser].phone = noti.userInfo[@"phone"];
    XKUserSynchronize;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    [XKUserInfo currentUser].birthday = aStr;
    XKUserSynchronize;
    [self updateWithNickname:nil Avatar:nil Sex:nil Birthday:@(aStr.longLongValue) Signature:nil provinceCode:nil cityCode:nil districtCode:nil];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - XKRegionPickerViewControllerDelegate

/** 选择地区回调 */
- (void)regionPickerViewController:(XKRegionPickerViewController *)pickerViewController didSelectedRegion:(XKRegionPickerModel *)model {
    NSString *aStr = [NSString stringWithFormat:@"%@%@%@",model.provinceName,model.cityName,model.districtName];
    self.viewModel.model.address = aStr;
    [XKUserInfo currentUser].address = aStr;
    XKUserSynchronize;
    [self updateWithNickname:nil Avatar:nil Sex:nil Birthday:nil Signature:nil provinceCode:model.provinceCode cityCode:model.cityCode districtCode:model.districtCode];
    [self.tableView reloadData];
}
@end

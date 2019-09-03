////
////  XKMineChangeLoginPasswordViewController.m
////  XKSquare
////
////  Created by RyanYuan on 2018/9/4.
////  Copyright © 2018年 xk. All rights reserved.
////
//
#import "XKMineChangeLoginPasswordViewController.h"
//#import "XKMineChangeLoginPasswordTableViewCell.h"
//#import "XKLoginNetworkMethod.h"
//#import "XKAlertUtil.h"
//#import "XKResetLoginPasswordViewController.h"
//#import "XKChangePhonenumViewController.h"
//
//static const CGFloat kChangeLoginPasswordTableViewEdge = 10.0;
//static const CGFloat kChangeLoginPasswordTableViewCellHight = 44.0;
//static const CGFloat kChangeLoginPasswordTableViewHeaderHight = 5.0;
//static const CGFloat kChangeLoginPasswordTableViewFooterHight = 20.0;
//NSString *const kChangeLoginPasswordTableViewCellIdentifier = @"XKMineChangeLoginPasswordTableViewCell";
//
@interface XKMineChangeLoginPasswordViewController () //<UITableViewDataSource, UITableViewDelegate, XKMineChangeLoginPasswordTableViewCellDelegate, XKMineChangeLoginPasswordTableViewCellDelegate>
//
//@property (nonatomic, strong) UITableView *tableView;
//
//@property (nonatomic, copy) NSString *inputOldPassword;
//@property (nonatomic, copy) NSString *inputNewPassword;
//@property (nonatomic, copy) NSString *confirmNewPassword;
//
@end
//
@implementation XKMineChangeLoginPasswordViewController
@end
//
//- (void)viewDidLoad {
//    
//    [super viewDidLoad];
//    [self initializeViews];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 5)];
//    tableHeaderView.backgroundColor = [UIColor whiteColor];
//    [tableHeaderView cutCornerWithRoundedRect:tableHeaderView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
//    return tableHeaderView;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    
//    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 5)];
//    tableFooterView.backgroundColor = [UIColor whiteColor];
//    [tableFooterView cutCornerWithRoundedRect:tableFooterView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
//    return tableFooterView;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    XKMineChangeLoginPasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChangeLoginPasswordTableViewCellIdentifier forIndexPath:indexPath];
//    cell.delegate = self;
//    if (indexPath.row == 0) {
//        cell.type = XKMineChangeLoginPasswordTableViewCellTypeOldPassword;
//        [cell configChangeLoginPasswordTableViewCell:self.inputOldPassword];
//    } else if (indexPath.row == 1) {
//        cell.type = XKMineChangeLoginPasswordTableViewCellTypeNewPassword;
//        [cell configChangeLoginPasswordTableViewCell:self.inputNewPassword];
//    } else {
//        cell.type = XKMineChangeLoginPasswordTableViewCellTypeEnsurePassword;
//        [cell configChangeLoginPasswordTableViewCell:self.confirmNewPassword];
//        [cell hiddenCellSeparator];
//    }
//    return cell;
//}
//
//#pragma mark - XKMineChangeLoginPasswordTableViewCellDelegate
//
//- (void)cell:(XKMineChangeLoginPasswordTableViewCell *)cell changePasswordWithString:(NSString *)password {
//    
//    switch (cell.type) {
//        case XKMineChangeLoginPasswordTableViewCellTypeOldPassword:{
//            self.inputOldPassword = password;
//            break;
//        }
//        case XKMineChangeLoginPasswordTableViewCellTypeNewPassword:{
//            self.inputNewPassword = password;
//            break;
//        }
//        case XKMineChangeLoginPasswordTableViewCellTypeEnsurePassword:{
//            self.confirmNewPassword = password;
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//#pragma mark - event
//
//// 点击忘记密码
//- (void)clickForgotButton:(UIButton *)sender {
//    
//    // 验证是否绑定手机号
//    NSString *phoneNum = [XKUserInfo currentUser].userPhoneNumber;
//    if (!phoneNum || phoneNum.length == 0) {
//        [XKAlertUtil presentAlertViewWithTitle:nil message:@"您还未绑定手机号，是否立即绑定" cancelTitle:@"取消" defaultTitle:@"去绑定" distinct:NO cancel:^{
//            return;
//        } confirm:^{
//            XKChangePhonenumViewController *changePhoncenumViewController = [XKChangePhonenumViewController new];
//            changePhoncenumViewController.type = XKChangePhonenumViewControllerTypeSetPhoneNum;
//            [self.navigationController pushViewController:changePhoncenumViewController animated:YES];
//        }];
//    } else {
//        XKResetLoginPasswordViewController *resetLoginPasswordViewController = [XKResetLoginPasswordViewController new];
//        resetLoginPasswordViewController.phoneNum = phoneNum;
//        [self.navigationController pushViewController:resetLoginPasswordViewController animated:YES];
//    }
//}
//
//// 点击确定
//- (void)clickConfirmButton:(UIButton *)sender {
//
//    [self.tableView endEditing:YES];
//    
//    if (self.inputOldPassword == nil || [self.inputOldPassword isEqualToString:@""]) {
//        [XKHudView showErrorMessage:@"请输入旧密码" to:self.view animated:YES];
//        return;
//    }
//    if (![self checkPassword:self.inputOldPassword]) {
//        [XKHudView showErrorMessage:@"旧密码输入格式错误" to:self.view animated:YES];
//        return;
//    }
//    if (self.inputNewPassword == nil || [self.inputNewPassword isEqualToString:@""]) {
//        [XKHudView showErrorMessage:@"请输入新密码" to:self.view animated:YES];
//        return;
//    }
//    if (![self checkPassword:self.inputNewPassword]) {
//        [XKHudView showErrorMessage:@"新密码输入格式错误" to:self.view animated:YES];
//        return;
//    }
//    if (![self.inputNewPassword isEqualToString:self.confirmNewPassword]) {
//        [XKHudView showErrorMessage:@"请与新设置密码保持一致" to:self.view animated:YES];
//        return;
//    }
//    
//    NSDictionary *paramsDict = @{@"oldPassword": self.inputOldPassword,
//                                 @"newPassword": self.inputNewPassword,
//                                  @"rePassword": self.confirmNewPassword};
//    [XKLoginNetworkMethod updatePasswordWithParameters:paramsDict Block:^(id responseObject, BOOL isSuccess) {
//        if (isSuccess) {
//            [XKHudView showSuccessMessage:@"修改成功"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }else{
//            [XKHudView showErrorMessage:responseObject to:self.view animated:YES];
//            XKMineChangeLoginPasswordTableViewCell *oldPasswordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            [oldPasswordCell clearInputTextField];
//        }
//    }];
//}
//
//#pragma mark - UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return kChangeLoginPasswordTableViewHeaderHight;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return kChangeLoginPasswordTableViewFooterHight;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return kChangeLoginPasswordTableViewCellHight;
//}
//
//#pragma mark - private methods
//
//- (void)initializeViews {
//    
//    [self setNavTitle:@"修改登录密码" WithColor:[UIColor whiteColor]];
//    
//    // 密码输入列表
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height + kChangeLoginPasswordTableViewEdge, kChangeLoginPasswordTableViewEdge, 0, kChangeLoginPasswordTableViewEdge));
//    }];
//    [self.tableView registerClass:[XKMineChangeLoginPasswordTableViewCell class] forCellReuseIdentifier:kChangeLoginPasswordTableViewCellIdentifier];
//    
//    // 描述
//    UILabel *describeLabel = [UILabel new];
//    describeLabel.numberOfLines = 1;
//    describeLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
//    describeLabel.numberOfLines = 0;
//    describeLabel.textColor = [UIColor lightGrayColor];
//    describeLabel.text = @"密码可由6-20位大小写英文字母、数字、除空格外的特殊符号组成";
//    [self.view addSubview:describeLabel];
//    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.tableView.mas_top).offset(152);
//        make.left.equalTo(self.tableView.mas_left);
//        make.right.equalTo(self.tableView.mas_right);
//    }];
//    
//    // 确定按钮
//    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [confirmButton setTitle:@"保存新密码" forState:UIControlStateNormal];
//    confirmButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:15];
//    confirmButton.layer.cornerRadius = 5;
//    confirmButton.layer.masksToBounds = YES;
//    confirmButton.backgroundColor = XKMainTypeColor;
//    [confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:confirmButton];
//    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(describeLabel.mas_bottom).offset(10);
//        make.left.equalTo(self.tableView.mas_left);
//        make.right.equalTo(self.tableView.mas_right);
//        make.height.mas_equalTo(45);
//    }];
//    
//    // 忘记密码按钮
//    UIButton *forgotButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [forgotButton setTitle:@"忘记密码" forState:UIControlStateNormal];
//    [forgotButton setTitleColor:XKMainTypeColor forState:UIControlStateNormal];
//    forgotButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:14.0];
//    [forgotButton addTarget:self action:@selector(clickForgotButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:forgotButton];
//    [forgotButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(confirmButton.mas_bottom).offset(5);
//        make.right.equalTo(confirmButton.mas_right);
//    }];
//}
//
//#pragma mark - setter and getter
//
//- (UITableView *)tableView {
//    
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundColor = self.view.backgroundColor;
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.showsHorizontalScrollIndicator = NO;
//        _tableView.scrollEnabled = NO;
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}
//
//@end

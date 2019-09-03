////
////  XKMineSettingRootViewController.m
////  XKSquare
////
////  Created by william on 2018/8/15.
////  Copyright © 2018年 xk. All rights reserved.
////
//
#import "XKMineSettingRootViewController.h"
//#import "XKMineSettingRootHeaderView.h"
//#import "XKPersonalDataViewController.h"
//#import "XKComplaintsViewController.h"
//#import "XKPersonalDataTableViewCell.h"
//#import "UIView+XKCornerRadius.h"
//#import "XKSysSettingsViewController.h"
//#import "XKMineConfigureRecipientListViewController.h"
//#import "XKMineAccountManageViewController.h"
//#import "XKRealNameAuthController.h"
//#import "XKQRCodeCardController.h"
//#import "XKPrivacySettingViewController.h"
//#import "XKBankCardListViewController.h"
//#import "XKReceiptManageListController.h"
//#import "XKLoginConfig.h"
//#import "XKLoginViewController.h"
//#import "XKRealNameInfoModel.h"
@interface XKMineSettingRootViewController ()<UITableViewDelegate,UITableViewDataSource>
//
//@property(nonatomic, strong) UITableView *mainBackTableView;
//@property(nonatomic, strong) NSArray     *cellNameArr;
//@property(nonatomic, strong) XKRealNameInfoModel *model;
//@property(nonatomic, strong) XKMineSettingRootHeaderView *headerView;
@end
//
@implementation XKMineSettingRootViewController
//
//#pragma mark – Life Cycle
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self initViews];
//}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self loadData];
//    [self.headerView loadUI];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//#pragma mark – Private Methods
//-(void)initViews{
//    self.navigationView.hidden = YES;
//    [self.view addSubview:self.mainBackTableView];
//}
//
//- (void)loadData {
//    [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserAuthDetailBefore/1.0" timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
//        self.model = [XKRealNameInfoModel yy_modelWithJSON:responseObject];
//        [self.mainBackTableView reloadData];
//    } failure:^(XKHttpErrror *error) {
//    }];
//}
//
////设置cell名称和图标
//-(void)setView:(UIView *)view Title:(NSString *)title hasAccessButton:(BOOL)isHas{
//    if (isHas) {
//        UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:title font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:16] textColor:UIColorFromRGB(0x222222) backgroundColor:[UIColor whiteColor]];
//        label.adjustsFontSizeToFitWidth = YES;
//        [view addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.and.bottom.mas_equalTo(view);
//            make.left.mas_equalTo(view.mas_left).offset(7 * ScreenScale);;
//        }];
//
//        UIImageView *nextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xk_btn_Mine_Setting_nextBlack"]];
//        [view addSubview:nextImage];
//        [nextImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(view.mas_centerY);
//            make.right.mas_equalTo(view.mas_right).offset(-16 * ScreenScale);
//            make.size.mas_equalTo(CGSizeMake(9.8 * ScreenScale, 20 * ScreenScale));
//        }];
//    }
//    else{
//        UILabel *label = [BaseViewFactory labelWithFram:CGRectMake(0, 0, 0, 0) text:title font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:16] textColor:UIColorFromRGB(0x000000) backgroundColor:[UIColor whiteColor]];
//        label.adjustsFontSizeToFitWidth = YES;
//        label.textAlignment = NSTextAlignmentCenter;
//        [view addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.and.bottom.and.right.and.left.mas_equalTo(view);
//        }];
//    }
//}
//
//#pragma mark - Events
//
//#pragma mark - Custom Delegates
//
//#pragma mark – Getters and Setters
//-(UITableView *)mainBackTableView{
//    if (!_mainBackTableView) {
//        _mainBackTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
//        _mainBackTableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomSafeHeight, 0);
//        _mainBackTableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
//        _mainBackTableView.delegate = self;
//        _mainBackTableView.dataSource = self;
//        _mainBackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_mainBackTableView registerClass:[XKPersonalDataTableViewCell class] forCellReuseIdentifier:@"cell"];
//        if (@available(iOS 11.0, *)) {
//            _mainBackTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//        }
//    }
//    return _mainBackTableView;
//}
//
//-(NSArray *)cellNameArr{
//    if (!_cellNameArr) {
//        _cellNameArr = @[@[@"收货地址管理",@"发票信息",@"我的二维码"],@[@"实名认证",@"账号安全",@"系统设置",@"我要投诉"],@[@"退出登录"]];
//    }
//    return _cellNameArr;
//}
//
//#pragma mark - UITableViewDataSource
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//       UITableViewCell *cell;
//   if (indexPath.section == 0){
//        XKPersonalDataTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        myCell.titleLabel.text = self.cellNameArr[indexPath.section][indexPath.row];
//        myCell.xk_openClip = YES;
//        myCell.xk_radius = 8;
//        if (indexPath.row == 0) {
//            myCell.xk_clipType = XKCornerClipTypeTopBoth;
//        }else if (indexPath.row == [self.cellNameArr[indexPath.section] count] - 1){
//            myCell.xk_clipType = XKCornerClipTypeBottomBoth;
//        }else {
//            myCell.xk_clipType = XKCornerClipTypeNone;
//        }
//        return myCell;
//    }
//    else if (indexPath.section == 1){
//        XKPersonalDataTableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        myCell.titleLabel.text = self.cellNameArr[indexPath.section][indexPath.row];
//        myCell.xk_openClip = YES;
//        myCell.xk_radius = 8;
//        if ([myCell.titleLabel.text isEqualToString:@"实名认证"]) {
//            if ([self.model.authStatus isEqualToString:@"SUBMIT"]) {
//                myCell.rightTitlelabel.text = [NSString stringWithFormat:@"认证中"];
//
//            }else if ([self.model.authStatus isEqualToString:@"SUCCESS"]){
//                myCell.rightTitlelabel.text = [NSString stringWithFormat:@"%@%@",self.model.realName,self.model.idCardNum];
//
//            }else{
//                myCell.rightTitlelabel.text = @"请尽快实名认证";
//            }
//        }
//        if (indexPath.row == 0) {
//            myCell.xk_clipType = XKCornerClipTypeTopBoth;
//        }else if (indexPath.row == [self.cellNameArr[indexPath.section] count] - 1){
//            myCell.xk_clipType = XKCornerClipTypeBottomBoth;
//        }else {
//            myCell.xk_clipType = XKCornerClipTypeNone;
//        }
//        return myCell;
//    }
//    else if(indexPath.section == 2){
//        cell = [[UITableViewCell alloc]init];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self setView:cell Title:[self.cellNameArr[indexPath.section] firstObject] hasAccessButton:NO];
//        return cell;
//    }else {
//        return nil;
//    }
//}
//#pragma mark - UITableViewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.cellNameArr.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.cellNameArr[section] count];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//   return 50 * ScreenScale;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 210 * ScreenScale;
//    }else {
//        return 0.00000001f;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        return 10 * ScreenScale;
//    }
//    else if (section == 1){
//        return 10 * ScreenScale;
//    }
//    else if (section == 2){
//        return 10 * ScreenScale;
//    }
//    else{
//        return 0.00000001f;
//    }
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        XKWeakSelf(ws);
//        if (!self.headerView) {
//            self.headerView = [[XKMineSettingRootHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210 * ScreenScale)];
//            [self.headerView setEditPersonheaderBlock:^{
//                XKPersonalDataViewController *vc = [[XKPersonalDataViewController alloc]init];
//                [ws.navigationController pushViewController:vc animated:YES];
//            }];
//            [self.headerView setbottomCellViewBlock:^{
//                XKPrivacySettingViewController *vc = [[XKPrivacySettingViewController alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
//            }];
//            self.headerView.cellName = @"隐私设置";
//            [self.headerView loadUI];
//        }
//        return self.headerView;
//    }else{
//        return [[UIView alloc]init];
//    }
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [[UIView alloc]init];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//   if (indexPath.section == 0){
//        XKPersonalDataTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if ([cell.titleLabel.text isEqualToString:@"收货地址管理"]) {
//            XKMineConfigureRecipientListViewController *vc = [XKMineConfigureRecipientListViewController new];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if ([cell.titleLabel.text isEqualToString:@"发票信息"]){
//            XKReceiptManageListController *vc = [[XKReceiptManageListController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else if ([cell.titleLabel.text isEqualToString:@"我的二维码"]){
//            XKQRCodeCardController *vc = [[XKQRCodeCardController alloc]init];
//            vc.canSave = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else if ([cell.titleLabel.text isEqualToString:@"银行卡管理"]){
//            XKBankCardListViewController *vc = [[XKBankCardListViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }else if (indexPath.section == 1){
//        XKPersonalDataTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if ([cell.titleLabel.text isEqualToString:@"实名认证"]){
//            if (self.model.idCardNum) {
//                if ([self.model.authStatus isEqualToString:@"SUBMIT"]) {
//                    cell.rightTitlelabel.text = [NSString stringWithFormat:@"认证中"];
//
//                }else if ([self.model.authStatus isEqualToString:@"SUCCESS"]){
//                    cell.rightTitlelabel.text = [NSString stringWithFormat:@"%@%@",self.model.realName,self.model.idCardNum];
//
//                }
//                else if ([self.model.authStatus isEqualToString:@"FAILED"]){
//                    XKRealNameAuthController *vc = [[XKRealNameAuthController alloc]init];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }
//            }else{
//                XKRealNameAuthController *vc = [[XKRealNameAuthController alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//
//        }else if ([cell.titleLabel.text isEqualToString:@"账号安全"]){
//            XKMineAccountManageViewController *vc = [XKMineAccountManageViewController new];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if ([cell.titleLabel.text isEqualToString:@"系统设置"]){
//            XKSysSettingsViewController *vc = [XKSysSettingsViewController new];
//            vc.hidesBottomBarWhenPushed = YES;
//            [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
//        }else if ([cell.titleLabel.text isEqualToString:@"我要投诉"]){
//            XKComplaintsViewController *vc = [[XKComplaintsViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }else if (indexPath.section == 2){
//        [XKAlertView showCommonAlertViewWithTitle:@"确定退出登录？" rightText:@"确定" rightBlock:^{
//            [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserLogout/1.0" timeoutInterval:20 parameters:@{} success:^(id responseObject) {
//
//            } failure:^(XKHttpErrror *error) {
//
//            }];
//            [XKLoginConfig loginDropOutConfig];
//        }];
//    }
//}
//
//
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat y = 0;
//    if (scrollView.mj_offsetY > 0) {//向上移动
//        y = 0;
//    } else {//向下移动
//        y = scrollView.mj_offsetY;
//    }
//    self.headerView.backImageView.y = y;
//    self.headerView.backImageView.height = 185 * ScreenScale - y;
//}
@end

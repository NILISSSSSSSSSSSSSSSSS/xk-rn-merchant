//
//  XKSysSettingsViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSysSettingsViewController.h"
#import "XKPersonalDataTableViewCell.h"
#import "UIView+XKCornerRadius.h"
#import "XKAboutUsViewController.h"
#import "XKPushMessageSettingViewController.h"
#import "XKCacheTool.h"
@interface XKSysSettingsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSArray        *dataArray;
@property (nonatomic, copy)   NSString       *cacheStr;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@end

@implementation XKSysSettingsViewController
#pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"系统设置" WithColor:[UIColor whiteColor]];
    [self initViews];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark – Private Methods
- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NavigationAndStatue_Height));
        make.left.bottom.right.equalTo(self.view);
    }];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    //设置小菊花颜色
    self.activityIndicator.color = [UIColor grayColor];
    //设置背景颜色
    self.activityIndicator.backgroundColor = [UIColor whiteColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    self.activityIndicator.hidesWhenStopped = YES;
    
}
- (void)initData {
    self.cacheStr = [XKCacheTool getFolderCacheSize];
}
#pragma mark - Events

#pragma mark - Custom Delegates

#pragma mark – Getters and Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[XKPersonalDataTableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"推送消息设置",@"清除缓存",@"关于我们"];
    }
    return _dataArray;
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKPersonalDataTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    cell.xk_radius = 5;
    cell.xk_openClip = YES;
    if (indexPath.row == 0) {
        cell.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
    }else if (indexPath.row == 2){
        cell.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
    }else {
        cell.xk_clipType = XKCornerClipTypeNone;
    }
    if (indexPath.row == 1) {
        cell.rightTitlelabel.text = self.cacheStr;
        CGFloat width = [self.cacheStr getWidthStrWithFontSize:14.0 height:20.0];
        [cell.rightTitlelabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        [cell.contentView addSubview:self.activityIndicator];
        [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.rightTitlelabel.mas_left).offset(-10);
            make.width.height.mas_equalTo(15);
            make.centerY.equalTo(cell.contentView);
        }];
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50 * ScreenScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 12 * ScreenScale;
    }else {
        return 0.00000001f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

       return 0.00000001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        XKPushMessageSettingViewController *vc = [[XKPushMessageSettingViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        [XKAlertView showCommonAlertViewWithTitle:@"是否清除缓存" rightText:@"确定" rightBlock:^{
            [self.activityIndicator startAnimating];
            [XKHudView showLoadingTo:self.tableView animated:YES];
            [XKCacheTool removeAllCachesComplete:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XKHudView showSuccessMessage:@"清除成功" to:self.tableView animated:YES];
                    [XKHudView hideHUDForView:self.tableView animated:YES];
                    [self.activityIndicator stopAnimating];
                    self.cacheStr = @"0M";
                    [self.tableView reloadData];
                });
               
            }];
        }];
        
    }else if (indexPath.row == 2){
        XKAboutUsViewController *vc = [[XKAboutUsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

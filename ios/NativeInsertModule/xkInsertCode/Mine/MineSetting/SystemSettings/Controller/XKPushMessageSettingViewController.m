//
//  XKPushMessageSettingViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPushMessageSettingViewController.h"
#import "XKPushMessageTableViewCell.h"
#import "UIView+XKCornerRadius.h"

@interface XKPushMessageSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSArray        *dataArray;
/**是否接收消息*/
@property(nonatomic, assign) BOOL isReceiveMessage;
@end

@implementation XKPushMessageSettingViewController


#pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"推送消息设置" WithColor:[UIColor whiteColor]];
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
}
- (void)initData {
    
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
        [_tableView registerClass:[XKPushMessageTableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"接收新消息通知",@"铃声提醒",@"震动提醒"];
    }
    return _dataArray;
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKPushMessageTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    XKWeakSelf(ws);
    cell.xk_radius = 5;
    cell.xk_openClip = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if ([[XKUserInfo currentUser].isReceiveMessage isEqualToString:@"YES"]) {
            cell.xkSwitch.on = YES ;
            self.isReceiveMessage = YES;
        }else if ([[XKUserInfo currentUser].isReceiveMessage isEqualToString:@"NO"]){
            cell.xkSwitch.on = NO ;
            self.isReceiveMessage = NO;
        }
        cell.switchChangeBLock = ^(UISwitch *xkSwitch) {
            [ws receiveNewMessageNotificationIsOn:xkSwitch.isOn];
        };
        cell.xk_clipType = XKCornerClipTypeAllCorners;
        cell.titleLabel.text = self.dataArray[0];
    }else{
        cell.titleLabel.text = self.dataArray[indexPath.row + 1];
        if (indexPath.row == 0) {
            if (self.isReceiveMessage) {
                if ([[XKUserInfo currentUser].isVoice isEqualToString:@"YES"]) {
                    cell.xkSwitch.on = YES ;
                }else if ([[XKUserInfo currentUser].isVoice isEqualToString:@"NO"]){
                    cell.xkSwitch.on = NO ;
                }
            }else{
                cell.xkSwitch.on = NO;
            }
            
            cell.switchChangeBLock = ^(UISwitch *xkSwitch) {
                [ws theBellRemindIsOn:xkSwitch.isOn];
            };
            cell.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
        }else if (indexPath.row == 1){
            if (self.isReceiveMessage) {
                if ([[XKUserInfo currentUser].isShake isEqualToString:@"YES"]) {
                    cell.xkSwitch.on = YES ;
                }else if ([[XKUserInfo currentUser].isShake isEqualToString:@"NO"]){
                    cell.xkSwitch.on = NO ;
                }
            }else{
                cell.xkSwitch.on = NO;
            }
            cell.switchChangeBLock = ^(UISwitch *xkSwitch) {
                [ws theVibrationRemindIsOn:xkSwitch.isOn];
            };
            cell.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
        }
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    return headerView;
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
    if (section == 0) {
        return 10 * ScreenScale;
    }else{
        return 0.00000001f;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){
        
    }
}


/**
 接收新消息通知

 @param isOn 是否接收
 */
- (void)receiveNewMessageNotificationIsOn:(BOOL)isOn {
    if (isOn) {
        [XKUserInfo currentUser].isReceiveMessage = @"YES";
        XKUserSynchronize;
    }else {
        [XKUserInfo currentUser].isReceiveMessage = @"NO";
        XKUserSynchronize;
    }
    [self.tableView reloadData];
}

/**
 铃声提醒

 @param isOn 是否铃声提醒
 */
- (void)theBellRemindIsOn:(BOOL)isOn {
    if (isOn) {
        [XKUserInfo currentUser].isVoice = @"YES";
        XKUserSynchronize;
    }else {
        [XKUserInfo currentUser].isVoice = @"NO";
        XKUserSynchronize;
    }
}

/**
 震动提醒
 
 @param isOn 是否震动提醒
 */
- (void)theVibrationRemindIsOn:(BOOL)isOn {
    if (isOn) {
        [XKUserInfo currentUser].isShake = @"YES";
        XKUserSynchronize;
    }else {
        [XKUserInfo currentUser].isShake = @"NO";
        XKUserSynchronize;
    }
}

@end

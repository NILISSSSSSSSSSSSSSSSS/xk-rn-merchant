//
//  XKRedPacketDetailViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKRedPacketDetailViewController.h"
#import "XKRedPacketDetailTopView.h"
#import "XKRedPacketDetailCell.h"
@interface XKRedPacketDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XKCustomNavBar *navBar;
@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) XKRedPacketDetailTopView  *infoView;
@end

@implementation XKRedPacketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)handleData {
    [super handleData];
    self.titleStr = @"晓可币红包";
}

- (void)addCustomSubviews {
    XKWeakSelf(ws);
    [self hideNavigation];
    _navBar =  [[XKCustomNavBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kIphoneXNavi(64))];
    [_navBar customBaseNavigationBar];
    _navBar.titleLabel.text = self.titleStr;
    _navBar.backgroundColor = [UIColor clearColor];
    _navBar.leftButtonBlock = ^{
        [ws.navigationController popViewControllerAnimated:YES];
        [ws.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
   
    [self.view addSubview:self.tableView];
    [self.view addSubview:_navBar];

}


#pragma mark tableview代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKRedPacketDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKRedPacketDetailCell" forIndexPath:indexPath];
    if(2 == 1) {
         cell.bgContainView.xk_clipType = XKCornerClipTypeAllCorners;
    } else {
        if(indexPath.row == 0) {
            cell.bgContainView.xk_clipType = XKCornerClipTypeTopBoth;
        } else if(indexPath.row == 9) {
            cell.bgContainView.xk_clipType = XKCornerClipTypeBottomBoth;
        } else {
            cell.bgContainView.xk_clipType = XKCornerClipTypeNone;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.clearFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 320 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  self.infoView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
 
}
#pragma mark 懒加载
- (UITableView *)tableView {
    if(!_tableView) {

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, - kStatusBarHeight, SCREEN_WIDTH,  SCREEN_HEIGHT + kStatusBarHeight - kBottomSafeHeight) style:UITableViewStyleGrouped];
        //XKWeakSelf(ws);
        _tableView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[XKRedPacketDetailCell class] forCellReuseIdentifier:@"XKRedPacketDetailCell"];

    }
    return _tableView;
}

- (XKRedPacketDetailTopView *)infoView {
    if (!_infoView) {
        _infoView = [[XKRedPacketDetailTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 320)];
        _infoView.detailBlock = ^(UIButton * _Nonnull sender) {
            
        };
    }
    return _infoView;
}
@end

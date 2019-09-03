//
//  XKGameCoinAccountListViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKGameCoinAccountListViewController.h"
#import "XKAddGameCoinAccountViewController.h"

static NSString * const cardCellID   = @"cardCellID";

@interface XKGameCoinAccountListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy  ) NSArray     *dataSource;
@end

@implementation XKGameCoinAccountListViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    [self configNavigationBar];
    [self configTableView];
}

#pragma mark - Events




#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"账号管理" WithColor:[UIColor whiteColor]];
}

- (void)configTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height+10, 10, 0, 10));
    }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataSource.count;
    if (section == 0) {
        return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cardCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        cell.textLabel.textColor = HEX_RGB(0x222222);
        cell.detailTextLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        cell.detailTextLabel.textColor = HEX_RGB(0x555555);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 53, SCREEN_WIDTH, 1)];
        line.tag = 111;
        line.backgroundColor = XKSeparatorLineColor;
        [cell.contentView addSubview:line];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"晓可币";
        cell.detailTextLabel.text = @"测试人员";
        cell.imageView.image = [UIImage imageNamed:@"xk_iocn_coin"];
        UIView *view = [cell.contentView viewWithTag:111];
        view.hidden = NO;
        
        if (indexPath.row == 0) {
            [cell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 54)];
        } else if (indexPath.row == 4) {
            view.hidden = YES;
            [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 54)];
        } else {
            [cell restoreFromCorner];
        }
        
    } else {
        [cell cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 54)];
        cell.textLabel.text = @"添加账号";
        cell.detailTextLabel.text = @"";
        cell.imageView.image = [UIImage imageNamed:@"xk_btn_subscription_add"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        
        //添加账号
        XKAddGameCoinAccountViewController *vc = [[XKAddGameCoinAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section ? 10 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


#pragma Coustom Delegate



#pragma mark - lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 54;
    }
    return _tableView;
}


@end

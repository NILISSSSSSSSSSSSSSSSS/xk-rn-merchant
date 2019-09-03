//
//  XKAddGameCoinAccountViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/17.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAddGameCoinAccountViewController.h"
#import "XKAddGameCoinAccountCell.h"
#import "XKBottomAlertSheetView.h"

static NSString * const cardCellID   = @"cardCellID";

@interface XKAddGameCoinAccountViewController () <UITableViewDelegate, UITableViewDataSource, AddGameCoinAccountTextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy  ) NSArray     *dataSource;
@property (nonatomic, strong) UIButton    *sureButton;

@end

@implementation XKAddGameCoinAccountViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    
    _dataSource = @[@{@"title":@"绑定账号", @"place":@"请选择 >", @"value":@""},
                    @{@"title":@"账号：", @"place":@"QQ号/手机号/邮箱", @"value":@""},
                    @{@"title":@"密码：", @"place":@"请输入密码", @"value":@""}];
    
    [self configNavigationBar];
    [self configTableView];
}

#pragma mark - Events

- (void)sureButtonClicked:(UIButton *)sender {
    //绑定请求
    
    //请求成功
    if (self.addGameCoinAccount) {
        self.addGameCoinAccount();
    }
}


#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"添加账号" WithColor:[UIColor whiteColor]];
}

- (void)configTableView {
    [self.view addSubview:self.tableView];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 64)];
    [footerView addSubview:self.sureButton];
    self.tableView.tableFooterView = footerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(NavigationAndStatue_Height+10, 0, 0, 0));
    }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKAddGameCoinAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cardCellID];
    if (!cell) {
        cell = [[XKAddGameCoinAccountCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cardCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegete = self;
    }
    [cell setvalueWithDictionary:_dataSource[indexPath.row] indexPath:indexPath];

    
    if (indexPath.row == 0) {
        [cell setTextFieldTextAlignment:NSTextAlignmentRight];
        [cell hiddenLineView:NO];
        [cell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 54)];
    } else {
        
        [cell setTextFieldTextAlignment:NSTextAlignmentLeft];
        if (indexPath.row == _dataSource.count - 1) {
            [cell hiddenLineView:YES];
            [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 54)];
        } else {
            [cell restoreFromCorner];
        }
    }

    return cell;
}



#pragma mark - CustomDelegate

- (void)chooseCardNumber:(NSString *)oldCardNumber {
    
    XKBottomAlertSheetView *sheet = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"晓可币",@"Q币",@"xx币",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
        
        NSLog(@"%ld%@", (long)index,choseTitle);
    }];
    [sheet show];
}

- (void)textFieldSelected:(UITextField *)textField {
    
    NSLog(@"----%@---", textField.text);
    
}


#pragma mark - lazy load

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 54;
    }
    return _tableView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH - 20, 44)];
        [_sureButton addTarget:self action:@selector(sureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 5;
        _sureButton.backgroundColor = HEX_RGB(0x4A90FA);
        [_sureButton setTitle:@"确认绑定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    }
    return _sureButton;
}

@end

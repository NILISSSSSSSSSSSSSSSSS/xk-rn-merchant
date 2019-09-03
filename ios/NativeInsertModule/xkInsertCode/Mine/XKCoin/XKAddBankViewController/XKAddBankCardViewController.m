//
//  XKAddBankCardViewController.m
//  XKSquare
//
//  Created by hupan on 2018/9/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAddBankCardViewController.h"
#import "XKAddBankCardCell.h"

static NSString * const cardCellID   = @"cardCellID";

@interface XKAddBankCardViewController () <UITableViewDelegate, UITableViewDataSource, AddBankCardDelegate>

@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, copy  ) NSMutableArray     *dataSource;
@property (nonatomic, strong) UIButton           *sureButton;

@end

@implementation XKAddBankCardViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HEX_RGB(0xf6f6f6);
    
    _dataSource = @[@{@"title":@"姓名", @"place":@"请输入持卡人姓名", @"value":@""},
                    @{@"title":@"身份证", @"place":@"请输入持卡人身份证", @"value":@""},
                    @{@"title":@"卡类型", @"place":@"", @"value":@"储蓄卡"},
                    @{@"title":@"银行卡号", @"place":@"请输入银行卡号", @"value":@""},
                    @{@"title":@"所属银行", @"place":@"", @"value":@"中国银行"},
                    @{@"title":@"预留手机", @"place":@"请输入银行预留手机号码", @"value":@""}].mutableCopy;
    
    [self configNavigationBar];
    [self configTableView];
}

#pragma mark - Events

- (void)sureButtonClicked:(UIButton *)sender {
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:_dataSource[0][@"value"] forKey:@"realName"];
//    [muDic setObject:_dataSource[1][@"value"] forKey:@"realName"];
    [muDic setObject:_dataSource[3][@"value"] forKey:@"cardNumber"];
    [muDic setObject:_dataSource[4][@"value"] forKey:@"bankName"];
    [muDic setObject:@"天府新区支行" forKey:@"openBank"];


    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetXKAddBankCard
                                timeoutInterval:20
                                     parameters:muDic
                                        success:^(id responseObject) {
                                            
                                            [XKHudView hideHUDForView:self.tableView];
                                            
                                            if (self.addBankCard) {
                                                self.addBankCard();
                                            }
                                            
                                        } failure:^(XKHttpErrror *error) {
                                            [XKHudView hideHUDForView:self.tableView];
                                            [XKHudView showErrorMessage:error.message];
                                        }];
}


#pragma mark - Private Metheods

- (void)configNavigationBar {
    [self setNavTitle:@"添加银行卡" WithColor:[UIColor whiteColor]];
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
    
    XKAddBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cardCellID];
    if (!cell) {
        cell = [[XKAddBankCardCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cardCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegete = self;
    }
    [cell setvalueWithDictionary:_dataSource[indexPath.row] indexPath:indexPath];
    if (indexPath.row == _dataSource.count - 1) {
        [cell hiddenLineView:YES];
    } else {
        [cell hiddenLineView:NO];
    }
    
    if (indexPath.row == 0) {
        [cell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 44)];
    } else if (indexPath.row == _dataSource.count - 1) {
        [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 44)];
    } else {
        [cell restoreFromCorner];
    }
    return cell;
}



#pragma mark - CustomDelegate

- (void)textFieldSelected:(UITextField *)textField {
    NSMutableDictionary *oldDic = [NSMutableDictionary dictionaryWithDictionary:_dataSource[textField.tag]];
    NSString *valueStr = textField.text ? textField.text : @"";
    [oldDic setObject:valueStr forKey:@"value"];
    [_dataSource replaceObjectAtIndex:textField.tag withObject:oldDic];

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
        _tableView.rowHeight = 44;
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
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    }
    return _sureButton;
}

@end

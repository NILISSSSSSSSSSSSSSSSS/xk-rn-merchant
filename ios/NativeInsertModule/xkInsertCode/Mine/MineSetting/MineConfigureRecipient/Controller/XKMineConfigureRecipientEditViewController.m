//
//  XKMineConfigureRecipientEditViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/8/27.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMineConfigureRecipientEditViewController.h"
#import "XKRegionPickerViewController.h"
#import "XKMineConfigureRecipientEditLinkmanTableViewCell.h"
#import "XKMineConfigureRecipientEditRegionTableViewCell.h"
#import "XKMineConfigureRecipientEditAddressTableViewCell.h"
#import "XKMineConfigureRecipientEditDefaultTableViewCell.h"
#import "XKMineConfigureRecipientEditTagTableViewCell.h"
#import "XKAdressTagViewController.h"
#import <ContactsUI/ContactsUI.h>
#import "XKAuthorityTool.h"
#import "XKMineConfigureRecipientListModel.h"

static const CGFloat kConfigureRecipientEditTableViewEdge = 10.0;
static const CGFloat kConfigureRecipientEditLinkmanTableViewCellHight = 106.0;
static const CGFloat kConfigureRecipientEditRegionTableViewCellHight = 48.0;
static const CGFloat kConfigureRecipientEditAddressTableViewCellHight = 106.0;
static const CGFloat kConfigureRecipientEditDefaultTableViewCellHight = 48.0;
static const CGFloat kConfigureRecipientEditAddressTagTableViewCellHight = 48.0;
static const CGFloat kConfigureRecipientEditTableViewHeaderHight = 5.0;
static const CGFloat kConfigureRecipientEditTableViewFooterHight = 20.0;

NSString *const kConfigureRecipientEditLinkmanTableViewCellIdentifier = @"XKMineConfigureRecipientEditLinkmanTableViewCell";
NSString *const kConfigureRecipientEditRegionTableViewCellIdentifier = @"XKMineConfigureRecipientEditRegionTableViewCell";
NSString *const kConfigureRecipientEditAddressTableViewCellIdentifier = @"XKMineConfigureRecipientEditAddressTableViewCell";
NSString *const kConfigureRecipientEditDefaultTableViewCellIdentifier = @"XKMineConfigureRecipientEditDefaultTableViewCell";
NSString *const kConfigureRecipientEditTagTableViewCellIdentifier = @"XKMineConfigureRecipientEditTagTableViewCell";

@interface XKMineConfigureRecipientEditViewController () <UITableViewDataSource, UITableViewDelegate, CNContactPickerDelegate, XKMineConfigureRecipientEditLinkmanTableViewCellDelegate,  XKMineConfigureRecipientEditRegionTableViewCellDelegate, XKRegionPickerViewControllerDelegate, XKMineConfigureRecipientEditTagTableViewCellDelegate, XKAdressTagViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XKRegionPickerViewController *regionPickerViewController;
@property (nonatomic, strong) XKRegionPickerModel *selectedRegionPickerModel;
@property (nonatomic, strong) UIButton *operationButton;

@end

@implementation XKMineConfigureRecipientEditViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initializeViews];
    if (!self.recipientItem) {
        self.recipientItem = [XKMineConfigureRecipientItem new];
    } else {
        self.selectedRegionPickerModel = [XKRegionPickerModel new];
        self.selectedRegionPickerModel.provinceCode = self.recipientItem.provinceCode;
        self.selectedRegionPickerModel.cityCode = self.recipientItem.cityCode;
        self.selectedRegionPickerModel.districtCode = self.recipientItem.districtCode;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    } else {
        return 2;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) {
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 5)];
        tableHeaderView.backgroundColor = [UIColor whiteColor];
        [tableHeaderView cutCornerWithRoundedRect:tableHeaderView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        return tableHeaderView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) {
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 5)];
        tableFooterView.backgroundColor = [UIColor whiteColor];
        [tableFooterView cutCornerWithRoundedRect:tableFooterView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        return tableFooterView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        XKMineConfigureRecipientEditLinkmanTableViewCell *linkmanTableViewCell = [tableView dequeueReusableCellWithIdentifier:kConfigureRecipientEditLinkmanTableViewCellIdentifier forIndexPath:indexPath];
        linkmanTableViewCell.delegate = self;
        [linkmanTableViewCell configTableViewCell:self.recipientItem];
        cell = linkmanTableViewCell;
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        XKMineConfigureRecipientEditRegionTableViewCell *regionTableViewCell = [tableView dequeueReusableCellWithIdentifier:kConfigureRecipientEditRegionTableViewCellIdentifier forIndexPath:indexPath];
        regionTableViewCell.delegate = self;
        [regionTableViewCell configTableViewCell:self.recipientItem];
        cell = regionTableViewCell;
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        XKMineConfigureRecipientEditAddressTableViewCell *addressTableViewCell = [tableView dequeueReusableCellWithIdentifier:kConfigureRecipientEditAddressTableViewCellIdentifier forIndexPath:indexPath];
        [addressTableViewCell configTableViewCell:self.recipientItem];
        cell = addressTableViewCell;
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        XKMineConfigureRecipientEditDefaultTableViewCell *defaultTableViewCell = [tableView dequeueReusableCellWithIdentifier:kConfigureRecipientEditDefaultTableViewCellIdentifier forIndexPath:indexPath];
        [defaultTableViewCell configTableViewCell:self.recipientItem isForceDefault:self.isForceDefault];
        cell = defaultTableViewCell;
    }
    else {
        XKMineConfigureRecipientEditTagTableViewCell *tagTableViewCell = [tableView dequeueReusableCellWithIdentifier:kConfigureRecipientEditTagTableViewCellIdentifier forIndexPath:indexPath];
        [tagTableViewCell configTableViewCell:self.recipientItem];
        tagTableViewCell.delegate = self;
        cell = tagTableViewCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kConfigureRecipientEditTableViewHeaderHight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kConfigureRecipientEditTableViewFooterHight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return kConfigureRecipientEditLinkmanTableViewCellHight;
        } else if (indexPath.row == 1) {
            return kConfigureRecipientEditRegionTableViewCellHight;
        } else if (indexPath.row == 2) {
            return kConfigureRecipientEditAddressTableViewCellHight;
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return kConfigureRecipientEditDefaultTableViewCellHight;
        } else if (indexPath.row == 1) {
            return kConfigureRecipientEditAddressTagTableViewCellHight;
        }
    }
    
    return 0;
}

#pragma mark - XKMineConfigureRecipientEditLinkmanTableViewCellDelegate

/** 选择联系人 */
- (void)linkmanCell:(XKMineConfigureRecipientEditLinkmanTableViewCell *)cell clickAddressBookControl:(UIControl *)sender {
    [self openSystemAddressBook];
}

#pragma mark - CNContactPickerDelegate

/** 选择联系人回调 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    
    CNContact *contact = contactProperty.contact;
    NSString *nameString = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    self.recipientItem.receiver = nameString;
    
    if ([contactProperty.value isKindOfClass:[CNPhoneNumber class]]) {
        CNPhoneNumber *phoneNumber = contactProperty.value;
        NSString * phoneNumberTempString = phoneNumber.stringValue;
        NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *phoneNumString = [[phoneNumberTempString componentsSeparatedByCharactersInSet:setToRemove]componentsJoinedByString:@""];
        self.recipientItem.phone = phoneNumString;
        [self.tableView reloadData];
    }
}

#pragma mark - XKMineConfigureRecipientEditRegionTableViewCellDelegate

/** 选择地区 */
- (void)regionCellDidSelected:(XKMineConfigureRecipientEditRegionTableViewCell *)cell {
    
    self.regionPickerViewController = [XKRegionPickerViewController showRegionPickerViewWithController:self regionPickerModel:self.selectedRegionPickerModel];
    self.regionPickerViewController.delegate = self;
}

#pragma mark - XKRegionPickerViewControllerDelegate

/** 选择地区回调 */
- (void)regionPickerViewController:(XKRegionPickerViewController *)pickerViewController didSelectedRegion:(XKRegionPickerModel *)model {
    
    self.selectedRegionPickerModel = model;
    self.recipientItem.provinceName = model.provinceName;
    self.recipientItem.provinceCode = model.provinceCode;
    self.recipientItem.cityName = model.cityName;
    self.recipientItem.cityCode = model.cityCode;
    self.recipientItem.districtName = model.districtName;
    self.recipientItem.districtCode= model.districtCode;
    [self.tableView reloadData];
}

#pragma mark - XKMineConfigureRecipientEditTagTableViewCellDelegate

/** 选择标签 */
- (void)addressTagCellDidSelected:(XKMineConfigureRecipientEditTagTableViewCell *)cell {
    
    XKAdressTagViewController *adressTagViewController = [XKAdressTagViewController showRegionPickerViewWithController:self tag:self.recipientItem.label];
    adressTagViewController.delegate = self;
}

#pragma mark - XKAdressTagViewControllerDelegate

/** 选择标签回调 */
- (void)adressTagViewController:(XKAdressTagViewController *)viewController didSelectedTag:(NSString *)tagString {
    
    self.recipientItem.label = tagString;
    [self.tableView reloadData];
}

#pragma mark - events

/** 保存地址 */
- (void)clickSaveButton:(UIButton *)button {
    
    // 输入校验
    if (!self.recipientItem.receiver || [self.recipientItem.receiver isEqualToString:@""]) {
        [XKHudView showTipMessage:@"请输入收货人" to:self.view animated:YES];
        return;
    }
    
    NSInteger receiverLength = self.recipientItem.receiver.length;
    if (receiverLength < 2) {
        [XKHudView showTipMessage:@"收货人请输入2-20个字符" to:self.view animated:YES];
        return;
    }
    
    if (!self.recipientItem.phone || [self.recipientItem.phone isEqualToString:@""]) {
        [XKHudView showTipMessage:@"请输入联系电话" to:self.view animated:YES];
        return;
    }
    if (!self.recipientItem.districtCode || [self.recipientItem.districtCode isEqualToString:@""]) {
        [XKHudView showTipMessage:@"请选择省市区" to:self.view animated:YES];
        return;
    }
    if (!self.recipientItem.street || [self.recipientItem.street isEqualToString:@""]) {
        [XKHudView showTipMessage:@"请输入详细地址" to:self.view animated:YES];
        return;
    }
    
    // 组装请求
    NSString *urlString;
    if (self.recipientItem.ID && ![self.recipientItem.ID isEqualToString:@""]) {
        urlString = GetUpdateRecipientUrl;
    } else {
        urlString = GetCreateRecipientUrl;
    }
    
    NSDictionary *tempParameters = [self.recipientItem yy_modelToJSONObject];
    NSDictionary *parameters = @{@"userShopAddr": tempParameters};
    
    [XKHudView showLoadingTo:self.tableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:urlString timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        [XKHudView showSuccessMessage:@"保存成功"];
        [XKHudView hideHUDForView:self.tableView];
        [self.delegate viewController:self creatNewRecipientItem:self.recipientItem];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.tableView];
    }];
}

/** 删除地址 */
- (void)clickDelegateButton:(UIButton *)button {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定删除该地址吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *ID = self.recipientItem.ID;
        NSDictionary *parameters = @{@"id": ID};
        [XKHudView showLoadingTo:self.tableView animated:YES];
        [HTTPClient postEncryptRequestWithURLString:GetDeleteRecipientUrl timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
            [XKHudView showSuccessMessage:@"删除成功"];
            [XKHudView hideHUDForView:self.tableView];
            [self.delegate viewController:self didDeletedRecipientItem:self.recipientItem];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(XKHttpErrror *error) {
            
            [XKHudView hideHUDForView:self.tableView];
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - private methods

-(void)initializeViews {
    
    if (self.state == XKMineConfigureRecipientEditViewControllerStateEdit) {
        [self setNavTitle:@"修改收货地址" WithColor:[UIColor whiteColor]];
        UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveButton addTarget:self action:@selector(clickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTintColor:[UIColor whiteColor]];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self setRightView:saveButton withframe:CGRectMake(20, 20, 80, 24)];
    } else {
        [self setNavTitle:@"新增收货地址" WithColor:[UIColor whiteColor]];
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(NavigationAndStatue_Height +kConfigureRecipientEditTableViewEdge);
        make.left.equalTo(self.view.mas_left).offset(kConfigureRecipientEditTableViewEdge);
        make.right.equalTo(self.view.mas_right).offset(-kConfigureRecipientEditTableViewEdge);
        make.height.mas_equalTo(kConfigureRecipientEditTableViewHeaderHight * 2 +
                                kConfigureRecipientEditLinkmanTableViewCellHight +
                                kConfigureRecipientEditRegionTableViewCellHight +
                                kConfigureRecipientEditAddressTableViewCellHight +
                                kConfigureRecipientEditDefaultTableViewCellHight +
                                kConfigureRecipientEditAddressTagTableViewCellHight +
                                kConfigureRecipientEditTableViewFooterHight * 2);
    }];
    [self.operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(10);
        make.left.equalTo(self.tableView.mas_left);
        make.right.equalTo(self.tableView.mas_right);
        make.height.mas_equalTo(45);
    }];
    
    [self.tableView registerClass:[XKMineConfigureRecipientEditLinkmanTableViewCell class] forCellReuseIdentifier:kConfigureRecipientEditLinkmanTableViewCellIdentifier];
    [self.tableView registerClass:[XKMineConfigureRecipientEditRegionTableViewCell class] forCellReuseIdentifier:kConfigureRecipientEditRegionTableViewCellIdentifier];
    [self.tableView registerClass:[XKMineConfigureRecipientEditAddressTableViewCell class] forCellReuseIdentifier:kConfigureRecipientEditAddressTableViewCellIdentifier];
    [self.tableView registerClass:[XKMineConfigureRecipientEditDefaultTableViewCell class] forCellReuseIdentifier:kConfigureRecipientEditDefaultTableViewCellIdentifier];
    [self.tableView registerClass:[XKMineConfigureRecipientEditTagTableViewCell class] forCellReuseIdentifier:kConfigureRecipientEditTagTableViewCellIdentifier];
}

/** 打开系统通讯录 */
- (void)openSystemAddressBook {

//    if (@available(iOS 11.0, *)) {
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
//    } else {
//        // Fallback on earlier versions
//    }
    
    CNContactPickerViewController * contactPickerViewController = [CNContactPickerViewController new];
    contactPickerViewController.delegate = self;
    
    [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeAddressBook needGuide:YES has:^{
        [self presentViewController:contactPickerViewController animated:YES completion:nil];
    } hasnt:^{
        // 未授权
    }];
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

- (UIButton *)operationButton {
    
    if (!_operationButton) {
        _operationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _operationButton.layer.cornerRadius = 5;
        _operationButton.layer.masksToBounds = YES;
        [_operationButton.titleLabel setFont:[UIFont fontWithName:XK_PingFangSC_Regular size:15.0]];
        if (self.state == XKMineConfigureRecipientEditViewControllerStateEdit) {
            [_operationButton addTarget:self action:@selector(clickDelegateButton:) forControlEvents:UIControlEventTouchUpInside];
            [_operationButton setTitle:@"删除收货地址" forState:UIControlStateNormal];
            _operationButton.backgroundColor = RGB(232, 73, 79);
        } else {
            [_operationButton addTarget:self action:@selector(clickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
            [_operationButton setTitle:@"保 存" forState:UIControlStateNormal];
            _operationButton.backgroundColor = XKMainTypeColor;
        }
        [self.view addSubview:_operationButton];
    }
    return _operationButton;
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

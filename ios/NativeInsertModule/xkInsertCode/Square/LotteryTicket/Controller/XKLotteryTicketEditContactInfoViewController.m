//
//  XKLotteryTicketEditContactInfoViewController.m
//  XKSquare
//
//  Created by xudehuai on 2018/12/11.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKLotteryTicketEditContactInfoViewController.h"
#import "XKLotteryTicketEditInfoTableViewCell.h"
#import "XKLotteryTicketAnnouncementFooter.h"
#import "XKCommonResultViewController.h"

static NSUInteger TFTag = 1000;

@interface XKLotteryTicketEditContactInfoViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *datas;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *idCard;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *phone;

@end

@implementation XKLotteryTicketEditContactInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"填写联系方式" WithColor:HEX_RGB(0xFFFFFF)];
    [self initializeViews];
    [self updateViews];
}

- (void)initializeViews {
    
    XKLotteryTicketAnnouncementFooter *footer = [[XKLotteryTicketAnnouncementFooter alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 84.0)];
    [footer.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    footer.confirmBtnBlock = ^{
        [self.view endEditing:YES];
        if (!self.name || !self.name.length) {
            [XKHudView showErrorMessage:@"请输入持卡人姓名"];
            return ;
        }
        if (!self.idCard || !self.idCard.length) {
            [XKHudView showErrorMessage:@"请输入身份证号"];
            return ;
        }
        if (!self.address || !self.address.length) {
            [XKHudView showErrorMessage:@"请填写居住地址"];
            return ;
        }
        if (!self.phone || !self.phone.length) {
            [XKHudView showErrorMessage:@"请输入手机号码"];
            return ;
        }
        XKCommonResultViewController *vc = [[XKCommonResultViewController alloc] init];
        vc.titleStr = @"申请成功";
        vc.vcType = XKCommonResultVCTypeSucceed;
        vc.resultStr = @"您的领取申请已提交，请等待平台确认！";
        [self.navigationController pushViewController:vc animated:YES];
    };
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = footer;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:[XKLotteryTicketEditInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XKLotteryTicketEditInfoTableViewCell class])];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.containView addSubview:self.tableView];
}

- (void)updateViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKLotteryTicketEditInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XKLotteryTicketEditInfoTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.containerView.xk_radius = 6.0;
        cell.containerView.xk_clipType = XKCornerClipTypeTopBoth;
        cell.containerView.xk_openClip = YES;
    } else if (indexPath.row == self.datas.count - 1) {
        cell.containerView.xk_radius = 6.0;
        cell.containerView.xk_clipType = XKCornerClipTypeBottomBoth;
        cell.containerView.xk_openClip = YES;
    } else {
        cell.containerView.xk_radius = 0.0;
        cell.containerView.xk_clipType = XKCornerClipTypeNone;
        cell.containerView.xk_openClip = YES;
    }
    NSDictionary *dic = self.datas[indexPath.row];
    cell.contentTF.tag = TFTag + indexPath.row;
    cell.contentTF.delegate = self;
    [cell configCellWithTitle:dic[@"title"] placeholder:dic[@"placeholder"]];
    [cell setCellLineHidden:indexPath.row == self.datas.count - 1];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag - TFTag == 0) {
        self.name = textField.text;
    } else if (textField.tag - TFTag == 1) {
        self.idCard = textField.text;
    } else if (textField.tag - TFTag == 2) {
        self.address = textField.text;
    } else if (textField.tag - TFTag == 3) {
        self.phone = textField.text;
    }
}

#pragma mark - getter setter

- (NSArray <NSDictionary *>*)datas {
    return @[
             @{
                 @"id" : @"name",
                 @"title" : @"姓名",
                 @"placeholder" : @"请输入持卡人姓名",
                 },
             @{
                 @"id" : @"idCard",
                 @"title" : @"身份证",
                 @"placeholder" : @"请输入身份证号",
                 },
             @{
                 @"id" : @"address",
                 @"title" : @"居住地",
                 @"placeholder" : @"请填写居住地址",
                 },
             @{
                 @"id" : @"phone",
                 @"title" : @"联系方式",
                 @"placeholder" : @"请输入手机号码",
                 },
             ];
}

@end

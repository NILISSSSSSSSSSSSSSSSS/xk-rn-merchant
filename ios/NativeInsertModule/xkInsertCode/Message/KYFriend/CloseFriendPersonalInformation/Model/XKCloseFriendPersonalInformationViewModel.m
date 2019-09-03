//
//  XKCloseFriendPersonalInformationViewModel.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//


#import "XKCloseFriendPersonalInformationViewModel.h"
#import "XKPersonalDataTableViewCell.h"
#import "XKPersonalDataHeaderTableViewCell.h"
#import "XKPushMessageTableViewCell.h"

static NSString * const cellID         = @"cell";
static NSString * const headerCellID   = @"headerCell";
static NSString * const settingCellID  = @"settingCellID";

@interface XKCloseFriendPersonalInformationViewModel()

/**nameArray*/
@property(nonatomic, strong) NSArray *cellNameArr;

@end

@implementation XKCloseFriendPersonalInformationViewModel
- (void)registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKPersonalDataTableViewCell class] forCellReuseIdentifier:cellID];
    [tableView registerClass:[XKPersonalDataHeaderTableViewCell class] forCellReuseIdentifier:headerCellID];
    [tableView registerClass:[XKPushMessageTableViewCell class] forCellReuseIdentifier:settingCellID];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XKWeakSelf(ws);
    if (indexPath.section == 0){
        XKPushMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellID forIndexPath:indexPath];
        cell.switchChangeBLock = ^(UISwitch *xkSwitch) {
            if (ws.upSwitchChangeBLock) {
                ws.upSwitchChangeBLock(xkSwitch.isOn);
            }
        };
        cell.titleLabel.text = self.cellNameArr[indexPath.row];
        cell.xkSwitch.on = self.model.outside;
        cell.xk_radius = 8;
        cell.xk_openClip = YES;
        cell.xk_clipType = XKCornerClipTypeAllCorners;
        return cell;
    }
    else if (indexPath.section == 1) {
        XKPersonalDataHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:headerCellID forIndexPath:indexPath];
        headerCell.xk_radius = 8;
        headerCell.xk_openClip = YES;
        headerCell.xk_clipType = XKCornerClipTypeAllCorners;
        [headerCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:kDefaultHeadImg];
        return headerCell;
    }else{
        XKPersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.titleLabel.text = self.cellNameArr[indexPath.row + 2];
        cell.xk_radius = 8;
        cell.xk_openClip = YES;
        if([cell.titleLabel.text isEqualToString:@"昵称"]) {
            cell.rightTitlelabel.text = self.model.nickname ? self.model.nickname : @"未知";
            cell.xk_clipType = XKCornerClipTypeTopBoth;
        } else if ([cell.titleLabel.text isEqualToString:@"手机号码"]){
            cell.rightTitlelabel.text = self.model.phone ? self.model.phone : @"";
        }
        else if ([cell.titleLabel.text isEqualToString:@"性别"]){
            cell.rightTitlelabel.text = self.model.sexDes ? self.model.sexDes : @"未选择";
        }
        else if ([cell.titleLabel.text isEqualToString:@"生日"]){
            cell.rightTitlelabel.text = self.model.birthday ? self.model.birthdayDes : @"未选择";
        }
        else if ([cell.titleLabel.text isEqualToString:@"个性签名"]){
            if (self.model.signature.length >= 14) {
                NSString * modelSignatureStr = [self.model.signature substringWithRange:NSMakeRange(0, 14)];
                cell.rightTitlelabel.text = [NSString stringWithFormat:@"%@...",modelSignatureStr];
            }else {
                cell.rightTitlelabel.text = self.model.signature ?: @"本宝宝暂时还没有想到有趣的签名";
            }
        }
        else if([cell.titleLabel.text isEqualToString:@"安全码"]) {
            cell.rightTitlelabel.text = XKUserInfo.getCurrentMrCode ? : @"";
            cell.xk_clipType = XKCornerClipTypeBottomBoth;
        }else if ([cell.titleLabel.text isEqualToString:@"我的二维码"]){
            [cell.rightTitlelabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.appendImage(IMG_NAME(@"xk_btn_QR"));
            }];
        }
        else if ([cell.titleLabel.text isEqualToString:@"地址"]){
            cell.rightTitlelabel.text = self.model.address ? self.model.address : @"未选择";
        }
        
        if ([cell.titleLabel.text isEqualToString:@"安全码"]) {
            cell.nextImageView.hidden = YES;
        }else{
            cell.nextImageView.hidden = NO;
        }
        return cell;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 1;
    }
    else if (section == 2){
        return 8;
    }
    else{
        return 0;
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 75 * ScreenScale;
    }
    else{
        return 50 * ScreenScale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 12 * ScreenScale;
    }
    else {
        return 0.00000001f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10 * ScreenScale;
    }else if (section == 1){
        return 10 * ScreenScale;
    }
    else{
        return 0.00000001f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBlock) {
        self.selectBlock(tableView, indexPath);
    }
}

- (XKSecretCircleDetailModel *)model {
    if (!_model) {
        _model = [[XKSecretCircleDetailModel alloc]init];
    }
    return _model;
}

- (NSArray *)cellNameArr {
    if (!_cellNameArr) {
        _cellNameArr = @[@"外置显示",@"头像",@"昵称",@"我的二维码",@"手机号码",@"性别",@"生日",@"地址",@"个性签名",@"安全码"];
    }
    return _cellNameArr;
}

- (void)reloadData {
    if (_loadBlock) {
        _loadBlock();
    }
}
- (void)getData {
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"secretId"] = self.secretId;
    [HTTPClient postEncryptRequestWithURLString:@"im/ua/secretCircleDetail/1.0" timeoutInterval:20.0 parameters:params success:^(id responseObject) {
        XKSecretCircleDetailModel *model = [XKSecretCircleDetailModel yy_modelWithJSON:responseObject];
        self.model = model;
        [self reloadData];
    } failure:^(XKHttpErrror *error) {
        
    }];
}

@end

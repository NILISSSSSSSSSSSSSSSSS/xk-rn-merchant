//
//  XKUnionPersonalInfoViewModel.m
//  XKSquare
//
//  Created by Lin Li on 2019/5/6.
//  Copyright © 2019 xk. All rights reserved.
//

#import "XKUnionPersonalInfoViewModel.h"
#import "XKUnionPersonalHeaderTableViewCell.h"
#import "XKUnionPersonalTableViewCell.h"
static NSString * const cellID  = @"cell";
static NSString * const headerCellID  = @"headerCell";

@interface XKUnionPersonalInfoViewModel()
/**nameArray*/
@property(nonatomic, strong) NSArray *cellNameArr;

/**是否展示个人资料*/
@property(nonatomic, assign) BOOL showInfomation;
@end

@implementation XKUnionPersonalInfoViewModel
- (instancetype)init {
  if (self = [super init]) {
    _showInfomation = YES;
  }
  return self;
}

- (void)registerCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[XKUnionPersonalTableViewCell class] forCellReuseIdentifier:cellID];
    [tableView registerClass:[XKUnionPersonalHeaderTableViewCell class] forCellReuseIdentifier:headerCellID];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *title = self.cellNameArr[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"用户头像"]) {
        XKUnionPersonalHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:headerCellID forIndexPath:indexPath];
        [headerCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar ? self.model.avatar : [XKUserInfo getCurrentUserAvatar]] placeholderImage:kDefaultHeadImg];
        return headerCell;
    }else {
        XKUnionPersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.titleLabel.text = title;
        if([title isEqualToString:@"昵称"]) {
            cell.rightTitlelabel.text = self.model.nickname ? self.model.nickname : [XKUserInfo getCurrentUserName];
            cell.myContentView.xk_clipType = XKCornerClipTypeTopBoth;
        } else if ([title isEqualToString:@"生日"]){
            cell.rightTitlelabel.text = self.model.birthday ? self.model.birthdayDes : @"未填写";
            cell.rightTitlelabel.textColor = self.model.birthday ? HEX_RGB(0x222222) : HEX_RGB(0xCCCCCC) ;
        }else if ([title isEqualToString:@"年龄"]){
            cell.rightTitlelabel.text = self.model.age ? self.model.age : @"未填写";
            cell.rightTitlelabel.textColor = self.model.age ? HEX_RGB(0x222222) : HEX_RGB(0xCCCCCC) ;

        }else if ([title isEqualToString:@"性别"]){
            cell.rightTitlelabel.text = self.model.sexDes ? self.model.sexDes : @"未填写";
            cell.rightTitlelabel.textColor = self.model.sexDes ? HEX_RGB(0x222222) : HEX_RGB(0xCCCCCC) ;

        }else if([title isEqualToString:@"安全码"]) {
            cell.rightTitlelabel.text = XKUserInfo.getCurrentMrCode ? : @"";
        } else if ([title isEqualToString:@"地址"]){
            cell.rightTitlelabel.text = self.model.address ? self.model.address : @"未填写";
            cell.rightTitlelabel.textColor = self.model.address ? HEX_RGB(0x222222) : HEX_RGB(0xCCCCCC) ;
        }
        return cell;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellNameArr[section] count];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellNameArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 101;
    }
    else{
        return 65;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 0.00000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 125;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  if (self.showInfomation) {
    return [self getFooterView];
  }else{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
  }
}

- (UIView *)getFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
    footerView.backgroundColor = HEX_RGB(0xffffff);
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = XKRegularFont(15);
    titleLabel.text = @"签名";
    titleLabel.textColor = HEX_RGB(0x222222);
    [footerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(15);
    }];
    UILabel *ortherLabel = [[UILabel alloc]init];
    ortherLabel.font = XKRegularFont(15);
    [footerView addSubview:ortherLabel];
    [ortherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
    }];
    ortherLabel.textColor = self.model.signature ? HEX_RGB(0x222222) : HEX_RGB(0xCCCCCC) ;
    if (self.model.signature.length >= 14) {
        NSString * modelSignatureStr = [self.model.signature substringWithRange:NSMakeRange(0, 14)];
        ortherLabel.text = [NSString stringWithFormat:@"%@...",modelSignatureStr];
    }else {
        [ortherLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
            confer.text( self.model.signature?:@"这个人很懒，没有填写签名");
        }];
        
    }
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBlock) {
        self.selectBlock(tableView, indexPath);
    }
}

- (XKUnionPersonalDataModel *)model {
    if (!_model) {
        _model = [[XKUnionPersonalDataModel alloc]init];
    }
    return _model;
}

- (NSArray *)cellNameArr {
    if (!_cellNameArr) {
        _cellNameArr = @[@[@"用户头像",@"昵称",@"生日",@"年龄",@"性别",@"安全码",@"地址"]];
    }
    return _cellNameArr;
}
#pragma mark – Private Methods
- (void)loadData {
    [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserDetail/1.0" timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        XKUnionPersonalDataModel *model = [XKUnionPersonalDataModel yy_modelWithJSON:responseObject];
        self.showInfomation = model.showInfomation;
        self.model = model;
        if (self.loadBlock) {
            self.loadBlock(self.showInfomation);
        }
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
        NSLog(@"%@", error.message);
      if (self.loadBlock) {
        self.loadBlock(self.showInfomation);
      }
    }];
}

@end

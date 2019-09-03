/*******************************************************************************
 # File        : XKReceiptInfoViewModel.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKReceiptInfoViewModel.h"
#import "XKReceiptInputCell.h"
#import "XKReceiptSwitchCell.h"
#import "XKReceiptSegmentCell.h"
#import "XKReceiptInfoModel.h"
#import "UIView+XKCornerRadius.h"
@interface XKReceiptInfoViewModel() {
    NSString *_editReceiptId;
}
@property(nonatomic, strong)  XKReceiptInfoModel *companyReceiptModel;
@property(nonatomic, strong)  XKReceiptInfoModel *personalReceiptModel;
/***/
@property(nonatomic, strong) XKReceiptInfoModel *currentModel;
/**数据源*/
@property(nonatomic, strong) NSMutableArray *dataArray;
/**显示配置项*/
@property(nonatomic, strong) NSMutableDictionary *displayCongfig;

@end

@implementation XKReceiptInfoViewModel

- (instancetype)init {
    if (self = [super init]) {
        _dataArray = [NSMutableArray array];
        _companyReceiptModel = [XKReceiptInfoModel createForCompany];
        _personalReceiptModel = [XKReceiptInfoModel createForPerson];
        [self changeReiceptTypeForPerson:YES];
    }
    return self;
}

#pragma mark - 切换个人/企业
- (void)changeReiceptTypeForPerson:(BOOL)isPersonal {
    if (isPersonal) {
        self.currentModel = _personalReceiptModel;
    } else {
        self.currentModel = _companyReceiptModel;
    }
    [self reBuildDataArray];
}

#pragma mark - 重设数据源
- (void)reBuildDataArray {
    [self.dataArray removeAllObjects];
    _displayCongfig = nil;
    if (self.currentModel.isPersonal) {
        [self.dataArray addObjectsFromArray:@[@(XKReceiptInfoCellTypeSegment),@(XKReceiptInfoCellTypeTitle),@(XKReceiptInfoCellTypeDefault)]];
    } else {
        [self.dataArray addObjectsFromArray:@[@(XKReceiptInfoCellTypeSegment),@(XKReceiptInfoCellTypeTitle),@(XKReceiptInfoCellTypeTaxNum),@(XKReceiptInfoCellTypeAddr),@(XKReceiptInfoCellTypeBank),@(XKReceiptInfoCellTypeBankNum),@(XKReceiptInfoCellTypeDefault)]];
    }
    EXECUTE_BLOCK(self.refreshBlock);
}

#pragma mark - 注册cell
- (void)regisCellFor:(UITableView *)tableView {
    [tableView registerClass:[XKReceiptInputCell class] forCellReuseIdentifier:@"input"];
    [tableView registerClass:[XKReceiptSwitchCell class] forCellReuseIdentifier:@"switch"];
    [tableView registerClass:[XKReceiptSegmentCell class] forCellReuseIdentifier:@"segment"];
}

#pragma mark - 处理传入的model  代表编辑模式
- (void)setEditReceiptId:(NSString *)editId {
    _editStatus = YES;
    _editReceiptId = editId;
}

#pragma mark - 公用方法
#pragma mark 检测数据
- (BOOL)checkData {
    if (self.currentModel == _personalReceiptModel) { // 个人
        if (self.currentModel.head.length == 0) {
            [XKHudView showWarnMessage:@"请输入发票抬头"];
            return NO;
        }
        if (self.currentModel.head.length != 0) {
            if (![self checkDataLimit:XKReceiptInfoCellTypeTitle]) {
                return NO;
            }
        }
    } else { // 企业
        
        if (self.currentModel.head.length == 0) {
            [XKHudView showWarnMessage:@"请输入发票抬头"];
            return NO;
        }
        if (self.currentModel.head.length != 0) {
            if (![self checkDataLimit:XKReceiptInfoCellTypeTitle]) {
                return NO;
            }
        }
       
        if (self.currentModel.taxNo.length == 0) {
            [XKHudView showWarnMessage:@"请输入企业税号"];
            return NO;
        }
        if (self.currentModel.taxNo.length != 0) {
            if (![self checkDataLimit:XKReceiptInfoCellTypeTaxNum]) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - 检测数据位数
- (BOOL)checkDataLimit:(XKReceiptInfoCellType)type {
    XKReceiptInfoDataConfig *config = self.displayCongfig[@(type)];
    NSString *text;
    if (type == XKReceiptInfoCellTypeTitle) {
        text = self.currentModel.head;
    } else if (type == XKReceiptInfoCellTypeTaxNum) {
        text = self.currentModel.taxNo;
    } else {
        // 还未补充
    }
    if (text.length < config.minLengthNum || text.length > config.maxLengthNum) {
        NSString *warnMsg;
        if (config.minLengthNum == config.maxLengthNum) {
             warnMsg = [NSString stringWithFormat:@"请输入%ld位%@",config.minLengthNum,config.title];
        } else {
            warnMsg = [NSString stringWithFormat:@"请输入%ld-%ld位%@",config.minLengthNum,config.maxLengthNum,config.title];
        }
        [XKHudView showWarnMessage:warnMsg];
        return NO;
    }
    return YES;
}


#pragma mark - ---请求---

#pragma mark 新建
- (void)requestUploadReceipt:(void (^)(NSString *, id))response {
    NSDictionary *receiptInfo = [self.currentModel yy_modelToJSONObject];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userInvoice"] = receiptInfo;
    [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserInvoiceCreate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        response(nil,@"");
    } failure:^(XKHttpErrror *error) {
        response(error.message,nil);
    }];
}

#pragma mark 详情
- (void)requestReceiptInfo:(void (^)(NSString *, id))response {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = _editReceiptId;
    [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserInvoiceDetail/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        XKReceiptInfoModel *receipt = [XKReceiptInfoModel yy_modelWithJSON:responseObject];
        if (receipt.isPersonal) {
            self.personalReceiptModel = receipt;
            self.companyReceiptModel.receiptId = receipt.receiptId; // 把id给另一个type
        } else {
            self.companyReceiptModel = receipt;
            self.personalReceiptModel.receiptId = receipt.receiptId;
        }
        [self changeReiceptTypeForPerson:receipt.isPersonal];
        EXECUTE_BLOCK(response,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(response,error.message,nil);
    }];
}

#pragma mark 删除
- (void)requestDeleteReceipt:(void (^)(NSString *, id))response {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = _editReceiptId;
    [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserInvoiceDelete/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        EXECUTE_BLOCK(response,nil,responseObject);
    } failure:^(XKHttpErrror *error) {
        EXECUTE_BLOCK(response,error.message,nil);
    }];
}

#pragma mark 修改
- (void)requestUpdateReceiptInfo:(void (^)(NSString *, id))response {
    NSDictionary *receiptInfo = [self.currentModel yy_modelToJSONObject];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"userInvoice"] = receiptInfo;
    [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserInvoiceUpdate/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        response(nil,@"");
    } failure:^(XKHttpErrror *error) {
        response(error.message,nil);
    }];
}

#pragma mark - ------代理------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKReceiptInfoCellType type = [self.dataArray[indexPath.row] integerValue];
    __weak typeof(self) weakSelf = self;
    XKReceiptInfoBaseCell *cell;
    switch (type) {
        case XKReceiptInfoCellTypeDefault:
            cell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
            break;
        case XKReceiptInfoCellTypeSegment:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"segment" forIndexPath:indexPath];
            XKReceiptSegmentCell *segCell = (XKReceiptSegmentCell *)cell;
            [segCell setCheck:^(BOOL forPerson) {
                [weakSelf changeReiceptTypeForPerson:forPerson];
            }];
        }
            break;
        case XKReceiptInfoCellTypeTitle:
        case XKReceiptInfoCellTypeAddr:
        case XKReceiptInfoCellTypeTaxNum:
        case XKReceiptInfoCellTypeBank:
        case XKReceiptInfoCellTypeBankNum:
            cell = [tableView dequeueReusableCellWithIdentifier:@"input" forIndexPath:indexPath];
            break;
        default:
            break;
    }
    cell.cellType = type;
    cell.indexPath = indexPath;
    cell.config = self.displayCongfig[@(type)];
    cell.model = self.currentModel;
    cell.hideSeperate = indexPath.row == self.dataArray.count - 1;
  
    cell.refreshBlock = ^(NSIndexPath *indexPath) {
        EXECUTE_BLOCK(weakSelf.refreshBlock);
    };
    // 圆角
    cell.xk_openClip = YES;
    cell.xk_radius = 6;
    if (indexPath.row == 0) {
        cell.xk_clipType = XKCornerClipTypeTopBoth;
    } else if (indexPath.row != self.dataArray.count - 1) {
        cell.xk_clipType = XKCornerClipTypeNone;
    } else {
        cell.xk_clipType = XKCornerClipTypeBottomBoth;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark - 配置显示项

- (NSMutableDictionary *)displayCongfig {
    if (!_displayCongfig) {
        _displayCongfig = [NSMutableDictionary dictionary];
        {//XKReceiptInfoCellTypeSegment
            XKReceiptInfoDataConfig *config = [XKReceiptInfoDataConfig configTitle:@"发票类型" hasStar:YES placeHolder:@"" maxLength:0 minLength:0 inputType:0];
            _displayCongfig[@(XKReceiptInfoCellTypeSegment)] = config;
        }
        {//XKReceiptInfoCellTypeTitle
            if (self.currentModel.isPersonal) {
                XKReceiptInfoDataConfig *config = [XKReceiptInfoDataConfig configTitle:@"发票抬头" hasStar:YES placeHolder:@"请输入" maxLength:10 minLength:1 inputType:XKReceiptInfoInputTypeNormal];
                _displayCongfig[@(XKReceiptInfoCellTypeTitle)] = config;
            } else {
                XKReceiptInfoDataConfig *config = [XKReceiptInfoDataConfig configTitle:@"发票抬头" hasStar:YES placeHolder:@"请输入企业全称" maxLength:15 minLength:5 inputType:XKReceiptInfoInputTypeNormal];
                _displayCongfig[@(XKReceiptInfoCellTypeTitle)] = config;
            }
        }
        {//XKReceiptInfoCellTypeDefault
            XKReceiptInfoDataConfig *config = [XKReceiptInfoDataConfig configTitle:@"默认发票" hasStar:YES placeHolder:@"" maxLength:0 minLength:0 inputType:0];
            _displayCongfig[@(XKReceiptInfoCellTypeDefault)] = config;
        }
        if (!self.currentModel.isPersonal) {
            {//XKReceiptInfoCellTypeTaxNum
                XKReceiptInfoDataConfig *config = [XKReceiptInfoDataConfig configTitle:@"企业税号" hasStar:YES placeHolder:@"请输入企业税号" maxLength:20 minLength:15 inputType:XKReceiptInfoInputTypeNum];
                _displayCongfig[@(XKReceiptInfoCellTypeTaxNum)] = config;
            }
            {//XKReceiptInfoCellTypeAddr
                XKReceiptInfoDataConfig *config = [XKReceiptInfoDataConfig configTitle:@"企业地址" hasStar:NO placeHolder:@"请输入企业注册地址" maxLength:50 minLength:0 inputType:XKReceiptInfoInputTypeNormal];
                _displayCongfig[@(XKReceiptInfoCellTypeAddr)] = config;
            }
            {//XKReceiptInfoCellTypeBank
                XKReceiptInfoDataConfig *config = [XKReceiptInfoDataConfig configTitle:@"开户银行" hasStar:NO placeHolder:@"请输入企业开户银行" maxLength:20 minLength:0 inputType:XKReceiptInfoInputTypeNormal];
                _displayCongfig[@(XKReceiptInfoCellTypeBank)] = config;
            }
            {//XKReceiptInfoCellTypeBankNum
                XKReceiptInfoDataConfig *config = [XKReceiptInfoDataConfig configTitle:@"银行账号" hasStar:NO placeHolder:@"请输入企业银行账号" maxLength:19 minLength:0 inputType:XKReceiptInfoInputTypeNum];
                _displayCongfig[@(XKReceiptInfoCellTypeBankNum)] = config;
            }
        }
    }
    return _displayCongfig;
}

@end

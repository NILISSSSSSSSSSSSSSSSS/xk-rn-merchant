//
//  XKPersonalDataViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/4.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPersonalDataViewController.h"
#import "XKPersonalDataTableViewCell.h"
#import "XKPersonalDataHeaderTableViewCell.h"
#import "XKChangeNicknameViewController.h"
#import "XKChangePhonenumViewController.h"
#import "XKChangephoneNumSecViewController.h"
#import "XKBottomAlertSheetView.h"
#import "XKPhotoPickHelper.h"
#import "XKDatePickerView.h"
#import "XKSignatureViewController.h"
#import "XKPersonalDataModel.h"
#import "XKRegionPickerViewController.h"
#import "XKQRCodeCardController.h"

@interface XKPersonalDataViewController ()
<UITableViewDelegate,
UITableViewDataSource,
XKDatePickerViewDelegate,
XKRegionPickerViewControllerDelegate>

@property (nonatomic, strong) UITableView                              *mainBackTableView;
@property (nonatomic, strong) XKPersonalDataTableViewCell              *cell;
@property (nonatomic, strong) XKDatePickerView                         *dateView;
@property (nonatomic, strong) XKPhotoPickHelper                        *bottomSheetView;
@property (nonatomic, strong) XKPersonalDataModel                      *model;
@property (nonatomic, strong) XKRegionPickerViewController             *regionPickerViewController;

/**头像*/
@property (nonatomic, strong) UIImage      *headerImage;

/**签名，完整*/
@property (nonatomic, copy)   NSString     *allSignature;

/**m标题数组*/
@property (nonatomic, strong) NSArray      *cellNameArr;

@end

@implementation XKPersonalDataViewController
#pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self setNavTitle:@"个人资料" WithColor:[UIColor whiteColor]];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark – Private Methods

- (NSString *)currentDateForString {
    NSDate *date = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

-(void)initViews{
    [self.view addSubview:self.mainBackTableView];
    [self.mainBackTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(@(NavigationAndStatue_Height));
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(phoneNot:) name:XKChangephoneNumSecViewPhone object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:XKChangephoneNumSecViewPhone object:nil];
}
#pragma mark - Events

- (void)phoneNot:(NSNotification *)noti {
    self.model.phone = noti.userInfo[@"phone"];
    [XKUserInfo currentUser].phone = noti.userInfo[@"phone"];
    XKUserSynchronize;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
    [self.mainBackTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    NSLog(@"%@", noti.userInfo[@"phone"]);
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XKPersonalDataHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"headerCell" forIndexPath:indexPath];
        [headerCell.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar ? self.model.avatar : [XKUserInfo getCurrentUserAvatar]] placeholderImage:kDefaultHeadImg];
        return headerCell;
    }else {
        XKPersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.titleLabel.text = self.cellNameArr[indexPath.row + 1];

        if([cell.titleLabel.text isEqualToString:@"昵称"]) {
            cell.rightTitlelabel.text = self.model.nickname ? self.model.nickname : [XKUserInfo getCurrentUserName];
            [cell cutCornerForType:XKCornerCutTypeFitst WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50  * ScreenScale)];
        } else if ([cell.titleLabel.text isEqualToString:@"我的二维码"]){
            [cell.rightTitlelabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.appendImage(IMG_NAME(@"xk_btn_QR"));
            }];
        }else if ([cell.titleLabel.text isEqualToString:@"手机号码"]){
            if (self.model.phone && self.model.phone.length != 0) {
                cell.rightTitlelabel.text = self.model.phone;
            } else {
                cell.rightTitlelabel.text = @"未绑定";
            }
            [cell restoreFromCorner];
        }
        else if ([cell.titleLabel.text isEqualToString:@"性别"]){
            [cell restoreFromCorner];
            cell.rightTitlelabel.text = self.model.sexDes ? self.model.sexDes : @"请选择";
        }
        else if ([cell.titleLabel.text isEqualToString:@"生日"]){
            [cell restoreFromCorner];
            cell.rightTitlelabel.text = self.model.birthday ? self.model.birthdayDes : @"请选择";
        }
        else if ([cell.titleLabel.text isEqualToString:@"地址"]){
            [cell restoreFromCorner];
            cell.rightTitlelabel.text = self.model.address ? self.model.address : @"请选择";
        }
        else if ([cell.titleLabel.text isEqualToString:@"个性签名"]){
            [cell restoreFromCorner];
            if (self.model.signature.length >= 14) {
                NSString * modelSignatureStr = [self.model.signature substringWithRange:NSMakeRange(0, 14)];
                cell.rightTitlelabel.text = [NSString stringWithFormat:@"%@...",modelSignatureStr];
            }else {
                cell.rightTitlelabel.text = self.model.signature ?: @"本宝宝暂时还没有想到有趣的签名";
            }
            
        }
        else if([cell.titleLabel.text isEqualToString:@"安全码"]) {
            cell.rightTitlelabel.text = self.model.referralCode ? self.model.referralCode : @"1000000";
            [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50  * ScreenScale)];
        }
        
        if ([cell.titleLabel.text isEqualToString:@"安全码"]) {
            cell.nextImageView.hidden = YES;
        }else{
            cell.nextImageView.hidden = NO;
        }
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 8;
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 75 * ScreenScale;
    }
    else{
        return 50 * ScreenScale;
    }
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
    if (indexPath.section == 0) {
        [self.bottomSheetView showView];
    }else {
        XKPersonalDataTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.cell = cell;
        if ([cell.titleLabel.text isEqualToString:@"昵称"]) {
            [self cellForTheNickName];
            
        }else if ([cell.titleLabel.text isEqualToString:@"手机号码"]){
            XKChangePhonenumViewController *vc = [[XKChangePhonenumViewController alloc]init];
            if (self.model.phone && self.model.phone.length != 0) {
                vc.type = XKChangePhonenumViewControllerTypeChangePhoneNum;
            } else {
                vc.type = XKChangePhonenumViewControllerTypeSetPhoneNum;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.titleLabel.text isEqualToString:@"性别"]){
            [self cellForTheSex];
            
        }else if ([cell.titleLabel.text isEqualToString:@"生日"]){
            [self cellForTheBirthday];
            
        }else if ([cell.titleLabel.text isEqualToString:@"个性签名"]){
            [self cellForTheSignature];
            
        }
        else if ([cell.titleLabel.text isEqualToString:@"地址"]){
            self.regionPickerViewController = [XKRegionPickerViewController showRegionPickerViewWithController:self];
            self.regionPickerViewController.delegate = self;
            
        }else if ([cell.titleLabel.text isEqualToString:@"我的二维码"]){
            
            XKQRCodeCardController *vc = [[XKQRCodeCardController alloc]init];
            vc.canSave = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - 点击cell的方法
- (void)cellForTheNickName {
    XKWeakSelf(ws);
    XKChangeNicknameViewController *vc = [[XKChangeNicknameViewController alloc]init];
    vc.nickName = self.model.nickname;
    [vc setNicknameBlock:^(NSString *nickName) {
        ws.model.nickname = nickName;
        [self updateWithNickname:nickName Avatar:nil Sex:nil Birthday:nil Signature:nil provinceCode:nil cityCode:nil districtCode:nil];
        [ws.mainBackTableView  reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cellForTheSex {
    XKWeakSelf(ws);
    XKBottomAlertSheetView *sheet = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"保密",@"男",@"女",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
        NSLog(@"%ld%@", (long)index,choseTitle);
        NSString *str = @"";
        if ([choseTitle isEqualToString:@"男"]) {
            str = XKSexMale;
        }else if (([choseTitle isEqualToString:@"女"])) {
            str = XKSexFemale;
        }else {
            str = XKSexUnknow;
        }
        ws.model.sex = str;
        [self updateWithNickname:nil Avatar:nil Sex:str Birthday:nil Signature:nil provinceCode:nil cityCode:nil districtCode:nil];
        [ws.mainBackTableView  reloadData];
    }];
    [sheet show];
}

- (void)cellForTheBirthday {
    if (self.model.birthday) {
        self.dateView.CurrentDate = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:self.model.birthday];
    }else {
        self.dateView.CurrentDate = [self currentDateForString];
    }
    [self.dateView show];
}

- (void)cellForTheSignature {
    XKWeakSelf(ws);
    XKSignatureViewController *vc = [[XKSignatureViewController alloc]init];
    vc.signatureStr = self.allSignature;
    [vc setBlock:^(NSString *signature) {
        if (signature.length >= 14) {
            NSString * signatureStr = [signature substringWithRange: NSMakeRange(0, 14)];
            ws.model.signature = [NSString stringWithFormat:@"%@",signatureStr];
        }else{
            ws.model.signature = signature;
        }
        self.allSignature = signature;
        [ws updateWithNickname:nil Avatar:nil Sex:nil Birthday:nil Signature:signature provinceCode:nil cityCode:nil districtCode:nil];
        [ws.mainBackTableView  reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Custom Delegates
#pragma mark - THDatePickerViewDelegate
/**
 保存按钮代理方法
 
 @param time 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)time{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date =[dateFormat dateFromString:time];
    NSString *aStr = [XKTimeSeparateHelper backTimestampSecondStringWithDate:date];
    self.model.birthday = aStr;
    [self updateWithNickname:nil Avatar:nil Sex:nil Birthday:@(aStr.longLongValue) Signature:nil provinceCode:nil cityCode:nil districtCode:nil];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:1];
    [self.mainBackTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - XKRegionPickerViewControllerDelegate

/** 选择地区回调 */
- (void)regionPickerViewController:(XKRegionPickerViewController *)pickerViewController didSelectedRegion:(XKRegionPickerModel *)model {
    NSString *aStr = [NSString stringWithFormat:@"%@%@%@",model.provinceName,model.cityName,model.districtName];
    self.model.address = aStr;
    [XKUserInfo currentUser].address = aStr;
    XKUserSynchronize
    [self updateWithNickname:nil Avatar:nil Sex:nil Birthday:nil Signature:nil provinceCode:model.provinceCode cityCode:model.cityCode districtCode:model.districtCode];
    [self.mainBackTableView reloadData];
}

#pragma mark – netWork -

/**
 加载当前数据
 */
- (void)loadData {
    [HTTPClient postEncryptRequestWithURLString:GetXkUserDetailUrl timeoutInterval:20.0 parameters:@{} success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        XKPersonalDataModel *model = [XKPersonalDataModel yy_modelWithJSON:responseObject];
        self.model = model;
        self.allSignature = model.signature;
        self.dateView.CurrentDate = [XKTimeSeparateHelper backYMDStringByStrigulaSegmentWithTimestampString:self.model.birthday ?: [self currentDateForString]];
        [self.mainBackTableView reloadData];
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
        NSLog(@"%@", error.message);
    }];
}

/**
 上传头像

 @param avatar 头像
 @param avatarUrlBlock 头像的回调事件
 */
- (void)uploadAvatar:(NSString *)avatar AvatarUrlBlock:(void(^)(NSString *avatar))avatarUrlBlock{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"avatar"] = avatar;
    [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserUpdateAvatar/1.0" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NSDictionary * dic = [responseObject xk_jsonToDic];
        avatarUrlBlock(dic[@"avatarUrl"]);
        [XKHudView showSuccessMessage:@"更新成功"];
    } failure:^(XKHttpErrror *error) {
        [XKHudView showErrorMessage:error.message];
    }];
}

/**
 上传更新资料

 @param nickname 昵称
 @param avatar 头像
 @param sex 性别
 @param birthday 生日
 @param signature 签名
 @param provinceCode 省code
 @param cityCode 城市code
 @param districtCode 地区code
 */
- (void)updateWithNickname:(NSString *)nickname Avatar:(NSString *)avatar Sex:(NSString *)sex Birthday:(NSNumber *)birthday Signature:(NSString *)signature provinceCode:(NSString *)provinceCode cityCode:(NSString *)cityCode districtCode:(NSString *)districtCode{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"nickname"] = nickname;
    parameters[@"avatar"] = avatar;
    parameters[@"sex"] = sex;
    parameters[@"birthday"] = birthday;
    parameters[@"signature"] = signature;
    parameters[@"provinceCode"] = provinceCode;
    parameters[@"cityCode"] = cityCode;
    parameters[@"districtCode"] = districtCode;
    [XKHudView showLoadingTo:self.mainBackTableView animated:YES];
    [HTTPClient postEncryptRequestWithURLString:GetXkUserUpdateUrl timeoutInterval:20.0 parameters:[parameters copy] success:^(id responseObject) {
        [XKHudView hideHUDForView:self.mainBackTableView animated:YES];
        if (nickname) {
            [XKUserInfo currentUser].nickname = self.model.nickname;
            XKUserSynchronize;
        }
        if (sex) {
            [XKUserInfo currentUser].sex = sex;
            XKUserSynchronize;
        }
        if (birthday) {
            [XKUserInfo currentUser].birthday = self.model.birthday;
            XKUserSynchronize;
        }
        if (signature) {
            [XKUserInfo currentUser].signature = signature;
            XKUserSynchronize;
        }
        if (avatar) {
            [XKUserInfo currentUser].avatar = avatar;
            XKUserSynchronize;
        }
        [XKHudView showSuccessMessage:@"更新成功"];
    } failure:^(XKHttpErrror *error) {
        [XKHudView hideHUDForView:self.mainBackTableView animated:YES];
        [XKHudView showErrorMessage:error.message to:self.mainBackTableView animated:YES];
    }];
}

#pragma mark – Getters and Setters

- (UITableView *)mainBackTableView {
    if (!_mainBackTableView) {
        _mainBackTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainBackTableView.backgroundColor = UIColorFromRGB(0xEEEEEE);
        _mainBackTableView.delegate = self;
        _mainBackTableView.dataSource = self;
        _mainBackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainBackTableView.bounces = NO;
        _mainBackTableView.scrollEnabled = NO;
        [_mainBackTableView registerClass:[XKPersonalDataTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_mainBackTableView registerClass:[XKPersonalDataHeaderTableViewCell class] forCellReuseIdentifier:@"headerCell"];
        
        if (@available(iOS 11.0, *)) {
            _mainBackTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _mainBackTableView;
}

- (XKPhotoPickHelper *)bottomSheetView {
    if(!_bottomSheetView) {
        XKWeakSelf(ws);
        _bottomSheetView = [[XKPhotoPickHelper alloc] init];
        _bottomSheetView.allowCrop = YES;
        _bottomSheetView.maxCount = 1;
        [_bottomSheetView handleVideoChoseWithNeeded:NO];
        _bottomSheetView.choseImageBlcok = ^(NSArray<UIImage *> * _Nullable images) {
            for (UIImage *image in images) {
                [[XKUploadManager shareManager]uploadImage:image withKey:@"headerImage" progress:^(CGFloat progress) {
                } success:^(NSString *url) {
                    NSString *imageUrl = kQNPrefix(url);
                    ws.model.avatar = imageUrl;
                    [ws.mainBackTableView reloadData];
                    [ws updateWithNickname:nil Avatar:imageUrl Sex:nil Birthday:nil Signature:nil provinceCode:nil cityCode:nil districtCode:nil];
                } failure:^(id data) {
                }];
            }
        };
        
    }
    return _bottomSheetView;
}

- (NSArray *)cellNameArr {
    if (!_cellNameArr) {
        _cellNameArr = @[@"头像",@"昵称",@"我的二维码",@"手机号码",@"性别",@"生日",@"地址",@"个性签名",@"安全码"];
    }
    return _cellNameArr;
}

- (XKDatePickerView *)dateView {
    if (!_dateView) {
        _dateView = [[XKDatePickerView alloc] init];
        _dateView.delegate = self;
    }
    return _dateView;
}

- (XKPersonalDataModel *)model {
    if (!_model) {
        _model = [[XKPersonalDataModel alloc]init];
    }
    return _model;
}
@end

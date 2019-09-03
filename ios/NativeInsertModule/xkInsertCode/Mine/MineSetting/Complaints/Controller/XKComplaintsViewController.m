//
//  XKComplaintsViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKComplaintsViewController.h"
#import "XKComplaintsTextViewTableViewCell.h"
#import "XKComplaintsUpPictureTableViewCell.h"
#import "XKPersonalDataTableViewCell.h"
#import "XKUploadManager.h"
#import "XKComplaintVideoImageModel.h"
#import "XKAlertUtil.h"
#import "XKChangePhonenumViewController.h"

@interface XKComplaintsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) UIButton       *nextButton;
@property (nonatomic, copy)   NSString       *textViewStr;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation XKComplaintsViewController
#pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"我要投诉" WithColor:[UIColor whiteColor]];
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self verifyPhoneState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)verifyPhoneState{
    
    // 验证绑定手机号
    NSString *phoneNum = [XKUserInfo currentUser].phone;
    if (!phoneNum || phoneNum.length == 0) {
        [XKAlertUtil presentAlertViewWithTitle:nil message:@"您还未绑定手机号，是否立即绑定" cancelTitle:@"取消" defaultTitle:@"去绑定" distinct:NO cancel:^{
            [self.navigationController popViewControllerAnimated:YES];
            return;
        } confirm:^{
            XKChangePhonenumViewController *changePhoncenumViewController = [XKChangePhonenumViewController new];
            changePhoncenumViewController.type = XKChangePhonenumViewControllerTypeSetPhoneNum;
            [self.navigationController pushViewController:changePhoncenumViewController animated:YES];
        }];
    }
}

#pragma mark – Private Methods
- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NavigationAndStatue_Height));
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (UIView *)footerView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    [view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.top.equalTo(@20);
        make.height.equalTo(@50);
    }];
    return view;
}
#pragma mark - Events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)nextAction:(UIButton *)sender {
    XKWeakSelf(ws);
    if (self.textViewStr.length < 4) {
        [XKHudView showErrorMessage:@"投诉字数小于4，请重新填写"];
        return;
    }
    if (self.textViewStr.length > 250) {
        [XKHudView showErrorMessage:@"投诉字数大于500，请重新填写"];
        return;
    }
    [self uploadMediaComplete:^(NSString *error, id data) {
        NSLog(@"%@", error);
        [ws nextActionNetWork];
        
    }];
}
#pragma mark - Custom Delegates

#pragma mark – Getters and Setters

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [self footerView];
        [_tableView registerClass:[XKPersonalDataTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:[XKComplaintsTextViewTableViewCell class] forCellReuseIdentifier:@"textViewCell"];
        [_tableView registerClass:[XKComplaintsUpPictureTableViewCell class] forCellReuseIdentifier:@"pictureCell"];

        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}
- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc]init];
        [_nextButton setTitle:@"提交" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
        _nextButton.layer.masksToBounds = true;
        _nextButton.layer.cornerRadius = 10 * ScreenScale;
        _nextButton.backgroundColor = HEX_RGB(0x4A90FA);
        [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
         XKComplaintsTextViewTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"textViewCell" forIndexPath:indexPath];
        [textCell setTextViewDidEndEditingBlock:^(NSString *text) {
            self.textViewStr = text;
        }];
        [textCell cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 173  * ScreenScale)];
        return textCell;
    }else if (indexPath.section == 1){
        XKComplaintsUpPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pictureCell" forIndexPath:indexPath];
        self.dataArray = cell.dataArray;
        XKWeakSelf(ws);
        cell.block = ^{
            [ws.view endEditing:YES];
        };
        [cell cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 120  * ScreenScale)];
        cell.selectBlock = ^(NSIndexPath *indexpath, UICollectionView *collectionView) {
            XKComplaintVideoImageModel *model = ws.dataArray[indexpath.item];
            if (model.isVideo) {
                [XKGlobleCommonTool playVideoWithUrl:model.videoUrl];
            }else {
                [XKGlobleCommonTool showSingleImgWithImg:model.image viewController:self];
            }
        };
        return cell;
    }
    else if (indexPath.section == 2){
        XKPersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

        if (indexPath.row == 0) {
            cell.titleLabel.text = @"手机号码";
            cell.rightTitlelabel.text = [XKUserInfo currentUser].phone;
            cell.nextImageView.hidden = YES;
            [cell cutCornerForType:XKCornerCutTypeOnly WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50  * ScreenScale)];
        }else{
            cell.titleLabel.text = @"发生时间";
            cell.rightTitlelabel.text = @"2018-08-01 12:00:30";
            [cell cutCornerForType:XKCornerCutTypeLast WithCellFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50  * ScreenScale)];
        }
        return cell;
    }
    else{
        return nil;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return 1;
    }
    else if (section == 2){
        return 1;
    }
    else{
        return 0;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 173 * ScreenScale;
    }else if (indexPath.section == 1){
        return 120 * ScreenScale;
    }
    else{
        return 50 * ScreenScale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10 * ScreenScale;
    }else {
        return 0.00000001f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
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
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            
        }
    }
}
#pragma mark - 投诉上传
-(void)nextActionNetWork {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableArray *imageArray = [NSMutableArray array];
    NSString *videoUrl = @"";
    
    for (XKComplaintVideoImageModel *mediaInfo in self.dataArray) {
        if (!mediaInfo.isVideo) {
            [imageArray addObject:mediaInfo.imageNetAddr];
        }else {
            videoUrl = mediaInfo.videoNetAddr;
        }
    }
    parameters[@"content"] = self.textViewStr;
    parameters[@"userType"] = @"user";
    parameters[@"app"] = @"ua";
    parameters[@"clientVersion"] = XKAppVersion;
    parameters[@"images"] = imageArray.copy;
    parameters[@"video"] = videoUrl;
    
    [HTTPClient postEncryptRequestWithURLString:@"sys/ua/personalFeedbackCreate/1.0" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            [XKHudView hideHUDForView:self.tableView animated:YES];
            [XKHudView showSuccessMessage:@"提交成功" to:self.tableView animated:YES];
        });
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(XKHttpErrror *error) {
        NSLog(@"%@", error.message);
        dispatch_async(dispatch_get_main_queue(), ^{
            [XKHudView hideHUDForView:self.tableView animated:YES];
        });

    }];
    
}


#pragma mark - GCD统一上传图片视频
- (void)uploadMediaComplete:(void(^)(NSString *error, id data))complete {
    dispatch_async(dispatch_get_main_queue(), ^{
        [XKHudView showLoadingTo:self.tableView animated:YES];
    });
    dispatch_group_t group = dispatch_group_create();
    // 核心思想 资源上传完毕统一回调 失败再次上传时不会重复上传
    NSArray *mediaArray = self.dataArray.copy;
    if (mediaArray.count <= 0) {
        return;
    }
    for (XKComplaintVideoImageModel *mediaInfo in mediaArray) {
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            if (mediaInfo.isVideo) { // 是视频
                [self requestUploadVideoInfo:mediaInfo complete:^(NSString *error, id data) {
                    dispatch_semaphore_signal(sema);
                }];
            } else {
                [self requestUploadPicInfo:mediaInfo complete:^(NSString *error, id data) {
                    dispatch_semaphore_signal(sema);
                }];
            }
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 请求完成 这里判断一下资源是否已经全部上传成功
        if ([self checkMediaAllUpload]) {
            complete(nil,@"嘿嘿 别用我我是酱油");
        } else {
            complete(@"网络错误",nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                [XKHudView hideHUDForView:self.tableView animated:YES];
            });
        }
    });
}

#pragma mark - 上传视频
- (void)requestUploadVideoInfo:(XKComplaintVideoImageModel *)info complete:(void(^)(NSString *error, id data))complete {
    if (info.videoFirstImgNetAddr.length != 0 && info.videoNetAddr.length != 0) {
        complete(nil,@"");
    } else {
        [[XKUploadManager shareManager] uploadVideoWithUrl:info.videoUrl FirstImg:info.image WithKey:@"complaint"  Progress:nil Success:^(NSString *videoKey, NSString *imgKey) {
            info.videoFirstImgNetAddr = kQNPrefix(imgKey);
            info.videoNetAddr = kQNPrefix(videoKey);
            complete(nil,@"");
        } Failure:^(NSString *error) {
            complete(error,nil);
        }];
    }
}


#pragma mark - 上传图片
- (void)requestUploadPicInfo:(XKComplaintVideoImageModel *)info complete:(void(^)(NSString *error, id data))complete {
    if(info.imageNetAddr.length != 0) {
        complete(nil,info.imageNetAddr);
    } else {
        [[XKUploadManager shareManager] uploadImage:info.image withKey:@"complaint" progress:nil success:^(NSString *key) {
            info.imageNetAddr = kQNPrefix(key);
            complete(nil,info.imageNetAddr);
        } failure:^(id data) {
            complete(nil,info.imageNetAddr);
        }];
    }
}

#pragma mark - 检测资源是否全部上传完成
- (BOOL)checkMediaAllUpload {
    NSArray *mediaArr = self.dataArray.copy;
    if (mediaArr.count == 0) {
        return YES;
    } else {
        for (XKComplaintVideoImageModel *info in mediaArr) {
            if (info.isVideo) {
                if (info.videoNetAddr.length == 0 || info.videoFirstImgNetAddr.length == 0) {
                    return NO;
                }
            } else {
                if (info.imageNetAddr.length == 0) {
                    return NO;
                }
            }
        }
        return YES;
    }
}

@end

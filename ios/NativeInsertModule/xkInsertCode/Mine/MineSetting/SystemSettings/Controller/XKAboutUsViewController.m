//
//  XKAboutUsViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/9/6.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAboutUsViewController.h"
#import "XKPersonalDataTableViewCell.h"
#import "UIView+XKCornerRadius.h"
#import "XKCopyrightInformationViewController.h"
#import <StoreKit/StoreKit.h>
@interface XKAboutUsViewController ()<UITableViewDelegate,UITableViewDataSource,SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSArray        *dataArray;

@end

@implementation XKAboutUsViewController
#pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"关于我们" WithColor:[UIColor whiteColor]];
    [self initViews];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark – Private Methods
- (void)initViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NavigationAndStatue_Height));
        make.left.bottom.right.equalTo(self.view);
    }];
}
- (void)initData {
}
#pragma mark - Events

#pragma mark - Custom Delegates

#pragma mark – Getters and Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[XKPersonalDataTableViewCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"版权信息",@"评价我们"];
    }
    return _dataArray;
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XKPersonalDataTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    cell.xk_radius = 5;
    cell.xk_openClip = YES;
    if (indexPath.row == 0) {
        cell.xk_clipType = XKCornerClipTypeTopLeft | XKCornerClipTypeTopRight;
    }else if (indexPath.row == 1){
        cell.xk_clipType = XKCornerClipTypeBottomLeft | XKCornerClipTypeBottomRight;
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120 * ScreenScale)];
    UIImageView *headerImageView = [[UIImageView alloc]init];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1540221593857&di=8628c9ec1c77197aafb1615f38b8b5de&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F26%2F00%2F04%2F58ab0ef627d23_1024.jpg"]];
    [headerView addSubview:headerImageView];
    headerImageView.clipsToBounds = YES;
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.mas_equalTo(20);
        make.height.equalTo(@(60 * ScreenScale));
        make.width.equalTo(@(80 * ScreenScale));
    }];
    UILabel *label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"晓可广场v%@版",XKAppVersion];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = HEX_RGB(0x999999);
    label.font = XKFont(XK_PingFangSC_Regular, 12);
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView);
        make.top.equalTo(headerImageView.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50 * ScreenScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 120 * ScreenScale;
    }else {
        return 0.00000001f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00000001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        XKCopyrightInformationViewController *vc = [[XKCopyrightInformationViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        [self addAppReview];
 }
}

/**
 跳转到appstore评分
 */
- (void)gotoAppStore {
    NSString *APPID = @"1373539611";
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", APPID];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
}

/**
 本地跳转出appstore页面
 */
- (void)loadAppStoreController {
    NSString *APPID = @"1373539611";
    SKStoreProductViewController*storeProductViewContorller = [[SKStoreProductViewController alloc]init];
    storeProductViewContorller.delegate=self;
    [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:APPID}completionBlock:^(BOOL result,NSError *error)   {
        if(error)  {
            NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
        }else{
            // 模态弹出appstore
            dispatch_async(dispatch_get_main_queue(), ^{
               [self presentViewController:storeProductViewContorller animated:YES completion:nil];
            });
        }
    }];
}

//AppStore取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 弹框评分
 */
- (void)addAppReview{
    NSString *APPID = @"1373539611";
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"亲，喜欢晓可广场么?给个五星好评吧!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    //跳转APPStore 中应用的撰写评价页面
    UIAlertAction *review = [UIAlertAction actionWithTitle:@"我要吐槽" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *appReviewUrl = [NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",APPID]];//换成应用的 APPID
        /// 大于等于10.0系统使用此openURL方法
        [[UIApplication sharedApplication] openURL:appReviewUrl options:@{} completionHandler:nil];
    }];
    //不做任何操作
    UIAlertAction *noReview = [UIAlertAction actionWithTitle:@"用用再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVC removeFromParentViewController];
    }];
    
    [alertVC addAction:review];
    [alertVC addAction:noReview];
    //判断系统,是否添加五星好评的入口
    if (@available(iOS 10.3, *)) {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
            UIAlertAction *fiveStar = [UIAlertAction actionWithTitle:@"五星好评" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication].keyWindow endEditing:YES];
                //  五星好评
                [SKStoreReviewController requestReview];
            }];
            [alertVC addAction:fiveStar];
        }
    } else {
        // Fallback on earlier versions
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[UIApplication sharedApplication]keyWindow] rootViewController] presentViewController:alertVC animated:YES completion:nil];
    });
}
@end

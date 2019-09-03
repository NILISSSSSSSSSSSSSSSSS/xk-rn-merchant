//
//  XKPayAlertSheetView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/5.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPayAlertSheetView.h"
#import "XKBottomAlertSheetCell.h"
#import "XKPayCenter.h"
#import "XKPayForMallViewController.h"
@interface XKPayAlertSheetView () <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong)UITableView *tableView;
/**
 上方的遮盖viwe
 */
@property (nonatomic, strong)UIView *coverView;
/**
 数据源
 */
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *imgNameArr;
/**
 顶部视图 包括标题/线/支付金额
 */
@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UILabel *priceLabel;

@property (nonatomic, copy)void(^choseBlock)(NSInteger index, NSString *choseTitle);

@end

@implementation XKPayAlertSheetView
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化默认数据
        [self createDefaultData];
        // 初始化UI
        [self createUI];
    }
    return self;
}

#pragma mark - 初始化默认数据
- (void)createDefaultData {
    self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 5 * 50 + 70 + kBottomSafeHeight);
    self.coverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.tableView.height);
    _titleArr = @[@"支付宝",@"微信",@"银行卡",@"晓可币支付"];
    _imgNameArr = @[@"xk_btn_order_pay_alipay",@"xk_btn_order_pay_wechat",@"xk_btn_order_pay_bank",@"xk_btn_order_pay_other"];
    XKWeakSelf(ws);
//    self.choseBlock = ^(NSInteger index, NSString *choseTitle) {
//        switch (index) {
//            case 0:
//                {
//
//                }
//                break;
//            case 1:
//                {
//
//                }
//                break;
//            case 2:
//                {
//
//                }
//                break;
//            case 3:
//                {

//                }
//                break;
//
//            default:
//                break;
//        }
//
//    };
}

#pragma mark - 初始化UI
- (void)createUI {
    self.frame = [UIScreen mainScreen].bounds;
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    dismissTap.delegate = self;
    [self addGestureRecognizer:dismissTap];
    [self addSubview:self.tableView];
    //[self addSubview:self.coverView];
}

#pragma mark - 显示
+ (void)showWithResultBlock:(void(^)(NSInteger index))choseBlock {
    XKPayAlertSheetView *paySheet = [XKPayAlertSheetView new];
    paySheet.choseBlock = ^(NSInteger index, NSString *choseTitle) {
    choseBlock(index);
    };
    paySheet.backgroundColor = RGBA(0, 0, 0, 0.5);
    [[UIApplication sharedApplication].keyWindow addSubview:paySheet];
    [UIView animateWithDuration:0.3 animations:^{
        paySheet.backgroundColor = RGBA(0, 0, 0, 0.5);
        paySheet.tableView.bottom = paySheet.height;
    }];
}

#pragma mark - 消失
- (void)dismissSelf {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0);
        self.tableView.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma 手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma tableview代理
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = _titleArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_imgNameArr[indexPath.row]];
    cell.imageView.contentMode = UIViewContentModeCenter;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = UIColorFromRGB(0x222222);
    cell.textLabel.font = XKRegularFont(14);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(self.choseBlock) {
        if(indexPath.section == 0) {
            NSString *title = _titleArr[indexPath.row];
            self.choseBlock(indexPath.row, title);
            [self dismissSelf];
        } else {
            [self dismissSelf];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];

    return  footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorColor = XKSeparatorLineColor;
        [_tableView registerClass:[XKBottomAlertSheetCell class] forCellReuseIdentifier:@"XKBottomAlertSheetCell"];
    }
    return _tableView;
    
}

- (UIView *)coverView {
    if(!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}

- (UIView *)headerView {
    if(!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        titleLabel.text = @"选择支付方式";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = XKRegularFont(17);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = XKSeparatorLineColor;
        [_headerView addSubview:lineView];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH, 70)];
        _priceLabel.text = @"支付金额：¥3500 ";
        _priceLabel.textColor = UIColorFromRGB(0xee6161);
        _priceLabel.font = XKRegularFont(17);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:_priceLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 119, SCREEN_WIDTH, 1)];
        line.backgroundColor = XKSeparatorLineColor;
        [_headerView addSubview:line];
        
    };
    return _headerView;
}
@end

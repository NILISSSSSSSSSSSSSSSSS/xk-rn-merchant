//
//  XKAdressTagViewController.m
//  XKSquare
//
//  Created by RyanYuan on 2018/9/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKAdressTagViewController.h"
#import "XKAdressTagStringTableViewCell.h"

static const CGFloat kAdressTagTableViewFooterHeight = 8.0;
static const CGFloat kAdressTagTableViewCellHeight = 44.0;
static const CGFloat kAdressTagViewControllerCustomTagViewHeight = 44.0;
static const CGFloat kAdressTagTableViewContainerViewMaxHeight = 400;
NSString *const kAdressTagStringTableViewCellIdentifier = @"XKAdressTagStringTableViewCell";
NSString *const kAdressTagViewControllerCancleButtonTitle = @"取消";

@interface XKAdressTagViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, XKAdressTagStringTableViewCellDelegate>

@property (nonatomic,weak) UIViewController *superViewController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *dataArr;
//@property (nonatomic,strong) NSString *customTagString;
//@property (nonatomic, strong) NSString *selectedTagString;

@end

@implementation XKAdressTagViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.dataArr = @[@"家", @"学校", @"公司"].mutableCopy;
    [self initializeViews];
    [self originalPositionAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changePositionAnimation];
}

/**
 设置动画初始位置
 */
- (void)originalPositionAnimation {
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(280);
    }];
    self.maskView.alpha = 0.0;
    [self.view layoutIfNeeded];
}

/**
 设置动画
 */
- (void)changePositionAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        [self.view layoutIfNeeded];
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
    }];
}
#pragma mark - public methods

+ (XKAdressTagViewController *)showRegionPickerViewWithController:(UIViewController *)viewController {
    
    XKAdressTagViewController *regionPickerViewController = [XKAdressTagViewController new];
    if ([viewController isKindOfClass:[viewController class]]) {
        regionPickerViewController.superViewController = viewController;
        regionPickerViewController.modalPresentationStyle = UIModalPresentationCustom;
        [viewController presentViewController:regionPickerViewController animated:NO completion:nil];
    }
    return regionPickerViewController;
}

+ (XKAdressTagViewController *)showRegionPickerViewWithController:(UIViewController *)viewController tag:(NSString *)tagString {

    XKAdressTagViewController *regionPickerViewController = [self showRegionPickerViewWithController:viewController];
    [regionPickerViewController insertTagToDataArr:tagString];
    [regionPickerViewController.tableView reloadData];
    return regionPickerViewController;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.dataArr.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kAdressTagTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return kAdressTagTableViewFooterHeight;
    } else {
        return 0;
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        XKAdressTagStringTableViewCell *adressTagStringTableViewCell = [tableView dequeueReusableCellWithIdentifier:kAdressTagStringTableViewCellIdentifier forIndexPath:indexPath];
        adressTagStringTableViewCell.delegate = self;
        [adressTagStringTableViewCell configAdressTagStringTableViewCellWithTagString:self.dataArr[indexPath.row]];
        return adressTagStringTableViewCell;
    } else {
        XKAdressTagStringTableViewCell *adressTagStringTableViewCell = [tableView dequeueReusableCellWithIdentifier:kAdressTagStringTableViewCellIdentifier forIndexPath:indexPath];
        adressTagStringTableViewCell.delegate = self;
        [adressTagStringTableViewCell configAdressTagStringTableViewCellWithTagString:kAdressTagViewControllerCancleButtonTitle];
        return adressTagStringTableViewCell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kAdressTagTableViewFooterHeight)];
    separatorView.backgroundColor = XKSeparatorLineColor;
    return separatorView;
}

#pragma mark - XKAdressTagStringTableViewCellDelegate

- (void)addressTagStringCellDidSelected:(XKAdressTagStringTableViewCell *)cell tagString:(NSString *)tagString {
    if (![tagString isEqualToString:kAdressTagViewControllerCancleButtonTitle]) {
        [self.delegate adressTagViewController:self didSelectedTag:tagString];
    }
    [self dismissViewController];
}

#pragma mark events

- (void)dismissViewController {
    
    [self.superViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)clickConfirmButton:(UIButton *)sender {
    
    NSString *currentInputTag = self.textField.text;
    [self insertTagToDataArr:currentInputTag];
    
    [self.delegate adressTagViewController:self didSelectedTag:self.textField.text];
    [self.superViewController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - private methods

- (void)initializeViews {
    
    // 控制器根视图
    self.view.backgroundColor = [UIColor clearColor];
    
    // 标签选择容器
    UIView *containerView = [UIView new];
    [self.view addSubview:containerView];
    CGFloat containerViewHeight = kAdressTagTableViewCellHeight * self.dataArr.count + kAdressTagTableViewCellHeight + kAdressTagTableViewFooterHeight + kAdressTagViewControllerCustomTagViewHeight;
    containerViewHeight = containerViewHeight > kAdressTagTableViewContainerViewMaxHeight ? kAdressTagTableViewContainerViewMaxHeight : containerViewHeight;
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(containerViewHeight);
    }];
    self.contentView = containerView;
    // 遮罩视图
    UIView *maskView = [UIView new];
    maskView.backgroundColor = [UIColor grayColor];
    maskView.alpha = 0.0;
    self.maskView = maskView;
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(containerView.mas_top);
        make.width.equalTo(self.view.mas_width);
    }];
    
    // 自定义标签视图
    UIView *customTagView = [UIView new];
    customTagView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:customTagView];
    [customTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView.mas_top);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(44);
    }];
    
    // 确定按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = XKMainTypeColor;
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    confirmButton.layer.cornerRadius = 5;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [customTagView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(customTagView.mas_centerY);
        make.right.equalTo(customTagView.mas_right).offset(-25);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(30);
    }];
    
    // 输入自定义标签文本框
    UITextField *textField = [UITextField new];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.layer.borderColor = [UIColor grayColor].CGColor;
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 5;
    textField.placeholder = @"自定义标签";
    textField.font = [UIFont fontWithName:XK_PingFangSC_Regular size:12.0];
    [customTagView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(customTagView.mas_left).offset(25);
        make.right.equalTo(confirmButton.mas_left).offset(-10);
        make.centerY.equalTo(customTagView.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    self.textField = textField;
    
    // 标签选择视图
    [containerView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customTagView.mas_bottom);
        make.left.equalTo(containerView.mas_left);
        make.bottom.equalTo(containerView.mas_bottom);
        make.right.equalTo(containerView.mas_right);
    }];
}

- (void)insertTagToDataArr:(NSString *)tagString {
    
    if (tagString && ![tagString isEqualToString:@""]) {
        BOOL hasSameTagString = NO;
        for (NSString *tempTagString in self.dataArr) {
            if ([tempTagString isEqualToString:tagString]) {
                hasSameTagString = YES;
                break;
            }
        }
        if (!hasSameTagString) {
            [self.dataArr insertObject:tagString atIndex:0];
        }
    }
}

#pragma mark setter and getter

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[XKAdressTagStringTableViewCell class] forCellReuseIdentifier:kAdressTagStringTableViewCellIdentifier];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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

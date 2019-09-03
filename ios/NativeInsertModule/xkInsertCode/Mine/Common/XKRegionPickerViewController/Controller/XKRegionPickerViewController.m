////
////  XKRegionPickerViewController.m
////  XKSquare
////
////  Created by RyanYuan on 2018/8/30.
////  Copyright © 2018年 xk. All rights reserved.
////
//
#import "XKRegionPickerViewController.h"
#import "XKCityDBManager.h"
#import "XKCityListModel.h"
//
@interface XKRegionPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) XKRegionPickerModel *selectedModel;
@property (nonatomic,weak) UIViewController *superViewController;
@property (nonatomic, strong) UIPickerView *regionPickerView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *regionPickerContainerView;
@property (nonatomic, strong) NSMutableArray *provinceArr;
@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) NSMutableArray *districtArr;

@property (nonatomic, strong) XKRegionPickerModel *selectedRegionPickerModel;
//
@end
//
@implementation XKRegionPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeViews];
    [self originalPositionAnimation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changePositionAnimation];
    [self loadRegionData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 设置弹出动画初始位置
 */
- (void)originalPositionAnimation {
    [self.regionPickerContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(280);
    }];
    self.maskView.alpha = 0.0;
    [self.view layoutIfNeeded];
}

/**
 设置弹出动画
 */
- (void)changePositionAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        [self.regionPickerContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        [self.view layoutIfNeeded];
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
    }];
}
#pragma mark - public methods

+ (XKRegionPickerViewController *)showRegionPickerViewWithController:(UIViewController *)viewController {
    XKRegionPickerViewController *regionPickerViewController = [XKRegionPickerViewController new];
    if ([viewController isKindOfClass:[viewController class]]) {
        regionPickerViewController.superViewController = viewController;
        regionPickerViewController.modalPresentationStyle = UIModalPresentationCustom;
        [viewController presentViewController:regionPickerViewController animated:NO completion:^{}];
    }
    return regionPickerViewController;
}

+ (XKRegionPickerViewController *)showRegionPickerViewWithController:(UIViewController *)viewController regionPickerModel:(XKRegionPickerModel *)model {

    XKRegionPickerViewController *regionPickerViewController = [self showRegionPickerViewWithController:viewController];
    regionPickerViewController.selectedModel = model;
    return regionPickerViewController;
}

#pragma mark-- UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (component == 0) {
        return self.provinceArr.count;
    } else if (component == 1) {
        return self.cityArr.count;
    } else {
        return self.districtArr.count;
    }
}

#pragma mark-- UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {

    UILabel *label=[[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.minimumScaleFactor = 0.5;
    label.adjustsFontSizeToFitWidth = YES;

    if (component == 0) {
        if (self.provinceArr.count > row) {
            DataItem *aDataItem = self.provinceArr[row];
            NSString *name = aDataItem.name;
            if (name && ![name isEqualToString:@""]) {
                label.text = name;
            }
        }
    } else if (component == 1) {
        if (self.cityArr.count > row) {
            DataItem *aDataItem = self.cityArr[row];
            NSString *name = aDataItem.name;
            if (name && ![name isEqualToString:@""]) {
                label.text = name;
            }
        }
    } else if(component == 2){
        if (self.districtArr.count > row) {
            DataItem *aDataItem = self.districtArr[row];
            NSString *name = aDataItem.name;
            if (name && ![name isEqualToString:@""]) {
                label.text = name;
            }
        }
    }
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    if (component == 0) {
        return [UIScreen mainScreen].bounds.size.width/3;
    } else if (component == 1) {
        return [UIScreen mainScreen].bounds.size.width/3;
    } else {
        return [UIScreen mainScreen].bounds.size.width/3;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 37;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (component == 0) {
        [self updateCityArrAndDistrict:component andRow:row];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }

    if (component == 1) {
        [self updateCityArrAndDistrict:component andRow:row];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
}

#pragma mark - private methods

- (void)loadRegionData {

    NSArray *provinceArr = [[XKCityDBManager shareInstance] getAllProvince];
    self.provinceArr = provinceArr.mutableCopy;
    DataItem *defaultDataItem = [DataItem new];
    defaultDataItem.name = @"请选择(省)";
    [self.provinceArr insertObject:defaultDataItem atIndex:0];

    if (self.selectedModel != nil) {

        // 自动选择省市区
        NSString *provinceCode = self.selectedModel.provinceCode;
        NSString *cityCode = self.selectedModel.cityCode;
        NSString *districtCode = self.selectedModel.districtCode;

        NSInteger selectedProvinceIndex = 0;
        NSInteger selectedCityIndex = 0;
        NSInteger selectedDistrictIndex = 0;

        if (self.provinceArr && self.provinceArr.count > 0) {
            for (NSInteger index = 0; index < self.provinceArr.count; index++) {
                DataItem *provinceDataItem = self.provinceArr[index];
                if ([provinceCode isEqualToString:provinceDataItem.code]) {
                    selectedProvinceIndex = index;
                    break;
                }
            }
        }
        [self updateCityArrAndDistrict:0 andRow:selectedProvinceIndex];

        if (self.cityArr && self.cityArr.count > 0) {
            for (NSInteger index = 0; index < self.cityArr.count; index++) {
                DataItem *cityDataItem = self.cityArr[index];
                if ([cityCode isEqualToString:cityDataItem.code]) {
                    selectedCityIndex = index;
                    break;
                }
            }
        }
        [self updateCityArrAndDistrict:1 andRow:selectedCityIndex];

        if (self.districtArr && self.districtArr.count > 0) {
            for (NSInteger index = 0; index < self.districtArr.count; index++) {
                DataItem *districtDataItem = self.districtArr[index];
                if ([districtCode isEqualToString:districtDataItem.code]) {
                    selectedDistrictIndex = index;
                    break;
                }
            }
        }
        [self.regionPickerView reloadAllComponents];
        [self.regionPickerView selectRow:selectedProvinceIndex inComponent:0 animated:YES];
        [self.regionPickerView selectRow:selectedCityIndex inComponent:1 animated:YES];
        [self.regionPickerView selectRow:selectedDistrictIndex inComponent:2 animated:YES];
    } else {
        [self.regionPickerView reloadAllComponents];
    }
}

- (void)initializeViews {

    // 控制器根视图
    self.view.backgroundColor = [UIColor clearColor];

    // 地区选择容器
    UIView *regionPickerContainerView = [UIView new];
    [self.view addSubview:regionPickerContainerView];
    [regionPickerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(280);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(280 + kBottomSafeHeight);
    }];
    self.regionPickerContainerView = regionPickerContainerView;
    // 遮罩视图
    UIView *maskView = [UIView new];
    maskView.backgroundColor = [UIColor grayColor];
    maskView.alpha = 0.0;
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(regionPickerContainerView.mas_top);
        make.width.equalTo(self.view.mas_width);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCancelButton:)];
    [maskView addGestureRecognizer:tap];
    self.maskView = maskView;

    // 操作栏
    UIView *operationBar = [UIView new];
    operationBar.backgroundColor = [UIColor whiteColor];
    [regionPickerContainerView addSubview:operationBar];
    [operationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(regionPickerContainerView.mas_top);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(44);
    }];

    // 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.borderColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1].CGColor;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [operationBar addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(operationBar.mas_top);
        make.bottom.equalTo(operationBar.mas_bottom);
        make.left.equalTo(operationBar.mas_left);
        make.width.equalTo(operationBar.mas_width).multipliedBy(0.5);
    }];

    // 确定按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = [UIColor whiteColor];
    confirmButton.layer.borderWidth = 0.5;
    confirmButton.layer.borderColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1].CGColor;
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithRed:89/255.0 green:144/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [operationBar addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(operationBar.mas_top);
        make.bottom.equalTo(operationBar.mas_bottom);
        make.right.equalTo(operationBar.mas_right);
        make.width.equalTo(operationBar.mas_width).multipliedBy(0.5);
    }];

    // 地区选择器
    [regionPickerContainerView addSubview:self.regionPickerView];
    [self.regionPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(operationBar.mas_bottom);
        make.left.equalTo(regionPickerContainerView.mas_left);
        make.bottom.equalTo(regionPickerContainerView.mas_bottom).offset(-kBottomSafeHeight);
        make.right.equalTo(regionPickerContainerView.mas_right);
    }];
}

- (BOOL)anySubViewScrolling:(UIView *)view {

    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    return NO;
}

- (void)updateCityArrAndDistrict:(NSInteger)component andRow:(NSInteger)row {

    if (component == 0) {
        DataItem *provinceDataItem = self.provinceArr[row];
        NSString *code = provinceDataItem.code;
        if (code && ![code isEqualToString:@""]) {
            NSArray *cityArr = [[XKCityDBManager shareInstance] getCityWithProvinceCode:code];
            self.cityArr = cityArr.mutableCopy;
            DataItem *defaultDataItem = [DataItem new];
            defaultDataItem.name = @"请选择(市)";
            [self.cityArr insertObject:defaultDataItem atIndex:0];
        }
    } else if (component == 1) {
        DataItem *cityDataItem = self.cityArr[row];
        NSString *code = cityDataItem.code;
        if (code && ![code isEqualToString:@""]) {
            NSArray *districtArr = [[XKCityDBManager shareInstance] getDistrictWithCityCode:code];
            self.districtArr = districtArr.mutableCopy;
            DataItem *defaultDataItem = [DataItem new];
            defaultDataItem.name = @"请选择(区)";
            [self.districtArr insertObject:defaultDataItem atIndex:0];
        }
    }
}

#pragma mark events

- (void)clickCancelButton:(UIButton *)sender {
    [self.superViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)clickConfirmButton:(UIButton *)sender {

    if ([self anySubViewScrolling:self.regionPickerView]) {
        return;
    }

    NSInteger provinceRow = [self.regionPickerView selectedRowInComponent:0];
    NSInteger cityRow = [self.regionPickerView selectedRowInComponent:1];
    NSInteger districtRow = [self.regionPickerView selectedRowInComponent:2];

    if (provinceRow == 0 || cityRow == 0 || districtRow == 0) {
        return;
    }

    DataItem *provinceDataItem = self.provinceArr[provinceRow];
    DataItem *cityDataItem = self.cityArr[cityRow];
    DataItem *districtDataItem = self.districtArr[districtRow];

    self.selectedRegionPickerModel.provinceName = provinceDataItem.name;
    self.selectedRegionPickerModel.provinceCode = provinceDataItem.code;
    self.selectedRegionPickerModel.cityName = cityDataItem.name;
    self.selectedRegionPickerModel.cityCode = cityDataItem.code;
    self.selectedRegionPickerModel.districtName = districtDataItem.name;
    self.selectedRegionPickerModel.districtCode = districtDataItem.code;

    [self.delegate regionPickerViewController:self didSelectedRegion:self.selectedRegionPickerModel];
    [self.superViewController dismissViewControllerAnimated:NO completion:nil];

}

#pragma mark setter and getter

- (UIPickerView *)regionPickerView {

    if (!_regionPickerView) {
        _regionPickerView = [UIPickerView new];
        _regionPickerView.dataSource = self;
        _regionPickerView.delegate = self;
        _regionPickerView.backgroundColor = [UIColor whiteColor];
    }
    return _regionPickerView;
}

- (XKRegionPickerModel *)selectedRegionPickerModel {

    if (!_selectedRegionPickerModel) {
        _selectedRegionPickerModel = [XKRegionPickerModel new];
    }
    return _selectedRegionPickerModel;
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

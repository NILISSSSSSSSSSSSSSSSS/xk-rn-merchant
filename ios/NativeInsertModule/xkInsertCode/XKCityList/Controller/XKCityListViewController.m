//
//  XKCityListViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/8/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCityListViewController.h"
#import "XKCityHeaderView.h"
#import "XKCityListTableViewCell.h"
#import "XKCityListDefaults.h"
#import "XKBaiduLocation.h"
#import "XKAuthorityTool.h"
#import "XKCityNormalTableViewCell.h"
#import "XKSearchCityListViewController.h"
#import "XKCityListTranslation.h"
#import "XKCityListNetworkMethod.h"
#import "XKCityListNetworkMethod.h"
#import "XKCityListModel.h"
#import "BaseTabBarConfig.h"
#import "XKCityDBManager.h"
//#import "XKInvitationCodeViewController.h"

static NSString *XKCITYCELL = @"cityCell";
static NSString *XKCITYNAMECELL = @"cityNameCell";

@interface XKCityListViewController ()
<UITableViewDelegate,
UITableViewDataSource,
XKCityHeaderViewDelegate,
XKBaiduLocationDelegate,
UIViewControllerTransitioningDelegate
>
{
    NSMutableArray   *_indexMutableArray;           //存字母索引下标数组
    NSMutableArray   *_sectionMutableArray;         //存处理过以后的数组
    NSInteger        _HeaderSectionTotal;           //头section的个数
}

@property (nonatomic, strong) UITableView *rootTableView;
@property (nonatomic, strong) XKCityListTableViewCell *cell;
@property (nonatomic, strong) XKCityHeaderView *headerView;
@property (nonatomic, strong) XKBaiduLocation * baiduLocation;
@property (nonatomic, strong) XKCityListTranslation * cityListTranslation;

/**添加的(显示区县名称)cell的高度*/
@property (nonatomic, assign) CGFloat cellHeight;
/** 最近访问的城市*/
@property (nonatomic, strong) NSMutableArray *historyCityMutableArray;
/** 热门城市*/
@property (nonatomic, strong) NSMutableArray *hotCityArray;
/** 字母索引*/
@property (nonatomic, strong) NSMutableArray *characterMutableArray;
/** 所有“市”级城市名称*/
@property (nonatomic, strong) NSMutableArray *cityMutableArray;
/**在数据库中查到的区县(切换区县按钮下的区县)*/
@property (nonatomic, strong) NSMutableArray *areaMutableArray;

@end

@implementation XKCityListViewController
#pragma mark – Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initcommonality];
    [self layoutViews];
//    [self hideNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnClick {
    [self back];
}

- (void)dealloc {
    self.headerView.delegate = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:XKCityTableViewCellDidChangeCityNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:XKCityTableViewLoctionCellDidChangeCityNotification object:nil];
    NSLog(@"XKCityViewController dealloc");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
;
}
#pragma mark – Private Methods
- (void)initcommonality {
    [self setRightView:[self creatNavSearchBar] withframe:CGRectMake(0, 0, SCREEN_WIDTH - 60, 30)];
    self.view.backgroundColor = [UIColor whiteColor];
    _HeaderSectionTotal = 3;
    _indexMutableArray = [NSMutableArray array];
    _sectionMutableArray = [NSMutableArray array];
    //百度地图
    self.baiduLocation = [[XKBaiduLocation alloc]init];
    self.baiduLocation.delegate = self;
    if (![XKCityListDefaults getLocationCity]){
        [self.baiduLocation startBaiduSingleLocationService];
    }
    //设置默认初始值
    [self setDefaultData];
    //点击热门城市，最近访问的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCityWithName:) name:XKCityTableViewCellDidChangeCityNotification object:nil];
    //定位按钮的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loctionCityWithName:) name:XKCityTableViewLoctionCellDidChangeCityNotification object:nil];
    //判断本地是否有了字母索引和section的数据
    [self judgeGetCityData];
    
}

/**
 设置默认初始值
 */
- (void)setDefaultData {
    if (![XKCityListDefaults getLocationCity]) {
    
    if (![XKCityListDefaults getCityNumber]) {
        [XKCityListDefaults saveCityNumber:@"510600"];
    }
    
    if (![XKCityListDefaults getPrivateCityNumber]) {
        [XKCityListDefaults savePrivateCityNumber:@"510600"];
    }
    
    if (![XKCityListDefaults getCurrentCity]) {
        [XKCityListDefaults saveCurrentCity:@"德阳市"];
    }
    
    if (![XKCityListDefaults getParentCity]) {
        [XKCityListDefaults saveParentCity:@"德阳市"];
    }
  }
}
- (void)initViews {
    [self.view addSubview:self.rootTableView];
}

- (void)layoutViews {
    [self.rootTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

//判断是否以字母开头
- (BOOL)matchLetter:(NSString *)str {
    
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}

//最近访问城市的数据处理
- (void)historyCity:(DataItem *)model {
    XKWeakSelf(ws);
    if (_historyCityMutableArray.count <= 0) {
        [_historyCityMutableArray insertObject:model atIndex:0];
    }else {
        [self.historyCityMutableArray enumerateObjectsUsingBlock:^(DataItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:model.name]) {
                [ws.historyCityMutableArray removeObject:obj];
            }
        }];
        [self.historyCityMutableArray insertObject:model atIndex:0];
    }

    if (_historyCityMutableArray.count > 2) {
        [_historyCityMutableArray removeLastObject];
    }
    [XKCityDBManager shareInstance].historyCityMutableArray = self.historyCityMutableArray;
    
}
//返回之后的回调
- (void)returnSelecetCityInfo:(NSString *)cityName laititude:(double)laititude longtitude:(double)longtitude cityCode:(NSString *)cityCode {
    //回调 (存数据前)
    if (self.citySelectedBlock) {
        //不是同一个城市
        if (![cityName isEqualToString:[XKCityListDefaults getCurrentCity]]) {
            self.citySelectedBlock(cityName, laititude, longtitude, cityCode);
        }
        [self back];
    }else{
        //第一次进入首页
        BaseTabBarConfig *tabBarControllerConfig = [[BaseTabBarConfig alloc] init];
        CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
        [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
    }
}
//查询区县
- (void)searchCityAreaWithCityCode:(NSString *)cityCode districtListBlock:(void(^)(NSArray *areaData))districtListBlock{
    NSArray *array = [[XKCityDBManager shareInstance]getDistrictWithCityCode:cityCode];
    districtListBlock(array);
    
}
#pragma mark - Events


// 选择城市时调用通知函数（前提是点击cell的section < 2）
- (void)chooseCityWithName:(NSNotification *)info {
    NSDictionary *cityDic = info.userInfo;
    DataItem *model = cityDic[@"model"];
    
    //如果点击的是全城，需要特殊处理，全城这个model是初始化的时候加进去的，所以code是空的，需要给code赋值
    if ([model.name isEqualToString:@"全城"]) {
        
    //getPrivateCityNumber是所有的code都是2级城市的code，CityNumber是既有2级也有3级的。
        model.code = [XKCityListDefaults getPrivateCityNumber];
        _headerView.cityName = [NSString stringWithFormat:@"%@全城",[XKCityListDefaults getParentCity]];
        
        //回调 (存数据前)当是全城的时候，需要处理回调的名字，ParentCity里面存的就是2级城市的名字
        [self returnSelecetCityInfo:[NSString stringWithFormat:@"%@全城",[XKCityListDefaults getParentCity]] laititude:model.latitude.doubleValue longtitude:model.longitude.doubleValue cityCode:model.code];
    }else {
        _headerView.cityName = model.name;
        //回调 (存数据前)
        [self returnSelecetCityInfo:model.name laititude:model.latitude.doubleValue longtitude:model.longitude.doubleValue cityCode:model.code];
    }
    //存储当前城市的名字 和 code（不区分城市的级别）
    [XKCityListDefaults saveCurrentCity:model.name];
    [XKCityListDefaults saveCityNumber:model.code];
    //如果是三级城市
    if ([model.level isEqualToString:@"3"]) {
        //即使是3级城市的code也需要存一个2级城市的code
        [XKCityListDefaults savePrivateCityNumber:model.parentCode];
        //如果是三级城市就储存上级城市（2级城市）
        [XKCityListDefaults saveParentCity:[[XKCityDBManager shareInstance]getCityNameWithCityCode:model.parentCode]];
        [self historyCity:model];
    }else if ([model.level isEqualToString:@"2"]){
        if ([model.name isEqualToString:@"重新定位"]) {
            return;
        }else {
            [XKCityListDefaults savePrivateCityNumber:model.code];
            //如果不是三级城市就储存当前城市
            [XKCityListDefaults saveParentCity:model.name];
            [self historyCity:model];
        }
    }
}

//定位按钮的通知
- (void)loctionCityWithName:(NSNotification *)info {
    [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeLocation needGuide:YES has:^{
        [self chooseCityWithName:info];
    } hasnt:^{
        
    }];
}
//判断本地是否有了字母索引和section的数据
- (void)judgeGetCityData {
    //如果本地已经有了字母索引和section的数据就直接刷新
    if ([XKCityDBManager shareInstance].characterMutableArray) {
        self.characterMutableArray = [XKCityDBManager shareInstance].characterMutableArray;
        _sectionMutableArray = [XKCityDBManager shareInstance].sectionMutableArray;
        self.cityMutableArray = [XKCityDBManager shareInstance].cityMutableArray;
        self.hotCityArray = [XKCityDBManager shareInstance].hotMutableArray;
        [_rootTableView reloadData];
    }else {
        self.cityMutableArray = [[[XKCityDBManager shareInstance]getAllCity]mutableCopy];
        [XKCityDBManager shareInstance].cityMutableArray = self.cityMutableArray;

        //获取热门城市数据
        [self getHotCityData];
        
        //在子线程中异步执行汉字转拼音再转汉字耗时操作
        dispatch_queue_t serialQueue = dispatch_queue_create("com.cityList.www", DISPATCH_QUEUE_SERIAL);
        dispatch_async(serialQueue, ^{
            [self processData:^(id success) {
                //回到主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.rootTableView reloadData];
                });
            }];
        });
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rootTableView reloadData];
        });
    }
    //从本地读取历史城市
    self.historyCityMutableArray = [XKCityDBManager shareInstance].historyCityMutableArray;
}
- (void)processData:(void (^) (id))success {
    for (DataItem *model in self.cityMutableArray) {
        if (model.name.length) {  //下面那2个转换的方法一个都不能少
            NSMutableString *ms = [[NSMutableString alloc] initWithString:model.name];
            //汉字转拼音
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            }
            //拼音转英文
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                //字符串截取第一位，并转换成大写字母
                NSString *firstStr = [[ms substringToIndex:1] uppercaseString];
                //如果不是字母开头的，转为＃
                BOOL isLetter = [self matchLetter:firstStr];
                if (!isLetter)
                    firstStr = @"";
                //如果还没有索引
                if (_indexMutableArray.count <= 0) {
                    //保存当前这个做索引
                    [_indexMutableArray addObject:firstStr];
                    //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
                    NSMutableArray *array = [NSMutableArray arrayWithObject:model];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                    [_sectionMutableArray addObject:dic];
                }else{
                    //如果索引里面包含了当前这个字母，直接保存数据
                    if ([_indexMutableArray containsObject:firstStr]) {
                        //取索引对应的数组，保存当前标题到数组里面
                        NSMutableArray *array = _sectionMutableArray[0][firstStr];
                        [array addObject:model];
                        //重新保存数据
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                        [_sectionMutableArray addObject:dic];
                    }else{
                        //如果没有包含，说明是新的索引
                        [_indexMutableArray addObject:firstStr];
                        //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
                        NSMutableArray *array = [NSMutableArray arrayWithObject:model];
                        NSMutableDictionary *dic = _sectionMutableArray[0];
                        [dic setObject:array forKey:firstStr];
                        [_sectionMutableArray addObject:dic];
                    }
                }
            }
        }
    }
    //将字母排序
    NSArray *compareArray = [[_sectionMutableArray[0] allKeys] sortedArrayUsingSelector:@selector(compare:)];
    _indexMutableArray = [NSMutableArray arrayWithArray:compareArray];
    
    //判断第一个是不是字母，如果不是放到最后一个
    BOOL isLetter = [self matchLetter:_indexMutableArray[0]];
    if (!isLetter) {
        //获取数组的第一个元素
        NSString *firstStr = [_indexMutableArray firstObject];
        //移除第一项元素
        [_indexMutableArray removeObjectAtIndex:0];
        //插入到最后一个位置
        [_indexMutableArray insertObject:firstStr atIndex:_indexMutableArray.count];
    }
    
    [self.characterMutableArray addObjectsFromArray:_indexMutableArray];
    [XKCityDBManager shareInstance].characterMutableArray = self.characterMutableArray;
    [XKCityDBManager shareInstance].sectionMutableArray = _sectionMutableArray;
    success(@"成功");
}

//获取热门城市数据
- (void)getHotCityData{
    [XKHudView showLoadingTo:self.view animated:YES];
    [XKCityListNetworkMethod getCityCacheListParameters:@{@"v":@"",@"limit":@0,@"level":@2} Block:^(id responseObject, BOOL isSuccess) {
        [XKHudView hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            [self.hotCityArray removeAllObjects];
            NSLog(@"%@",responseObject);
            XKCityListModel *model = [XKCityListModel yy_modelWithJSON:responseObject];
            NSArray *array = model.data;
            for (DataItem *item in array) {
                if (item.isHot == 1) {
                    [self.hotCityArray addObject:item];
                }
            }
            [XKCityDBManager shareInstance].hotMutableArray = self.hotCityArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.rootTableView reloadData];
            });
        }
    }];
}
#pragma mark - Custom Delegates
- (void)cityNameWithSelected:(BOOL)selected{
    //获取当前城市的所有辖区
    if (selected) {
        //定位的城市需要根据名字反向查询code
        if ([XKCityListDefaults getLocationCity] && ![XKCityListDefaults getCityNumber]) {
            return;
        }
        [self searchCityAreaWithCityCode:[XKCityListDefaults getPrivateCityNumber] districtListBlock:^(NSArray *areaData) {
            [self.areaMutableArray addObjectsFromArray:areaData];
            if (0 == (self.areaMutableArray.count % 3)) {
                self.cellHeight = self.areaMutableArray.count / 3 * 50;
            }else {
                self.cellHeight = (self.areaMutableArray.count / 3 + 1) * 50;
            }
            if (self.cellHeight > 300) {
                self.cellHeight = 300;
            }
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
            [self.rootTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }];
    }else {
        //清空区县名称数组
        self.areaMutableArray = nil;
        self.cellHeight = 0;
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
        [self.rootTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
}
//搜索功能
- (void)searchButtonSelected {
    NSLog(@"//搜索功能");
    XKWeakSelf(ws);
    XKSearchCityListViewController *vc = [[XKSearchCityListViewController alloc]init];
    vc.transitioningDelegate = self;
    vc.block = ^(NSString *cityName, double laititude, double longtitude, NSString *cityCode, NSString *level ,NSString* parentCode) {
        [ws returnSelecetCityInfo:cityName laititude:laititude longtitude:longtitude cityCode:cityCode];
        [XKCityListDefaults saveCurrentCity:cityName];
        [XKCityListDefaults saveCityNumber:cityCode];
        [XKCityListDefaults savePrivateCityNumber:cityCode];
        if ([level isEqualToString:@"2"]) {
            //直接存储当前二级城市的名字
           [XKCityListDefaults saveParentCity:cityName];
        }else if ([level isEqualToString:@"3"]){
            //通过三级城市的code获取二级城市的名字并存起来
           [XKCityListDefaults saveParentCity:[[XKCityDBManager shareInstance]getCityNameWithCityCode:parentCode]];
        }
    };

    [self presentViewController:vc animated:YES completion:nil];
}

- (void)userLocationCountry:(NSString *)country state:(NSString *)state city:(NSString *)city subLocality:(NSString *)subLocality name:(NSString *)name{
    if (![XKCityListDefaults getLocationCity]) {
        [XKCityListDefaults savePrivateCityNumber:[[XKCityDBManager shareInstance]getCityCodeWithCityName:city]];
        [XKCityListDefaults saveCityNumber:[[XKCityDBManager shareInstance]getCityCodeWithCityName:city]];
        [XKCityListDefaults saveCurrentCity:city];
        [XKCityListDefaults saveParentCity:city];
    }
    [XKCityListDefaults saveLocationCity:city];
    _headerView.cityName = [XKCityListDefaults getParentCity] ?: [XKCityListDefaults getLocationCity];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.rootTableView reloadData];
    });
}

- (void)backButtonSelected {
    [self back];
}

- (void)back {
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
      __block  BOOL hasCodeVc = NO;
        [viewcontrollers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([vc isKindOfClass:[XKInvitationCodeViewController class]]) {
//                hasCodeVc = YES;
//                *stop = YES;
//            }else{
//                hasCodeVc = NO;
//            }
        }];
        if (hasCodeVc) {
            BaseTabBarConfig *tabBarControllerConfig = [[BaseTabBarConfig alloc] init];
            CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarController;
        }else{
            if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                //push方式
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else{
        //present方式
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark – Getters and Setters
- (NSMutableArray *)areaMutableArray {
    if (!_areaMutableArray) {
        DataItem * model = [[DataItem alloc]init];
        //添加一个全城的model
        model.name = @"全城";
        model.code = [[XKCityDBManager shareInstance]getCityCodeWithCityName:[XKCityListDefaults getCurrentCity]];
        _areaMutableArray = [NSMutableArray arrayWithObject:model];
    }
    return _areaMutableArray;
}

- (XKCityHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XKCityHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
        _headerView.delegate = self;
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.buttonTitle = @"切换区县";
        //如果当前的二级城市与当前的城市相同
        if ([[XKCityListDefaults getParentCity]isEqualToString:[XKCityListDefaults getCurrentCity]]) {
            _headerView.cityName = [XKCityListDefaults getParentCity] ;
        }else {
            _headerView.cityName = [NSString stringWithFormat:@"%@%@",[XKCityListDefaults getParentCity],[XKCityListDefaults getCurrentCity]];
        }
    }
    return _headerView;
}

- (NSMutableArray *)historyCityMutableArray {
    if (!_historyCityMutableArray) {
        _historyCityMutableArray = [[NSMutableArray alloc] init];
    }
    return _historyCityMutableArray;
}

- (NSMutableArray *)hotCityArray {
    if (!_hotCityArray) {
        _hotCityArray = [NSMutableArray array];
    }
    return _hotCityArray;
}

- (NSMutableArray *)characterMutableArray {
    if (!_characterMutableArray) {
        _characterMutableArray = [NSMutableArray arrayWithObjects:@"区县",@"定位", @"热门", nil];
    }
    return _characterMutableArray;
}

- (UITableView *)rootTableView {
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rootTableView.delegate = self;
        _rootTableView.dataSource = self;
        _rootTableView.backgroundColor = HEX_RGB(0xF6F6F6);
        _rootTableView.sectionIndexColor = HEX_RGB(0x777777);
        _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_rootTableView registerClass:[XKCityListTableViewCell class] forCellReuseIdentifier:XKCITYCELL];
        [_rootTableView registerClass:[XKCityNormalTableViewCell class] forCellReuseIdentifier:XKCITYNAMECELL];
    }
    return _rootTableView;
}

- (XKCityListTranslation *)cityListTranslation {
    if (!_cityListTranslation) {
        _cityListTranslation = [[XKCityListTranslation alloc]init];
    }
    return _cityListTranslation;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _characterMutableArray.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section < _HeaderSectionTotal ? 1 : [_sectionMutableArray[0][_characterMutableArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _HeaderSectionTotal) {
        self.cell = [tableView dequeueReusableCellWithIdentifier:XKCITYCELL forIndexPath:indexPath];
        if ( indexPath.section == 0) {
            //标记可以改变背景颜色和字体颜色
            _cell.isAllCityButton = YES;
            _cell.currentCityName = [XKCityListDefaults getCurrentCity];
            _cell.cityNameArray = _areaMutableArray;
        }
        if (indexPath.section == 1) {
            NSString *locationCity = [XKCityListDefaults getLocationCity];
            NSMutableArray *array = [NSMutableArray array];
            DataItem *model = [[DataItem alloc]init];
            model.name = locationCity ? locationCity : @"重新定位";
            model.level = @"2";
            //定位的城市需要根据名字反向查询code
            model.code = locationCity ? [[XKCityDBManager shareInstance]getCityCodeWithCityName:locationCity] : @"510600";

            [array addObject:model];
            for (DataItem *hmodel in self.historyCityMutableArray) {
                [array addObject:hmodel];
            }
            _cell.isShowLocation = YES;
            _cell.cityNameArray = array;
        }
        if (indexPath.section == 2) {
            _cell.cityNameArray = self.hotCityArray;
        }
        return _cell;
    }
    else {
        XKCityNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XKCITYNAMECELL forIndexPath:indexPath];
        NSArray *currentArray = _sectionMutableArray[0][_characterMutableArray[indexPath.section]];
        DataItem *model = currentArray[indexPath.row];
        cell.cityTextLabel.text = model.name;
        return cell;
    }
}

#pragma mark -  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_HeaderSectionTotal == 3 && indexPath.section == 0) {
        return self.cellHeight;
    }
    else {
        return indexPath.section == (_HeaderSectionTotal - 1) ? floorf(self.hotCityArray.count/3 + 1) * 50: 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 60;
    }else{
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.headerView;
    }else{
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        contentView.backgroundColor = HEX_RGB(0xF6F6F6);
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        switch (section) {
            case 1:
                titleLabel.text = @"定位/最近访问";
                titleLabel.textColor = HEX_RGB(0x999999);
                
                break;
            case 2:
                titleLabel.text = @"热门城市";
                titleLabel.textColor = HEX_RGB(0x999999);
                break;
            default:
                titleLabel.text = _characterMutableArray[section];
                titleLabel.textColor = HEX_RGB(0x222222);
                break;
        }
        [contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(19 * ScreenScale));
            make.centerY.equalTo(contentView);
            make.height.equalTo(@(20 * ScreenScale));
            make.width.equalTo(@(200));
        }];
        
        return contentView;
    }
}
//设置右侧索引的标题
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _characterMutableArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *currentArray = _sectionMutableArray[0][_characterMutableArray[indexPath.section]];
    DataItem *model = currentArray[indexPath.row];
    _headerView.model = model;
    //回调 (存数据前)
    [self returnSelecetCityInfo:model.name laititude:model.latitude.doubleValue longtitude:model.longitude.doubleValue cityCode:model.code];
    [XKCityListDefaults saveCurrentCity:model.name];
    [XKCityListDefaults saveCityNumber:model.code];
    [XKCityListDefaults savePrivateCityNumber:model.code];
    [XKCityListDefaults saveParentCity:model.name];
    [self historyCity:model];
}


#pragma mark UIViewControllerTransitioningDelegate(转场动画代理)
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.cityListTranslation.isSearchVC = NO;
    return self.cityListTranslation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.cityListTranslation.isSearchVC = YES;
    return self.cityListTranslation;
}



- (UIView *)creatNavSearchBar {
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 60, 30)];
    contentView.backgroundColor = [UIColor clearColor];
    
    UIButton *contentButton = [[UIButton alloc]init];
    [contentView addSubview:contentButton];
    contentButton.backgroundColor = RGB(110, 159, 249);
    contentButton.layer.masksToBounds = true;
    contentButton.layer.cornerRadius = 8;
    [contentButton addTarget:self action:@selector(contentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * searchImage = [[UIImageView alloc]init];
    searchImage.image = [UIImage imageNamed:@"xk_btn_welfare_search"];
    [contentButton addSubview:searchImage];
    
    UILabel *cityLabel = [[UILabel alloc] init];
    cityLabel.text = @"城市名/拼音";
    cityLabel.textAlignment = NSTextAlignmentLeft;
    cityLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    cityLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
    [contentButton addSubview:cityLabel];

    [contentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(contentButton);
        make.width.equalTo(@77);
        make.height.equalTo(@14);
    }];
    
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentButton);
        make.right.equalTo(cityLabel.mas_left).offset(-9);
        make.height.width.equalTo(@15);
    }];
    return contentView;
}

- (void)contentButtonAction:(UIButton *)sender {
    [self searchButtonSelected];
}
@end

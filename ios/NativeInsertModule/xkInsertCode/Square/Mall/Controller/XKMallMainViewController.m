//
//  XKMallMainViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/11.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallMainViewController.h"
#import "XKMallTopFilterView.h"
#import "XKCustomNavBar.h"
#import "XKWelfarePageMenu.h"
#import "XKMainMallOrderViewController.h"
#import "XKWelfareOrderWaitOpenViewController.h"
#import "XKWelfareOrderWinViewController.h"
#import "XKWelfareOrderFinishViewController.h"
#import "XKMallListViewController.h"
#import "XKMallBuyCarViewController.h"
#import "XKCommonSheetView.h"
#import "XKMallTypeView.h"
#import "XKMallCategoryListModel.h"
#import "XKMallListViewModel.h"
#import "XKMallSearchGoodsViewController.h"
#import "XKCustomeSerMessageManager.h"
#import "XKIMGlobalMethod.h"
#import "XKSquareSearchDetailMainViewController.h"
#import "XKSqureSearchViewController.h"
#import "XKMallHomeSearchResultViewController.h"
@interface XKMallMainViewController () <XKWelfarePageMenuDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) XKWelfarePageMenu *pageMenu;
@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) XKMallTopFilterView *filterView;
@property (nonatomic, strong) XKCustomNavBar *toolsBar;
@property (nonatomic, strong) XKCommonSheetView *sheetView;
@property (nonatomic, strong) XKMallTypeView *typeView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *typeBtn;
@property (nonatomic, strong) NSArray *categoryArr;
@property (nonatomic, assign) NSInteger  choseIndex;
@end

@implementation XKMallMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestCategoryListDataWithTips:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.toolsBar.searchBar.textField resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
   
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)handleData {
    [super handleData];
    _myChildViewControllers = [NSMutableArray array];

}

- (void)addCustomSubviews {
    [self hideNavigation];
    [self.view addSubview:self.toolsBar];
    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.bgScrollView config:nil];
}

#pragma mark network
- (void)requestCategoryListDataWithTips:(BOOL)tip {
    if(tip) {
     [XKHudView showLoadingTo:self.view animated:YES];
    }
    [XKMallCategoryListModel requestMallCategotyListSuccess:^(NSArray *listModel) {
        [self handleSuccessDataWithModel:listModel];
    } failed:^(NSString *failedReason) {
        [self handleErrorDataWithReason:failedReason];
    }];
}

- (void)handleSuccessDataWithModel:(NSArray *)listModel {
 
    if(listModel.count > 0) {
        self.bgScrollView.hidden = YES;
        [self.emptyTipView hide];
        self.categoryArr = listModel;
        for (NSInteger i = 0; i < listModel.count; i ++) {
            XKMallCategoryListModel * model = listModel[i];
            if (model.code == self.categoryCode.integerValue) {
                _choseIndex = i + 1;
            }
        }
        [self.view addSubview:self.addView];
        [self.view addSubview:self.pageMenu];
        [self.view addSubview:self.filterView];
        [self.view addSubview:self.typeBtn];
        [self.sheetView addSubview:self.typeView];
        self.sheetView.contentView = self.typeView;
    } else {
        self.bgScrollView.hidden = NO;
        [self.view bringSubviewToFront:self.bgScrollView];
        self.emptyTipView.config.viewAllowTap = NO;
        [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:nil];
    }
}

- (void)handleErrorDataWithReason:(NSString *)reason {
    XKWeakSelf(ws);
    self.bgScrollView.hidden = NO;
    [self.view bringSubviewToFront:self.bgScrollView];
    self.emptyTipView.config.viewAllowTap = YES;
    [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
        [ws requestCategoryListDataWithTips:YES];
    }];
    [XKHudView showErrorMessage:reason];
}

#pragma mark event
- (void)typeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.sheetView show];
}

#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(XKWelfarePageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(XKWelfarePageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:YES];
    }
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    CGFloat scrollViewH = SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - 44;
    targetViewController.view.frame = CGRectMake(SCREEN_WIDTH * toIndex, 0, SCREEN_WIDTH, scrollViewH);
    [_scrollView addSubview:targetViewController.view];
    
}

- (UIView *)addView {
    if(!_addView) {
        _addView = [[UIView alloc] initWithFrame:CGRectMake(0, kIphoneXNavi(64), SCREEN_WIDTH ,40)];
        _addView.backgroundColor = [UIColor whiteColor];
    }
    return _addView;
}
#pragma mark  懒加载
- (XKWelfarePageMenu *)pageMenu {
    if(!_pageMenu) {
        XKWeakSelf(ws);
         NSMutableArray *titleArr = [NSMutableArray array];
        [ws.categoryArr enumerateObjectsUsingBlock:^(XKMallCategoryListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titleArr addObject:obj.name];
        }];
        [titleArr insertObject:@"推荐" atIndex:0];
        CGFloat scrollViewH = SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - 44;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kIphoneXNavi(64) + 40 + 44, SCREEN_WIDTH, scrollViewH)];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        
        for (int i = 0; i < titleArr.count; i++) {
            XKMallListViewController *baseVc = [[NSClassFromString(@"XKMallListViewController") alloc] init];
            baseVc.view.backgroundColor = [UIColor clearColor];//UIColorFromRGB(0xf0f0f0);
            baseVc.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, scrollViewH);
            if (i == 0) {
                XKMallCategoryListModel *model = [XKMallCategoryListModel new];
                model.listType = @"recommend";
                baseVc.model = model;
            } else {
               baseVc.model = ws.categoryArr[i-1];
            }
            [self addChildViewController:baseVc];
            [self.myChildViewControllers addObject:baseVc];
            [scrollView addSubview:baseVc.view];
            
            
        }
         scrollView.contentSize = CGSizeMake(titleArr.count * SCREEN_WIDTH, 0);
        // trackerStyle:跟踪器的样式
        _pageMenu = [XKWelfarePageMenu pageMenuWithFrame:CGRectMake(0, kIphoneXNavi(64), SCREEN_WIDTH - SCREEN_WIDTH/6,40) trackerStyle:XKWelfarePageMenuPageMenuTrackerStyleLine];
        // 传递数组，默认选中
        [_pageMenu setItems:titleArr selectedItemIndex:0];
        _pageMenu.needTextColorGradients = NO;
        _pageMenu.unSelectedItemTitleColor = UIColorFromRGB(0x555555);
        _pageMenu.selectedItemTitleColor = XKMainTypeColor;
        _pageMenu.itemTitleFont = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        _pageMenu.tracker.backgroundColor = XKMainTypeColor;
        // 设置代理
        _pageMenu.delegate = self;

        
        // 这一行赋值，可实现pageMenu的跟踪器时刻跟随scrollView滑动的效果
        self.pageMenu.bridgeScrollView = self.scrollView;
        
    }
    return _pageMenu;
}

- (XKMallTopFilterView *)filterView {
    if(!_filterView) {
        XKWeakSelf(ws);
       
        _filterView = [[XKMallTopFilterView alloc] initWithFrame:CGRectMake(0, 40 + kIphoneXNavi(64), SCREEN_WIDTH, 44)];
        _filterView.hotBClickBlock = ^(UIButton *sender) {
            sender.selected = !sender.selected;
             XKMallListViewController *list = ws.childViewControllers[ws.pageMenu.selectedItemIndex];
            if(sender.selected) {
              [list filterRefreshWithType:XKMllFilterTypePopularity sort:0];
            } else {
              [list filterRefreshWithType:XKMllFilterTypePopularity sort:1];
            }
            
        };
        
        _filterView.sellBClickBlock = ^(UIButton *sender) {
             sender.selected = !sender.selected;
             XKMallListViewController *list = ws.childViewControllers[ws.pageMenu.selectedItemIndex];
            if(sender.selected) {
                [list filterRefreshWithType:XKMllFilterTypeSaleQ sort:0];
            } else {
               [list filterRefreshWithType:XKMllFilterTypeSaleQ sort:1];
            }
        };
        
        _filterView.priceBClickBlock = ^(UIButton *sender) {
             sender.selected = !sender.selected;
             XKMallListViewController *list = ws.childViewControllers[ws.pageMenu.selectedItemIndex];
            if(sender.selected) {
                [list filterRefreshWithType:XKMllFilterTypePrice sort:0];
            } else {
                [list filterRefreshWithType:XKMllFilterTypePrice sort:1];
            }
            
        };
    }
    return _filterView;
}

- (XKCustomNavBar *)toolsBar {
    if(!_toolsBar) {
        XKWeakSelf(ws);
        _toolsBar  =  [[XKCustomNavBar alloc] init];
        [_toolsBar customWelfareNaviBar];
        
        _toolsBar.inputTextFieldBlock = ^(NSString *text) {
//            XKMallListViewController *list = ws.childViewControllers[ws.pageMenu.selectedItemIndex];
//            XKMallSearchGoodsViewController *search = [XKMallSearchGoodsViewController new];
//            [search searchText:text withCategoryCode:list.viewModel.category];
//            [ws.navigationController pushViewController:search animated:YES];
            XKSqureSearchViewController *vc = [[XKSqureSearchViewController alloc] init];
            vc.searchType = SearchEntryType_Mall;
            [ws.navigationController pushViewController:vc animated:NO];
        };
        
        _toolsBar.leftButtonBlock = ^{
            [ws.navigationController popViewControllerAnimated:YES];
        };
        
        _toolsBar.messageButtonBlock = ^{
            [XKIMGlobalMethod gotoCustomerSerChatList];
        };
        
        _toolsBar.buyCarButtonBlock = ^{
            XKMallBuyCarViewController *buyCarVC = [XKMallBuyCarViewController new];
            [ws.navigationController pushViewController:buyCarVC animated:YES];
        };
        
        _toolsBar.orderButtonBlock = ^{
            XKMainMallOrderViewController *orderVC = [XKMainMallOrderViewController new];
            [ws.navigationController pushViewController:orderVC animated:YES];
        };
        
        _toolsBar.layoutButtonBlock = ^{
            XKMallListViewController *listVC = ws.childViewControllers[ws.pageMenu.selectedItemIndex];
            listVC.layoutType =  (listVC.layoutType == XKMallListLayoutSingle) ? XKMallListLayoutDouble : XKMallListLayoutSingle;
            [listVC updateLayout];
        };
    }
    return _toolsBar;
}

- (UIButton *)typeBtn {
    if(!_typeBtn) {
        _typeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/6,  kIphoneXNavi(64), SCREEN_WIDTH/6, 40)];
        [_typeBtn setBackgroundColor:[UIColor whiteColor]];
        [_typeBtn setImage:[UIImage imageNamed:@"xk_btn_mallType_rightIndicate"] forState:0];
        [_typeBtn setImage:[UIImage imageNamed:@"xk_btn_mine_arrow_down"] forState:UIControlStateSelected];
        [_typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH/6, 1)];
        lineView.backgroundColor = XKSeparatorLineColor;
        [_typeBtn addSubview:lineView];
    }
    return _typeBtn;
}

- (XKCommonSheetView *)sheetView {
    XKWeakSelf(ws);
    if(!_sheetView) {
        _sheetView = [[XKCommonSheetView alloc] init];
        _sheetView.dismissBlock = ^{
            ws.typeBtn.selected = !ws.typeBtn.selected;
        };
    }
    return _sheetView;
}

- (XKMallTypeView *)typeView {
    if(!_typeView) {
        XKWeakSelf(ws);
        _typeView = [[XKMallTypeView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - kIphoneXNavi(64) - 40 - kBottomSafeHeight)];
        [_typeView updateDataSourceForDataSource:ws.categoryArr forIndex:0];
        _typeView.choseIndexBlock = ^(NSInteger firstCode, NSInteger firstIndex, NSInteger secondCode, NSInteger secondIndex, NSString *searchName) {
            [ws.sheetView dismiss];
            XKMallHomeSearchResultViewController *vc = [[XKMallHomeSearchResultViewController alloc] init];
            vc.searchText = searchName;
            vc.code = secondCode;
         
            [ws.navigationController pushViewController:vc animated:YES];
            
        };
        
        _typeView.collectionBlock = ^(UIButton *sender) {
            [ws.sheetView dismiss];
//            XKMineCollectRootViewController *mineCollectRootViewController = [XKMineCollectRootViewController new];
//            mineCollectRootViewController.hidesBottomBarWhenPushed = YES;
//            [ws.navigationController pushViewController:mineCollectRootViewController animated:YES];
        };
        
    }
    return _typeView;
}

@end

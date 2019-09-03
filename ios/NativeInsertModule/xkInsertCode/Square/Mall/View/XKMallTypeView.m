//
//  XKMallTypeView.m
//  XKSquare
//
//  Created by hupan on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKMallTypeView.h"
#import "XKMallTypeCollectionViewCell.h"
#import "XKMallTypeTableViewCell.h"
#import "XKMallTypeCollectionReusableView.h"
#import "XKMallCategoryListModel.h"
#import "XKTradingAreaIndustyAllCategaryModel.h"

static NSString * const collectionViewCellID          = @"RightCollectionViewCell";
static NSString * const tableViewCellID               = @"leftTableViewCell";
static NSString * const collectionViewReusableViewID  = @"collectionViewReusableViewID";


@interface XKMallTypeView ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView            *topView;
@property (nonatomic, strong) UIView            *topIndicateView;
@property (nonatomic, strong) UILabel           *topNameLabel;
@property (nonatomic, strong) UIButton          *topIndicateBtn;

@property (nonatomic, strong) UITableView      *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic ,strong) NSArray          *leftClassDataArr;
@property (nonatomic ,strong) NSArray          *rightCollectionDataArr;
@property (nonatomic ,strong) NSArray          *rightCollectionAllArr;//二维数组
@property (nonatomic ,assign) NSInteger        selectedIndex;

@end

@implementation XKMallTypeView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
//        self.contentView.backgroundColor = HEX_RGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
    
}

#pragma mark - Private

- (void)initViews {
    
    [self addSubview:self.topView];
    [self.topView addSubview:self.topIndicateView];
    [self.topIndicateView addSubview:self.topNameLabel];
    [self.topIndicateView addSubview:self.topIndicateBtn];
    
    [self addSubview:self.leftTableView];
    [self addSubview:self.rightCollectionView];

}

- (void)layoutViews {
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@40);
    }];
    
    [self.topIndicateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topView);
        make.top.equalTo(self.topView).offset(5);
        make.bottom.equalTo(self.topView).offset(-5);
    }];
    
    [self.topNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topIndicateView).offset(20);
        make.centerY.equalTo(self.topIndicateView);
    }];
    
    [self.topIndicateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topIndicateView).offset(-20);
        make.centerY.equalTo(self.topIndicateView);
    }];
    
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.bottom.equalTo(self);
        make.width.equalTo(@(114 * ScreenScale));
    }];
    
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftTableView.mas_top);
        make.left.equalTo(self.leftTableView.mas_right);
        make.right.bottom.equalTo(self);
    }];
}

- (void)updateDataSourceForDataSource:(NSArray *)dataSource forIndex:(NSInteger)index{
    self.leftClassDataArr = dataSource;
    XKMallCategoryListModel *model = dataSource[index];
    self.rightCollectionDataArr = model.children;
    [self.leftTableView reloadData];
    [self.rightCollectionView reloadData];
}

- (void)updateDataSourceForLeftDataSource:(NSArray *)leftDataSource rightDataSource:(NSArray *)rightDataSource forIndex:(NSInteger)index {
    self.leftClassDataArr = leftDataSource;
    self.rightCollectionAllArr = rightDataSource;
    
    if (rightDataSource.count > index) {
        self.rightCollectionDataArr = rightDataSource[index];
    }
    [self.leftTableView reloadData];
    [self.rightCollectionView reloadData];
}

#pragma mark - UITableviewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.leftClassDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XKMallTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID];
    if (!cell) {
        cell = [[XKMallTypeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:tableViewCellID];
    }
    NSString *name = @"";
    if (self.typeView == TypeView_mall) {
        XKMallCategoryListModel *model = self.leftClassDataArr[indexPath.row];
        name = model.name;
        
        [cell setTitle:name titleColor:indexPath.row == self.selectedIndex ? XKMainTypeColor : HEX_RGB(0x222222)];
        [cell setSelectedBackGroundViewColor:indexPath.row == self.selectedIndex ? [UIColor whiteColor] : HEX_RGB(0xf1f1f1)];
        
    } else if (self.typeView == TypeView_tradingArea) {
        IndustyOneLevelItem *model = self.leftClassDataArr[indexPath.row];
        name = model.name;
        
        [cell setTitle:name titleColor:indexPath.row == self.selectedIndex ? XKMainTypeColor : HEX_RGB(0x222222)];
        [cell setSelectedBackGroundViewColor:indexPath.row == self.selectedIndex ? [UIColor whiteColor] : HEX_RGB(0xf1f1f1)];
        /*
        [cell setTitle:name titleColor:HEX_RGB(0x222222)];
        [cell setSelectedBackGroundViewColor:HEX_RGB(0xf1f1f1)];
        [cell showSelectedView:indexPath.row == self.selectedIndex];
         */
    }

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.rightCollectionView scrollRectToVisible:CGRectMake(0, 0, self.rightCollectionView.width, self.rightCollectionView.height) animated:YES];
    
    //在赋值前
//    NSIndexPath *oldInxdexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
//    NSIndexPath *newInxdexPath = indexPath;
    //赋值
    if (self.selectedIndex == indexPath.row) {
        return;
    }
    self.selectedIndex = indexPath.row;

//    [self.leftTableView reloadRowsAtIndexPaths:@[oldInxdexPath, newInxdexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    [self.leftTableView reloadData];
    if (self.typeView == TypeView_mall) {
        [self updateDataSourceForDataSource:self.leftClassDataArr forIndex:indexPath.row];
    } else if (self.typeView == TypeView_tradingArea) {
        [self updateDataSourceForLeftDataSource:self.leftClassDataArr rightDataSource:self.rightCollectionAllArr forIndex:indexPath.row];
    }

}

#pragma mark -  UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (self.typeView == TypeView_mall) {
        return _rightCollectionDataArr.count;

    } else if (self.typeView == TypeView_tradingArea) {
        return 1;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.typeView == TypeView_mall) {
        ChildrenItem *item = _rightCollectionDataArr[section];
        return item.children.count;
        
    } else if (self.typeView == TypeView_tradingArea) {
        return self.rightCollectionDataArr.count;
    }
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKMallTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    
    
    NSString *name = @"";
    NSString *iconUrl = @"";
    if (self.typeView == TypeView_mall) {
        ChildrenItem *item = _rightCollectionDataArr[indexPath.section];
        ChildrenObj *obj = item.children[indexPath.row];
        name = obj.name;
        iconUrl = obj.picUrl;
    } else if (self.typeView == TypeView_tradingArea) {
        IndustyTwoLevelItem *item = self.rightCollectionDataArr[indexPath.row];
        name = item.name;
        iconUrl = item.icon ? item.icon : @"xx";
    }
    
    [cell setTitle:name iconName:nil urlStr:iconUrl];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    XKMallTypeCollectionReusableView *reusableView;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewReusableViewID forIndexPath:indexPath];
        if (self.typeView == TypeView_mall) {

            ChildrenItem *item = _rightCollectionDataArr[indexPath.section];
            [reusableView setTitleWithTitleStr:item.name titleColor:nil font:nil];
        } else if (self.typeView == TypeView_tradingArea) {
            [reusableView setTitleWithTitleStr:@"二级分类" titleColor:nil font:nil];
        }
    }
    return reusableView;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.choseIndexBlock) {
        if (self.typeView == TypeView_mall) {
            ChildrenItem *item = _rightCollectionDataArr[indexPath.section];
            ChildrenObj *obj = item.children[indexPath.row];
            self.choseIndexBlock(0, self.selectedIndex, obj.code, 0, obj.name);
        } else if (self.typeView == TypeView_tradingArea) {
            self.choseIndexBlock(0, self.selectedIndex, 0, indexPath.row,@"");
        }
    }
}

- (void)topIndicateBtnClick:(UIButton *)sender {
    if (self.collectionBlock) {
        self.collectionBlock(sender);
    }
}
#pragma mark - setter && getter


- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = HEX_RGB(0xf1f1f1);
    }
    return _topView;
}

- (UIView *)topIndicateView {
    if (!_topIndicateView) {
        _topIndicateView = [[UIView alloc] init];
        _topIndicateView.backgroundColor = [UIColor whiteColor];
    }
    return _topIndicateView;
}

- (UILabel *)topNameLabel {
    if (!_topNameLabel) {
        _topNameLabel = [[UILabel alloc] init];
        _topNameLabel.text = @"我的收藏";
        _topNameLabel.textColor = HEX_RGB(0x222222);
        _topNameLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
    }
    return _topNameLabel;
}

- (UIButton *)topIndicateBtn {
    if (!_topIndicateBtn) {
        _topIndicateBtn = [[UIButton alloc] init];
        [_topIndicateBtn setImage:[UIImage imageNamed:@"xk_btn_mallType_rightIndicate"] forState:UIControlStateNormal];
        [_topIndicateBtn addTarget:self action:@selector(topIndicateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topIndicateBtn;
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 100, self.height) style:(UITableViewStylePlain)];
//        _leftTableView.backgroundColor = HEX_RGB(0xf6f6f6);
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.rowHeight = 50;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
    }
    return _leftTableView;
}

- (UICollectionView *)rightCollectionView {
    
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.minimumInteritemSpacing = 0.f;
        flowlayout.minimumLineSpacing = 0.f;
        flowlayout.itemSize = CGSizeMake((int)((self.width - 114*ScreenScale) / 3), (int)((self.width - 114*ScreenScale) / 3) + 20);
        flowlayout.headerReferenceSize = CGSizeMake((self.width - 114*ScreenScale), 50.0f);
        
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(100, 64, self.width - 100, self.height) collectionViewLayout:flowlayout];
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        
        [_rightCollectionView registerClass:[XKMallTypeCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
        [_rightCollectionView registerClass:[XKMallTypeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewReusableViewID];
        _rightCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _rightCollectionView;
}


- (void)setTypeView:(TypeView)typeView {
    _typeView = typeView;
    if (_typeView == TypeView_tradingArea) {
        self.topView.hidden = YES;
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.topIndicateView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.topView);
        }];
    }
}


@end

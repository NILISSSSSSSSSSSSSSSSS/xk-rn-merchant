//
//  XKChoosedSeatDetailViewController.m
//  XKSquare
//
//  Created by hupan on 2018/11/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKChoosedSeatDetailViewController.h"
#import "XKStoreInfoCollectionCell.h"
#import "XKMallTypeCollectionReusableView.h"


static NSString * const collectionViewCellID          = @"collectionViewCell";
static NSString * const collectionViewReusableViewID  = @"collectionViewReusableViewID";

@interface XKChoosedSeatDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation XKChoosedSeatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initViews];
    [self layoutViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private

- (void)initViews {
    [self.view addSubview:self.collectionView];
    
}

- (void)layoutViews {
    
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationAndStatue_Height);
        make.left.right.bottom.equalTo(self.view);
    }];
}


#pragma mark -  UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.rightCollectionDataArr.count;
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKStoreInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    XKMallTypeCollectionReusableView *reusableView;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewReusableViewID forIndexPath:indexPath];
    }
    [reusableView setTitleWithTitleStr:@"A1" titleColor:nil font:nil];
    return reusableView;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];


}
#pragma mark - setter && getter


- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.minimumInteritemSpacing = 0.f;
        flowlayout.minimumLineSpacing = 0.5f;
        flowlayout.itemSize = CGSizeMake((SCREEN_WIDTH - 20) / 4, (SCREEN_WIDTH - 20) / 4);
        flowlayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH - 20, 50.0f);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[XKStoreInfoCollectionCell class] forCellWithReuseIdentifier:collectionViewCellID];
        [_collectionView registerClass:[XKMallTypeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewReusableViewID];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}




@end

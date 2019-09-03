//
//  XKSqureToolHeaderView.m
//  XKSquare
//
//  Created by hupan on 2018/8/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKSqureToolHeaderView.h"
#import "XKHomeBannerView.h"
#import "XKSqureHeaderToolCollectionViewCell.h"
#import "XKSquareHomeToolModel.h"

static NSString *const collectionViewCellID = @"headerToolCollectionViewCell";
static NSUInteger itemCount = 5;


@interface XKSqureToolHeaderView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) XKHomeBannerView *loopView;
@property (nonatomic, strong) UIView           *toolBackView;
@property (nonatomic, strong) XKHotspotButton  *pullDownBtn;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy  ) NSArray           *toolArr;



@end

@implementation XKSqureToolHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEX_RGB(0xf6f6f6);
        [self initViews];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Private

- (void)initViews {
    [self addSubview:self.loopView];

    [self addSubview:self.toolBackView];
    [self.toolBackView addSubview:self.collectionView];
    [self.toolBackView addSubview:self.pullDownBtn];
}

- (void)layoutViews {
    
    [self.loopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@(ScreenScale*150 + 20));
    }];
    
    [self.toolBackView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.loopView.mas_bottom).offset(0);
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(10);
        make.height.equalTo(@(ScreenScale*70 + 20));

    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.toolBackView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    [self.pullDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.toolBackView);
        make.bottom.equalTo(self.toolBackView).offset(-5);
        make.width.equalTo(@15);
        make.height.equalTo(@10);
        
    }];
    
}

- (void)updateLayoutViews {
    
    [self.toolBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        NSInteger line = self.toolArr.count % itemCount ? (self.toolArr.count / itemCount + 1) : (self.toolArr.count / itemCount);
        if (self.pullDownBtn.selected) {
            make.height.equalTo(@(ScreenScale*(70*line) + 20));
        } else {
            make.height.equalTo(@(ScreenScale*70 + 20));
        }
    }];
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.toolBackView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    // 告诉self.view约束需要更新
    [self setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];

    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];

}

#pragma mark - Setter

- (XKHomeBannerView *)loopView {
    if (!_loopView) {
        _loopView = [[XKHomeBannerView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, ScreenScale*150)];
        _loopView.clipsToBounds = YES;

        XKWeakSelf(weakSelf);
        _loopView.tapBlock = ^(NSInteger type, NSString *jumpStr) {
            [weakSelf bannarItemClickedWithJumpType:type jumpAddress:jumpStr];
        };
    }
    return _loopView;
}



- (UIView *)toolBackView {
    if (!_toolBackView) {
        _toolBackView = [[UIView alloc] init];
        _toolBackView.backgroundColor = [UIColor whiteColor];
        [_toolBackView drawShadowPathWithShadowColor:HEX_RGB(0x000000) shadowOpacity:0.2 shadowRadius:5.0 shadowPathWidth:2.0 shadowOffset:CGSizeMake(0,1)];
    }
    return _toolBackView;
}

- (XKHotspotButton *)pullDownBtn {
    if (!_pullDownBtn) {
        _pullDownBtn = [[XKHotspotButton alloc] init];
        [_pullDownBtn setBackgroundImage:[UIImage imageNamed:@"xk_ic_login_down_arrow"] forState:UIControlStateNormal];
        [_pullDownBtn setBackgroundImage:[UIImage imageNamed:@"xk_ic_login_up_arrow"] forState:UIControlStateSelected];
        [_pullDownBtn addTarget:self action:@selector(pullDownBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pullDownBtn;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 20 - 20) / itemCount, 70*ScreenScale);
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[XKSqureHeaderToolCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
        
    }
    return _collectionView;
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.pullDownBtn.selected) {
        NSInteger line = self.toolArr.count % itemCount ? (self.toolArr.count / itemCount + 1) : (self.toolArr.count / itemCount);
        return line;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger totalNum = self.toolArr.count;

    if (self.pullDownBtn.selected) {
        NSInteger line = totalNum % itemCount ? (totalNum / itemCount + 1) : (totalNum / itemCount);
        if (totalNum) {
            if (section == line - 1) {
                return totalNum % itemCount ? totalNum % itemCount : itemCount;
            }
            return itemCount;
        }
    } else {
        if (totalNum >= itemCount) {
            return itemCount;
        }
        return totalNum;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKSqureHeaderToolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    XKSquareHomeToolModel *item = self.toolArr[indexPath.section * itemCount + indexPath.row];
    NSString *title = item.name;
    NSString *iconName = item.icon;
    if (item.iconInLocation) {
        [cell setTitle:title iconName:iconName];
    } else {
        [cell setTitle:title iconUrl:iconName];
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.toolItemBlock) {
        self.toolItemBlock(collectionView, indexPath);
    }
}


#pragma mark - Events

- (void)pullDownBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.pullDownBlock) {
        self.pullDownBlock(sender);
    }
    if ([self.superview isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.superview;
        if (tableView.contentOffset.y) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self updateLayoutViews];
            });
        } else {
            [self updateLayoutViews];
        }
        if (!sender.selected) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        } else {
            [self.collectionView reloadData];
        }
    }
}

- (void)setBannarView:(NSArray *)arr {
    
    [self.loopView setPageContrllerNumberOfPages:arr.count hidden:NO];
    self.loopView.dataArray = arr.mutableCopy;
}

- (void)setHomeToolView:(NSArray *)toolArr isPulled:(BOOL)isPulled {
    self.toolArr = toolArr;
    self.pullDownBtn.selected = isPulled;
    
    if (self.toolArr.count <= itemCount) {
        self.pullDownBtn.hidden = YES;
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolBackView).offset(5);
        }];
    } else {
        self.pullDownBtn.hidden = NO;
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolBackView).offset(0);
        }];
    }
    
    [self.toolBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        NSInteger line = self.toolArr.count % itemCount ? (self.toolArr.count / itemCount + 1) : (self.toolArr.count / itemCount);
        if (self.pullDownBtn.selected) {
            make.height.equalTo(@(ScreenScale*(70*line) + 20));
        } else {
            make.height.equalTo(@(ScreenScale*70 + 20));
        }
    }];
    [self.collectionView reloadData];
}

#pragma mark - Block

- (void)bannarItemClickedWithJumpType:(NSInteger)type jumpAddress:(NSString *)jumpAddress {
    if (self.viewItemBlock) {
        self.viewItemBlock(jumpAddress, type);
    }
}

@end







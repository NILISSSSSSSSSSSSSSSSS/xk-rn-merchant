//
//  XKMyProductionViewController.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/10/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKMyProductionViewController.h"
#import "XKVideoDisplayModel.h"
#import "XKMyProductionCollectionViewCell.h"
#import "XKMyProductionPreviewModel.h"
#import "XKMyProductionPreviewViewController.h"
@interface XKMyProductionViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView  *bottomView;

@property (nonatomic, strong) UIButton  *previewBtn;

@property (nonatomic, strong) UIButton  *sendBtn;


@property (nonatomic, strong) NSMutableArray *productions;

@property (nonatomic, assign) NSUInteger page;

@property (nonatomic, assign) NSUInteger maxCount;

@property (nonatomic, strong) NSMutableArray *choseArr;

@end

@implementation XKMyProductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)handleData {
    [super handleData];
    _choseArr = [NSMutableArray array];
}

- (void)addCustomSubviews {
    [self setNavTitle:@"我的作品" WithColor:HEX_RGB(0xffffff)];
    [self.containView addSubview:self.collectionView];
    [self.containView addSubview:self.bottomView];
    [self.bottomView addSubview:self.previewBtn];
    [self.bottomView addSubview:self.sendBtn];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.containView);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kBottomSafeHeight);
        make.leading.trailing.mas_equalTo(self.containView);
        make.height.mas_equalTo(50.0);
    }];
    [self.previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.bottomView);
        make.leading.mas_equalTo(25.0);
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.mas_equalTo(self.bottomView);
        make.width.mas_equalTo(105.0);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [self postProductions];
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.productions.count >= weakSelf.maxCount) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [weakSelf postProductions];
    }];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
    footer.ignoredScrollViewContentInsetBottom = kBottomSafeHeight;
    self.collectionView.mj_footer = footer;
    self.page = 0;
    [self postProductions];
    
    self.emptyTipView = [XKEmptyPlaceView configScrollView:self.collectionView config:nil];
}

#pragma mark - privite method

- (void)previewBtnAction:(UIButton *) sender {
    if (self.choseArr.count) {
        NSMutableArray *array = [NSMutableArray array];
        for (XKVideoDisplayVideoListItemModel *video in self.choseArr) {
            NSString *imgUrl;
            NSString *videoUrl;
            if (video.video.zdy_cover && video.video.zdy_cover.length) {
                imgUrl = video.video.zdy_cover;
            } else if (video.video.first_cover && video.video.first_cover.length) {
                imgUrl = video.video.first_cover;
            } else {
                imgUrl = @"";
            }
            if (video.video.wmImg_video && video.video.wmImg_video.length) {
                videoUrl = video.video.wmImg_video;
            } else if (video.video.video && video.video.video.length) {
                videoUrl = video.video.video;
            } else {
                videoUrl = @"";
            }
            [array addObject:[[XKMyProductionPreviewModel alloc] initWitImgUrl:imgUrl videoUrl:videoUrl]];
        }
        __weak typeof(self) weakSelf = self;
        XKMyProductionPreviewViewController *vc = [[XKMyProductionPreviewViewController alloc] init];
        vc.finishBtnBlock = ^(NSArray<XKVideoDisplayVideoListItemModel *> * _Nonnull videos) {
            if (weakSelf.sendProductionsBlock) {
                weakSelf.sendProductionsBlock([weakSelf.choseArr copy]);
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc previewWithPreviews:[array copy]];
    }
}

- (void)sendBtnAction:(UIButton *) sender {
    if (self.sendProductionsBlock) {
        self.sendProductionsBlock([self.choseArr copy]);
    }
}

#pragma mark POST

/** 获取我的作品列表 */
- (void)postProductions {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(self.page) forKey:@"page"];
    [para setObject:@(10) forKey:@"limit"];
    
    [XKZBHTTPClient postRequestWithURLString:GetMyProductListUrl timeoutInterval:20.0 parameters:para success:^(id responseObject) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (self.page == 0) {
            [self.productions removeAllObjects];
            [self.collectionView.mj_footer resetNoMoreData];
            self.maxCount = [responseObject[@"body"][@"total"] unsignedIntegerValue];
        }
        [self.productions addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XKVideoDisplayVideoListItemModel class] json:responseObject[@"body"][@"video_list"]]];
        [self.collectionView reloadData];
        if (self.productions.count) {
            // 有数据
            [self.emptyTipView hide];
        } else {
            // 无数据
            [self.emptyTipView showWithImgName:kEmptyPlaceImgName title:nil des:@"暂无数据" tapClick:nil];
        }
        self.page += 1;
    } failure:^(XKHttpErrror *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (self.productions.count == 0) {
            __weak typeof(self) weakSelf = self;
            self.emptyTipView.config.viewAllowTap = YES; // 整个背景是否可点击  否则只有按钮可以点击
            [self.emptyTipView showWithImgName:kNetErrorPlaceImgName title:@"网络错误" des:@"点击屏幕重试" tapClick:^{
                [weakSelf postProductions];
            }];
        }
    }];
}

#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     XKMyProductionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKMyProductionCollectionViewCell" forIndexPath:indexPath];
    [cell configCellWithVideoModel:self.productions[indexPath.row]];
    [cell setChoseBtnSelected:[self.choseArr containsObject:self.productions[indexPath.row]]];
    __weak typeof(self) weakSelf = self;
    cell.choseBlock = ^{
        if ([weakSelf.choseArr containsObject:self.productions[indexPath.row]]) {
            [weakSelf.choseArr removeObject:self.productions[indexPath.row]];
        } else {
            if (weakSelf.choseArr.count == 9) {
                return ;
            }
            [weakSelf.choseArr addObject:self.productions[indexPath.row]];
        }
        weakSelf.sendBtn.enabled = weakSelf.choseArr.count;
        [weakSelf.sendBtn setTitle:[NSString stringWithFormat:@"发送(%zd)",weakSelf.choseArr.count] forState:UIControlStateNormal];
        weakSelf.sendBtn.backgroundColor = weakSelf.choseArr.count ? XKMainTypeColor : HEX_RGB(0x999999);
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
      return CGSizeMake((SCREEN_WIDTH - 2.0)  / 2.0, (SCREEN_WIDTH - 2.0)  / 2.0 / 9.0 * 16.0);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 50, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
    
        [_collectionView registerClass:[XKMyProductionCollectionViewCell class] forCellWithReuseIdentifier:@"XKMyProductionCollectionViewCell"];
    }
    return _collectionView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)previewBtn {
    if (!_previewBtn) {
        _previewBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        _previewBtn.titleLabel.font = XKRegularFont(17);
        [_previewBtn addTarget:self action:@selector(previewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewBtn;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_sendBtn setTitle:@"发送(0)" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = XKRegularFont(17);
        [_sendBtn setBackgroundColor:UIColorFromRGB(0x999999)];
        [_sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (NSMutableArray *)productions {
    if (!_productions) {
        _productions = [NSMutableArray array];
    }
    return _productions;
}

@end

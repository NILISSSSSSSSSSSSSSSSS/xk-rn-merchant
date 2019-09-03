////
////  XKMainItemCollectionViewCell.m
////  XKSquare
////
////  Created by 刘晓霖 on 2018/10/15.
////  Copyright © 2018年 xk. All rights reserved.
////
//
//#import "XKMainItemCollectionViewCell.h"
//#import "XKSqureHeaderToolCollectionViewCell.h"
//@interface XKMainItemCollectionViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
//
//@property (nonatomic, strong)UICollectionView *collectionView;
//
//
//@end
//
//@implementation XKMainItemCollectionViewCell
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if(self) {
//        self.backgroundColor = [UIColor whiteColor];
//        [self addCustomSubviews];
//        [self addUIConstraint];
//        self.xk_openClip = YES;
//        self.xk_radius = 8;
//        self.xk_clipType = XKCornerClipTypeAllCorners;
//    }
//    return self;
//}
//
//- (void)addCustomSubviews {
//    [self.contentView addSubview:self.collectionView];
//
//}
//
////- (void)bindData:(MallGoodsListItem *)item {
////    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:kDefaultPlaceHolderImg];
////    self.nameLabel.text = item.name;
////    self.sellLabel.text = [NSString stringWithFormat:@"月销量:%zd",item.saleQ];
////    self.priceLabel.text = [NSString stringWithFormat:@"¥%zd",item.price];
////}
//
//- (void)addUIConstraint {
//
//}
//
//#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    //    return _dataArr.count;
//    return 10;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    XKSqureHeaderToolCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XKSqureHeaderToolCollectionViewCell" forIndexPath:indexPath];
//    
//    NSString *title = @"";
//    NSString *iconName = @"";
//    title = @"火锅";
//    iconName = @"xk_btn_home_welfare";
//    [cell setTitle:title iconName:iconName];
//    return cell;
//}
//
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//
//}
//
//#pragma mark 懒加载
//- (UICollectionView *)collectionView {
//    if(!_collectionView) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 160) collectionViewLayout:layout];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//        _collectionView.alwaysBounceVertical = YES;
//        _collectionView.backgroundColor = [UIColor clearColor];
//        [_collectionView registerClass:[XKSqureHeaderToolCollectionViewCell class] forCellWithReuseIdentifier:@"XKSqureHeaderToolCollectionViewCell"];
//        
//        MJRefreshBackNormalFooter *foot = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            
//        }];
//        [foot setTitle:@"到底了..." forState:MJRefreshStateNoMoreData];
//        self.collectionView.mj_footer = foot;
//    }
//    return _collectionView;
//}
//@end

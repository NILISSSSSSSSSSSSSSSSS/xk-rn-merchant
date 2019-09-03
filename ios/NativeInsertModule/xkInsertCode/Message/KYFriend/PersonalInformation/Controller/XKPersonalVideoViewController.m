//
//  XKPersonalVideoViewController.m
//  XKSquare
//
//  Created by Lin Li on 2018/10/10.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPersonalVideoViewController.h"
#import "XKBottomAlertSheetView.h"
#import "XKPersonalVideoCollectionReusableView.h"
#import "XKPersonalVideoCollectionViewCell.h"
#import "XKPhotoPickHelper.h"
#import "XKPesonalDetailInfoModel.h"
#import "XKVideoDisplayModel.h"
#import "XKVideoDisplayMediator.h"

@interface XKPersonalVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
/**collectionView*/
@property(nonatomic, strong) UICollectionView *collectionView;
/**headerView*/
@property(nonatomic, strong)XKPersonalVideoCollectionReusableView *headerView;
@property(nonatomic, strong)XKPhotoPickHelper *photoPickHelper;
@property(nonatomic, strong)XKPesonalDetailInfoModel *model;
@property(nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation XKPersonalVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"小视频" WithColor:[UIColor whiteColor]];
    self.navigationView.backgroundColor = HEX_RGBA(0x4A90FA, 0);
    [self setNavRightButton];
    [self creatCollectionView];
    [self hideNavigationSeperateLine];
    [self loadUserNetWork];
    [self loadVideoNetWork];
}

- (void)creatCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.clipsToBounds = NO;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[XKPersonalVideoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[XKPersonalVideoCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self.view addSubview:_collectionView];
    [self.view bringSubviewToFront:self.navigationView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
}

- (void)setNavRightButton {
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"上传" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:17];
    [button addTarget:self action:@selector(upAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:button withframe:CGRectMake(0, 0, XKViewSize(45), 20)];
}

- (void)upAction:(UIButton *)sender {
    XKWeakSelf(ws);
    XKBottomAlertSheetView *sheet = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"我的收藏",@"我的作品",@"打开相册",@"拍摄",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle){
        switch (index) {
            case 0:{
                
            }
                break;
            case 1:{
                
            }
                break;
            case 2:{
                [ws.photoPickHelper videoFromLibiaryWithBlock:^(UIImage *coverImage, id asset) {
                    NSLog(@"%@", asset);
                }];
            }
                break;
            case 3:{
                [ws.photoPickHelper videoFromCameraWithBlock:^(NSString *videoPath, UIImage *coverImg) {
                    NSLog(@"%@", videoPath);
                }];
            }
                break;
                
            default:
                break;
        }
    }];
    [sheet show];
}
- (UIImage *)returnImageName {
    if ([self.model.sex isEqualToString:@"female"]) {
        return  IMG_NAME(@"xk_img_personDetailInfo_female");
    }else if ([self.model.sex isEqualToString:@"male"]){
        return IMG_NAME(@"xk_img_personDetailInfo_male");
    }else{
        return IMG_NAME(@"");
    }
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark collectionview代理 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 200);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XKPersonalVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(SCREEN_WIDTH/3, 188 * ScreenScale);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [XKVideoDisplayMediator displaySingleVideoWithViewController:self videoListItemModel:self.dataArray[indexPath.item]];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        identifier = @"HeaderView";
        XKPersonalVideoCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        self.headerView = view;
        if (self.type == XKKYPersonalVideoControllerType) {
           [self.headerView.backImgView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:nil];
            [self.headerView.headerImg sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:kDefaultHeadImg];
            [self.headerView.nameLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.appendImage([self returnImageName]).bounds(CGRectMake(0, -2, 17, 17));
                confer.text(self.model.nickname);
            }];
            self.headerView.shuoshuoLabel.text = self.model.signature;
        }else{
            [self.headerView.backImgView sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539176705265&di=e5e740c00798a9fb5f12171a6ec69ec3&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Fd1160924ab18972b5b0772d4eccd7b899e510aea.jpg"] placeholderImage:nil];
            [self.headerView.headerImg sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1539176705263&di=0492646a27ed3060da1568b938f11eae&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201602%2F18%2F20160218173243_4GCyW.thumb.700_0.jpeg"] placeholderImage:kDefaultHeadImg];
            [self.headerView.nameLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.appendImage(IMG_NAME(@"xk_img_personDetailInfo_male")).bounds(CGRectMake(0, -2, 17, 17));
                confer.text(@" 遇见一只柴");
            }];
            [self.headerView.shuoshuoLabel rz_colorfulConfer:^(RZColorfulConferrer * _Nonnull confer) {
                confer.text(@"柴犬是体型中等并且又最古老的犬。柴犬能够应付陡峭的丘陵和山脉的斜坡，拥有灵敏的感官，使得柴犬屡次成为上乘的狩猎犬。");
            }];
        }
        return view;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.mj_offsetY > 0) {//向上移动
        self.headerView.backImgView.y = -self.headerView.backImagYOffset;
        self.headerView.backImgView.height = self.headerView.backImagYOffset + self.headerView.headerViewheight;
    } else {//向下移动
        self.headerView.backImgView.y = -self.headerView.backImagYOffset + scrollView.mj_offsetY;
        self.headerView.backImgView.height = self.headerView.backImagYOffset + self.headerView.headerViewheight - scrollView.mj_offsetY;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {//向上移动
        CGFloat alpha = MIN(1, (offsetY)/NavigationAndStatue_Height);
        self.navigationView.backgroundColor = HEX_RGBA(0x4A90FA, alpha);
    } else {//向下移动
        self.navigationView.backgroundColor = HEX_RGBA(0x4A90FA, 0);
    }
}

- (XKPhotoPickHelper *)photoPickHelper {
    if (!_photoPickHelper) {
        _photoPickHelper = [[XKPhotoPickHelper alloc]init];
    }
    return _photoPickHelper;
}


#pragma mark ------网络请求-----

- (void)loadUserNetWork {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = [XKUserInfo getCurrentUserId];;
    parameters[@"rid"] = self.rid;
    [HTTPClient postEncryptRequestWithURLString:@"user/ua/xkUserHomePage/1.0" timeoutInterval:20.0 parameters:parameters success:^(id responseObject) {
        if (responseObject) {
             self.model = [XKPesonalDetailInfoModel yy_modelWithJSON:responseObject];
        }

    } failure:^(XKHttpErrror *error) {
        
    }];
}

- (void)loadVideoNetWork {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"page"] = @0;
    parameters[@"limit"] = @40;
    parameters[@"userId"] = [XKUserInfo getCurrentUserId];
    parameters[@"rid"] = self.rid;
    [XKZBHTTPClient postRequestWithURLString:@"index/Square/a001/showVideo/1.0" timeoutInterval:20.0 parameters:parameters success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            XKVideoDisplayModel * model = [XKVideoDisplayModel yy_modelWithJSON:responseObject];
            self.dataArray = model.body.video_list.mutableCopy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    } failure:^(XKHttpErrror * _Nonnull error) {
    }];
}

@end

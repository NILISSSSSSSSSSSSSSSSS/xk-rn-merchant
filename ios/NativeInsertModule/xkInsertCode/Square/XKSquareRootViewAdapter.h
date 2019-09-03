//
//  XKSquareRootViewAdapter.h
//  XKSquare
//
//  Created by hupan on 2018/8/7.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    CellType_carouselAndTool,//轮播和工具下的空cell
    CellType_reward,//抽奖
    CellType_subscription,//订阅
    
    CellType_storeRecommend,//商城推荐
    CellType_merchantRecommend,//商家推荐
    CellType_squreConsult,//广场资讯
    CellType_friendCircle,//朋友圈
    CellType_videoOfConcerned, //关注的小视频
    CellType_gamesRecommend, //游戏推荐
} CellType;

@protocol XKSquareRootViewAdapterDelegate <NSObject>

//TableViewCell
- (void)adapterTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath infoDic:(NSDictionary *)info;

//工具item
- (void)adapterToolItemClicked:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath itemCode:(NSString *)code;

//工具下拉条
- (void)adapterPullDownButtonClicked:(UIButton *)sender cellIndexPath:(NSIndexPath *)indexPath;

//轮播图
- (void)adapterAutoScrollViewItemSelectedWithJumpType:(NSUInteger)jumpType jumpAddress:(NSString *)jumpAddress;

//商城推荐Collection
- (void)adapterStoreRecommendCollectionView:(UICollectionView *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath info:(NSDictionary *)info;

//more
- (void)footerMoreViewSelected:(NSInteger)moreViewTag;


//朋友圈图片点击
- (void)adapterFriendsCircleCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath imgUrlArr:(NSArray *)imgUrlArr;


//推荐小视频点击
- (void)videoRecommendItemSelected:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath infoDic:(NSDictionary *)dic;

@end


@interface XKSquareRootViewAdapter : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak  ) id<XKSquareRootViewAdapterDelegate> delegate;
@property (nonatomic, copy  ) NSString                            *cityCode;
@property (nonatomic, assign) CGFloat                             lng;
@property (nonatomic, assign) CGFloat                             lat;
@property (nonatomic, strong) dispatch_group_t                     group;

@property (nonatomic, strong) UITableView                         *tableView;
@property (nonatomic, copy  ) NSArray                             *subscriptionArray;


// 请求广告数据
- (void)requestLaunchAdvertisementData;

// 请求更新信息
- (void)requestUpdateInfoData;

// 请求首页卡券数据
- (void)requestSquareCardCouponsData;


//注册cell
- (void)registerAllCells;

//刷新首页工具
- (void)refreshHomeToolView;

//请求轮播图数据
- (void)requestBannerData;

//home工具接口
- (void)requestSquareHomeToolData;

//抽奖信息
- (void)requestSqureRewardData;

//请求商城的商品推荐数据
- (void)requestStoreRecommendData;

//请求商圈商家推荐
- (void)requestMerchantRecommendData;

//广场资讯
- (void)requestSquareConsultData;

//朋友圈推荐
- (void)requestSquareFriendsCircleRecommendData;

//小视频推荐
- (void)requestVideoRecommendData;

//游戏推荐
- (void)requestGamesRecommendData;

@end

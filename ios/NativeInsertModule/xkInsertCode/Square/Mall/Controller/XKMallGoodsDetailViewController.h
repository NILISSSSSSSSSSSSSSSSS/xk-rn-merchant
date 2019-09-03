//
//  XKMallGoodsDetailViewController.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/12.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseWKWebViewController.h"
#import "XKMallListViewModel.h"

typedef NS_ENUM(NSInteger, XKMallGoodsDetailViewControllerType) {
    XKMallGoodsDetailViewControllerTypeSoldByXiaoke = 0,         /**< 自营商品详情 */
    XKMallGoodsDetailViewControllerTypeSoldByVideoAdvertisement  /**< 小视频广告商品详情 */
};

@interface XKMallGoodsDetailViewController : BaseWKWebViewController

/**传item 或者 goodsId 初始化数据*/
@property(nonatomic, copy) NSString *goodsId;
@property(nonatomic, assign) XKMallGoodsDetailViewControllerType type;

/**
   自营商品详情

 @param item 模型
 */
/*暂不需要
- (void)updateDataWithItem:(MallGoodsListItem *)item;
 */
@end

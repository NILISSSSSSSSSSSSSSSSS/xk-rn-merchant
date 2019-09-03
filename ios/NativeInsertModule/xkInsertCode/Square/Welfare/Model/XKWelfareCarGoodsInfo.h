/*******************************************************************************
 # File        : XKWelfareCarGoodsInfo.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/28
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>

@interface XKWelfareCarGoodsInfo : NSObject
/**是否失效*/
@property (nonatomic , assign) BOOL  status;
/**id*/
@property (nonatomic , copy) NSString *goodsId;
/**数量*/
@property (nonatomic , assign) NSInteger quantity;
/**价格*/
@property (nonatomic , copy) NSString *price;
/**开奖时间*/
@property (nonatomic , copy) NSString *drawType;
/**开奖时间*/
@property (nonatomic , copy) NSString *drawTime;
/**最大注数*/
@property (nonatomic , copy) NSString *maxStake;
/**累计开奖次数*/
@property (nonatomic , copy) NSString *lotteryNumber;
/**已购买注数*/
@property (nonatomic , copy) NSString *participateStake;
/**商品名称*/
@property (nonatomic , copy) NSString *name;
/**商品图片*/
@property (nonatomic , copy) NSString *url;
@end

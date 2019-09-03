/*******************************************************************************
 # File        : XKCollectGoodsModel.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/26
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
@interface XKCollectGoodsTarget :NSObject
@property (nonatomic , copy) NSString              * targetId;
@property (nonatomic , copy) NSString              * sequenceId;
@property (nonatomic , strong) NSArray <NSString *>              * typeList;
@property (nonatomic , copy) NSString              *price;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * showPics;
@property (nonatomic , strong) NSArray <NSString *>              * targetType;
@property (nonatomic , assign) NSInteger              mouthVolume;
@property (nonatomic , copy) NSString              * goodsType;
@property (nonatomic , assign) BOOL              isLoseEfficacy;
// 规格
@property (nonatomic, copy) NSString *showSkuName;
@property (nonatomic , copy) NSString              * buyPrice;

@end


@interface XKCollectGoodsDataItem :NSObject
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , strong) XKCollectGoodsTarget * target;
@property (nonatomic , assign) NSInteger              updatedAt;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * xkModule;
@property (nonatomic , assign) BOOL              isSelected;
@property (nonatomic , assign) BOOL              isSendSelected;

@end


@interface XKCollectGoodsModel :NSObject
@property (nonatomic , strong) NSArray <XKCollectGoodsDataItem *>      * data;
@property (nonatomic , assign) NSInteger              total;

@end

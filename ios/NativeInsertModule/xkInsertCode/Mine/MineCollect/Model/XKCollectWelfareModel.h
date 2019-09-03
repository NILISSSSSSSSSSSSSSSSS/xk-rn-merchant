/*******************************************************************************
 # File        : XKCollectWelfareModel.h
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

@interface Target :NSObject
@property (nonatomic , copy) NSString              * sequenceId;
@property (nonatomic , copy) NSString              * targetId;
@property (nonatomic , copy) NSString              * drawStatus;
@property (nonatomic , assign) NSInteger              joinCount;
@property (nonatomic , copy) NSString              * drawType;
@property (nonatomic , copy) NSString              * showPics;
@property (nonatomic , copy) NSString              * showAttr;
@property (nonatomic , assign) NSInteger              runningDate;
@property (nonatomic , assign) NSInteger              perPrice;
@property (nonatomic , copy) NSString              *expectDrawTime;
@property (nonatomic , strong) NSArray <NSString *>              * typeList;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * goodsName;
@property (nonatomic , assign) NSInteger              maxStake;

@end


@interface XKCollectWelfareDataItem :NSObject
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , strong) Target              * target;
@property (nonatomic , assign) NSInteger              updatedAt;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * xkModule;
@property (nonatomic , assign) BOOL              isSelected;
@property (nonatomic , assign) BOOL              isSendSelected;

@end


@interface XKCollectWelfareModel :NSObject
@property (nonatomic , strong) NSArray <XKCollectWelfareDataItem *>              * data;
@property (nonatomic , assign) NSInteger              total;

@end

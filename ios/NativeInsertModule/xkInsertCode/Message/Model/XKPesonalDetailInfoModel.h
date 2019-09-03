/*******************************************************************************
 # File        : XKPesonalDetailInfoModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/18
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
#import "XKContactModel.h"

@interface XKPesonalDetailInfoModel :XKContactModel

@property (nonatomic , copy) NSString              * fansNum;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * birthday;
@property(nonatomic  , copy) NSString              * constellation;
@property (nonatomic , copy) NSString              * followNum;


@end

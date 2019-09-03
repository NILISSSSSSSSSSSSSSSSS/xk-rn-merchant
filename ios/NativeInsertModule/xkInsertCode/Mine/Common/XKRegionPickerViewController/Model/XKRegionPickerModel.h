//
//  XKRegionPickerModel.h
//  XKSquare
//
//  Created by RyanYuan on 2018/8/30.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRegionPickerModel : NSObject

@property (nonatomic, copy) NSString *provinceCode; /**< 省级编码 */
@property (nonatomic, copy) NSString *cityCode;     /**< 市级编码 */
@property (nonatomic, copy) NSString *districtCode; /**< 区级编码 */

@property (nonatomic, copy) NSString *provinceName; /**< 省级名称 */
@property (nonatomic, copy) NSString *cityName;     /**< 市级名称 */
@property (nonatomic, copy) NSString *districtName; /**< 区级名称 */

@end

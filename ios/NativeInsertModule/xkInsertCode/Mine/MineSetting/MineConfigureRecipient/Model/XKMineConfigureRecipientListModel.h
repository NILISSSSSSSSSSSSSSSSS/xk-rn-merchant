//
//  XKMineConfigureRecipientListModel.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/19.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKMineConfigureRecipientItem :NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *receiver;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *districtName;
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *districtCode;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *isDefault;

@end

@interface XKMineConfigureRecipientListModel : NSObject

@property (nonatomic, copy) NSString *total;
@property (nonatomic, strong) NSArray<XKMineConfigureRecipientItem *> *data;

@end


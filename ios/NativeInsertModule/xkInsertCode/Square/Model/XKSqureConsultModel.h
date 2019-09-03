//
//  XKSqureConsultModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/22.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ConsultItemModel;

@interface XKSqureConsultModel : NSObject

@property (nonatomic , strong) NSArray <ConsultItemModel *>  * data;
@property (nonatomic , assign) NSInteger                     total;
@property (nonatomic , assign) BOOL                          empty;

@end



@interface ConsultItemModel :NSObject

@property (nonatomic , copy) NSString              * activityTypeId;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * createdAt;
@property (nonatomic , copy) NSString              * itemId;
@property (nonatomic , copy) NSString              * pushTime;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * updatedAt;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , copy) NSString              * image;

@end




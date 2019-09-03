//
//  XKOrderTransportInfoModel.h
//  XKSquare
//
//  Created by 刘晓霖 on 2018/11/28.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface XKOrderTransportInfoObj : NSObject
@property (nonatomic , copy) NSString              * location;
@property (nonatomic , copy) NSString              * time;
@end

@interface XKOrderTransportInfoModel : NSObject
@property (nonatomic , copy)   NSString              * companyName;
@property (nonatomic , copy)   NSString              * number;
@property (nonatomic , copy)   NSString              * status;
@property (nonatomic , copy)   NSString              * deliveryStatus;
@property (nonatomic , copy)   NSString              * ID;
@property (nonatomic , assign) NSInteger              createdAt;
@property (nonatomic , assign) NSInteger              isSign;
@property (nonatomic , strong) NSArray <XKOrderTransportInfoObj *>              * list;
@property (nonatomic , assign) NSInteger              updatedAt;

+ (void)requestTransportInfoWithParm:(NSDictionary *)parmDic Success:(void(^)(id data))success failed:(void(^)(NSString *failedReason ,NSInteger code))failed;
@end

NS_ASSUME_NONNULL_END

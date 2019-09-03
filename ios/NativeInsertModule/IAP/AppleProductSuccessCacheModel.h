//
//  AppleProductSuccessCacheModel.h
//  HFTPayCenter
//
//  Created by Jamesholy on 2018/4/19.
//  Copyright © 2018年 shenghai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppleProductSuccessCacheModel : NSObject
/**唯一标识*/
@property(nonatomic, copy) NSString *transactionIdentifier;

@property (nonatomic, copy  ) NSString   *orderNo;
@property (nonatomic, copy  ) NSString   *tradeNo;
@property (nonatomic, copy  ) NSString   *ticket;
@end

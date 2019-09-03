//
//  XKWelfarePastAwardRecordModel.h
//  XKSquare
//
//  Created by xudehuai on 2018/12/3.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKWelfarePastAwardRecordModel : NSObject

@property (nonatomic, copy) NSString *mainUrl;

@property (nonatomic, copy) NSString *sequenceId;

@property (nonatomic, assign) NSUInteger expectDrawTime;

@property (nonatomic, copy) NSString *goodsId;

@end

NS_ASSUME_NONNULL_END

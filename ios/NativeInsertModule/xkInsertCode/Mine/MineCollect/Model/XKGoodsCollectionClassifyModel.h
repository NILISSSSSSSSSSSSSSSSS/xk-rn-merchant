//
//  XKGoodsCollectionClassifyModel.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/27.
//  Copyright © 2018 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface goodsChildrenItem :NSObject
@property (nonatomic , copy) NSString              * picUrl;
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , assign) NSInteger              level;
@property (nonatomic , assign) NSInteger              enable;
@property (nonatomic , assign) NSInteger              pCode;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sort;

@end


@interface XKGoodsCollectionClassifyChildrenItem :NSObject
@property (nonatomic , copy) NSString              * picUrl;
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , assign) NSInteger              level;
@property (nonatomic , strong) NSArray <goodsChildrenItem *>              * children;
@property (nonatomic , assign) NSInteger              enable;
@property (nonatomic , assign) NSInteger              pCode;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sort;

@end


@interface XKGoodsCollectionClassifyModel :NSObject
@property (nonatomic , copy) NSString              * picUrl;
@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , assign) NSInteger              level;
@property (nonatomic , strong) NSArray <XKGoodsCollectionClassifyChildrenItem *>              * children;
@property (nonatomic , assign) NSInteger              pCode;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sort;

@end
NS_ASSUME_NONNULL_END

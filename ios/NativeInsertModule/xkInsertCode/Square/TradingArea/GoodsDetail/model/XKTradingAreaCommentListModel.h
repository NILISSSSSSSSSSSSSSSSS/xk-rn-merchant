//
//  XKTradingAreaCommentListModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/24.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CommentListItem;
@class ShopReplier;
@class Goods;
@class Commenter;

@interface XKTradingAreaCommentListModel : NSObject

@property (nonatomic , strong) NSArray <CommentListItem *>  * data;
@property (nonatomic , assign) BOOL                        empty;
@property (nonatomic , assign) NSInteger                   total;

@end




@interface CommentListItem :NSObject

@property (nonatomic , strong) Commenter          * commenter;
@property (nonatomic , strong) ShopReplier        * shopReplier;
@property (nonatomic , strong) Goods              * goods;

@property (nonatomic , assign) BOOL                   unfold;
@property (nonatomic , copy  ) NSString              * content;
@property (nonatomic , copy  ) NSString              * createdAt;
@property (nonatomic , copy  ) NSString              * itemId;
@property (nonatomic , strong) NSArray <NSString *>  * pictures;
@property (nonatomic , assign) NSInteger              score;
@property (nonatomic , assign) NSInteger              replyCount;
@property (nonatomic , copy  ) NSString              * status;
@property (nonatomic , copy  ) NSString              * updatedAt;
@property (nonatomic , copy  ) NSString              * video;

@end

@interface ShopReplier :NSObject

@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * createdAt;
@property (nonatomic , copy) NSString              * replierId;

@end


@interface Goods :NSObject
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , copy  ) NSString              * goodsId;
@property (nonatomic , copy  ) NSString              * name;
@property (nonatomic , copy  ) NSString              * mainPic;
@property (nonatomic , copy  ) NSString              * shopId;
@property (nonatomic , copy  ) NSString              * skuCode;
@property (nonatomic , copy  ) NSString              * skuValue;

@end


@interface Commenter :NSObject
@property (nonatomic , copy) NSString              * account;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * commenterId;
@property (nonatomic , copy) NSString              * nickName;

@end
























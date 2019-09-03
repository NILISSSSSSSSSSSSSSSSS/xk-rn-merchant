//
//  XKCustomServiceGoodsView.h
//  xkMerchant
//
//  Created by 刘晓霖 on 2018/12/19.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ListType) {
  ListTypeSearch  = 0,
  ListTypeNotSearch
};
NS_ASSUME_NONNULL_BEGIN

@interface XKCustomServiceGoodsView : UIView
- (instancetype)initWithTicketArr:(NSArray *)ticketArr titleStr:(NSString *)title;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, copy)void(^choseBlock)(id item);
/**带不带搜索框*/
@property(nonatomic, assign) ListType searchType;
@end

NS_ASSUME_NONNULL_END

//
//  XKVideoDisplayModel.h
//  XKSquare
//
//  Created by RyanYuan on 2018/10/15.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XKVideoDisplayTopicModel :NSObject
@property (nonatomic, assign) NSInteger topic_id;
@property (nonatomic, copy) NSString *topic_name;
@end

@interface XKVideoDisplayRecomGoodsItemModel :NSObject
@property (nonatomic, copy) NSString *goods_id;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *goods_type;
@end

@interface XKVideoDisplayMusicModel :NSObject
@property (nonatomic, assign) NSInteger music_id;
@property (nonatomic, copy) NSString *music_name;
@property (nonatomic, copy) NSString *music_img;
@end

@interface XKVideoDisplayLocationModel :NSObject
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@end

@interface XKVideoDisplayAddsModel :NSObject
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *add;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, strong) XKVideoDisplayLocationModel *location;
@end

@interface XKVideoDisplayVideoModel :NSObject
@property (nonatomic, copy) NSString *video;
@property (nonatomic, copy) NSString *wmImg_video;
@property (nonatomic, copy) NSString *first_cover;
@property (nonatomic, copy) NSString *zdy_cover;
@property (nonatomic, assign) NSInteger video_id;
@property (nonatomic, assign) NSInteger doc_type;
@property (nonatomic, assign) NSInteger date;
@property (nonatomic, assign) NSInteger share_num;
@property (nonatomic, assign) NSInteger gift_to_money;
@property (nonatomic, assign) NSInteger com_num;
@property (nonatomic, assign) NSInteger praise_num;
@property (nonatomic, assign) NSInteger watch_num;
@property (nonatomic, assign) NSInteger fans_num;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL is_praise;
@property (nonatomic, assign) BOOL is_danger;
@end

@interface XKVideoDisplayUserModel :NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_img;
@property (nonatomic, copy) NSString *rooms_id;
@property (nonatomic, copy) NSString *play;
@property (nonatomic, assign) NSInteger is_follow;
@property (nonatomic, assign) BOOL is_live;
@end

@interface XKVideoDisplayVideoListItemModel :NSObject
@property (nonatomic, strong) XKVideoDisplayTopicModel *topic;
@property (nonatomic, strong) NSArray <XKVideoDisplayRecomGoodsItemModel *> *recom_goods;
@property (nonatomic, strong) XKVideoDisplayMusicModel *music;
@property (nonatomic, strong) XKVideoDisplayAddsModel *adds;
@property (nonatomic, strong) XKVideoDisplayVideoModel *video;
@property (nonatomic, strong) XKVideoDisplayUserModel *user;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic , assign) BOOL              isSendSelected;

@end

@interface XKVideoDisplayBodyModel :NSObject
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, copy) NSString *rand;
@property (nonatomic, strong) NSArray <XKVideoDisplayVideoListItemModel *> *video_list;
@end

@interface XKVideoDisplayModel : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) XKVideoDisplayBodyModel *body;
@end

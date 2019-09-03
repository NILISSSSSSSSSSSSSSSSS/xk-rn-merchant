//
//  XKMyProductionModel.h
//  XKSquare
//
//  Created by RyanYuan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKMyProductionTopicModel :NSObject
@property (nonatomic , assign) NSInteger topic_id;
@end

@interface XKMyProductionMusicModel :NSObject
@property (nonatomic , assign) NSInteger music_id;
@property (nonatomic , copy) NSString *music_img;
@property (nonatomic , copy) NSString *music_name;
@end

@interface XKMyProductionLocationModel :NSObject
@property (nonatomic , copy) NSString *lat;
@property (nonatomic , copy) NSString *lon;
@end

@interface XKMyProductionAddsModel :NSObject
@property (nonatomic , copy) NSString *city;
@property (nonatomic , copy) NSString *area;
@property (nonatomic , copy) NSString *add;
@property (nonatomic , strong) XKMyProductionLocationModel *location;
@end

@interface XKMyProductionVideoModel :NSObject
@property (nonatomic , copy) NSString *video;
@property (nonatomic , copy) NSString *wmImg_video;
@property (nonatomic , copy) NSString *first_cover;
@property (nonatomic , copy) NSString *zdy_cover;
@property (nonatomic , assign) NSInteger video_id;
@property (nonatomic , assign) NSInteger doc_type;
@property (nonatomic , assign) NSInteger date;
@property (nonatomic , assign) NSInteger share_num;
@property (nonatomic , assign) NSInteger gift_to_money;
@property (nonatomic , assign) NSInteger com_num;
@property (nonatomic , assign) NSInteger praise_num;
@property (nonatomic , assign) NSInteger watch_num;
@property (nonatomic , assign) NSInteger fans_num;
@property (nonatomic , copy) NSString *describe;
@property (nonatomic , assign) NSInteger status;
@end

@interface XKMyProductionUserModel :NSObject
@property (nonatomic , copy) NSString *user_id;
@property (nonatomic , copy) NSString *user_img;
@property (nonatomic , copy) NSString *user_name;
@property (nonatomic , copy) NSString *is_follow;
@end

@interface XKMyProductionVideoListItemModel :NSObject
@property (nonatomic , strong) XKMyProductionTopicModel *topic;
@property (nonatomic , strong) XKMyProductionMusicModel *music;
@property (nonatomic , strong) XKMyProductionAddsModel *adds;
@property (nonatomic , strong) XKMyProductionVideoModel *video;
@property (nonatomic , strong) XKMyProductionUserModel *user;
@end

@interface XKMyProductionBodyModel :NSObject
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , assign) NSInteger total;
@property (nonatomic , strong) NSArray <XKMyProductionVideoListItemModel *> *video_list;
@end

@interface XKMyProductionModel :NSObject
@property (nonatomic , assign) NSInteger code;
@property (nonatomic , copy) NSString *message;
@property (nonatomic , strong) XKMyProductionBodyModel *body;
@end

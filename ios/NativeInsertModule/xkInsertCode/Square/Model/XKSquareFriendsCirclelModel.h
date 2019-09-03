//
//  XKSquareFriendsCirclelModel.h
//  XKSquare
//
//  Created by hupan on 2018/10/23.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKContactModel.h"
@class FriendsCirclelListItem;
@class FriendsCirclelCommentsItem;
@class FriendsCirclelPictureContentsItem;
@class FriendsCirclelLikesItem;
@class FriendsCirclelVideoContentsItem;

@interface XKSquareFriendsCirclelModel : NSObject

@property (nonatomic , assign) NSInteger                                total;
@property (nonatomic , strong) NSArray <FriendsCirclelListItem *>       * list;

@end


@interface FriendsCirclelListItem :NSObject <YYModel>

@property (nonatomic , copy  ) NSString                                        * createdAt;
@property (nonatomic , assign) BOOL                                            isLike;
@property (nonatomic , assign) BOOL                                            isAuth;
@property (nonatomic , assign) BOOL                                            isMe;
@property (nonatomic , copy  ) NSString                                        * content;
/**动态类型 picture video*/
@property (nonatomic , copy  ) NSString                                        * detailType;
@property (nonatomic , copy  ) NSString                                        * userId;
@property (nonatomic , copy  ) NSString                                        * nickname;
@property (nonatomic , copy  ) NSString                                        * avatar;

@property (nonatomic , copy  ) NSString                                        * did;

@property (nonatomic , strong) NSArray <FriendsCirclelLikesItem *>             * likes;
@property (nonatomic , strong) NSArray <FriendsCirclelCommentsItem *>          * comments;
@property (nonatomic , strong) NSArray <FriendsCirclelPictureContentsItem *>   * pictureContents;
@property (nonatomic , strong) NSArray <FriendsCirclelVideoContentsItem *>     * videoContents;
@property (nonatomic , assign) BOOL                                            unfold;

- (BOOL)isStrange;

@end

@interface FriendsCirclelCommentsItem :NSObject

/**评论类型（comment 评论，reply 回复 */
@property (nonatomic , copy) NSString              * commentType;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * replyUserId;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * did;
@property (nonatomic , copy) NSString              * commentsItemId;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * updatedAt;
@property (nonatomic , copy) NSString              * createdAt;


#pragma mark - 辅助
/**<##>*/
@property(nonatomic, strong) XKContactModel *user;
@property(nonatomic, strong) XKContactModel *replyUser;

/**<##>*/
@property(nonatomic, strong) NSAttributedString *contentMStr;
/**<##>*/
@property(nonatomic, assign) CGFloat contentHeight;

@end


@interface FriendsCirclelPictureContentsItem :NSObject

@property (nonatomic , assign) NSInteger               sort;
@property (nonatomic , copy  ) NSString                * url;

@end


@interface FriendsCirclelVideoContentsItem :NSObject

@property (nonatomic , copy  ) NSString                * showPic;
@property (nonatomic , copy  ) NSString                * url;
@property (nonatomic , copy  ) NSString                * describe;

@end


@interface FriendsCirclelLikesItem :NSObject

@property (nonatomic , copy) NSString              * createdAt;
@property (nonatomic , copy) NSString              * did;
@property (nonatomic , copy) NSString              * likesItemId;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * updatedAt;
@property (nonatomic , copy) NSString              * userId;

@property(nonatomic, strong) XKContactModel *user;

@end



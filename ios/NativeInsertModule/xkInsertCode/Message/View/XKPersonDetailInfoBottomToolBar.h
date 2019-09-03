//
//  XKPersonDetailInfoBottomToolBar.h
//  XKSquare
//
//  Created by Jamesholy on 2018/9/18.
//  Copyright © 2018年 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKPesonalDetailInfoModel.h"
@protocol XKPersonDetailInfoBottomToolBarDelegate <NSObject>

#pragma mark - 关注按钮点击
- (void)attentionButtonClick;

#pragma mark - 添加可友点击
- (void)addXKFriendButtonClick;

#pragma mark - 添加密友点击
- (void)addSecretFriendButtonClick;

#pragma mark - 发送消息点击
- (void)sendMessageButtonClick;

#pragma mark - 接收申请点击
- (void)acceptApplyButtonClick;

@end


typedef NS_ENUM(NSInteger,XKPersonDetailInfoBottomToolStatus) {
    XKPersonDetailInfoBottomToolNoraml = 0, // 关注 ， 加好友或者发消息状态
    XKPersonDetailInfoBottomToolIsFriendApply, //  好友申请状态
};

/**只做界面显示和事件传输  不要做逻辑 否则逻辑混乱*/

@interface XKPersonDetailInfoBottomToolBar : UIView

/**<##>*/
@property(nonatomic, weak) id<XKPersonDetailInfoBottomToolBarDelegate> delegate;

@property(nonatomic,assign) XKPersonDetailInfoBottomToolStatus toolStatus;
@property(nonatomic,assign) BOOL    secret;
@property(nonatomic,copy) NSString *    secretId; // 此时的secretId
@property(nonatomic,assign) XKRelationType    followRelation;
@property(nonatomic,assign) XKRelationType    friendRelation;
@property(nonatomic,assign) XKRelationType    secretRelation;
@property(nonatomic, strong) XKPesonalDetailInfoModel *info;

- (void)updateUI;
@end

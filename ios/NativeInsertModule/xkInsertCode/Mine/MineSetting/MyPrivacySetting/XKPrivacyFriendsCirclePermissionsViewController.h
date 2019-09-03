//
//  XKPrivacyFriendsCirclePermissionsViewController.h
//  XKSquare
//
//  Created by william on 2018/9/14.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

@class XKFriendsCirclePermissionsModel;

typedef enum : NSUInteger {
    PermissionsType_notLookTheir,//我不看他朋友圈
    PermissionsType_notLookMine,//不让他看我朋友圈
} PermissionsType;


@interface XKPrivacyFriendsCirclePermissionsViewController : BaseViewController

@property (nonatomic, assign) PermissionsType permissionsType;

@end

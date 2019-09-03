//
//  XKWelfareCollectionViewCell.h
//  XKSquare
//
//  Created by Lin Li on 2018/11/16.
//  Copyright © 2018 xk. All rights reserved.
//

#import "XKDeleteCollectionViewCell.h"
#import "XKCollectWelfareModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef  void(^choseBtnBlock)(void);
typedef  void(^shareBtnBlock)(XKCollectWelfareDataItem *model);

@interface XKWelfareCollectionViewCell : XKDeleteCollectionViewCell
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong)UIButton    *shareButton;
/**model*/
@property(nonatomic, strong) XKCollectWelfareDataItem *model;

@property(nonatomic, copy) choseBtnBlock block;
/**
 分享按钮block
 */
@property(nonatomic, copy) shareBtnBlock shareBlock;
/**
 进入管理模式
 */
- (void)updateLayout;

/**
 退出管理模式
 */
- (void)restoreLayout;

@property (nonatomic, assign)XKControllerType controllerType;


/**
 发送选择按钮block
 */
@property(nonatomic, copy) shareBtnBlock sendChoseblock;
@end

NS_ASSUME_NONNULL_END

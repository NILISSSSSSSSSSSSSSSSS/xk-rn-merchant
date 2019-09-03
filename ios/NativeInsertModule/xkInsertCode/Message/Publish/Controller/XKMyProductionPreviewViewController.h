//
//  XKMyProductionPreviewViewController.h
//  XKSquare
//
//  Created by xudehuai on 2018/11/22.
//  Copyright © 2018 xk. All rights reserved.
//

#import "BaseViewController.h"

@class XKMyProductionPreviewModel;

NS_ASSUME_NONNULL_BEGIN

@interface XKMyProductionPreviewViewController : BaseViewController

@property (nonatomic, copy) NSString *finishBtnTitle;

@property (nonatomic, copy) void(^finishBtnBlock)(NSArray <XKVideoDisplayVideoListItemModel *>*videos);

- (void)previewWithPreviews:(NSArray <XKMyProductionPreviewModel *>*) previews;

@end

NS_ASSUME_NONNULL_END

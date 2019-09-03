//
//  XKOrderSureChooseSeatNumViewController.h
//  XKSquare
//
//  Created by hupan on 2018/9/26.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^RefreshBlock)(NSMutableDictionary *selectedMuDic);

@interface XKOrderSureChooseSeatNumViewController : BaseViewController

@property (nonatomic, copy  ) RefreshBlock           refreshBlock;
@property (nonatomic, copy  ) NSString              *shopId;
@property (nonatomic, assign) NSInteger              maxSeat;
@property (nonatomic ,strong) NSMutableDictionary   *selectedSetMuDic;

@end

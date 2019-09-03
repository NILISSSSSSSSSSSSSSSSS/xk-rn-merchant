//
//  XKShareDetailsContentView.h
//  XKSquare
//
//  Created by Lin Li on 2018/10/23.
//  Copyright © 2018 xk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKQRCodeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKShareDetailsContentView : UIView
/**imageView*/
@property(nonatomic, strong) UIImageView *topImageView;
/**contentView*/
@property(nonatomic, strong) UIView *contentView;
/**bottom*/
@property(nonatomic, strong) UIView *bottomView;
/**contentView*/
@property(nonatomic, strong) UIView *topContentView;

@property (nonatomic, strong)XKQRCodeView *iconImgView;

@property (nonatomic, strong)UILabel     *nameLabel;

-(void)creatUI ;
@end

NS_ASSUME_NONNULL_END

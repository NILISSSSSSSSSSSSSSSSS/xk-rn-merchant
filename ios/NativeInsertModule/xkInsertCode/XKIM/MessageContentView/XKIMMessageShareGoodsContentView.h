//
//  XKIMMessageShareGoodsContentView.h
//  XKSquare
//
//  Created by william on 2018/11/9.
//  Copyright © 2018 xk. All rights reserved.
//

#import "NIMSessionMessageContentView.h"

@interface XKIMMessageShareGoodsContentView : XKIMMessageBaseContentView

@property(nonatomic,strong)UIImageView          *headerImageView;
@property(nonatomic,strong)UILabel              *titleLabel;
@property(nonatomic,strong)UILabel              *despLabel;
@property(nonatomic,strong)UILabel              *priceLabel;
@property(nonatomic,strong)UILabel              *fromLabel;
@property(nonatomic,strong)UIView               *midLine;

@end


//
//  XKCustomerSerMoreContainerView.m
//  XKSquare
//
//  Created by william on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKCustomerSerMoreContainerView.h"
#import "UIButton+XKButton.h"
#import "XKCustomerSerComplaintViewController.h"
#import <TZImagePickerController.h>
#import "XKIMGlobalMethod.h"
#import "XKCustomerSerEvaluateView.h"
#import "XKCustomerSerRootViewController.h"
#import "XKWelfareOrderListViewModel.h"
#import "XKMallOrderViewModel.h"
#import "XKCommonSheetView.h"
#import "XKCustomerSerChatOrderView.h"
#import <NIMKit.h>
#import "XKIMMessageCustomerSerOrderAttachment.h"
#import "XKCustomeSerMessageManager.h"
#import "XKCommonSheetView.h"
#import "XKMallBuyCarViewModel.h"
#import "XKCustomServiceGoodsView.h"

@interface XKCustomerSerMoreContainerView()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, assign)XKIMType    IMType;

/**
 相册
 */
@property(nonatomic, strong)UIButton    *photoButton;


/**
 照相
 */
@property(nonatomic, strong)UIButton    *cameraButton;


/**
 订单
 */
@property(nonatomic, strong)UIButton    *orderButton;


/**
 评价
 */
@property(nonatomic, strong)UIButton    *evaluateButton;


/**
 投诉客服
 */
@property(nonatomic, strong)UIButton    *complaintCustomerSerButton;

/**
 发送服务
 */
@property(nonatomic, strong)UIButton    *sendServiceButton;

/**
 发送商品
 */
@property(nonatomic, strong)UIButton    *sendGoodsButton;

@end

@implementation XKCustomerSerMoreContainerView

#pragma mark – Life Cycle
-(id)initWithFrame:(CGRect)frame andSession:(NIMSession *)session{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _session = session;
//        [self initViews];
//        [self layoutViews];
    }
    return self;
}

#pragma mark – Private Methods

-(void)initViews{
  for (UIView *temp in self.subviews) {
    [temp removeFromSuperview];
  }
  if (self.IMType == XKIMTypeSquareCustomerService) {
    [self addSubview:self.photoButton];
    [self addSubview:self.cameraButton];
    [self addSubview:self.orderButton];
    [self addSubview:self.complaintCustomerSerButton];
  } else if (self.IMType == XKIMTypeMerchantCustomerService) {
    [self addSubview:self.photoButton];
    [self addSubview:self.sendServiceButton];
    [self addSubview:self.sendGoodsButton];
    self.sendServiceButton.hidden = YES;
    self.sendGoodsButton.hidden = YES;
  }
}

-(void)layoutViews{
  if (self.IMType == XKIMTypeSquareCustomerService) {
    
    [_photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self->_cameraButton.mas_top);
      make.right.mas_equalTo(self->_cameraButton.mas_left).offset(-20 * ScreenScale);
      make.size.mas_equalTo(CGSizeMake(65 * 1.0, 85 * 1.0));
    }];

    [_cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self.mas_top).offset(20 * ScreenScale);
      make.right.mas_equalTo(self.mas_centerX).offset(-10 * ScreenScale);
      make.size.mas_equalTo(CGSizeMake(65 * 1.0, 85 * 1.0));
    }];
    
    [_orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self->_cameraButton.mas_top);
      make.left.mas_equalTo(self.mas_centerX).offset(10 * ScreenScale);
      make.size.mas_equalTo(CGSizeMake(65 * 1.0, 85 * 1.0));
    }];

    [_complaintCustomerSerButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self->_cameraButton.mas_top);
      make.left.mas_equalTo(self->_orderButton.mas_right).offset(20 * ScreenScale);
      make.size.mas_equalTo(CGSizeMake(65 * 1.0, 85 * 1.0));
    }];
  } else if (self.IMType == XKIMTypeMerchantCustomerService) {
    
    [_photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self->_sendServiceButton.mas_top);
      make.right.mas_equalTo(self->_sendServiceButton.mas_left).offset(-20 * ScreenScale);
      make.size.mas_equalTo(CGSizeMake(65 * 1.0, 85 * 1.0));
    }];
    
    [_sendServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self.mas_top).offset(20 * ScreenScale);
      make.right.mas_equalTo(self.mas_centerX).offset(-10 * ScreenScale);
      make.size.mas_equalTo(CGSizeMake(65 * 1.0, 85 * 1.0));
    }];
    
    [_sendGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self->_sendServiceButton.mas_top);
      make.left.mas_equalTo(self.mas_centerX).offset(10 * ScreenScale);
      make.size.mas_equalTo(CGSizeMake(65 * 1.0, 85 * 1.0));
    }];
  }
}

- (void)configWithIMType:(XKIMType)IMType {
  _IMType = IMType;
  [self initViews];
  [self layoutViews];
}

#pragma mark - Events
-(void)photoButtonClicked:(UIButton *)sender{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        
        [XKCustomeSerMessageManager sendSerImageMessageWithImageArr:photos sessoin:self->_session];
    }];
    [[self getCurrentUIVC] presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)cameraButtonClicked:(UIButton *)sender{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self; //设置代理
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera; //图片来源
    [[self getCurrentUIVC] presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)orderButtonClicked:(UIButton *)sender{
  XKCustomerSerRootViewController *vc = (XKCustomerSerRootViewController *)[self getCurrentUIVC];
  [vc hideInputView];
  XKCommonSheetView *sheetView = [[XKCommonSheetView alloc] init];
  
  XKCustomerSerChatOrderView *orderView = [[XKCustomerSerChatOrderView alloc] initWithFrame:CGRectMake(0.0, SCREEN_HEIGHT, SCREEN_WIDTH, 422.0 + kBottomSafeHeight)];
  orderView.closeBtnBlock = ^{
    [sheetView dismiss];
  };
  orderView.sendBtnBlock = ^(NSArray *array) {
    [sheetView dismiss];
    for (id order in array) {
      XKIMMessageCustomerSerOrderAttachment *attachment = [[XKIMMessageCustomerSerOrderAttachment alloc] init];
      if ([order isKindOfClass:[WelfareOrderDataItem class]]) {
        WelfareOrderDataItem *welfareOrder = (WelfareOrderDataItem *)order;
        attachment.orderType = 1;
        attachment.orderId = welfareOrder.orderId;
        attachment.orderCommodityCount = 1;
        attachment.orderIconUrl = welfareOrder.url;
        attachment.commodityName = welfareOrder.name;
        attachment.commoditySpecification = @"";
        attachment.orderTotalAmount = 0.0;
      }
      if ([order isKindOfClass:[MallOrderListDataItem class]]) {
        MallOrderListDataItem *platformOrder = (MallOrderListDataItem *)order;
        attachment.orderType = 2;
        attachment.orderId = platformOrder.orderId;
        attachment.orderCommodityCount = platformOrder.goods.count;
        attachment.orderIconUrl = platformOrder.goods.count >= 1 ? (platformOrder.goods.firstObject.goodsPic) : @"";
        if (platformOrder.goods.count >= 1) {
          MallOrderListObj *goods = platformOrder.goods.firstObject;
          if (platformOrder.goods.count == 1) {
            attachment.commodityName = goods.goodsName;
            attachment.commoditySpecification = goods.goodsShowAttr;
          } else {
            attachment.commodityName = [NSString stringWithFormat:@"共%tu件商品", platformOrder.goods.count];
            attachment.commoditySpecification = @"";
          }
        } else {
          attachment.commodityName = @"订单内无商品";
          attachment.commoditySpecification = @"";
        }
        attachment.orderTotalAmount = platformOrder.totalPrice;
      }
      [XKCustomeSerMessageManager sendSerOrderMessageWithOrderDictionary:attachment session:self.session];
    }
  };
  sheetView.contentView = orderView;
  [sheetView addSubview:orderView];
  [sheetView show];
}

-(void)evaluateButtonClicked:(UIButton *)sender{
    XKCustomerSerRootViewController *vc = (XKCustomerSerRootViewController *)[self getCurrentUIVC];
    [vc hideInputView];
    XKCustomerSerEvaluateView *evaluateView = [[XKCustomerSerEvaluateView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [evaluateView show];
}

-(void)complaintCustomerSerButtonClicked:(UIButton *)sender{
    XKCustomerSerComplaintViewController *vc = [[XKCustomerSerComplaintViewController alloc]init];
    [[self getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

-(void)sendServiceButtonClicked:(UIButton *)sender {
  XKCommonSheetView *commonSheetView = [[XKCommonSheetView alloc] init];
  XKCustomServiceGoodsView *serviceView = [[XKCustomServiceGoodsView alloc] initWithTicketArr:@[] titleStr:@""];
  commonSheetView.contentView = serviceView;
  [commonSheetView addSubview:serviceView];
  serviceView.choseBlock = ^(XKMallBuyCarItem *item) {
    [commonSheetView dismiss];
  };
  [commonSheetView show];
}

-(void)sendGoodsButtonClicked:(UIButton *)sender {
  XKCommonSheetView *commonSheetView = [[XKCommonSheetView alloc] init];
  XKCustomServiceGoodsView *goodsView = [[XKCustomServiceGoodsView alloc] initWithTicketArr:@[] titleStr:@""];
  commonSheetView.contentView = goodsView;
  [commonSheetView addSubview:goodsView];
  goodsView.choseBlock = ^(XKMallBuyCarItem *item) {
    [commonSheetView dismiss];
  };
  [commonSheetView show];
}

#pragma mark - Custom Delegates
#pragma mark -实现图片选择器代理-（上传图片的网络请求也是在这个方法里面进行，这里我不再介绍具体怎么上传图片）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    NSLog(@"%@",image);
    [XKCustomeSerMessageManager sendSerImageMessageWithImageArr:@[image] sessoin:self->_session];

}

//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark – Getters and Setters


-(UIButton *)photoButton{
    if (!_photoButton) {
        _photoButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"相册" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_photoButton setImage:[UIImage imageNamed:@"xk_btn_IM_inputView_photo"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(photoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_photoButton setImageAtTopAndTitleAtBottomWithSpace:7];
    }
    return _photoButton;
}

-(UIButton *)cameraButton{
    if (!_cameraButton) {
        _cameraButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"照相" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_cameraButton setImage:[UIImage imageNamed:@"xk_btn_IM_inputView_camera"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraButton setImageAtTopAndTitleAtBottomWithSpace:7];
    }
    return _cameraButton;
}

-(UIButton *)orderButton{
    if (!_orderButton) {
        _orderButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"订单" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_orderButton setImage:[UIImage imageNamed:@"xk_btn_IM_inputView_order"] forState:UIControlStateNormal];
        [_orderButton addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_orderButton setImageAtTopAndTitleAtBottomWithSpace:7];
    }
    return _orderButton;
}

-(UIButton *)evaluateButton{
    if (!_evaluateButton) {
        _evaluateButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"评价" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_evaluateButton setImage:[UIImage imageNamed:@"xk_btn_IM_inputView_evaluat"] forState:UIControlStateNormal];
        [_evaluateButton addTarget:self action:@selector(evaluateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_evaluateButton setImageAtTopAndTitleAtBottomWithSpace:7];
    }
    return _evaluateButton;
}

-(UIButton *)complaintCustomerSerButton{
    if (!_complaintCustomerSerButton) {
        _complaintCustomerSerButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"投诉客服" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
        [_complaintCustomerSerButton setImage:[UIImage imageNamed:@"xk_btn_IM_inputView_complaintCustomerSer"] forState:UIControlStateNormal];
        [_complaintCustomerSerButton setImageAtTopAndTitleAtBottomWithSpace:7];
        [_complaintCustomerSerButton addTarget:self action:@selector(complaintCustomerSerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _complaintCustomerSerButton;
}

-(UIButton *)sendServiceButton {
  if (!_sendServiceButton) {
    _sendServiceButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"发送服务" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
    [_sendServiceButton setImage:[UIImage imageNamed:@"xk_sh_btn_IM_inputView_sendService"] forState:UIControlStateNormal];
    [_sendServiceButton setImageAtTopAndTitleAtBottomWithSpace:7];
    [_sendServiceButton addTarget:self action:@selector(sendServiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _sendServiceButton;
}

-(UIButton *)sendGoodsButton {
  if (!_sendGoodsButton) {
    _sendGoodsButton = [BaseViewFactory buttonWithFrame:CGRectMake(0, 0, 65, 85) font:[UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:12] title:@"发送服务" titleColor:UIColorFromRGB(0x777777) backColor:[UIColor clearColor]];
    [_sendGoodsButton setImage:[UIImage imageNamed:@"xk_sh_btn_IM_inputView_sendGoods"] forState:UIControlStateNormal];
    [_sendGoodsButton setImageAtTopAndTitleAtBottomWithSpace:7];
    [_sendGoodsButton addTarget:self action:@selector(sendGoodsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _sendGoodsButton;
}

@end

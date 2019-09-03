//
//  XKQRCodeView.h
//  QRCodeScan
//
//  Created by hupan on 2018/7/24.
//  Copyright © 2018年 hupan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKQRCodeView : UIView

/**
 将String转换成二维码图片
 
 @param qrString qrString description
 */
- (void)createQRImageWithQRString:(NSString *)qrString;
 // L,M,Q,H 容错率
- (void)createQRImageWithQRString:(NSString *)qrString correctionLevel:(NSString *)level;

/**
 将String转换成条形码图片
 
 @param barCodeString barCodeString description
 */
- (void)createBarCodeImageWithBarCodeString:(NSString *)barCodeString;
/**
 将String转换成条形码图片  分享专用
 
 @param barCodeString barCodeString description
 */
- (void)createShareQRImageWithQRString:(NSString *)qrString correctionLevel:(NSString *)level;
@end

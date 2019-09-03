/*******************************************************************************
 # File        : xkMerchantEmitterModule.h
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2018/12/24
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <React/RCTEventEmitter.h>


@interface xkMerchantEmitterModule : RCTEventEmitter<RCTBridgeModule>

+ (void)loginTokenFail:(NSString *)code message:(NSString*)message;

+ (void)friendRedPointStatusChange:(BOOL)has;

+ (void)RNJumpToWelfareDetailWithSequenceId:(NSString *)sequenceId goodsId:(NSString *)goodsId;

+ (void)RNJumpToGoodsDetailWithGoodsId:(NSString *)goodsId;

+ (void)RNSystemMessage:(NSString *)jsonStr;

+ (void)RNJumpToPersonalVcUserId:(NSString *)userId;

@end

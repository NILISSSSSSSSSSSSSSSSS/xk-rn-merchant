/*******************************************************************************
 # File        : XKReceiptInfoModel.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/7
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>

@interface XKReceiptInfoModel : NSObject <YYModel>

/**id*/
@property(nonatomic, copy) NSString *receiptId;
/**类别 类别（PERSONAL[个人], ENTERPRISE[企业]） must*/
@property(nonatomic, copy) NSString *type;
/**发票抬头 must*/
@property(nonatomic, copy) NSString *head;
/**企业税号 must*/
@property(nonatomic, copy) NSString *taxNo;
/**企业地址*/
@property(nonatomic, copy) NSString *address;
/**开户银行*/
@property(nonatomic, copy) NSString *bankName;
/**银行账号*/
@property(nonatomic, copy) NSString *bankAccount;
/**是否默认*/
@property(nonatomic, assign) BOOL isDefault;

/**是否是个人发票*/
- (BOOL)isPersonal;
- (void)setPersonal:(BOOL)personal;

+ (instancetype)createForPerson;
+ (instancetype)createForCompany;

@end




typedef NS_ENUM(NSInteger,XKReceiptInfoInputType) {
    XKReceiptInfoInputTypeNormal = 0 ,// 不限制
    XKReceiptInfoInputTypeNum  ,// 数字
};

@interface XKReceiptInfoDataConfig : NSObject

+ (instancetype)configTitle:(NSString *)title hasStar:(BOOL)has placeHolder:(NSString *)placeHolder maxLength:(NSInteger)maxLengthNum minLength:(NSInteger)minLengthNum inputType:(XKReceiptInfoInputType)inputType;

/**名称*/
@property(nonatomic, copy) NSString *title;
/**是否加星星*/
@property(nonatomic, assign) BOOL hasStar;
/**placeHolder*/
@property(nonatomic, copy) NSString *placeHolder;
/**限制字数*/
@property(nonatomic, assign) NSInteger maxLengthNum;
/**限制字数*/
@property(nonatomic, assign) NSInteger minLengthNum;
/**输入限制*/
@property(nonatomic, assign) XKReceiptInfoInputType inputType;

@end



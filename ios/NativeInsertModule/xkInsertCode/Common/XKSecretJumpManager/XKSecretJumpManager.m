/*******************************************************************************
 # File        : XKSecretJumpManager.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/31
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKSecretJumpManager.h"
#import <QN_GTM_Base64.h>
#import "NSString+XYPinYin.h"
#import "XKSecretFriendRootViewController.h"
#import "XKSecretContactCacheManager.h"

@interface XKSecretJumpManager ()
/**<##>*/
@property(nonatomic, assign) BOOL canJump;
@end

@implementation XKSecretJumpManager
+ (instancetype)shareManager {
  static XKSecretJumpManager *_instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [XKSecretJumpManager new];
  });
  return _instance;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _canJump = YES;
  }
  return self;
}

+ (void)canJump:(BOOL)canJump {
  [XKSecretJumpManager shareManager].canJump = canJump;
}

- (void)textFieldTextChange:(UITextField *)textField {
  if (!self.canJump) {
    return;
  };
  [self dealJump:textField];
}

static NSMutableArray *_zzArr;
static BOOL _hasShowAlert;
#pragma mark - 判断是否需要跳转密友圈
- (void)dealJump:(UITextField *)textField {
  NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
  if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 有高亮选择的字 则不搜索
    if (position) {
      return;
    }
  }
  NSString *text = textField.text;
  if (text.length > 2) {
    NSString *last = [text substringFromIndex:text.length - 1];
    // #＃
    if ([last isEqualToString:@"#"] || [last isEqualToString:@"＃"]) {
      NSString *secretCode = [text substringToIndex:text.length - 1];
      NSMutableDictionary *params = [NSMutableDictionary dictionary];
      params[@"secretPwd"] = secretCode;
      [HTTPClient postEncryptRequestWithURLString:@"im/ua/secretCircleFind/1.0" timeoutInterval:20 parameters:params success:^(id responseObject) {
        XKSecretCircleInfo *info = [XKSecretCircleInfo yy_modelWithJSON:responseObject];
        if (info.secretId) {
          
          if (_hasShowAlert == NO) {
            _hasShowAlert = YES;
            [KEY_WINDOW endEditing:YES];
            [XKAlertView showCommonAlertViewWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"是否进入密友圈【%@】",info.secretName] leftText:@"取消" rightText:@"确定" leftBlock:^{
              _hasShowAlert = NO;
              [XKSecretContactCacheManager configCurrentSecretId:nil];
            } rightBlock:^{
              _hasShowAlert = NO;
              XKSecretFriendRootViewController * vc = [[XKSecretFriendRootViewController alloc] init];
              vc.circleInfoModel = info;
              [self.getCurrentUIVC.navigationController pushViewController:vc animated:YES];
            } textAlignment:NSTextAlignmentCenter];
          }
          
        }
      } failure:^(XKHttpErrror *error) {
        //
      }];
    }
  }
}

@end

@implementation UITextField (SecretJump)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class targetClass = [self class];
    SEL originalSelector = @selector(initWithFrame:);
    SEL swizzledSelector = @selector(sy_initWithFrame:);
    [self swizzleMethod:targetClass orgSel:originalSelector swizzSel:swizzledSelector];
  });
}

- (instancetype)sy_initWithFrame:(CGRect)frame {
  UITextField * text = [self sy_initWithFrame:frame];
  //    [text enableSecretJump:YES];
  return text;
}

- (void)enableSecretJump:(BOOL)canJump {
  if (canJump) {
    [self addTarget:[XKSecretJumpManager shareManager] action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
  } else {
    [self removeTarget:[XKSecretJumpManager shareManager] action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
  }
}


@end

@implementation UISearchBar (SecretJump)

- (void)enableSecretJump:(BOOL)canJump {
  UITextField *textField;
  for (UIView *subView in self.subviews) {
    if ([subView isKindOfClass:[UITextField class]]) {
      textField = (UITextField *)subView;
    }
  }
  if (canJump) {
    [textField addTarget:[XKSecretJumpManager shareManager] action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
  } else {
    [textField removeTarget:[XKSecretJumpManager shareManager] action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
  }
}


@end




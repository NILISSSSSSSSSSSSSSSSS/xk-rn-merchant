/*******************************************************************************
 # File        : BigPhotoPreviewDeleteController.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/9/20
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "BigPhotoPreviewDeleteController.h"
#import "PhotoPreviewModel.h"

@interface BigPhotoPreviewDeleteController ()

@end

@implementation BigPhotoPreviewDeleteController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isSupportLongPress = YES;
        self.longPressOptions = @[kLongPressOptionsSavePhoto];
        self.isShowNav = YES;
        self.isShowTitle = YES;
        self.isHiddenDeleteButton = NO;
        self.isShowStatusBar = YES;
    }
    return self;
}

- (void)deletePhotoDataAction {
    PhotoPreviewModel *deleteModel = (PhotoPreviewModel *)self.models[self.currentIndex];

    __weak typeof(self) weakSelf = self;;
    [XKHudView showSuccessMessage:@"删除成功" to:weakSelf.view time:1.1 animated:YES completion:^{
        [weakSelf handleDeletePhotoAction:deleteModel completeBlock:^(NSInteger index){
            EXECUTE_BLOCK(weakSelf.deleteComplete,index);
            
        }];
    }];
}



@end

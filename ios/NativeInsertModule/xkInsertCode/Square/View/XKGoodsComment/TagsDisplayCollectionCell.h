/*******************************************************************************
 # File        : TagsDisplayCollectionCell
 # Project     : Erp4iOS
 # Author      : Jamesholy
 # Created     : 2017/11/21
 # Corporation : 
 # Description :black_close <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <UIKit/UIKit.h>

@interface TagsDisplayCollectionCell : UICollectionViewCell
/**文字*/
@property(nonatomic, copy) NSString *text;
/**index*/
@property(nonatomic, assign) NSInteger index;
/**<##>*/
@property(nonatomic, assign) BOOL beSelected;

+ (CGSize)cellSize:(NSString *)text;

@end


@interface TagsDisplayInfo :NSObject
/**<##>*/
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) BOOL selected;
@end

/*******************************************************************************
 # File        : LeftCustomFlowLayout.m
 # Project     : Erp4iOS
 # Author      : Jamesholy
 # Created     : 2017/11/21
 # Corporation : 成都好房通科技股份有限公司
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "LeftCustomFlowLayout.h"

@implementation LeftCustomFlowLayout

- (instancetype)init
{
	self = [super init];
	if (self) {
		 self.maximumInteritemSpacing = 8.f;
	}
	return self;
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
	//使用系统帮我们计算好的结果。
	NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
	
	//第0个cell没有上一个cell，所以从1开始
	for(int i = 1; i < [attributes count]; ++i) {
		//这里 UICollectionViewLayoutAttributes 的排列总是按照 indexPath的顺序来的。
		UICollectionViewLayoutAttributes *curAttr = attributes[i];
		UICollectionViewLayoutAttributes *preAttr = attributes[i-1];
		
		NSInteger origin = CGRectGetMaxX(preAttr.frame);
		//根据  maximumInteritemSpacing 计算出的新的 x 位置
		CGFloat targetX = origin + _maximumInteritemSpacing;
		// 只有系统计算的间距大于  maximumInteritemSpacing 时才进行调整
		if (CGRectGetMinX(curAttr.frame) > targetX) {
			// 换行时不用调整
			if (targetX + CGRectGetWidth(curAttr.frame) < self.collectionViewContentSize.width) {
				CGRect frame = curAttr.frame;
				frame.origin.x = targetX;
				curAttr.frame = frame;
			}
		}
	}
	return attributes;
}

@end

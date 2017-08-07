//
//  RBTreeView.h
//  TreePro
//
//  Created by LHJ on 2017/8/3.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBTreeView : UIView

/** 先计算红黑树的高度，然后设置合适的尺寸 */
- (void) adjustTreeView:(void(^)(CGSize sizeView))completeBlock;

@end

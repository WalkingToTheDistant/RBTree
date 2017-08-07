//
//  RBTree.h
//  TreePro
//
//  Created by LHJ on 2017/7/18.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBTreeNode.h"

/** 红黑树 */
@interface RBTree : NSObject

/** 全局对象 */
+ (instancetype) sharedRBTree;

/** 添加节点值 */
- (void) addValue:(NSNumber*)value;

/** 删除节点值 */
- (void) deleteValue:(NSNumber*)value;

/** 获取树高度 */
- (int) getTreeHeight;

/** 获取树的根节点 */
- (RBTreeNode*) getRootTreeNode;

/** 获取某个节点的右子树高度 */
- (int) getTreeNodeRightHeight:(RBTreeNode*)treeNode;

/** 获取某个节点的左子树高度 */
- (int) getTreeNodeLeftHeight:(RBTreeNode*)treeNode;

@end

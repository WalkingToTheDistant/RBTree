//
//  RBTree.m
//  TreePro
//
//  Created by LHJ on 2017/7/18.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import "RBTree.h"
#import "RBTreeNode.h"

static RBTree *sharedRBTree = nil;

@implementation RBTree
{
    RBTreeNode *mRootTreeNode;
}
/** 全局对象 */
+ (instancetype) sharedRBTree
{
    if(sharedRBTree == nil){
        sharedRBTree = [RBTree new];
    }
    return sharedRBTree;
}

/** 添加节点值 */
+ (void) addValue:(NSNumber*)value
{
    [[RBTree sharedRBTree] addValue:value];
}

/** 添加节点值 */
- (void) addValue:(NSNumber*)value
{
    if(value == nil) { return; }
    
    RBTreeNode *nodeAdd = [RBTreeNode treeNodeWithValue:value withColor:NodeColor_Red];
    
    /** 二叉树操作 */
    if(mRootTreeNode == nil){
        mRootTreeNode = nodeAdd;
    } else {
        [self addValueWithParentNode:mRootTreeNode withNewTreeNode:nodeAdd];
    }
    
    /** 红黑树操作 */
    [self handleRBTree:nodeAdd];
}
- (void) addValueWithParentNode:(RBTreeNode*)parentNode withNewTreeNode:(RBTreeNode*)newTreeNode
{
    /** 二叉树的插入操作 */
    if(newTreeNode.getNodeValue <= parentNode.getNodeValue){ // 左节点
    
        if(parentNode.getLeftNode == nil){ // 如果左孩纸为空，直接赋值
            [parentNode setLeftNode:newTreeNode];
        } else {
            [self addValueWithParentNode:parentNode.getLeftNode withNewTreeNode:newTreeNode];
        }
        
    } else { // 右节点
        if(parentNode.getRightNode == nil){ // 如果右孩纸为空，直接赋值
            [parentNode setRightNode:newTreeNode];
        } else {
            [self addValueWithParentNode:parentNode.getRightNode withNewTreeNode:newTreeNode];
        }
    }
}
/** 根据当前指向的节点调整红黑树 */
- (void) handleRBTree:(__weak RBTreeNode*)treeNode
{
    /** 情况1：红黑树只有一个根节点 */
    if(treeNode == mRootTreeNode){ // 如果是根节点，那么直接将节点变黑即可
        [treeNode setNodeColor:NodeColor_Black];
        return;
    }
    /** 以下情况则必定存在父节点 */
    /** 情况2：当前节点的父节点为黑色 */
    if(treeNode.getParentNode.getNodeColor == NodeColor_Black){ // 符合红黑树规则，不需要处理
        return;
    }
    
    /** 以下情况父节点必定是红色，所以按照红黑树规则，必定存在祖父节点 */
    RBTreeNode *parentNode = treeNode.getParentNode; // 父节点
    RBTreeNode *grandfatherNode = parentNode.getParentNode; // 祖父节点
    BOOL isLeftForParentNodeToGrandfather = (grandfatherNode.getLeftNode == parentNode)? YES : NO; // 父节点是左节点还是右节点
    RBTreeNode *uncleNode = (isLeftForParentNodeToGrandfather == YES)? grandfatherNode.getRightNode : grandfatherNode.getLeftNode; // 叔叔节点
    BOOL isLeftForCurrentNodeToParent = (parentNode.getLeftNode == treeNode)? YES : NO; // 当前节点是左节点还是右节点
    
    /** 情况3：当前节点的父节点为红色，而叔叔节点也为红色（祖父节点和叔叔节点不为空） */
    if(parentNode.getNodeColor == NodeColor_Red
        && uncleNode != nil
        && uncleNode.getNodeColor == NodeColor_Red){
        // 把父节点、叔叔节点都变为黑，祖父节点变为红，然后当前节点指针指向祖父节点再继续监测红黑树
        [parentNode setNodeColor:NodeColor_Black];
        [uncleNode setNodeColor:NodeColor_Black];
        [grandfatherNode setNodeColor:NodeColor_Red];
        return [self handleRBTree:grandfatherNode];
    }
    
    /** 情况4：当前节点的父节点为红色，而叔叔节点为黑色，或者为空 */
    if(parentNode.getNodeColor == NodeColor_Red
        && (uncleNode == nil || uncleNode.getNodeColor == NodeColor_Black)){
        
        if(isLeftForParentNodeToGrandfather == YES){ // 父节点是祖父节点的左孩纸
            if(isLeftForCurrentNodeToParent == YES){ // 当前节点是父节点的左孩纸，这时候只需要把父节点变为黑，祖父节点变成红，当前节点指向祖父节点，并在祖父节点向右旋转
                [parentNode setNodeColor:NodeColor_Black];
                [grandfatherNode setNodeColor:NodeColor_Red];
                [self nodeRotate_toRight:grandfatherNode];
                return [self handleRBTree:grandfatherNode];
            } else { // 当前节点是父节点的右孩纸，那么先把当前节点指向父节点，然后在父节点左旋
                [self nodeRotate_toLeft:parentNode];
                return [self handleRBTree:parentNode];
            }
            
        } else { // 父节点是祖父节点的右孩纸
            if(isLeftForCurrentNodeToParent == YES){// 当前节点是父节点的左孩纸，那么先把当前节点指向父节点，然后在父节点右旋
                [self nodeRotate_toRight:parentNode];
                return [self handleRBTree:parentNode];
            
            } else {// 当前节点是父节点的右孩纸，这时候只需要把父节点变为黑，祖父节点变成红，当前节点指向祖父节点，并在祖父节点向左旋转
                [parentNode setNodeColor:NodeColor_Black];
                [grandfatherNode setNodeColor:NodeColor_Red];
                [self nodeRotate_toLeft:grandfatherNode];
                return [self handleRBTree:grandfatherNode];
            }
        }
    }
}
/** 节点旋转 - 向右旋转 */
- (void) nodeRotate_toRight:(__weak RBTreeNode*)treeNode
{
    RBTreeNode *leftChildTreeNode = [treeNode getLeftNode]; // 当前节点的左孩纸
    RBTreeNode *parentTreeNode = [treeNode getParentNode];
    if(parentTreeNode != nil){
        if(parentTreeNode.getLeftNode == treeNode){
            [parentTreeNode setLeftNode:leftChildTreeNode];
        } else {
            [parentTreeNode setRightNode:leftChildTreeNode];
        }
    }
    RBTreeNode *rightForChildTreeNode = [leftChildTreeNode getRightNode]; // 左孩纸的右孩纸
    [treeNode setLeftNode:rightForChildTreeNode];
    [leftChildTreeNode setRightNode:treeNode];
}
/** 节点旋转 - 向左旋转 */
- (void) nodeRotate_toLeft:(__weak RBTreeNode*)treeNode
{
    RBTreeNode *rightChildTreeNode = [treeNode getRightNode]; // 当前节点的右孩纸
    RBTreeNode *parentTreeNode = [treeNode getParentNode];
    if(parentTreeNode != nil){
        if(parentTreeNode.getLeftNode == treeNode){
            [parentTreeNode setLeftNode:rightChildTreeNode];
        } else {
            [parentTreeNode setRightNode:rightChildTreeNode];
        }
    }
    
    RBTreeNode *leftForChildTreeNode = [rightChildTreeNode getRightNode]; // 右孩纸的左孩纸
    [treeNode setRightNode:leftForChildTreeNode];
    [rightChildTreeNode setLeftNode:treeNode];
}

@end

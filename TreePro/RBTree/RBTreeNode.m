//
//  RBTreeNode.m
//  TreePro
//
//  Created by LHJ on 2017/7/17.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import "RBTreeNode.h"

@implementation RBTreeNode

@synthesize mLeftNode;
@synthesize mNodeColor;
@synthesize mNodeValue;
@synthesize mRightNode;
@synthesize mParentNode;

/** 初始化对象，并复制节点值和节点颜色 */
+ (instancetype) treeNodeWithValue:(NSNumber*)value withColor:(NodeColor)color
{
    RBTreeNode *node = [RBTreeNode new];
    [node setNodeValue:value];
    [node setNodeColor:color];
    return node;
}
- (void) setLeftNode:(RBTreeNode *)leftNode
{
    if(mLeftNode == leftNode) { return; }
    
    mLeftNode = leftNode;
    if(mLeftNode != nil){
        [mLeftNode setParentNode:self]; // 弱引用
    }
}
- (void) setRightNode:(RBTreeNode *)rightNode
{
    if(mRightNode == rightNode) { return; }
    
    mRightNode = rightNode;
    if(mRightNode != nil){
        [mRightNode setParentNode:self];
    }
}

@end

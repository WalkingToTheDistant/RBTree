//
//  RBTreeView.m
//  TreePro
//
//  Created by LHJ on 2017/8/3.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import "RBTreeView.h"
#import "RBTree.h"

static const int RadiusCircle = 15; // 节点半径
static const int LengthX_Line = RadiusCircle*3; // 节点之间的线间距 - X方向
static const int LengthY_Line = LengthX_Line; // 节点之间的线间距 - Y方向
static const int SpaceXOfTreeToEdge = 10; // 树跟View边缘的间距 - X方向
static const int SpaceYOfTreeToEdge = 60; // 树跟View边缘的间距 - Y方向
static const float LineWidth = 1.0f; // 线条宽度
static const int SpaceXForNode = RadiusCircle*11/10;

@implementation RBTreeView
{
    UIColor *mColorBlack;
    UIColor *mColorRed;
    UIColor *mColorLine;
    NSMutableArray<NSValue*> *mMuAryForNodeRect;
}
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
        [self initData];
    }
    return self;
}
- (void) removeFromSuperview
{
    [super removeFromSuperview];
    [mMuAryForNodeRect removeAllObjects];
}
- (void) initData
{
    mColorBlack = [UIColor blackColor];
    mColorRed = [UIColor redColor];
    mColorLine = [UIColor blueColor];
    mMuAryForNodeRect = [NSMutableArray new];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(contextRef, kCGLineCapSquare);
    CGContextSetLineWidth(contextRef, LineWidth);
    [self beginDrawRBTree:contextRef];
}
- (void) beginDrawRBTree:(CGContextRef)contextRef
{
    if(contextRef == NULL) { return; }
    
    int beginX = self.bounds.origin.x + self.bounds.size.width/2;
    int beginY = self.bounds.origin.y + SpaceYOfTreeToEdge;
    CGPoint pointBegin = CGPointMake(beginX, beginY);
    
    [self drawNodeWithContext:contextRef
               withBeginPoint:pointBegin
                  withToPoint:pointBegin
                 withTreeNode:[[RBTree sharedRBTree] getRootTreeNode]
     withTreeHeightForCurNode:[[RBTree sharedRBTree] getTreeHeight]];
}
- (void) drawNodeWithContext:(CGContextRef)contextRef
              withBeginPoint:(CGPoint)pointBegin
                 withToPoint:(CGPoint)pointTo
                withTreeNode:(RBTreeNode*)treeNode
    withTreeHeightForCurNode:(int)treeHeight
{
    if(contextRef == nil){ return; }
    if(treeNode == nil){ return; }
    
    // 首先检查将要画节点的位置，是否跟其他节点的位置有重合（覆盖）的情况，如果有，则稍微改变一下位置
    CGRect frameTo;
    frameTo.origin.x = pointTo.x - RadiusCircle;
    frameTo.origin.y = pointTo.y - RadiusCircle;
    frameTo.size = CGSizeMake(RadiusCircle*2, RadiusCircle*2);
    
    int index = 3;
    for(NSValue *valueRect in mMuAryForNodeRect){
        CGRect frameAry = [valueRect CGRectValue];
        index = 3; // 最多检查三遍
        while ( YES && index>0 ) {
            BOOL isIntersect = CGRectIntersectsRect(frameTo, frameAry);
            if(isIntersect == YES ){ // 两矩阵交错
                if(CGRectGetMinX(frameTo) < CGRectGetMinX(frameAry)){ // 将要画的节点在已画节点的左边
                    frameTo.origin.x -= SpaceXForNode; // 先减去一个单位的距离，然后重新检查一下这两个矩阵是否交错，如果还交错，则继续处理
                    
                } else {
                    frameTo.origin.x += SpaceXForNode;
                    
                }
                index -= 1; // 最多检查次数，避免特殊情况出现的死循环
                continue;
            }
            break;
        }
    }
    pointTo.x = frameTo.origin.x + RadiusCircle;
    [mMuAryForNodeRect addObject:[NSValue valueWithCGRect:frameTo]];
    
    // 先画线条
    if(CGPointEqualToPoint(pointBegin, pointTo) != YES){
        float value = (pointTo.x - pointBegin.x) / (pointTo.y - pointBegin.y);
        float angle = atan(value);
        int x = sin(angle) * RadiusCircle;
        int y = cos(angle) * RadiusCircle;
        CGPoint pointLineBegin = CGPointMake(pointBegin.x, pointBegin.y);
        pointLineBegin.x += x;
        pointLineBegin.y += y;
        
        CGPoint pointLineTo = CGPointMake(pointTo.x, pointTo.y);
        pointLineTo.x += (-x);
        pointLineTo.y += (-y);
        
        CGPoint points[2];
        points[0] = pointLineBegin;
        points[1] = pointLineTo;
        CGContextSetStrokeColorWithColor(contextRef, mColorLine.CGColor);
        CGContextAddLines(contextRef, points, 2);
        CGContextDrawPath(contextRef, kCGPathStroke);
    }
    
    // 画节点圆
    if(treeNode.getNodeColor == NodeColor_Red){ // 红色节点
        CGContextSetFillColorWithColor(contextRef, mColorRed.CGColor);
    } else { // 黑色节点
        CGContextSetFillColorWithColor(contextRef, mColorBlack.CGColor);
    }
    CGContextAddArc(contextRef, pointTo.x, pointTo.y, RadiusCircle, 0, M_PI*2, NO);
    CGContextDrawPath(contextRef, kCGPathFill);
    
    NSString *strText = [NSString stringWithFormat:@"%i", treeNode.getNodeValue.intValue];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor]; // 文字颜色
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:11]; // 字体
    CGSize size = [strText sizeWithAttributes:dic];
    CGPoint pointText = CGPointMake(pointTo.x, pointTo.y);
    pointText.x -= size.width/2;
    pointText.y -= size.height/2;
    [strText drawAtPoint:pointText withAttributes:dic];
    
    // 采用深度优先的方式绘制树
    if(treeNode.getLeftNode != nil){ // 先绘制左子树
        int heightLeft = [[RBTree sharedRBTree] getTreeNodeRightHeight:treeNode.getLeftNode];
        int valueForRootNode = heightLeft * SpaceXForNode + ((heightLeft > 0)? heightLeft-1 : 0) * LengthX_Line;
        int xTo = pointTo.x - valueForRootNode - LengthX_Line;
        int yTo = pointTo.y + LengthY_Line;
        CGPoint pointNext = CGPointMake(xTo, yTo);
        [self drawNodeWithContext:contextRef
                   withBeginPoint:pointTo
                      withToPoint:pointNext
                     withTreeNode:treeNode.getLeftNode
         withTreeHeightForCurNode:treeHeight-1];
    }
    
    if(treeNode.getRightNode != nil){ // 绘制右子树
        int heightRight = [[RBTree sharedRBTree] getTreeNodeLeftHeight:treeNode.getRightNode];
        int valueForRootNode =  heightRight * SpaceXForNode + ((heightRight > 0)? heightRight-1 : 0) * LengthX_Line;
        int xTo = pointTo.x + valueForRootNode + LengthX_Line;
        int yTo = pointTo.y + LengthY_Line;
        CGPoint pointNext = CGPointMake(xTo, yTo);
        [self drawNodeWithContext:contextRef
                   withBeginPoint:pointTo
                      withToPoint:pointNext
                     withTreeNode:treeNode.getRightNode
         withTreeHeightForCurNode:treeHeight-1];
    }
}
/** 刷新界面，一般用在修改红黑树之后 */
- (void) refreshView
{
    [mMuAryForNodeRect removeAllObjects];
    [self setNeedsDisplay];
}
/** 先计算红黑树的高度，然后设置合适的尺寸 */
- (void) adjustTreeView:(void(^)(CGSize sizeView))completeBlock
{
    int heightTree = [[RBTree sharedRBTree] getTreeHeight]; // 树高度
    if(heightTree == 0){ return; }
    
    int withView = pow(2, heightTree-1) * LengthX_Line + (pow(2, heightTree-1)-2)*SpaceXForNode + SpaceXOfTreeToEdge*2;
    int heightView = (heightTree-1) * LengthY_Line + SpaceYOfTreeToEdge*2;
    
    withView = (withView > self.bounds.size.width)? withView : self.bounds.size.width;
    heightView = (heightView > self.bounds.size.height)? heightView : self.bounds.size.height;
    CGRect frame = self.frame;
    frame.size = CGSizeMake(withView, heightView);
    self.frame = frame;
    [self refreshView];
    if(completeBlock != nil){
        completeBlock(self.bounds.size);
    }
}

@end

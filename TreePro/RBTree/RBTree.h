//
//  RBTree.h
//  TreePro
//
//  Created by LHJ on 2017/7/18.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 红黑树 */
@interface RBTree : NSObject

/** 全局对象 */
+ (instancetype) sharedRBTree;

/** 添加节点值 */
- (void) addValue:(NSNumber*)value;

/** 添加节点值 */
+ (void) addValue:(NSNumber*)value;

/** 删除节点值 */
- (void) deleteValue:(NSNumber*)value;

/** 删除节点值 */
+ (void) deleteValue:(NSNumber*)value;

@end

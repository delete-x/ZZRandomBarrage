//
//  ZZBarrageItemObjectProtocol.h
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZZBarrageItemQueuePriority)
{
    ZZBarrageItemQueuePriorityLow = 1 << 0,
    ZZBarrageItemQueuePriorityHigh = 1 << 1
};

/*
 弹幕itemObject协议
 */
@protocol ZZBarrageItemObjectProtocol <NSObject>

@required
// 绑定的Item的类名
- (Class)itemClass;
// 绑定的Item的布局大小
- (CGSize)itemSize;

@optional
// 排队优先级
- (ZZBarrageItemQueuePriority)queuePriority;

@end

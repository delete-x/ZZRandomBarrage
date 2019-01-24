//
//  ZZBarrageItemObject.m
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import "ZZBarrageItemObject.h"
#import "ZZBarrageItem.h"

@implementation ZZBarrageItemObject

- (Class)itemClass
{
    // 默认绑定的Item的基类
    return [ZZBarrageItem class];
}

// 绑定的Item的布局大小
- (CGSize)itemSize
{
    // 默认布局大小
    return CGSizeMake(60.0f, 36.0f);
}

- (ZZBarrageItemQueuePriority)queuePriority
{
    // 默认优先级: 低
    return ZZBarrageItemQueuePriorityLow;
}

@end

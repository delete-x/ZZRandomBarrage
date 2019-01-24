//
//  ZZBarrageItem.m
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import "ZZBarrageItem.h"

@implementation ZZBarrageItem

- (void)shouldUpdateItemWithObject:(ZZBarrageItemObject *)object {};

- (void)barrageView:(ZZRandomBarrageView *)barrageView itemDidAddedOnContentView:(UIView *)contentView object:(ZZBarrageItemObject *)object removeHandler:(ZZBarrageItemRemoveHandler)removeHandler
{
    // 默认: 3秒后移除item
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        removeHandler();
    });
}

@end

//
//  ZZRandomBarrageConfig.m
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import "ZZRandomBarrageConfig.h"          // 弹幕配置

@implementation ZZRandomBarrageConfig

- (instancetype)init
{
    if (self = [super init]) {
        // 属性默认值
        self.trackCount = 3;
        self.horMargin = 10.0f;
        self.minHorSpace = 4.0f;
        self.minVerSpace = 4.0f;
        self.maxQueueConcurrent = 1;
    }
    return self;
}

@end

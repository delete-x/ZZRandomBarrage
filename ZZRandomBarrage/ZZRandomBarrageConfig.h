//
//  ZZRandomBarrageConfig.h
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZRandomBarrageConfig : NSObject

// 弹道个数 (default : 3)
@property (nonatomic, assign) NSUInteger trackCount;
// 弹幕的水平边距 (default : 10.0f)
@property (nonatomic, assign) CGFloat horMargin;
// 弹幕最小水平间距 (default : 4.0f)
@property (nonatomic, assign) CGFloat minHorSpace;
// 弹幕最小垂直间距 (default : 4.0f)
@property (nonatomic, assign) CGFloat minVerSpace;
// 缓冲队列最大并发数量 (default : 1)
@property (nonatomic, assign) NSUInteger maxQueueConcurrent;

@end

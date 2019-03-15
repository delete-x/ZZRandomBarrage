//
//  ZZRandomBarrageView.h
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZRandomBarrageConfig.h"
#import "ZZBarrageItemObject.h"
#import "ZZBarrageItem.h"

@class ZZRandomBarrageView;

/*
 弹幕协议
 */
@protocol ZZRandomBarrageViewDelegate <NSObject>

// 弹幕更新时触发
- (void)barrageView:(ZZRandomBarrageView *)barrageView didUpdateBufferQueue:(NSArray *)bufferQueue;
// 弹幕被点击时触发
- (void)barrageView:(ZZRandomBarrageView *)barrageView didSelectItemObject:(ZZBarrageItemObject *)itemObject;
@end

/*
 随机弹幕View
 功能:
 1. 在符合不重叠原则下, 随机出合适的弹幕Item位置
 2. 支持缓存队列(当消息高并发时, 消息会自动排队)
 3. 支持消息的优先级, 优先级高的可以插队
 */
@interface ZZRandomBarrageView : UIView

@property (nonatomic, weak) id<ZZRandomBarrageViewDelegate> delegate;

/**
 自定义配置初始化
 @param config        配置
 */
- (instancetype)initWithConfig:(ZZRandomBarrageConfig *)config;

/**
 添加一个弹幕单元
 @param itemObject    弹幕单元对象
 */
- (void)addBarrageItemObject:(ZZBarrageItemObject *)itemObject;

/**
 清空
 */
- (void)clear;

@end

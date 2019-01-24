//
//  ZZBarrageTrack.m
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import "ZZBarrageTrack.h"          // 虚拟弹道

@interface ZZBarrageTrack ()

@property (nonatomic, strong) ZZRandomBarrageConfig *config;
@property (nonatomic, strong) NSMutableArray *itemFrameArray;

@end

@implementation ZZBarrageTrack

#pragma mark - public
- (instancetype)initWithConfig:(ZZRandomBarrageConfig *)config
{
    if (self = [super init]) {
        self.config = config;
    }
    return self;
}

- (BOOL)isCanHoldSize:(CGSize)aSize
{
    CGFloat margin = _config.horMargin;
    CGFloat left = margin;
    CGFloat right;
    for (int i = 0; i < _itemFrameArray.count + 1; i++) {
        NSValue *frameValue = nil;
        if (i < _itemFrameArray.count) {
            frameValue = _itemFrameArray[i];
            right = frameValue.CGRectValue.origin.x;
        } else {
            right = self.frame.size.width - margin;
        }
        CGFloat width = right - left;
        // 筛选出符合条件的空隙
        if (width >= (_config.minHorSpace * 2 + aSize.width)) {
            return YES;
        }
        if (frameValue) {
            left = frameValue.CGRectValue.origin.x + frameValue.CGRectValue.size.width;
        }
    }
    return NO;
}

- (NSValue *)getSuitableFrameWithItemObject:(ZZBarrageItemObject *)itemObject
{
    CGSize itemSize = [itemObject itemSize];
    NSMutableArray *spaceArray = [NSMutableArray array];
    CGFloat margin = _config.horMargin;
    CGFloat height = self.frame.size.height;
    CGFloat left = margin;
    CGFloat right;
    for (int i = 0; i < _itemFrameArray.count + 1; i++) {
        NSValue *frameValue = nil;
        if (i < _itemFrameArray.count) {
            frameValue = _itemFrameArray[i];
            right = frameValue.CGRectValue.origin.x;
        } else {
            right = self.frame.size.width - margin;
        }
        CGFloat width = right - left;
        // 筛选出符合条件的空隙
        if (width >= (_config.minHorSpace * 2 + itemSize.width)) {
            NSValue *value = [NSValue valueWithCGRect:CGRectMake(left, 0, width, height)];
            [spaceArray addObject:@{@"rect":value, @"index":@(i)}];
        }
        if (frameValue) {
            left = frameValue.CGRectValue.origin.x + frameValue.CGRectValue.size.width;
        }
    }
    if (spaceArray.count == 0) {
        return nil;
    }
    NSUInteger index = arc4random() % spaceArray.count;
    NSDictionary *dic = spaceArray[index];
    NSValue *rectValue = dic[@"rect"];
    NSUInteger arrIndex = [dic[@"index"] integerValue];
    CGRect rect = rectValue.CGRectValue;
    CGPoint point = [self getItemPointWithSize:itemSize inRect:rect];
    NSValue *frameValue = [NSValue valueWithCGRect:CGRectMake(point.x, point.y + self.frame.origin.y, itemSize.width, itemSize.height)];
    [self.itemFrameArray insertObject:frameValue atIndex:arrIndex];
    return frameValue;
}

- (void)removeItemFrameValue:(NSValue *)frameValue
{
    [self.itemFrameArray removeObject:frameValue];
}

- (void)clear
{
    [self.itemFrameArray removeAllObjects];
}

#pragma mark - private
/**
 获取一个合适且随机的item的布局坐标
 @param aSize   一个尺寸
 @return 合适且随机的布局坐标
 */
- (CGPoint)getItemPointWithSize:(CGSize)aSize inRect:(CGRect)rect
{
    CGFloat horSpace = _config.minHorSpace;
    CGFloat verMargin = _config.minVerSpace / 2.0;
    CGFloat diffX = [ZZBarrageTrack randomFloatBetweenFloat1:horSpace float2:rect.size.width - aSize.width - horSpace];
    CGFloat diffY = [ZZBarrageTrack randomFloatBetweenFloat1:verMargin float2:rect.size.height - (aSize.height + verMargin)];
    return CGPointMake(ceilf(rect.origin.x + diffX), ceilf((rect.origin.y + diffY)));
}

/*
 产生一个区间的随机浮点数
 @param float1   其中一个浮点数
 @param float2   其中一个浮点数
 @return 随机结果
 */
+ (CGFloat)randomFloatBetweenFloat1:(CGFloat)float1 float2:(CGFloat)float2
{
    CGFloat diffValue = float1 - float2;
    return float1 - ((arc4random() % 10) / 9.0) * diffValue;
}

#pragma mark - getter
- (NSMutableArray *)itemFrameArray
{
    if (!_itemFrameArray) {
        self.itemFrameArray = [NSMutableArray array];
    }
    return _itemFrameArray;
}

@end

//
//  ZZRandomBarrageView.m
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import "ZZRandomBarrageView.h"
#import "ZZBarrageTrack.h"              // 虚拟弹道

@interface ZZRandomBarrageView ()

@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIView *lowContentView;
@property (nonatomic, strong) UIView *highContentView;
@property (nonatomic, strong) NSMutableArray *itemQueue;
@property (nonatomic, strong) dispatch_source_t queueTimer;
@property (nonatomic, strong) NSMutableArray<ZZBarrageTrack *> *trackArray;
@property (nonatomic, strong) ZZRandomBarrageConfig *config;

@end

@implementation ZZRandomBarrageView

- (instancetype)initWithConfig:(ZZRandomBarrageConfig *)config
{
    if (self = [super init]) {
        self.config = config;
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    NSUInteger trackCount = self.config.trackCount;
    for (int i = 0; i < trackCount; i++) {
        ZZBarrageTrack *track = [[ZZBarrageTrack alloc] initWithConfig:self.config];
        [self.trackArray addObject:track];
    }
    [self addSubview:self.lowContentView];
    [self addSubview:self.highContentView];
    
    self.lowContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lowContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lowContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lowContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lowContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0f]];
    
    self.highContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.highContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.highContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.highContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.highContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0f]];
}

- (void)layoutSubviews
{
    CGSize size = self.bounds.size;
    if (!CGSizeEqualToSize(size, _size)) {
        NSUInteger trackCount = _trackArray.count;
        CGFloat trackHeight = size.height / trackCount * 1.0;
        CGFloat trackTop = 0;
        for (int i = 0; i < trackCount; i++) {
            ZZBarrageTrack *track = _trackArray[i];
            track.frame = CGRectMake(0, trackTop, size.width, trackHeight);
            trackTop += trackHeight;
        }
        self.size = size;
    }
}

/**
 添加一个弹幕单元
 @param itemObject    弹幕单元对象
 */
- (void)addBarrageItemObject:(ZZBarrageItemObject *)itemObject
{
    if (self.itemQueue.count > 0) {
        [self addQueueWithItemObject:itemObject];
        return;
    }
    [self tryShowBarrageItemObject:itemObject];
}

- (void)clear
{
    for (ZZBarrageTrack *track in _trackArray) {
        [track clear];
    }
    [self.itemQueue removeAllObjects];
    for (UIView *subView in self.lowContentView.subviews) {
        [subView removeFromSuperview];
    }
    for (UIView *subView in self.highContentView.subviews) {
        [subView removeFromSuperview];
    }
    if ([self.delegate respondsToSelector:@selector(barrageView:didUpdateBufferQueue:)]) {
        [self.delegate barrageView:self didUpdateBufferQueue:nil];
    }
}

- (void)tryShowBarrageItemObject:(ZZBarrageItemObject *)itemObject
{
    NSMutableArray *spaceTrackIndexArray = [NSMutableArray array];
    for (int i = 0; i < _trackArray.count; i++) {
        ZZBarrageTrack *track = _trackArray[i];
        if ([track isCanHoldSize:[itemObject itemSize]]) {
            [spaceTrackIndexArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    if (spaceTrackIndexArray.count == 0) {
        
        [self addQueueWithItemObject:itemObject];
        
    } else {
        
        if ([_itemQueue containsObject:itemObject]) {
            [_itemQueue removeObject:itemObject];
        }
        NSUInteger index = [spaceTrackIndexArray[arc4random() % spaceTrackIndexArray.count] integerValue];
        ZZBarrageTrack *track = _trackArray[index];
        NSValue *frameValue = [track getSuitableFrameWithItemObject:itemObject];
        Class itemClass = [itemObject itemClass];
        ZZBarrageItem *item = [[itemClass alloc] init];
        if ([itemObject queuePriority] == ZZBarrageItemQueuePriorityHigh) {
            [self.highContentView addSubview:item];
        } else {
            [self.lowContentView addSubview:item];
        }
        item.frame = frameValue.CGRectValue;
        
        if ([item respondsToSelector:@selector(shouldUpdateItemWithObject:)]) {
            [item shouldUpdateItemWithObject:itemObject];
        }
        
        if ([item respondsToSelector:@selector(barrageView:itemDidAddedOnContentView:object:removeHandler:)]) {
            ZZBarrageItemRemoveHandler removeHandler = ^{
                [item removeFromSuperview];
                [track removeItemFrameValue:frameValue];
            };
            [item barrageView:self itemDidAddedOnContentView:item.superview object:itemObject removeHandler:removeHandler];
        }
        
        if ([self.delegate respondsToSelector:@selector(barrageView:didUpdateBufferQueue:)]) {
            [self.delegate barrageView:self didUpdateBufferQueue:[NSArray arrayWithArray:self.itemQueue]];
        }
    }
}

- (void)addQueueWithItemObject:(ZZBarrageItemObject *)itemObject
{
    if ([self.itemQueue containsObject:itemObject]) {
        return;
    }
    switch ([itemObject queuePriority]) {
        case ZZBarrageItemQueuePriorityLow:
        {
            [self.itemQueue addObject:itemObject];
        }
            break;
        case ZZBarrageItemQueuePriorityHigh:
        {
            [self.itemQueue insertObject:itemObject atIndex:0];
        }
            break;
        default:
            break;
    }
    if (!_queueTimer) {
        dispatch_resume(self.queueTimer);
    }
    if ([self.delegate respondsToSelector:@selector(barrageView:didUpdateBufferQueue:)]) {
        [self.delegate barrageView:self didUpdateBufferQueue:[NSArray arrayWithArray:self.itemQueue]];
    }
}

#pragma mark - getter
- (ZZRandomBarrageConfig *)config
{
    if (!_config) {
        self.config = [ZZRandomBarrageConfig new];
    }
    return _config;
}

- (UIView *)lowContentView
{
    if (!_lowContentView) {
        self.lowContentView = [UIView new];
    }
    return _lowContentView;
}

- (UIView *)highContentView
{
    if (!_highContentView) {
        self.highContentView = [UIView new];
    }
    return _highContentView;
}

- (NSMutableArray<ZZBarrageTrack *> *)trackArray
{
    if (!_trackArray) {
        self.trackArray = [NSMutableArray array];
    }
    return _trackArray;
}

- (NSMutableArray *)itemQueue
{
    if (!_itemQueue) {
        self.itemQueue = [NSMutableArray array];
    }
    return _itemQueue;
}

- (dispatch_source_t)queueTimer
{
    if (!_queueTimer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.queueTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_queueTimer, dispatch_walltime(NULL, 0), 0.5 * NSEC_PER_SEC, 0.3 * NSEC_PER_SEC);
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_queueTimer, ^{
            if (weakSelf.itemQueue.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ZZBarrageItemObject *itemObject = weakSelf.itemQueue[0];
                    [weakSelf tryShowBarrageItemObject:itemObject];
                });
            }
        });
    }
    return _queueTimer;
}

- (void)dealloc
{
    dispatch_cancel(_queueTimer);
    self.queueTimer = nil;
}

@end

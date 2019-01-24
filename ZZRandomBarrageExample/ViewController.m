//
//  ViewController.m
//  ZZRandomBarrageExample
//
//  Created by 任强宾(18137801314) on 2018/6/6.
//  Copyright © 2018 renqiangbin. All rights reserved.
//

#import "ViewController.h"
#import "ZZRandomBarrageView.h"     // 随机弹幕

@interface ViewController () <ZZRandomBarrageViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 创建弹幕View
    ZZRandomBarrageConfig *config = [ZZRandomBarrageConfig new];
    config.trackCount = 5;
    ZZRandomBarrageView *randomBarrageView = [[ZZRandomBarrageView alloc] initWithConfig:config];
    randomBarrageView.delegate = self;
    randomBarrageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 360.0f);
    [self.view addSubview:randomBarrageView];
    
    // 添加弹幕
    
}

#pragma mark - <ZZRandomBarrageViewDelegate>
// 弹幕更新时触发
- (void)barrageView:(ZZRandomBarrageView *)barrageView didUpdateBufferQueue:(NSArray *)bufferQueue
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

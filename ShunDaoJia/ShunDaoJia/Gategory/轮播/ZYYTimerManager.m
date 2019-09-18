//
//  ZYYTimerManager.m
//  CustomDemo
//
//  Created by zhngyy on 16/6/27.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import "ZYYTimerManager.h"

@interface ZYYTimerManager()
@property (nonatomic,strong)NSTimer *timer;
@end

@implementation ZYYTimerManager



-(void)setTimeSeconds:(NSTimeInterval)timeSeconds
{
    _timeSeconds = timeSeconds;
}



#pragma mark - 创建定时器
-(NSTimer *)timer
{
    if(!_timer)
    {
        _timer = [NSTimer timerWithTimeInterval:_timeSeconds>0?_timeSeconds:2
                                         target:self
                                       selector:@selector(timeAction:)
                                       userInfo:nil
                                        repeats:YES];
    }
    return _timer;
}

#pragma mark - 暂停定时器（这里的暂停不是销毁）
- (void)stopTimer
{
     [self.timer invalidate];
    self.timer = nil;
    self.isTimering = NO;
}

#pragma mark - 开始执行定时器
- (void)startTimer
{
    [[NSRunLoop mainRunLoop]addTimer:self.timer
                             forMode:NSRunLoopCommonModes];
    self.isTimering = YES;
}

#pragma mark - 延迟几秒
- (void)startTimerWithdelayTime:(NSTimeInterval)duration
{
    if(self.isTimering)
    {
        [self stopTimer];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startTimer];
    });
}

#pragma mark - 定时器执行的方法
- (void)timeAction:(NSTimer *)currentTime
{
    if(_timeBlock)
    {
        _timeBlock(currentTime);
    }
}

-(void)timeBlockAction:(TimeActionCallBack)block
{
    if(block)
    {
        _timeBlock = block;
    }
}

-(void)dealloc
{
    [self.timer invalidate];
    self.isTimering = NO;
    self.timer = nil;
}
@end

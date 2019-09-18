//
//  ZYYTimerManager.h
//  CustomDemo
//
//  Created by zhngyy on 16/6/27.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TimeActionCallBack)(NSTimer *time);

@interface ZYYTimerManager : NSObject

@property (nonatomic,copy)TimeActionCallBack timeBlock;

//多少秒执行一次  不赋值的话默认2秒执行一次
@property (nonatomic,assign)NSTimeInterval timeSeconds;
//是否正在计时
@property (nonatomic,assign)BOOL isTimering;
//暂停定时器（不是销毁）
- (void)stopTimer;

//开始定时器
- (void)startTimer;

//延迟
- (void)startTimerWithdelayTime:(NSTimeInterval)duration;

//定时器回调的方法
- (void)timeBlockAction:(TimeActionCallBack)block;

@end

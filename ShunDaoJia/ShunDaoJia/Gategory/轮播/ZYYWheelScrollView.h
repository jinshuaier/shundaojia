//
//  ZYYWheelScrollView.h
//  CustomDemo
//
//  Created by zhngyy on 16/6/27.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYYImageView.h"
#import "ZYYTimerManager.h"
@protocol ZYYWheelScrollViewDelegate <NSObject>
/**
 *  当前点击的index
 *
 *  @param index index索引
 */
- (void)clickWithCurrentIndex:(NSInteger)index;

/**
 *  获取当前的索引
 *
 *  @param index 当前索引
 */
- (void)getcurrentIndex:(NSInteger)index;

@end

@interface ZYYWheelScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,assign)id<ZYYWheelScrollViewDelegate>zyyDelegate;
//这里可以传Image,本地图片名字，也可以是网络图片链接
@property (nonatomic,strong)NSArray *imageArray;
//是否自动轮播
@property (nonatomic,assign)BOOL isCustomPlay;
//时间间隔(默认两秒)
@property (nonatomic,assign)NSTimeInterval durationTimer;
//延迟执行
@property (nonatomic,assign)NSTimeInterval delayDurationTimer;
//当前页数，用来给外界用
@property (nonatomic,assign)NSInteger currentIndex;
//时间管理器
@property (nonatomic,strong)ZYYTimerManager *timerManager;

@property (nonatomic,copy)NSString *placeholdeName;
/**
 *  展示图文（展示标题）
 *
 *  @param frame      frame
 *  @param imageArray 图片数组
 *  @param titleArray 标题数组
 *
 *  @return 返回实例
 */
- (instancetype)initWithFrame:(CGRect)frame
                   imageArray:(NSArray *)imageArray
                   titleArray:(NSArray *)titleArray;


/**
 *  展示图片（不需要展示标题的）
 *
 *  @param frame      frame
 *  @param imageArray 图片数组
 *
 *  @return 返回实例
 */
- (instancetype)initWithFrame:(CGRect)frame
                   imageArray:(NSArray *)imageArray;


- (void)scrollToCurrentIndex:(NSInteger)index;


@end

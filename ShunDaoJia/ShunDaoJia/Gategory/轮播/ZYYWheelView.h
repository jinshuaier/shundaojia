//
//  ZYYWheelView.h
//  CustomDemo
//
//  Created by zhngyy on 16/6/27.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  回调block
 *
 *  @param index 当前索引
 */
typedef void(^ClickImageViewWithIndex)(NSInteger index);

@interface ZYYWheelView : UIView
//图片资源数组：URL类型 ，string地址，本地图片名称，image类型都可以
@property (nonatomic,strong)NSArray *imageArray;
//时间间隔
@property (nonatomic,assign)NSTimeInterval durationTime;
//pagecontrol的颜色
@property (nonatomic,strong)UIColor *pageControlTinColor;
//移动到当前的光标的颜色
@property (nonatomic,strong)UIColor *currentPageControlTinColor;

@property (nonatomic,copy)NSString *placeholdName;
@property (nonatomic, assign)BOOL isScroll;



/**
 *  初始化
 *
 *  @param frame      frame
 *  @param imageArray 图片数组
 *  @param duration   时间
 *
 *  @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame
                   imageArray:(NSArray *)imageArray
                placeholdName:(NSString *)placeholdName
                     duration:(NSTimeInterval)duration scroller:(BOOL)scroll;

/**
 *  点击当前imageView的回调方法
 *
 *  @param block 回调block
 */
- (void)clickImageViewWithIndex:(ClickImageViewWithIndex)block;

/**
 *  滚动到某区域
 *
 *  @param index 索引
 */
- (void)scrollToIndex:(NSInteger)index;

@property (nonatomic, strong) NSString *typeStr;

@end

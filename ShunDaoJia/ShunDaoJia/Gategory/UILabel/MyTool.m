//
//  MyTool.m
//  json转换
//
//  Created by 张艳江 on 2017/11/2.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "MyTool.h"

@implementation MyTool

+ (CGFloat)cellContentViewWith{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

@end

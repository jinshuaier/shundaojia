//
//  TCTool.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/21.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCTool.h"

@implementation TCTool

+ (CGFloat)cellContentViewWith{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
@end

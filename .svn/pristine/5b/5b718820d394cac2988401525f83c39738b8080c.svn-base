//
//  UIApplication+GYApplication.m
//  页面任意push
//
//  Created by GeYang on 2017/3/27.
//  Copyright © 2017年 GeYang. All rights reserved.
//

#import "UIApplication+GYApplication.h"

@implementation UIApplication (GYApplication)

- (UIWindow *)mainWindow{
    return self.delegate.window;
}

- (UINavigationController *)visibleNavigationController{
    return [[self visibleViewController] navigationController];
}

- (UIViewController *)visibleViewController{
    UIViewController *rootviewcontroller = [self.mainWindow rootViewController];
    return [self getVisibleViewControllerFrom:rootviewcontroller];
} 

//遍历  找到当前navigation下的页面
- (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc)visibleViewController]];
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc)selectedViewController]];
    }else{
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        }else{
            return vc;
        }
    }
}


@end

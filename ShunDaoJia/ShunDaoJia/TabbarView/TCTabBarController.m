//
//  TCTabBarController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/10/9.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCTabBarController.h"

#import "TCNavController.h"

#import "TCMainViewController.h"
#import "TCOrderViewController.h"
//#import "TCGroupViewController.h"  //团购
#import "TCMyMessageViewController.h"


@interface TCTabBarController ()<UITabBarControllerDelegate>

@end

@implementation TCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.delegate = self;
    //改变tabbar 线条颜色
    CGRect rect = CGRectMake(0, 0, WIDTH, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   TCUIColorFromRGB(0xE8E8E8).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
     [UITabBar appearance].backgroundColor = [UIColor whiteColor];
    
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    [self addChildViewController:[TCMainViewController new] navTitle:@"" tabbarTitle:@"首页" tabbarImage:@"首页icon"];

    [self addChildViewController:[TCOrderViewController new] navTitle:@"" tabbarTitle:@"订单" tabbarImage:@"订单icon"];
    [self addChildViewController:[TCMyMessageViewController new] navTitle:@"" tabbarTitle:@"我的" tabbarImage:@"我的"];
    
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginTwoStateChange:)
                                                 name:KNotificationTwoLoginStateChange
                                               object:nil];
}
#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //点击tabBarItem动画
    [self tabBarButtonClick:[self getTabBarButton]];
    
}
- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    NSLog(@"%ld",self.selectedIndex);
    
    return tabBarButton;
}
#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据自己需求改动
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.3,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //添加动画
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}

#pragma mark - 禁止屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

- (void)addChildViewController:(UIViewController *)controller navTitle:(NSString *)navTitle tabbarTitle:(NSString *)tabbarTitle tabbarImage:(NSString *)tabbarImage{
    
    //自定义的Navc
    TCNavController *nav = [[TCNavController alloc]initWithRootViewController:controller];
    controller.navigationItem.title = navTitle;
    controller.tabBarItem.title = tabbarTitle;
    
    //自定义的大小
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:153/255.0 blue:0/255.0 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateSelected];
    controller.tabBarItem.image = [[UIImage imageNamed:tabbarImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage= [[UIImage imageNamed:[NSString stringWithFormat:@"%@点击",tabbarImage]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self addChildViewController:nav];
}

- (void)loginTwoStateChange:(NSNotification *)notification {
    self.selectedViewController = [self.viewControllers objectAtIndex:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end



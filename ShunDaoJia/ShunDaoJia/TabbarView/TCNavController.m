//
//  TCNavController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/10/9.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCNavController.h"
#import "AppDelegate.h"

@interface TCNavController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property(nonatomic,weak) UIViewController* currentShowVC;
@end

@implementation TCNavController

-(id)initWithRootViewController:(UIViewController *)rootViewController {
    TCNavController *nvc= [super initWithRootViewController:rootViewController];
    self.interactivePopGestureRecognizer.delegate = self;
    nvc.delegate = self;
    return nvc;
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count > 1)
        self.currentShowVC = nil;
    else {
        self.currentShowVC = viewController;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.禁用系统自带的返回手势
//    self.interactivePopGestureRecognizer.enabled = NO;
//    //2.捕获返回手势的代理
//    id target = self.interactivePopGestureRecognizer.delegate;
//    // 3.添加全屏滑动返回手势，事件指向系统自带的Pop转场
//    SEL backGestureSelector = NSSelectorFromString(@"handleNavigationTransition:");
//
//    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:backGestureSelector];
//    //4.添加手势
//    [self.view addGestureRecognizer:self.pan];
//    //5.设置自己为自己代理，这样的设置不科学，但可用
//    self.delegate = self;
//
    //导航栏标题的颜色字体大小
    [self.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:18],
       NSForegroundColorAttributeName:TCUIColorFromRGB(0x333333)}];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    
    //隐藏导航栏下的黑线
//    self.navigationBar.subviews[0].subviews[0].hidden = YES;
    // Do any additional setup after loading the view.
}

 - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//     if (gestureRecognizer == self.interactivePopGestureRecognizer) {
//         return (self.currentShowVC == self.topViewController);
//     }
     AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
     if (delegate.isSDJSYTBack == YES || delegate.isBack == YES) {
         return NO; 
     } else {
         return YES;
     }
 }

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果有大于控制器
    
    if (self.childViewControllers.count >= 1) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        [self setBackItem:viewController];
    }
    
    [super pushViewController:viewController animated:animated];
    // 修正push控制器tabbar上移问题
    
    if (@available(iOS 11.0, *)){
        
        // 修改tabBra的frame
        
        CGRect frame = self.tabBarController.tabBar.frame;
        
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        
        self.tabBarController.tabBar.frame = frame;
    }
}

- (void)setBackItem:(UIViewController *)controller{
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:[UIImage imageNamed:@"返回系统"] forState:UIControlStateNormal];
    self.button.frame = CGRectMake(0, 0, 44, 44);
    // 让按钮内部的所有内容左对齐
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.button addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    // 修改导航栏左边的item
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.button];
    controller.navigationItem.leftBarButtonItem = leftItem;
}

- (void)btn:(UIButton *)sender {    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if (delegate.isBack == YES){
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tongzhifanhui" object:nil];
        return;
    } else if (delegate.isSDJSYTBack == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SDJSYTBack" object:nil];
    }
    else {
        [self popViewControllerAnimated:YES];
    }
}

//导航控制器的代理，处理Pan手势是否生效，解决NavitionController的根控制器转场错乱
//-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    // 判断下当前控制器是不是根控制器
//    if (navigationController.viewControllers.count>1) {
//        self.pan.enabled = YES;
//    }else{
//        self.pan.enabled = NO;
//        //手势无效，无法转场，自然不会出现转场错乱的问题。
//    }
//
//}


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



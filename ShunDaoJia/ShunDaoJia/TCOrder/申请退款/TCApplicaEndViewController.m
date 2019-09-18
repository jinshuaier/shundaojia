//
//  TCApplicaEndViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/13.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCApplicaEndViewController.h"
#import "TCOrderDetailsViewController.h"
#import "TCMainViewController.h"

@interface TCApplicaEndViewController ()

@end

@implementation TCApplicaEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请退款";
    self.view.backgroundColor = TCBgColor;
    [self creatUI];
    // Do any additional setup after loading the view.
}
-(void)creatUI{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,1 + StatusBarAndNavigationBarHeight, WIDTH, 198)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(16, 26, 91, 20);
    label1.text = @"申请提交成功~";
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label1.textColor = TCUIColorFromRGB(0x333333);
    label1.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(16, CGRectGetMaxY(label1.frame) + 4, 140, 20);
    label2.text = @"我们会尽快的帮您解决";
    label2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label2.textColor = TCUIColorFromRGB(0x333333);
    label2.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:label2];

    UIImageView *imagePic = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 74 - 48, 20, 74, 78)];
    imagePic.image = [UIImage imageNamed:@"支付成功 插图"];
    [bgView addSubview:imagePic];
    
    UIButton *orderBt = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH/2 - 72)/2, CGRectGetMaxY(label2.frame) + 62, 72, 28)];
    orderBt.layer.cornerRadius = 4;
    [orderBt setBackgroundColor:TCUIColorFromRGB(0xFFAE40)];
    [orderBt setTitle:@"查看订单" forState:(UIControlStateNormal)];
    [orderBt setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    orderBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    orderBt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [orderBt addTarget:self action:@selector(clickOrder:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:orderBt];
    
    UIButton *returnBt = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2 + (WIDTH/2 - 72)/2, CGRectGetMaxY(label2.frame) + 62, 72, 28)];
    returnBt.layer.cornerRadius = 4;
    [returnBt setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    [returnBt setTitle:@"返回首页" forState:(UIControlStateNormal)];
    [returnBt setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    returnBt.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    returnBt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [returnBt addTarget:self action:@selector(clickHome:) forControlEvents:(UIControlEventTouchUpInside)];
    [bgView addSubview:returnBt];


}

//-(void)clickOrder{
//    NSLog(@"返回订单");
//}
//-(void)clickReturn{
//    NSLog(@"返回首页");
//}
-(void)clickOrder:(UIButton *)sender{
    TCOrderDetailsViewController *detailVC = [[TCOrderDetailsViewController alloc] init];
    detailVC.idStr = self.orderId;
    detailVC.isPayOK = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)clickHome:(UIButton *)sender{
    NSLog(@"返回首页");
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//        if ([controller isKindOfClass:[TCMainViewController class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//        }
//    }
    self.tabBarController.selectedIndex = 0;
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

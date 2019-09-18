//
//  TCCurrencyViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/1.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCCurrencyViewController.h"

@interface TCCurrencyViewController ()

@end

@implementation TCCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = TCBgColor;
    [self creatUI];
    
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 12 + StatusBarAndNavigationBarHeight, WIDTH, 54)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, 96, 22)];
    label.text = @"清除图片缓存";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    label.textColor = TCUIColorFromRGB(0x4C4C4C);
    label.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:label];
    
    //计算缓存大小
    NSUInteger size = [SDImageCache sharedImageCache].getSize;
    double displaySize = size/ 1000.0 /1000.0;
    NSLog(@"%.2f-------",displaySize);
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 12 - WIDTH/3, 16, WIDTH/3, 22)];
    
    numLabel.tag = 7652;
    numLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    numLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    numLabel.text = [NSString stringWithFormat:@"%.2fM",displaySize];
    numLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:numLabel];
    //为topView添加点击事件
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getIntoAccount:)];
    
    [bgView addGestureRecognizer:tap];
    
}

-(void)getIntoAccount:(UIGestureRecognizer *)sender{
    
    [[SDImageCache sharedImageCache] clearDisk];
    UILabel *find_label = (UILabel *)[self.view viewWithTag:7652];
    find_label.text = @"0.00M";
    [TCProgressHUD showMessage:@"清理成功"];

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

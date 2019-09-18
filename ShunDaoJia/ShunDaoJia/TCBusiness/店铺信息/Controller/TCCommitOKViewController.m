//
//  TCCommitOKViewController.m
//  举报商家
//
//  Created by 吕松松 on 2017/12/7.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import "TCCommitOKViewController.h"
#import "TCShopMessageViewController.h"

@interface TCCommitOKViewController ()

@end

@implementation TCCommitOKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报商家";
    self.view.backgroundColor = TCBgColor;
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 120)/2,64 + 40, 120, 120)];
    imageV.image = [UIImage imageNamed:@"商品详情页占位"];
    [self.view addSubview:imageV];
    
    UILabel *completeLabel = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 64)/2, CGRectGetMaxY(imageV.frame) + 16, 64, 20)];
    completeLabel.text = @"提交成功";
    completeLabel.textColor = TCUIColorFromRGB(0x999999);
    completeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    completeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:completeLabel];
    
    UILabel *thankLabel = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 252)/2, CGRectGetMaxY(completeLabel.frame) + 8, 252, 16)];
    thankLabel.textAlignment = NSTextAlignmentCenter;
    thankLabel.textColor = TCUIColorFromRGB(0x999999);
    thankLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    thankLabel.text = @"感谢您的参与，待信息核实后顺道嘉会妥善处理";
    [self.view addSubview:thankLabel];
    
    UIButton *comBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(thankLabel.frame) + 32, WIDTH - 24, 48)];
    [comBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    [comBtn setTitle:@"完成" forState:(UIControlStateNormal)];
    [comBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    comBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    comBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    comBtn.layer.masksToBounds = YES;
    comBtn.layer.cornerRadius = 4;
    [comBtn addTarget:self action:@selector(clickCom:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:comBtn];
}



-(void)clickCom:(UIButton *)sender{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[TCShopMessageViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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

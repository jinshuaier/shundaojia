//
//  TCLocationViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCLocationViewController.h"

@interface TCLocationViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UIView *seachView; //创建输入框的view
    UIButton *locatBtn; // 地理位置
    YYSearchView *YYsearchView;
}

@end

@implementation TCLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择收货地址";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //新增地址
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addButton.frame = CGRectMake(WIDTH - 12 - 65, StatusBarHeight + 11, 65, 22);
    addButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [addButton setTitleColor:TCUIColorFromRGB(0x4C4C4C) forState:(UIControlStateNormal)];
    [addButton setTitle:@"新增地址" forState:normal];
    [addButton addTarget:self action:@selector(releaseInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    // Do any additional setup after loading the view.
}

#pragma mark -- 新增地址
- (void)releaseInfo:(UIButton *)sender
{
    NSLog(@"新增地址");
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

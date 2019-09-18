//
//  TCAddressViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCAddressViewController.h"
#import "TCAddressView.h"
#import "TCMapViewController.h" //进入地图
#import "TCReaddressViewController.h"
//#import "TCLocationViewController.m"

@interface TCAddressViewController ()<tapDelegete>
@property (nonatomic, strong) TCAddressView *addressView;


@property (nonatomic, strong) NSUserDefaults *userdefaults;

@end

@implementation TCAddressViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chuanaddress:) name:@"chuanaddress" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCBgColor;

    if (self.isChange == YES){
        self.title = @"修改地址";
         self.addressView = [[TCAddressView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight) andDic:self.dic];
        self.addressView.typeStr = self.typeStr;
    } else {
        self.title = @"新增地址";
        self.addressView = [[TCAddressView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight) andDic:@{}];
        self.addressView.typeStr = self.typeStr;
    }
    self.addressView.delegate = self;
    [self.view addSubview:self.addressView];
    
    // Do any additional setup after loading the view.
}
- (void)chuanaddress:(NSNotification *)notification{
    self.addressView.adressTextfiled.text = [NSString stringWithFormat:@"%@%@",notification.userInfo[@"name"],notification.userInfo[@"address"]];
    self.addressView.longtitude = notification.userInfo[@"longitude"];
    self.addressView.latitude = notification.userInfo[@"latitude"];
}

- (void)backController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendValue
{
    TCMapViewController *mapVC = [[TCMapViewController alloc] init];
    mapVC.diBlock = ^(NSString *address, NSString *latitude, NSString *longtitude) {
        self.addressView.adressTextfiled.text = address;
        self.addressView.longtitude = longtitude;
        self.addressView.latitude = latitude;
    };
    [self.navigationController pushViewController:mapVC animated:YES];
}

//更新
- (void)update
{
    //通知返回
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateadress" object:nil];
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

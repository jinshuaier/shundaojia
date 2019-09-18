//
//  TCPayOkViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/15.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCPayOkViewController.h"
#import "TCChooseAddressController.h"
#import "TCMainViewController.h"
#import "TCOrderDetailsViewController.h"
#import "AppDelegate.h"

@interface TCPayOkViewController ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) BOOL popAsLoginFlag;
@end

@implementation TCPayOkViewController

//将要出现，设置导航栏透明度为0
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.layer.shadowOpacity = 0.0;
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.isBack = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付成功";
    self.view.backgroundColor = TCBgColor;
    //接受返回的通知，用来控制返回按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isBack) name:@"tongzhifanhui" object:nil];
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

static SEL extracted() {
    return @selector(clickHome:);
}

-(void)creatUI{
    UIView *bgView1 = [[UIView alloc]initWithFrame:CGRectMake(8, 8 + StatusBarAndNavigationBarHeight, WIDTH - 16, 84)];
    bgView1.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView1];
    
    UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 24, 120, 14)];
    orderLabel.text = @"订单支付成功~";
    orderLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    orderLabel.textColor = TCUIColorFromRGB(0x333333);
    orderLabel.textAlignment = NSTextAlignmentLeft;
    [bgView1 addSubview:orderLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(orderLabel.frame) + 8, 100, 14)];
    moneyLabel.text = [NSString stringWithFormat:@"付款 ¥%@",self.orderPrice];
    moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    moneyLabel.textColor = TCUIColorFromRGB(0x666666);
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    [bgView1 addSubview:moneyLabel];
    
    UIImageView *payImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 16 - 20 - 54, (84- 60)/2, 54, 60)];
    payImage.image = [UIImage imageNamed:@"支付成功 插图"];
    [bgView1 addSubview:payImage];
    
    UIView *bgView2 = [[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(bgView1.frame) + 8, WIDTH - 16, 220)];
    bgView2.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgView2];
    
    UIImageView *mapImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, 19, 14, 16)];
    mapImage.image = [UIImage imageNamed:@"定位"];
    [bgView2 addSubview:mapImage];
    NSLog(@"%@",self.messDic);
    UILabel *mapLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mapImage.frame) + 8, 16, WIDTH - 30 - 32 - 16, 40)];
    mapLabel.text = [self.messDic[@"locaddress"] stringByAppendingString:self.messDic[@"address"]];
    mapLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    mapLabel.textColor = TCUIColorFromRGB(0x3333333);
    mapLabel.textAlignment = NSTextAlignmentLeft;
   
    mapLabel.numberOfLines = 0;
    mapLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [mapLabel sizeThatFits:CGSizeMake(WIDTH - 30 - 32 - 16, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    mapLabel.frame = CGRectMake(CGRectGetMaxX(mapImage.frame) + 8, 16, WIDTH - 30 - 32 -16, size.height);
    [bgView2 addSubview:mapLabel];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mapImage.frame) + 8, CGRectGetMaxY(mapLabel.frame) + 8, 42, 18)];
    nameLabel.text = self.messDic[@"name"];
    nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    nameLabel.textColor = TCUIColorFromRGB(0x666666);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.numberOfLines = 0;
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size1 = [nameLabel sizeThatFits:CGSizeMake(MAXFLOAT, 18)];
    
    if (size1.width <=  WIDTH - 16 - 46 - 90 - 32) {
        nameLabel.frame = CGRectMake(CGRectGetMaxX(mapImage.frame) + 8, CGRectGetMaxY(mapLabel.frame) + 8, size1.width, 18);
    }else{
        nameLabel.frame = CGRectMake(CGRectGetMaxX(mapImage.frame) + 8, CGRectGetMaxY(mapLabel.frame) + 8, WIDTH - 16 - 46 - 90 - 32, 18);
    }
    [bgView2 addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 16, CGRectGetMaxY(mapLabel.frame) + 8, 90, 18)];
    phoneLabel.text = self.messDic[@"mobile"];
    phoneLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    phoneLabel.textColor = TCUIColorFromRGB(0x666666);
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    [bgView2 addSubview:phoneLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(phoneLabel.frame) + 15, WIDTH - 16 - 16, 1)];
    line1.backgroundColor = TCLineColor;
    [bgView2 addSubview:line1];
    
    UIImageView *remarksPic = [[UIImageView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(line1.frame) + 14, 14, 14)];
    remarksPic.image = [UIImage imageNamed:@"订单icon点击"];
    remarksPic.layer.masksToBounds = YES;
    remarksPic.layer.cornerRadius = 4;
    [bgView2 addSubview:remarksPic];
    
    UILabel *remarksLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(remarksPic.frame) + 8, CGRectGetMaxY(line1.frame) + 12, 42, 18)];
    remarksLab.text = @"备注：";
    remarksLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    remarksLab.textColor = TCUIColorFromRGB(0x4C4C4C);
    remarksLab.textAlignment = NSTextAlignmentLeft;
    [bgView2 addSubview:remarksLab];
    
    UITextField *inputField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(remarksLab.frame), CGRectGetMaxY(line1.frame) + 12, WIDTH - 16 - 16 - 16 - 42 - 14, 18)];
    inputField.borderStyle = UITextBorderStyleNone;
    if (self.remakStr == nil){
        inputField.placeholder = @"暂无备注";
    } else {
        inputField.text = self.remakStr;
    }
    
    inputField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    inputField.textColor = TCUIColorFromRGB(0x4C4C4C);
    inputField.enabled = NO;
    [bgView2 addSubview:inputField];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(inputField.frame) + 11, WIDTH - 32, 1)];
    line2.backgroundColor = TCLineColor;
    [bgView2 addSubview:line2];
    
    UIButton *orderBtn = [[UIButton alloc]initWithFrame:CGRectMake(38, CGRectGetMaxY(line2.frame) + 26, 96, 28)];
    [orderBtn setBackgroundColor:TCUIColorFromRGB(0xFFAE40)];
    [orderBtn setTitle:@"查看订单" forState:(UIControlStateNormal)];
    orderBtn.layer.masksToBounds = YES;
    orderBtn.layer.cornerRadius = 4;
    [orderBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [orderBtn addTarget:self action:@selector(clickOrder:) forControlEvents:(UIControlEventTouchUpInside)];
    orderBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    orderBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView2 addSubview:orderBtn];
    
    UIButton *homeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderBtn.frame) + (WIDTH - 76 - 16 - 96*2), CGRectGetMaxY(line2.frame) + 26, 96, 28)];
    [homeBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    homeBtn.layer.masksToBounds = YES;
    homeBtn.layer.cornerRadius = 4;
    [homeBtn setTitle:@"返回首页" forState:(UIControlStateNormal)];
    [homeBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [homeBtn addTarget:self action:extracted() forControlEvents:(UIControlEventTouchUpInside)];
    homeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    homeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView2 addSubview:homeBtn];
    
    bgView2.frame = CGRectMake(8, CGRectGetMaxY(bgView1.frame) + 8, WIDTH - 16, CGRectGetMaxY(homeBtn.frame) + 26);
}

-(void)clickOrder:(UIButton *)sender{
//    TCOrderDetailsViewController *detailVC = [[TCOrderDetailsViewController alloc] init];
//    detailVC.idStr = self.orderId;
//    detailVC.shopidStr = self.shopID;
//    detailVC.isPayOK = YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
    self.tabBarController.selectedIndex = 1;
    //标记一下，在这个页面消失时做相应处理
    [self.navigationController popToRootViewControllerAnimated:NO];
    //发送一个通知如何 老哥
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dingdanshuaxin" object:nil];
}
-(void)clickHome:(UIButton *)sender{
    NSLog(@"返回首页");
    self.tabBarController.selectedIndex = 0;
    //标记一下，在这个页面消失时做相应处理
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    //发送一个通知如何 老哥
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dingdanshuaxin" object:nil];
}

//通知事件
- (void)isBack
{
    self.tabBarController.selectedIndex = 1;
    //标记一下，在这个页面消失时做相应处理
    [self.navigationController popToRootViewControllerAnimated:NO];
    //发送一个通知如何 老哥
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dingdanshuaxin" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    //记录返回按钮
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.isBack = NO;
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

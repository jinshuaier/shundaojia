//
//  TCAlRealNameViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/14.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCAlRealNameViewController.h"

@interface TCAlRealNameViewController ()

@property (nonatomic, strong) NSUserDefaults *userdefaults;
@property (nonatomic, strong) NSDictionary *messDic;

@end

@implementation TCAlRealNameViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.view.backgroundColor = TCBgColor;
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    //加收通知  绑定银行卡
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlRealNotifo) name:@"AlRealNotifo" object:nil];
    
    //请求接口
    [self quest];
    // Do any additional setup after loading the view.
}

#pragma mark -- 请求接口
- (void)quest
{
    [ProgressHUD showHUDToView:self.view];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"103008"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        [ProgressHUD hiddenHUD:self.view];
        self.messDic = jsonDic[@"data"];
         [self creatUI];
    } failure:^(NSError *error) {
        nil;
    }];
}

#pragma mark -- 接受通知刷新
- (void)AlRealNotifo
{
    [self quest];
}

-(void)creatUI{
    UIView *bgViwe = [[UIView alloc]initWithFrame:CGRectMake(12, 12 + StatusBarAndNavigationBarHeight, WIDTH - 24, 92)];
    bgViwe.layer.masksToBounds = YES;
    bgViwe.layer.cornerRadius = 4;
    bgViwe.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bgViwe];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, 48, 22)];
    nameLab.text = @"姓名：";
    nameLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    nameLab.textColor = TCUIColorFromRGB(0x4C4C4C);
    nameLab.textAlignment = NSTextAlignmentLeft;
    [bgViwe addSubview:nameLab];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLab.frame) + 8, 16, WIDTH - 48 - 3, 22)];
    name.text = [NSString stringWithFormat:@"%@",self.messDic[@"name"]];
   
    name.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    name.textColor = TCUIColorFromRGB(0x333333);
    name.textAlignment = NSTextAlignmentLeft;
    [bgViwe addSubview:name];
    
    UILabel *idenIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 54, 64, 22)];
    idenIDLabel.text = @"身份证：";
    idenIDLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    idenIDLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    idenIDLabel.textAlignment= NSTextAlignmentLeft;
    [bgViwe addSubview:idenIDLabel];
    
   UILabel * ID = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(idenIDLabel.frame) + 5, 54, WIDTH - 64 - 17 - 12, 22)];
    ID.text = [NSString stringWithFormat:@"%@",self.messDic[@"idno"]];
    ID.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    ID.textColor = TCUIColorFromRGB(0x333333);
    ID.textAlignment = NSTextAlignmentLeft;
    [bgViwe addSubview:ID];

    UILabel *sheetLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(bgViwe.frame) + 8, 160, 17)];
    sheetLabel.text = @" 如要解绑实名认证请联系客服";
    sheetLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    sheetLabel.textColor = TCUIColorFromRGB(0x999999);
    sheetLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:sheetLabel];
    
    UIButton *service = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sheetLabel.frame) + 8, CGRectGetMaxY(bgViwe.frame) + 8, 84, 17)];
    [service setBackgroundColor:TCBgColor];
    [service setTitle:@"4000-111-228 " forState:(UIControlStateNormal)];
    [service setTitleColor:TCUIColorFromRGB(0x0276FF) forState:(UIControlStateNormal)];
    [service addTarget:self action:@selector(phone:) forControlEvents:(UIControlEventTouchUpInside)];
    service.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    service.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:service];
}

-(void)phone:(UIButton *)sender{
    //拨打电话
    NSString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000-111-228"];
    // NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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

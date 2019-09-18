//
//  TCMysetupViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/22.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCMysetupViewController.h"
#import "TCAccountTableViewCell.h"
#import "TCAboutViewController.h"
#import "TCAccountViewController.h"
#import "TCCurrencyViewController.h"
#import "TCLoginViewController.h"

@interface TCMysetupViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSUserDefaults *userdefaults;

@end

@implementation TCMysetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.view.backgroundColor = TCBgColor;
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    
    self.titleArr = @[@"账户与安全",@"通用",@"欢迎评分",@"关于顺道嘉"];
    
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin) style:(UITableViewStyleGrouped)];
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.backgroundColor = TCBgColor;
    self.mainTableView.scrollEnabled = NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AdjustsScrollViewInsetNever (self,self.mainTableView);
    [self.view addSubview:self.mainTableView];
    
    //添加退出登录的按钮
    UIButton *signOut_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    signOut_btn.frame = CGRectMake(0, HEIGHT - 54, WIDTH, 54);
    [signOut_btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [signOut_btn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    signOut_btn.backgroundColor = TCUIColorFromRGB(0xF99E20);
    [signOut_btn addTarget:self action:@selector(signOutClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signOut_btn];
    
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
        headerView.backgroundColor = TCBgColor;
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 16, 80, 22)];
        titlelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        titlelabel.textColor = TCUIColorFromRGB(0x4C4C4C);
        titlelabel.text = _titleArr[indexPath.row];
        if (indexPath.row < 3) {
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(12, CGRectGetMaxY(titlelabel.frame) + 15, WIDTH - 24, 1);
            lineView.backgroundColor = TCLineColor;
            [cell.contentView addSubview:lineView];
        }
        
        titlelabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:titlelabel];
        
        //图片
        UIImageView *image = [[UIImageView alloc] init];
        image.image = [UIImage imageNamed:@"进入小三角（灰）"];
        image.frame = CGRectMake(WIDTH - 12 - 5, (54 - 8)/2, 5, 8);
        [cell.contentView addSubview:image];
        
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -- cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.row == 0) {
            NSLog(@"点击账户与安全");
            TCAccountViewController *accountVC = [[TCAccountViewController alloc]init];
            [self.navigationController pushViewController:accountVC animated:YES];
        }else if (indexPath.row == 1){
            NSLog(@"通用");
            TCCurrencyViewController *currencyVC = [[TCCurrencyViewController alloc]init];
            [self.navigationController pushViewController:currencyVC animated:YES];
        }
    else if (indexPath.row ==3){
        NSLog(@"关于顺道嘉");
        TCAboutViewController *aboutVC = [[TCAboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    else if (indexPath.row == 2){
        NSLog(@"进入欢迎评价");
        NSString *str = [NSString stringWithFormat:
                         @"https://itunes.apple.com/cn/app/id%@?mt=8",
                         @"1120901620"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark -- 点击退出登录
-(void)signOutClick:(UIButton *)send{
    NSLog(@"退出登录");
    
    [ProgressHUD showHUDToView:self.view];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr};
    
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    WEAKSELF
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102015"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@", jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
            [self.userdefaults removeObjectForKey:@"userID"];
            [self.userdefaults removeObjectForKey:@"userToken"];
            [self.userdefaults removeObjectForKey:@"imageHead"];
            [self.userdefaults removeObjectForKey:@"nickName"];
            [self.userdefaults removeObjectForKey:@"mobileStr"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderShuaxin" object:nil];

//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ //先跳出登录界面，在返回RootVC
            
                TCLoginViewController *dcLoginVc = [TCLoginViewController new];
                [weakSelf presentViewController:dcLoginVc animated:YES completion:^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationTwoLoginStateChange object:nil]; //退出登录
                }];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
//            });
        } else {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }
        [ProgressHUD hiddenHUD:self.view];
        //成功后返回更新
    } failure:^(NSError *error) {
        nil;
    }];
    
    
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
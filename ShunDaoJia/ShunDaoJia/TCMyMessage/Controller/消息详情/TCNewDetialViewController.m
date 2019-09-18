//
//  TCNewDetialViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/14.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCNewDetialViewController.h"

@interface TCNewDetialViewController ()
{
    UILabel *titLabel;
    UILabel *textLabel;
    UILabel *timeLabel;
}
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSDictionary *dic;
@end

@implementation TCNewDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.view.backgroundColor = TCBgColor;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    //请求接口
    [self createQuest];
    
    // Do any additional setup after loading the view.
}

//请求接口
- (void)createQuest
{
    [ProgressHUD showHUDToView:self.view];
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"messageId":self.messIdStr,@"timestamp":timeStr};
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"messageId":self.messIdStr,@"timestamp":timeStr,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102003"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]) {
            self.dic = jsonDic[@"data"];
            [self creatUI];
            //添加通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newDetialReadload" object:nil];
        }
        [ProgressHUD hiddenHUD:self.view];
    } failure:^(NSError *error) {
        nil;
    }];
}


-(void)creatUI{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((WIDTH - 336)/2, 8 + StatusBarAndNavigationBarHeight, 336, 150)];
    bgView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 4;
    [self.view addSubview:bgView];
    
    titLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, bgView.frame.size.width - 24, 16)];
    titLabel.text = self.dic[@"title"];
    titLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    titLabel.textColor = TCUIColorFromRGB(0x4C4C4C);
    titLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:titLabel];
    
    textLabel = [UILabel publicLab:self.dic[@"content"] textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
    textLabel.frame = CGRectMake(12, CGRectGetMaxY(titLabel.frame) + 8, bgView.frame.size.width - 24, 72);

    CGSize size = [textLabel sizeThatFits:CGSizeMake(bgView.frame.size.width - 24, MAXFLOAT)];
    textLabel.frame = CGRectMake(12, CGRectGetMaxY(titLabel.frame) + 8, bgView.frame.size.width - 24, size.height);
    [bgView addSubview:textLabel];
    //时间
    timeLabel = [UILabel publicLab:self.dic[@"createTime"] textColor:TCUIColorFromRGB(0x999999) textAlignment:NSTextAlignmentRight fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    timeLabel.frame = CGRectMake(0, CGRectGetMaxY(textLabel.frame) + 20,bgView.frame.size.width - 24, 12);
    [bgView addSubview:timeLabel];
    
    bgView.frame = CGRectMake((WIDTH - 336)/2, 8 + StatusBarAndNavigationBarHeight, 336, CGRectGetMaxY(timeLabel.frame) + 12);
    
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

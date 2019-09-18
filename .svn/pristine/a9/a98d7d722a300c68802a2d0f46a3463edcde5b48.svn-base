//
//  TCAboutViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/23.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCAboutViewController.h"

@interface TCAboutViewController ()

@end

@implementation TCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于顺道嘉";
    self.view.backgroundColor = TCBgColor;
    
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
   
    //关于顺道嘉的logo
    UIImageView *iconimage = [[UIImageView alloc] init];
    iconimage.image = [UIImage imageNamed:@"167"];
    iconimage.frame = CGRectMake((WIDTH - 64)/2, 72 + StatusBarAndNavigationBarHeight, 64, 64);
    iconimage.layer.cornerRadius = 5;
    iconimage.layer.masksToBounds = YES;
    [self.view addSubview:iconimage];
    
    //获取当前版本号
    NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    
    UILabel *edition = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconimage.frame) + 16, WIDTH, 22)];
    edition.text = [NSString stringWithFormat:@"顺道嘉用户版 %@",currentVersion];
    edition.textColor = TCUIColorFromRGB(0x999999);
    edition.textAlignment = NSTextAlignmentCenter;
    edition.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.view addSubview:edition];
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

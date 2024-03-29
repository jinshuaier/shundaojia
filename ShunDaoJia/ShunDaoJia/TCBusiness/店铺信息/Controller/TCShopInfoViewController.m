//
//  TCShopInfoViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/7.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShopInfoViewController.h"
#import "TCShareView.h" //分享
#import "TCBusineShopViewController.h" //商家
#import "TCEvaluateViewController.h" //评价
#import "RCSegmentView.h"

@interface TCShopInfoViewController ()
{
    UIButton *collecBtn ;
}
@property (nonatomic, assign) BOOL isSelect; //收藏
@property (nonatomic, strong) NSDictionary *dic;
@end

@implementation TCShopInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.shopTitle;
    self.view.backgroundColor = [UIColor whiteColor];

    //请求评价的接口
    [self quest];
    
    // Do any additional setup after loading the view.
}

#pragma mark -- 请求评价的接口
- (void)quest
{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"page":@"1",@"timestamp":timeStr,@"shopid":self.shopID};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"page":@"1",@"timestamp":timeStr,@"shopid":self.shopID,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101006"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
         self.dic = jsonDic[@"data"];
        [self crateNav];
    } failure:^(NSError *error) {
        nil;
    }];
}
//创建navc
- (void)crateNav
{
    //后面的背景 （没有头像数据）
    UIImageView *navImage = [[UIImageView alloc]init];
    navImage.frame = CGRectMake(0, 0, WIDTH, StatusBarAndNavigationBarHeight);
    navImage.userInteractionEnabled = YES;
    //（有头像数据）
    navImage.image = self.shopImage;
    //[backdImage sd_setImageWithURL:[NSURL URLWithString:_dic[@"headPic"]] placeholderImage:[UIImage imageNamed:@"默认头像-内部"]];
    [self.view addSubview: navImage];
    //模糊
    UIVisualEffectView *ruVisualEffectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    ruVisualEffectView.frame = navImage.bounds;
    ruVisualEffectView.alpha = 1;
    [navImage addSubview:ruVisualEffectView];
    
    //铺一个图层
    UIView *grayView = [[UIView alloc]init];
    grayView.frame = CGRectMake(0, 0, WIDTH, StatusBarAndNavigationBarHeight);
    grayView.backgroundColor = [TCUIColorFromRGB(0x000000) colorWithAlphaComponent:0.4];
    [navImage addSubview:grayView];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [backBtn setImage:[UIImage imageNamed:@"返回按钮(白)"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(backbtn) forControlEvents:(UIControlEventTouchUpInside)];
    backBtn.frame = CGRectMake(16, 14.2 + StatusBarHeight, 11, 20);
    [grayView addSubview:backBtn];
    
    //商铺名字
    UILabel *shopLabel = [[UILabel alloc] init];
    shopLabel.frame = CGRectMake(88, StatusBarHeight + 11, WIDTH - 176, 22);
    shopLabel.text = self.shopTitle;
    shopLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
    shopLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    shopLabel.textAlignment = NSTextAlignmentCenter;
    [grayView addSubview:shopLabel];
    
    //分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareBtn.frame = CGRectMake(WIDTH - 16 - 20, StatusBarHeight + 12, 20, 20);
    [shareBtn setImage:[UIImage imageNamed:@"分享商家图标"] forState:(UIControlStateNormal)];
    [shareBtn addTarget:self action:@selector(shareBtn) forControlEvents:(UIControlEventTouchUpInside)];
//    [grayView addSubview:shareBtn];
    
    //收藏按钮
    collecBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    collecBtn.frame = CGRectMake(WIDTH - 16 - 20 - 18 - 18, StatusBarHeight + 13, 18, 18);
    [collecBtn setImage:[UIImage imageNamed:@"收藏商家图标"] forState:(UIControlStateNormal)];
    [collecBtn addTarget:self action:@selector(collecBtn) forControlEvents:(UIControlEventTouchUpInside)];
//    [grayView addSubview:collecBtn];
    
    TCBusineShopViewController * BusineShop = [[TCBusineShopViewController alloc]init];
    BusineShop.shopID = self.shopID;
    TCEvaluateViewController * Evaluate = [[TCEvaluateViewController alloc]init];
    Evaluate.shopID = self.shopID;
    NSArray *controllers=@[BusineShop,Evaluate];
    
    NSString *eveStr = [NSString stringWithFormat:@"评价（%@）",self.dic[@"all"]];
    NSArray *titleArray =@[@"商家",eveStr];
    RCSegmentView * rcs=[[RCSegmentView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - TabbarSafeBottomMargin) controllers:controllers titleArray:titleArray ParentController:self];
    [self.view addSubview:rcs];
}

#pragma mark -- 返回按钮
- (void)backbtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 收藏的按钮
- (void)collecBtn
{
    if (_isSelect == YES){
        [TCProgressHUD showWithImage:[UIImage imageNamed:@"收藏商家图标（黄）"] Text:@"收藏商家成功" WithDurations:1.5];
        [collecBtn setImage:[UIImage imageNamed:@"收藏商家图标（黄）"] forState:(UIControlStateNormal)];

        _isSelect = NO;
    } else {
        [TCProgressHUD showWithImage:[UIImage imageNamed:@"收藏商家图标"] Text:@"取消收藏成功" WithDurations:1.5];
        _isSelect = YES;
        [collecBtn setImage:[UIImage imageNamed:@"收藏商家图标"] forState:(UIControlStateNormal)];

    }
}

#pragma mark -- 分享
- (void)shareBtn
{
    TCShareView *shareView = [[TCShareView alloc]init];
    [TCShareView ShowTheViewOfShareAndShowMes:self.mesDic[@"share"] andShareSuccess:^{
        [TCProgressHUD showMessage:@"分享成功"];
    } andShareFailure:^{
        [TCProgressHUD showMessage:@"分享失败"];
    } andShareCancel:^{
        [TCProgressHUD showMessage:@"分享取消"];
    }];
    [self.view addSubview:shareView];
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

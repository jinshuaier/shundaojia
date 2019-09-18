//
//  TCMyMessageViewController.m
//  顺道嘉
//
//  Created by 胡高广 on 2017/9/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCMyMessageViewController.h"
#import "TCLoginViewController.h" //登录页面
#import "TCMymessageCell.h"
#import "TCAccountViewController.h"//账户信息页面
#import "TCMysetupViewController.h"//设置页面
#import "TCNewsViewController.h" //消息界面
#import "TCWalletViewController.h"//钱包页面
#import "TCMydiscountViewController.h"//我的优惠券
#import "TCHelpViewController.h"//帮助中心
#import "TCJoinViewController.h"
#import "TCFeedbackViewController.h" //意见反馈
//#import "TCFavoriteViewController.h" //我的收藏
#import "TCReAddressViewController.h"//收货地址
#import "TCQRCodelViewController.h" //二维码界面
#import "TCMessageCollectionCell.h"//自定义Collectioncell
#import "TCAlRealNameViewController.h"//已实名认证
#import "TCWithAlSetViewController.h"//已设置支付密码
#import "TCModiViewController.h"//设置支付密码
#import "AppDelegate.h"

@interface TCMyMessageViewController ()<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *MycollectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSUserDefaults *userdefaults;

@property (nonatomic, strong) UIImageView *imageHead; //头像
@property (nonatomic, strong) UILabel *loginLabel; //登录文字
@property (nonatomic, strong) UILabel *nameLabel; //姓名
@property (nonatomic, strong) UILabel *phoneLabel; //电话
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation TCMyMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    //判断登录
    if ([_userdefaults valueForKey:@"userID"]){
        self.loginLabel.hidden = YES;
        self.nameLabel.hidden = NO;
        self.phoneLabel.hidden = NO;
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        if (delegate.isLoginChaoShi == NO) {
            //请求接口
            [self createQuest];
        }
    } else {
        self.loginLabel.hidden = NO;
        self.nameLabel.hidden = YES;
        self.phoneLabel.hidden = YES;
        self.imageHead.image = [UIImage imageNamed:@"头像"];
    }
    
    //修改完头像或者昵称
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chage) name:@"shuaxinmineview" object:nil];
}
#pragma mark -- 修改头像或者昵称的通知
- (void)chage
{
    //请求接口
    [self createQuest];
}

#pragma mark -- 请求接口
- (void)createQuest
{
    [BQActivityView showActiviTy];
    //请求接口
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userdefaults valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102013"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        if ([codeStr isEqualToString:@"1"]){
            self.messDic = jsonDic[@"data"];
            NSString *payStr = [NSString stringWithFormat:@"%@",self.messDic[@"is_pay"]];
            if ([payStr isEqualToString:@"1"]) {
                self.isPay = YES;
            }else{
                self.isPay = NO;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"huoquset" object:nil userInfo:self.messDic];
            [self.imageHead sd_setImageWithURL:[NSURL URLWithString: self.messDic[@"src"]] placeholderImage:[UIImage imageNamed:@"头像"]];
            self.nameLabel.text = self.messDic[@"nickname"];
            self.phoneLabel.text = self.messDic[@"mobile"];
            if ([self.messDic[@"mobile"] isEqualToString:@""]) {
                self.isbining = NO;
            }else{
                self.isbining = YES;
            }
        } else if ([codeStr isEqualToString:@"-5"]){
            TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
        
        [BQActivityView hideActiviTy];
        //成功后返回更新
    } failure:^(NSError *error) {
        nil;
    }];
}
-(UICollectionView *)MycollectionView{
    if (!_MycollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //设置垂直间的最小间距
        layout.minimumLineSpacing = 1;
        //设置水平间的最小间距
        layout.minimumInteritemSpacing = 1;
        
        _MycollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight + 130 + 8 , WIDTH, HEIGHT - 194 - 8) collectionViewLayout:layout];
        _MycollectionView.delegate = self;
        _MycollectionView.dataSource = self;
        _MycollectionView.scrollEnabled = YES;
        _MycollectionView.backgroundColor = TCBgColor;
    }
    return _MycollectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCBgColor;
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    
    self.navigationController.delegate = self;

    self.dataArr = [NSMutableArray array];
    //请求接口
//    [self createQuest];
    //背景图片
    UIImageView *headImageBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, StatusBarAndNavigationBarHeight + 130)];
    headImageBG.image = [UIImage imageNamed:@"背景顶部"];
    headImageBG.userInteractionEnabled = YES;
    [self.view addSubview:headImageBG];
    //加入手势
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHead)];
    [headImageBG addGestureRecognizer:tapHead];
    //通知
    UIButton *newBtn = [[UIButton alloc]initWithFrame:CGRectMake(6, StatusBarHeight + 12, 30, 20)];
    [newBtn setImage:[UIImage imageNamed:@"通知"] forState:(UIControlStateNormal)];
    [newBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [headImageBG addSubview:newBtn];
    //设置
    UIButton *setupBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 16 - 20, StatusBarHeight + 12, 30, 20)];
    [setupBtn setImage:[UIImage imageNamed:@"设置"] forState:(UIControlStateNormal)];
    [setupBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [headImageBG addSubview:setupBtn];
    
    //头像
    self.imageHead = [[UIImageView alloc] init];
    self.imageHead.frame = CGRectMake((WIDTH - 76)/2, CGRectGetMaxY(setupBtn.frame), 76, 76);
    self.imageHead.layer.cornerRadius = 76/2;
    self.imageHead.layer.masksToBounds = YES;
    self.imageHead.image = [UIImage imageNamed:@"头像"];
    [headImageBG addSubview:self.imageHead];
    //登录的文字
    self.loginLabel = [UILabel publicLab:@"登录" textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangTC-Medium" size:15 numberOfLines:0];
    self.loginLabel.frame = CGRectMake((WIDTH - 72)/2, CGRectGetMaxY(self.imageHead.frame) + 14, 72, 28);
    self.loginLabel.layer.cornerRadius = 4;
    self.loginLabel.layer.masksToBounds = YES;
    self.loginLabel.layer.borderWidth = 1;
    self.loginLabel.layer.borderColor = TCUIColorFromRGB(0xFFFFFF).CGColor;
    [headImageBG addSubview:self.loginLabel];
    
    //电话 姓名
    self.nameLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangTC-Medium" size:15 numberOfLines:0];
    if (self.messDic){
        self.nameLabel.text = self.messDic[@"nickname"];
    } else {
        self.nameLabel.text = @"";
    }
    self.nameLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageHead.frame) + 10, WIDTH, 15);
    [headImageBG addSubview:self.nameLabel];
    
    self.phoneLabel = [UILabel publicLab:self.messDic[@"mobile"] textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangTC-Regular" size:13 numberOfLines:0];
    if (self.messDic){
        self.phoneLabel.text = self.messDic[@"mobile"];
    } else {
        self.phoneLabel.text = @"";
    }
    self.phoneLabel.frame = CGRectMake((WIDTH - 100)/2, CGRectGetMaxY(self.nameLabel.frame) + 8, 100, 21);
    self.phoneLabel.backgroundColor = [TCUIColorFromRGB(0xFFFFFF) colorWithAlphaComponent:0.081];
    self.phoneLabel.layer.cornerRadius = 21/2;
    self.phoneLabel.layer.masksToBounds = YES;
    [headImageBG addSubview:self.phoneLabel];
    
    [self creatUI];
}

#pragma mark -- 创建九宫格
-(void)creatUI{
    self.images = @[@"钱包图标",@"优惠券",@"定位",@"实名认证",@"意见反馈图标",@"帮助中心 copy"];
    self.titles = @[@"钱包",@"优惠券",@"收货地址",@"实名认证",@"意见反馈",@"帮助中心"];

    [self.MycollectionView registerClass:[TCMessageCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.MycollectionView];
    
    UIView *bomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.MycollectionView.frame) + 1, WIDTH, HEIGHT - CGRectGetMaxY(_MycollectionView.frame) - 1)];
    bomView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:bomView];
}

#pragma mark -- UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//设置每个cell的宽高
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (WIDTH - 3)/3;
    return CGSizeMake(width, 99.5);
}
//cell的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 1, 1);
}
//cell 的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TCMessageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == 3) {
        cell.iconImage.frame = CGRectMake((cell.contentView.frame.size.width - 20)/2, 24.5, 20, 24);
    }else if (indexPath.row == 5){
        cell.iconImage.frame = CGRectMake((cell.contentView.frame.size.width - 24)/2, 28.5, 24, 20);
    }
   
        cell.iconImage.image = [UIImage imageNamed:self.images[indexPath.row]];
        cell.titlLabel.text = self.titles[indexPath.row];
    cell.backgroundColor = TCUIColorFromRGB(0xFFFFFF);

    return cell;
}
//设置cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"点击的是%@",self.titles[indexPath.row]);
        if (indexPath.row == 0) {
            //已经登录过
            if ([_userdefaults valueForKey:@"userID"]){
                TCWalletViewController *walletVC = [[TCWalletViewController alloc]init];
                walletVC.mobile = self.messDic[@"mobile"];
                if (self.isPay == YES) {
                    walletVC.isPay = YES;
                }else{
                    walletVC.isPay = NO;
                }
            [self.navigationController pushViewController:walletVC animated:YES];
            } else {
                TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
                
        }else if (indexPath.row == 1){
            if ([_userdefaults valueForKey:@"userID"]){
                TCMydiscountViewController *mydisVC = [[TCMydiscountViewController alloc]init];
                [self.navigationController pushViewController:mydisVC animated:YES];
            } else {
                TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
        }else if (indexPath.row == 2){
            if ([_userdefaults valueForKey:@"userID"]){
                TCReaddressViewController *reAdreeVC = [[TCReaddressViewController alloc]init];
                reAdreeVC.enterS = @"0";
                [self.navigationController pushViewController:reAdreeVC animated:YES];
            } else {
                TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
            
        }else if (indexPath.row == 3){
            if ([_userdefaults valueForKey:@"userID"]){
                [self creatbuding];
            } else {
                TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
            NSLog(@"实名认证");
        }else if (indexPath.row == 4){
            TCFeedbackViewController *feedbackVC = [[TCFeedbackViewController alloc]init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
    
        }else if (indexPath.row == 5){
            TCHelpViewController *helpVC = [[TCHelpViewController alloc]init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
}

-(void)creatbuding{
    [BQActivityView showActiviTy];
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
        
        NSString *codeStr = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
        
        if ([codeStr intValue] == 1){
            TCAlRealNameViewController *alRealName = [[TCAlRealNameViewController alloc]init];
            alRealName.name = jsonDic[@"data"][@"name"];
            alRealName.idnum = jsonDic[@"data"][@"idno"];
            [self.navigationController pushViewController:alRealName animated:YES];
        }
        if ([codeStr intValue] < 0){ //跳到银行卡页面
            if (self.isPay == YES) {
                TCWithAlSetViewController *alSet = [[TCWithAlSetViewController alloc]init];
                alSet.titleStr = @"实名认证";
                alSet.entranceTypeStr = @"1"; //入口
                [self.navigationController pushViewController:alSet animated:YES];
            }else{  //跳到设置支付密码页面
                TCModiViewController *modiVC = [[TCModiViewController alloc]init];
                modiVC.titleStr = @"实名认证";
                modiVC.entranceTypeStr = @"2"; //入口
                modiVC.mobile = self.messDic[@"mobile"];
                [self.navigationController pushViewController:modiVC animated:YES];
            }
        }
        [BQActivityView hideActiviTy];

    } failure:^(NSError *error) {
        nil;
    }];
}

#pragma mark -- button的点击事件
- (void)btn
{
    TCLoginViewController *LoginVC = [[TCLoginViewController alloc] init];
    [self presentViewController:LoginVC animated:YES completion:nil];
}
#pragma mark -- 账户信息
-(void)getIntoAccount:(UIButton *)sender{
    NSLog(@"跳转进入账户信息界面");
    
    UIImageView *find_image = (UIImageView *)[self.view viewWithTag:208];
    UILabel *find_label = (UILabel *)[self.view viewWithTag:209];
    find_label.text = @"一人足矣";
    NSURL *url = [NSURL URLWithString:@"http://q.qlogo.cn/qqapp/1105640733/E75E3A559A835B75E0C68AE60614254F/100"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    find_image.image = image;
    TCAccountViewController *accountVC = [[TCAccountViewController alloc]init];
    [self.navigationController pushViewController:accountVC animated:YES];
}

#pragma mark -- 消息按钮点击事件
-(void)clickLeftBtn:(UIButton *)sender{
    NSLog(@"1111");
   if ([_userdefaults valueForKey:@"userID"]){
       TCNewsViewController *newsVC = [[TCNewsViewController alloc]init];
       [self.navigationController pushViewController:newsVC animated:YES];
   } else {
       TCLoginViewController *LoginVC = [[TCLoginViewController alloc] init];
       [self presentViewController:LoginVC animated:YES completion:nil];
   }
}
#pragma mark -- 设置按钮点击事件
-(void)clickRightBtn:(UIButton *)sender{
    NSLog(@"进入设置页面");
     if ([_userdefaults valueForKey:@"userID"]){
         TCMysetupViewController *mysetVC =[[TCMysetupViewController alloc]init];
         [self.navigationController pushViewController:mysetVC animated:YES];
     } else {
         TCLoginViewController *LoginVC = [[TCLoginViewController alloc] init];
         [self presentViewController:LoginVC animated:YES completion:nil];
     }
}
#pragma mark -- 获取到三方登录的图片 昵称
- (void)asdf:(NSNotification *)notification{
    
    NSLog(@"接受到通知，改变图片昵称");
    UIImageView *find_image = (UIImageView *)[self.view viewWithTag:208];
    UILabel *find_label = (UILabel *)[self.view viewWithTag:209];
    NSLog(@"通知里面的%@",notification.userInfo[@"nickname"]);
    NSLog(@"图片的URl：%@",notification.userInfo[@"imageUrl"]);
    // 如果是传多个数据，那么需要哪个数据，就对应取出对应的数据即可
    //http://q.qlogo.cn/qqapp/1105640733/E75E3A559A835B75E0C68AE60614254F/100
    find_label.text = notification.userInfo[@"nickname"];
    NSString *urlStr = notification.userInfo[@"imageUrl"];
    NSURL *url = [NSURL URLWithString:urlStr];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    find_image.image = image;
    find_label.text = notification.userInfo[@"nickname"];
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TCMyMessageViewController" object:nil];
}

#pragma mark -- 点击手势
- (void)tapHead
{
    NSLog(@"点击手势");
    if ([_userdefaults valueForKey:@"userID"]){
        TCAccountViewController *accountVC = [[TCAccountViewController alloc] init];
        accountVC.isbinding = self.isbining;
        [self.navigationController pushViewController:accountVC animated:YES];
    } else {
        TCLoginViewController *LoginVC = [[TCLoginViewController alloc] init];
        [self presentViewController:LoginVC animated:YES completion:nil];
    }
}

#pragma mark -- 判断导航栏是否显示和隐藏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    BOOL isVC = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [BQActivityView hideActiviTy];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.isLoginChaoShi = NO;
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
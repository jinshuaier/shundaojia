//
//  TCAlreadyMessageController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCAlreadyMessageController.h"

#import "TCLoginViewController.h" //登录页面
#import "TCMymessageCell.h"
#import "TCAccountViewController.h"//账户信息页面
#import "TCMysetupViewController.h"//设置页面
#import "TCNewsViewController.h" //消息界面
#import "TCWalletViewController.h"//钱包页面
#import "TCMydiscountViewController.h"//我的优惠券
#import "TCHelpViewController.h"//帮助中心
#import "TCFeedbackViewController.h" //意见反馈
#import "TCFavoriteViewController.h" //我的收藏
#import "TCReAddressViewController.h"//收货地址
#import "TCQRCodelViewController.h" //二维码界面
#import "TCMessageCollectionCell.h"//自定义Collectioncell
#import "TCJoinViewController.h"//加盟合作
#import "TCAlRealNameViewController.h"//实名认证
#import "TCBindingNoSetController.h"
#import "TCNoReseNameController.h"//未实名认证
#import "TCBindingPassViewController.h"
@interface TCAlreadyMessageController ()<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *MycollectionView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) BOOL isReseName;
@property (nonatomic, assign) BOOL isSet;
@end

@implementation TCAlreadyMessageController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(UICollectionView *)MycollectionView{
    if (!_MycollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //设置垂直间的最小间距
        layout.minimumLineSpacing = 1;
        //设置水平间的最小间距
        layout.minimumInteritemSpacing = 1;
        
        _MycollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 194 + 8 , WIDTH, 99.5*3) collectionViewLayout:layout];
        _MycollectionView.delegate = self;
        _MycollectionView.dataSource = self;
        _MycollectionView.scrollEnabled = NO;
        _MycollectionView.backgroundColor = TCBgColor;
        
        
    }
    return _MycollectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isReseName = NO;
    self.isSet = NO;
    self.view.backgroundColor = TCBgColor;
    
    UIImageView *headImageBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 194)];
    headImageBG.image = [UIImage imageNamed:@"背景顶部"];
    headImageBG.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getIntoAccount:)];
    
    [headImageBG addGestureRecognizer:tap];
    
    [self.view addSubview:headImageBG];
    
    UIButton *newBtn = [[UIButton alloc]initWithFrame:CGRectMake(16, 31.5, 17, 20)];
    [newBtn setBackgroundImage:[UIImage imageNamed:@"通知"] forState:(UIControlStateNormal)];
    [newBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [headImageBG addSubview:newBtn];
    UILabel *dotLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 0, 8, 8)];
    dotLabel.layer.masksToBounds = YES;
    dotLabel.layer.cornerRadius = 4;
    dotLabel.backgroundColor = TCUIColorFromRGB(0xFF0000);
    [newBtn addSubview:dotLabel];
    
    
    UIButton *setupBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 16 - 20, 31.5, 20, 20)];
    [setupBtn setBackgroundImage:[UIImage imageNamed:@"设置"] forState:(UIControlStateNormal)];
    [setupBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [headImageBG addSubview:setupBtn];
    
    //创建imageView
    UIImageView *image_headView = [[UIImageView alloc] init];
    image_headView.frame = CGRectMake((WIDTH - 76)/2, CGRectGetMaxY(newBtn.frame), 76, 76);
    [image_headView sd_setImageWithURL:[NSURL URLWithString:self.messDic[@"src"]] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    image_headView.layer.cornerRadius = 76/2;
    image_headView.layer.masksToBounds = YES;
    image_headView.layer.borderColor = TCUIColorFromRGB(0xFFFFFF).CGColor;
    image_headView.layer.borderWidth = 1;
    [headImageBG addSubview:image_headView];

    
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 90)/2, CGRectGetMaxY(image_headView.frame) + 10, 90, 15)];
    namelabel.textAlignment = NSTextAlignmentCenter;
    namelabel.textColor = TCUIColorFromRGB(0xFFFFFF);
    namelabel.font = [UIFont fontWithName:@"PingFangTC-Medium" size:15];
    namelabel.text = self.messDic[@"nickname"];
    [headImageBG addSubview:namelabel];

    //电话label
    UILabel *phoneLabel = [UILabel publicLab:self.messDic[@"mobile"] textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangTC-Regular" size:13 numberOfLines:0];
    phoneLabel.frame = CGRectMake((WIDTH - 100)/2, CGRectGetMaxY(namelabel.frame) + 8, 100, 21);
    phoneLabel.backgroundColor = [TCUIColorFromRGB(0xFFFFFF) colorWithAlphaComponent:0.081];
    phoneLabel.layer.cornerRadius = 21/2;
    phoneLabel.layer.masksToBounds = YES;
    [headImageBG addSubview:phoneLabel];
    
    

    
    
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(0, 0, 100, 21);
//    label.text = @"15611331231";
//    label.font = [UIFont fontWithName:@"PingFangTC-Regular" size:13];
//    label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
//    label.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:label];


    
    
    
    
    [self creatUI];
    
}

#pragma mark -- 创建九宫格
-(void)creatUI{
    self.images = @[@"钱包图标",@"优惠券",@"二维码图标",@"定位",@"实名认证",@"收藏",@"意见反馈图标",@"加盟",@"帮助中心 copy"];
    self.titles = @[@"钱包",@"优惠券",@"二维码",@"收货地址",@"实名认证",@"我的收藏",@"意见反馈",@"加盟合作",@"帮助中心"];
    
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
        cell.iconImage.frame = CGRectMake(((WIDTH - 3)/3 - 20)/2, 24.5, 20, 24);
    }else if (indexPath.row == 5){
        cell.iconImage.frame = CGRectMake(((WIDTH - 3)/3 - 22)/2, 28.5, 22, 18);
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
        TCWalletViewController *walletVC = [[TCWalletViewController alloc]init];
        [self.navigationController pushViewController:walletVC animated:YES];
    }else if (indexPath.row == 1){
        TCMydiscountViewController *mydisVC = [[TCMydiscountViewController alloc]init];
        [self.navigationController pushViewController:mydisVC animated:YES];
    }else if (indexPath.row == 2){
        TCQRCodelViewController *qrCodeVC = [[TCQRCodelViewController alloc]init];
        [self.navigationController pushViewController:qrCodeVC animated:YES];
    }else if (indexPath.row == 3){
        TCReaddressViewController *reAdreeVC = [[TCReaddressViewController alloc]init];
        [self.navigationController pushViewController:reAdreeVC animated:YES];
    }else if (indexPath.row == 4){
        NSLog(@"实名认证");
        if (self.isReseName == YES) {
           TCAlRealNameViewController *alRealname = [[TCAlRealNameViewController alloc]init];
           [self.navigationController pushViewController:alRealname animated:YES];
        }else{
            
            if (self.isSet == YES) {
                TCBindingPassViewController *bindingVC = [[TCBindingPassViewController alloc]init];
                [self.navigationController pushViewController:bindingVC animated:YES];
            }else{
                TCBindingNoSetController *noSetVC = [[TCBindingNoSetController alloc]init];
                [self.navigationController pushViewController:noSetVC animated:YES];
            }
            
        }
        
    }else if (indexPath.row == 5){
        TCFavoriteViewController *favoriteVC = [[TCFavoriteViewController alloc]init];
        [self.navigationController pushViewController:favoriteVC animated:YES];
    }else if (indexPath.row == 6){
       TCFeedbackViewController *feedbackVC = [[TCFeedbackViewController alloc]init];
       [self.navigationController pushViewController:feedbackVC animated:YES];
        
    }else if (indexPath.row == 7){
        NSLog(@"加盟合作");
        TCJoinViewController *joinVC = [[TCJoinViewController alloc]init];
        [self.navigationController pushViewController:joinVC animated:YES];
    }else if (indexPath.row == 8){
        TCHelpViewController *helpVC = [[TCHelpViewController alloc]init];
        [self.navigationController pushViewController:helpVC animated:YES];
    }
    
}


#pragma mark -- button的点击事件
- (void)btn
{
    TCLoginViewController *LoginVC = [[TCLoginViewController alloc] init];
    LoginVC.isMyPage = YES;
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
    
    TCNewsViewController *newsVC = [[TCNewsViewController alloc]init];
    [self.navigationController pushViewController:newsVC animated:YES];
    
}
#pragma mark -- 设置按钮点击事件
-(void)clickRightBtn:(UIButton *)sender{
    NSLog(@"进入设置页面");
    TCMysetupViewController *mysetVC =[[TCMysetupViewController alloc]init];
    [self.navigationController pushViewController:mysetVC animated:YES];
    
    
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
    NSURL *urlStr = notification.userInfo[@"imageUrl"];
    NSURL *url = [NSURL URLWithString:urlStr];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    find_image.image = image;
    find_label.text = notification.userInfo[@"nickname"];
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TCMyMessageViewController" object:nil];
    
}

@end

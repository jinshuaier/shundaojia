//
//  TCBusineShopViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/7.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCBusineShopViewController.h"
#import "TCBusinessLicViewController.h"
#import "TCBussPlaceViewController.h" //商家位置
#import "ZoomImageView.h"

@interface TCBusineShopViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UITableView *shopActiveTable;
@property (nonatomic, assign) NSInteger cellHight;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSDictionary *messDic;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIScrollView *ScrollImageView;

@end

@implementation TCBusineShopViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCBgColor;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.dataArr = [NSMutableArray array];
    
    //请求的接口
    [self createQuest];
    
    // Do any additional setup after loading the view.
}

#pragma mark -- 视图
- (void)createUI
{
    //添加滚动视图
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT )];
    self.scrollview.contentSize = CGSizeMake(WIDTH, HEIGHT *2 );
    self.scrollview.delegate = self;
    self.scrollview.userInteractionEnabled = YES;
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.backgroundColor = TCBgColor;
    //解决ios11的导航栏布局的问
    //    AdjustsScrollViewInsetNever (self,self.scrollview);
    [self.view addSubview:self.scrollview];
    //商家照片+营业资质
    //主View
    UIView *mainView = [[UIView alloc] init];
    mainView.frame = CGRectMake(0, 12, WIDTH, 138);
    mainView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.scrollview addSubview:mainView];
    //商家照片
    UILabel *phoneLabel = [UILabel publicLab:@"商家照片" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    phoneLabel.frame = CGRectMake(12, 12, 56, 18);
    [mainView addSubview:phoneLabel];
    
    //照片的View
    UIView *phoneView = [[UIView alloc] init];
    phoneView.frame = CGRectMake(0, CGRectGetMaxY(phoneLabel.frame) + 8, WIDTH, 88);
    phoneView.backgroundColor = TCBgColor;
    [mainView addSubview:phoneView];
    
    NSMutableArray *imageNames = [NSMutableArray array];
    //    NSMutableArray *desArr = [NSMutableArray array];
    
    NSArray *arrPic = self.messDic[@"shopPics"];
    for (NSInteger i = 0; i < arrPic.count; i++) {
        [imageNames addObject:arrPic[i][@"src"]];
    }
    
    CGFloat itemWith = 72;
    _ScrollImageView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 88)];
    _ScrollImageView.showsVerticalScrollIndicator = FALSE;
    _ScrollImageView.showsHorizontalScrollIndicator = FALSE;
    _ScrollImageView.backgroundColor = TCBgColor;
    _ScrollImageView.bounces = NO;
    _ScrollImageView.contentSize = CGSizeMake(WIDTH *1.375 - 15, itemWith);
    [phoneView addSubview:_ScrollImageView];
    
    for (int i = 0; i < arrPic.count; i++) {
        ZoomImageView *imageView = [[ZoomImageView alloc]initWithFrame:CGRectMake(12 + i *(itemWith + 8), 8, itemWith, itemWith) withImage:imageNames[i]];
        imageView.imageArray = imageNames;
        [_ScrollImageView addSubview:imageView];
    }
    
    //下划线
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, CGRectGetMaxY(phoneView.frame) + 12, WIDTH, 1);
    lineView.backgroundColor = TCLineColor;
    [mainView addSubview:lineView];
    
    //营业执照的View
    UIView *licenseView = [[UIView alloc] init];
    licenseView.backgroundColor = [UIColor whiteColor];
    licenseView.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), WIDTH, 52);
    licenseView.userInteractionEnabled = YES;
    [self.scrollview addSubview:licenseView];
    //营业执照icon
    UIImageView *image_icon = [[UIImageView alloc] init];
    image_icon.frame = CGRectMake(12, 16, 20, 20);
    image_icon.image = [UIImage imageNamed:@"营业资质图标"];
    [licenseView addSubview:image_icon];
    //标题
    UILabel *titleLabel = [UILabel publicLab:@"营业资质" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    titleLabel.frame = CGRectMake(CGRectGetMaxX(image_icon.frame) + 8, 15, 60, 20);
    [licenseView addSubview:titleLabel];
    //小三角
    UIImageView *triangleImage = [[UIImageView alloc] init];
    triangleImage.frame = CGRectMake(WIDTH - 12 - 5, 21.5, 5, 8);
    triangleImage.image = [UIImage imageNamed:@"进入小三角（灰）"];
    [licenseView addSubview:triangleImage];
    
    //手势
    UITapGestureRecognizer *tap_one = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_one)];
    [licenseView addGestureRecognizer:tap_one];
    
    //view
    UIView *messView = [[UIView alloc] init];
    messView.frame = CGRectMake(0, CGRectGetMaxY(licenseView.frame) + 12, WIDTH, 4 *52);
    messView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.scrollview addSubview:messView];
    
    //定位View
    UIView *locationView = [[UIView alloc] init];
    locationView.frame = CGRectMake(0, 0, WIDTH, 52);
    locationView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    locationView.userInteractionEnabled = YES;
    [messView addSubview:locationView];
    
    UITapGestureRecognizer *tap_two = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_two)];
    [locationView addGestureRecognizer:tap_two];
    
    UIImageView *locate_icon = [[UIImageView alloc] init];
    locate_icon.frame = CGRectMake(12, 16, 20, 20);
    locate_icon.image = [UIImage imageNamed:@"定位图标"];
    [locationView addSubview:locate_icon];
    
    UILabel *titlelocatLabel = [UILabel publicLab:self.messDic[@"data"][@"locaddress"] textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
    titlelocatLabel.frame = CGRectMake(CGRectGetMaxX(image_icon.frame) + 8, 0, WIDTH - 24 - 5 - (CGRectGetMaxX(image_icon.frame) + 8), 52);
    [locationView addSubview:titlelocatLabel];
    
    UIImageView *locatImage = [[UIImageView alloc] init];
    locatImage.frame = CGRectMake(WIDTH - 12 - 5, 21.5, 5, 8);
    locatImage.image = [UIImage imageNamed:@"进入小三角（灰）"];
    [locationView addSubview:locatImage];
    //下划线
    UIView *line_four = [[UIView alloc] init];
    line_four.frame = CGRectMake(CGRectGetMaxX(image_icon.frame) + 8, CGRectGetMaxY(locationView.frame), WIDTH - (CGRectGetMaxX(image_icon.frame) + 8) , 1);
    line_four.backgroundColor = TCLineColor;
    [messView addSubview:line_four];
    
    //
    for (int i = 0; i < 3; i ++) {
        NSArray *imageArr = @[@"商家电话图标",@"配送时间图标",@"配送服务图标"];
        NSArray *titleArr = @[@"商家电话",@"配送时间",@"配送服务"];
        NSArray *disArr = @[self.messDic[@"data"][@"tel"],self.messDic[@"data"][@"shopTime"],@"商家提供配送"];
        UIImageView *imageStr = [[UIImageView alloc] init];
        imageStr.frame = CGRectMake(12, CGRectGetMaxY(line_four.frame) + 16 + (32 + 20) * i , 20, 20);
        imageStr.image = [UIImage imageNamed:imageArr[i]];
        [messView addSubview:imageStr];
        
        UILabel *titleStr = [UILabel publicLab:titleArr[i] textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:15 numberOfLines:0];
        titleStr.frame = CGRectMake(CGRectGetMaxX(imageStr.frame) + 8, CGRectGetMaxY(line_four.frame) + 52*i, 60 , 52);
        [messView addSubview:titleStr];
        
        UIView *linemesView = [[UIView alloc] init];
        linemesView.frame = CGRectMake(CGRectGetMaxX(imageStr.frame) + 8, CGRectGetMaxY(line_four.frame) + 52 + 52*i, WIDTH - (CGRectGetMaxX(imageStr.frame) + 8), 1);
        linemesView.backgroundColor = TCLineColor;
        [messView addSubview:linemesView];
        
        UILabel *disLabel = [[UILabel alloc] init];
        disLabel.text = disArr[i];
        if (i == 0){
            disLabel.textColor = TCUIColorFromRGB(0x4CA6FF);
            disLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
            
            disLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *telTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disLabelTap)];
            [disLabel addGestureRecognizer:telTap];
            
        } else if (i == 1){
            disLabel.textColor = TCUIColorFromRGB(0x33333);
            disLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        } else if (i == 2){
            disLabel.textColor = TCUIColorFromRGB(0x666666);
            disLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        }
        disLabel.frame = CGRectMake(CGRectGetMaxX(titleStr.frame), CGRectGetMaxY(line_four.frame) + 52*i, WIDTH - 24 - CGRectGetMaxX(titleStr.frame), 52);
        disLabel.textAlignment = NSTextAlignmentRight;
        [messView addSubview:disLabel];
        
        //活动的View
        UIView *activeView = [[UIView alloc] init];
        activeView.frame = CGRectMake(0, CGRectGetMaxY(messView.frame) + 12, WIDTH, 174);
        activeView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        [self.scrollview addSubview:activeView];
        //表头
        UILabel *headLabel = [UILabel publicLab:@"商家活动" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
        headLabel.tag = 1000;
        headLabel.frame = CGRectMake(12, 14, 56, 14);
        [activeView addSubview:headLabel];
        
        self.shopActiveTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headLabel.frame), WIDTH, 7 * 34) style:UITableViewStyleGrouped];
        self.shopActiveTable.backgroundColor = [UIColor whiteColor];
        self.shopActiveTable.delegate = self;
        self.shopActiveTable.dataSource = self;
        self.shopActiveTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.shopActiveTable.tableFooterView = [[UIView alloc] init];
        [activeView addSubview: self.shopActiveTable];
        
        activeView.frame = CGRectMake(0, CGRectGetMaxY(messView.frame) + 12, WIDTH,CGRectGetMaxY(self.shopActiveTable.frame) + 40);
        self.scrollview.contentSize = CGSizeMake(WIDTH, HEIGHT + 6 *34);
    }
}

#pragma mark -- 请求的接口
- (void)createQuest
{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefaults valueForKey:@"userToken"]];
    NSDictionary *dic1;
    NSDictionary *paramters;
    //判断登录与否
    if ([self.userDefaults valueForKey:@"userID"] == nil){
        dic1 = @{@"timestamp":timeStr,@"shopid":_shopID};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
        paramters = @{@"timestamp":timeStr,@"shopid":_shopID,@"sign":signStr1};
    } else {
        dic1 = @{@"timestamp":timeStr,@"shopid":_shopID,@"mid":midStr,@"token":tokenStr};
        NSString *signStr1 = [TCServerSecret signStr:dic1];
        paramters = @{@"timestamp":timeStr,@"shopid":_shopID,@"mid":midStr,@"token":tokenStr,@"sign":signStr1};
    }
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101005"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        self.messDic = jsonDic[@"data"];
        
        [self createUI];
        NSArray *arr = self.messDic[@"data"][@"activities"];
        for (int i = 0; i < arr.count; i ++) {
            [self.dataArr addObject:arr[i]];
        }
        [self.shopActiveTable reloadData];
       
    } failure:^(NSError *error) {
        nil;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identfire=@"cellID";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfire];
    }
    
    //表头的图片
    UILabel *imageLabel = [UILabel publicLab:@"首" textColor:TCUIColorFromRGB(0xFFFFFF) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Regular" size:10 numberOfLines:0];
    imageLabel.layer.cornerRadius = 2;
    imageLabel.layer.masksToBounds = YES;
    imageLabel.backgroundColor = TCUIColorFromRGB(0x72C62A);
    imageLabel.frame = CGRectMake(16, 0, 16, 16);
    [cell.contentView addSubview:imageLabel];
    //详情
    UILabel *disActiveLabel = [UILabel publicLab:self.dataArr[indexPath.row][@"content"] textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    disActiveLabel.frame = CGRectMake(CGRectGetMaxX(imageLabel.frame) + 4, 0, WIDTH - (CGRectGetMaxX(imageLabel.frame) + 4) - 16, 16);
    CGSize size = [disActiveLabel sizeThatFits:CGSizeMake(WIDTH - (CGRectGetMaxX(imageLabel.frame) + 4) - 16, MAXFLOAT)];
    disActiveLabel.frame = CGRectMake(CGRectGetMaxX(imageLabel.frame) + 4, 0, WIDTH - (CGRectGetMaxX(imageLabel.frame) + 4) - 16, size.height);
    
    [cell.contentView addSubview:disActiveLabel];
    self.cellHight = disActiveLabel.frame.size.height + 20;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 48, 24)];
        viewHead.backgroundColor = [UIColor whiteColor];
        return viewHead;
    }
    return [[UIView alloc] init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 48, 0)];
    footerView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 24;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


#pragma mark -- 营业资质
- (void)tap_one
{
    NSLog(@"营业纸质");
    TCBusinessLicViewController *busLicVC = [[TCBusinessLicViewController alloc] init];
    busLicVC.imageArr = self.messDic[@"authPics"];
    [self.navigationController pushViewController:busLicVC animated:YES];
}

#pragma mark -- 定位
- (void)tap_two
{
    NSLog(@"地图查看信息");
    TCBussPlaceViewController *bussPlaceVC = [[TCBussPlaceViewController alloc] init];
    bussPlaceVC.latStr = [NSString stringWithFormat:@"%@",self.messDic[@"data"][@"latitude"]];
    bussPlaceVC.longStr = [NSString stringWithFormat:@"%@",self.messDic[@"data"][@"longtitude"]];
    [self.navigationController pushViewController:bussPlaceVC animated:YES];
}

#pragma mark -- 打电话
- (void)disLabelTap
{
    //拨打电话
    NSString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.messDic[@"data"][@"tel"]];
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

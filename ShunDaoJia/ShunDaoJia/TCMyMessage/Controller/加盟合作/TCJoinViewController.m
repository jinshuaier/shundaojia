//
//  TCJoinViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/14.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCJoinViewController.h"
#import "TCMerchantentryViewController.h"

@interface TCJoinViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, assign) CGFloat cellH;
@end

@implementation TCJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加盟合作";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:18],NSForegroundColorAttributeName:TCUIColorFromRGB(0x333333)}];
    self.view.backgroundColor = TCBgColor;
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
    _tableview.delegate  = self;
    _tableview.dataSource = self;
    _tableview.scrollEnabled = NO;
    _tableview.backgroundColor = TCBgColor;
    [self.view addSubview: _tableview];
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 104;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 12;
    } else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
    footerView.backgroundColor = RGB(239, 239, 244);
    return footerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
    footerView.backgroundColor = RGB(239, 239, 244);
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(12, 16, 72, 72)];
    imageV.image = [UIImage imageNamed:@"插图"];
    [cell.contentView addSubview:imageV];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 14, 16, 64, 22)];
    title.text = @"商家入驻";
    title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    title.textColor = TCUIColorFromRGB(0x4C4C4C);
    title.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:title];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 14, CGRectGetMaxY(title.frame) + 30, 144, 17)];
    label.text = @"平台优势，成单量更有保障";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = TCUIColorFromRGB(0x4C4C4C);
    [cell.contentView addSubview:label];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 12 - 80, CGRectGetMaxY(title.frame) + 25, 80, 24)];
    [btn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    [btn setTitle:@"立即加盟" forState:(UIControlStateNormal)];
    [btn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    btn.layer.cornerRadius = 3;
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(share:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.contentView addSubview:btn];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)share:(UIButton *)sender{
    NSLog(@"立即加盟");
    TCMerchantentryViewController *merVC = [[TCMerchantentryViewController alloc]init];
    [self.navigationController pushViewController:merVC animated:YES];
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


//
//  TCTrackingOrderViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCTrackingOrderViewController.h"
#import "TCOrderTrackingTableViewCell.h"
#import "TCPhysicalViewController.h"
#import "TCTrackModel.h"

@interface TCTrackingOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation TCTrackingOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCBgColor;
    self.title = @"订单跟踪";
    self.dataArr = [NSMutableArray array];
    self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.backgroundColor = TCBgColor;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: self.listTableView];
    
    if (self.messDic){
        NSMutableArray *disarr = self.messDic[@"status_info"];
        for (int i = 0; i < disarr.count; i++) {
            TCTrackModel *model = [TCTrackModel DiscountsInfoWithDictionary:disarr[i] andwuliu:@"0"];
            [self.dataArr addObject:model];
        }
    }

    //解决ios11的导航栏布局的问
    AdjustsScrollViewInsetNever (self,self.listTableView);
    
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 8)];
    viewHead.backgroundColor = TCBgColor;
    return viewHead;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
    footerView.backgroundColor = TCBgColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
        return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    TCOrderTrackingTableViewCell *cell = [[TCOrderTrackingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" andDic:self.messDic andWuliu:@"1"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TCTrackModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    //记得最后一个没有竖线 切记
    if (indexPath.row == 0){
        cell.dotImage.image = [UIImage imageNamed:@"订单跟踪（当前）"];
        cell.dotImage.frame = CGRectMake(32, 13, 14, 14);
        cell.stateLable.textColor = TCUIColorFromRGB(0x46B900);
        cell.timeLabel.textColor = TCUIColorFromRGB(0x46B900);
        
        //查看物流
        UIButton *lookphysicalBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        lookphysicalBtn.frame = CGRectMake(WIDTH - 33 - 56, 8, 56, 14);
        [lookphysicalBtn setTitle:@"查看物流" forState:(UIControlStateNormal)];
        [lookphysicalBtn setTitleColor:TCUIColorFromRGB(0x27AEFF) forState:(UIControlStateNormal)];
        lookphysicalBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        lookphysicalBtn.hidden = YES;
        [lookphysicalBtn addTarget:self action:@selector(look:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.contentView addSubview:lookphysicalBtn];
        
        
        if ([self.wuliStr isEqualToString:@"1"]){
            lookphysicalBtn.hidden = NO;

        } else {
            lookphysicalBtn.hidden = YES;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48 + 35;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -- 查看物流信息
- (void)look:(UIButton *)sender
{
    TCPhysicalViewController *phyVC = [[TCPhysicalViewController alloc] init];
    phyVC.expressDic = self.messDic[@"express"];

    NSString *str; //物流的商品头像
    NSArray *arr = self.messDic[@"goods"];
    for (int i = 0; i < arr.count; i ++) {
        str = arr[0][@"src"];
    }
    phyVC.goodsImageStr = str;
    
    [self.navigationController pushViewController:phyVC animated:YES];
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

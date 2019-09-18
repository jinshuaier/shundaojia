//
//  TCPhysicalViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/12.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCPhysicalViewController.h"
#import "TCOrderTrackingTableViewCell.h"

@interface TCPhysicalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *dataArr; //物流的数组

@end

@implementation TCPhysicalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流信息";
    self.view.backgroundColor = TCBgColor;//
    self.dataArr = [NSMutableArray array];
    
    self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin) style:UITableViewStyleGrouped];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.backgroundColor = TCBgColor;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: self.listTableView];
    AdjustsScrollViewInsetNever (self,self.listTableView);
    
    //团购的查看物流信息
    NSArray *arr = self.expressDic[@"expressData"];
    for (int i = 0; i < arr.count; i++) {
        TCTrackModel *model = [TCTrackModel DiscountsInfoWithDictionary:arr[i] andwuliu:@"1"];
         [self.dataArr addObject:model];
    }
    
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 96 + 8 + 16)];
    UIView *backSectionView = [[UIView alloc] init];
    backSectionView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    backSectionView.frame = CGRectMake(0, 0, WIDTH, 96);
    [viewHead addSubview:backSectionView];
    //图片
    UIImageView *imageIcon = [[UIImageView alloc] init];
    imageIcon.frame = CGRectMake(12, 16, 64, 64);
    [imageIcon sd_setImageWithURL:[NSURL URLWithString:self.goodsImageStr] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    [backSectionView addSubview:imageIcon];
    
    //物流状态
    UILabel *titleHeadLable = [UILabel publicLab:@"物流状态：" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    titleHeadLable.frame = CGRectMake(CGRectGetMaxX(imageIcon.frame) + 16, 16, 70, 14);
    [backSectionView addSubview:titleHeadLable];
    
    //状态
    UILabel *staLable = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0x151515) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    if ([self.expressDic[@"expressNo"] isEqualToString:@""]){
        staLable.text = @"暂无";
    } else {
        staLable.text = self.expressDic[@"expressStatus"];
    }
    staLable.frame = CGRectMake(CGRectGetMaxX(titleHeadLable.frame), 16, WIDTH - CGRectGetMaxX(titleHeadLable.frame), 14);
    [backSectionView addSubview:staLable];
    
    //快递方
    UILabel *OrdersLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    OrdersLabel.frame = CGRectMake(CGRectGetMaxX(imageIcon.frame) + 16, CGRectGetMaxY(staLable.frame) + 8, WIDTH - (CGRectGetMaxX(imageIcon.frame) + 16), 12);
    if ([self.expressDic[@"expressNo"] isEqualToString:@""]){
        OrdersLabel.text = [NSString stringWithFormat:@"快递方：%@",@"暂无"];
    } else {
        OrdersLabel.text = [NSString stringWithFormat:@"快递方：%@",self.expressDic[@"expressName"]];
    }
    [backSectionView addSubview:OrdersLabel];
    //运单编码
    UILabel *waybillLabel = [UILabel publicLab:nil textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:12 numberOfLines:0];
    waybillLabel.frame = CGRectMake(CGRectGetMaxX(imageIcon.frame) + 16, CGRectGetMaxY(OrdersLabel.frame) + 8, WIDTH - (CGRectGetMaxX(imageIcon.frame) + 16), 12);
    if ([self.expressDic[@"expressNo"] isEqualToString:@""]){
        waybillLabel.text = [NSString stringWithFormat:@"运单编号：%@",@"暂无"];
    } else {
        waybillLabel.text = [NSString stringWithFormat:@"运单编号：%@",self.expressDic[@"expressCode"]];
    }
    [backSectionView addSubview:waybillLabel];
    
    UIView *garyView = [[UIView alloc] init];
    garyView.backgroundColor = TCBgColor;
    garyView.frame = CGRectMake(0, 96, WIDTH, 8);
    [viewHead addSubview:garyView];
    
    
    viewHead.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    return viewHead;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
    footerView.backgroundColor = TCBgColor;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8 + 96 + 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TCOrderTrackingTableViewCell *cell = [[TCOrderTrackingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" andDic:self.expressDic andWuliu:@"2"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TCTrackModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    //记得最后一个没有竖线 切记
    if (indexPath.row == 0){
        cell.dotImage.image = [UIImage imageNamed:@"订单跟踪（当前）"];
        cell.dotImage.frame = CGRectMake(32, 13, 14, 14);
        cell.stateLable.textColor = TCUIColorFromRGB(0x46B900);
        cell.timeLabel.textColor = TCUIColorFromRGB(0x46B900);
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48 + 30;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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

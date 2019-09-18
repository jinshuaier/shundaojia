//
//  TCCommonProblemController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCCommonProblemController.h"
#import "TCCommonProblemCell.h"
#import "TCProblemDetileController.h"

@interface TCCommonProblemController ()<UITableViewDelegate,UITableViewDataSource,tapDelegete>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *oneArr;
@property (nonatomic, strong) NSArray *twoArr;


@end

@implementation TCCommonProblemController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"常见问题";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:18],NSForegroundColorAttributeName:TCUIColorFromRGB(0x333333)}];
    
    [self creatUI];
    
    // Do any additional setup after loading the view.
}
-(void)creatUI{
    self.view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.dataArr = @[@"催单问题",@"退单问题",@"活动问题",@"我要投诉"];
    self.oneArr = @[@[@"我的订单还没送到，我要催单",@"商家联系不上怎么办？"],@[@"长时间没有收到单，我要催单",@"怎么退单？"],@[@"红包怎么使用",@"怎么得到红包"],@[@"我要投诉商家怎么投诉？",@"我收到商品有问题怎么办？"],];
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:(UITableViewStylePlain)];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = TCBgColor;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTableView];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.qh_width, 32)];
        headerView.backgroundColor = TCBgColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 6, 56, 20)];
        label.text = [NSString stringWithFormat:@"常见问题"];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.textColor = TCUIColorFromRGB(0x4C4C4C);
        label.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 32;
    }else{
        return 4;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 4;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCCommonProblemCell *cell = [[TCCommonProblemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.delegate = self;
    [cell.tap_one view].tag = indexPath.section;
    [cell.tap_two view].tag = indexPath.section;
    cell.problemName.text = self.dataArr[indexPath.section];
    cell.problemOne.text = self.oneArr[indexPath.section][0];
    cell.problemTwo.text = self.oneArr[indexPath.section][1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        TCProblemDetileController *problemVC = [[TCProblemDetileController alloc]init];
        [self.navigationController pushViewController:problemVC animated:YES];
}

- (void)sendValue_one:(UITapGestureRecognizer *)tap_one
{
    UIView *contentView = (UIView *)[[tap_one view] superview];
    TCCommonProblemCell *cell = (TCCommonProblemCell *)[contentView superview];
    NSIndexPath *path = [self.mainTableView indexPathForCell:cell];
    NSLog(@"%ld",(long)path.section);

}

- (void)sendValue_two:(UITapGestureRecognizer *)tap_two {
    UIView *contentView = (UIView *)[[tap_two view] superview];
    TCCommonProblemCell *cell = (TCCommonProblemCell *)[contentView superview];
    NSIndexPath *path = [self.mainTableView indexPathForCell:cell];
    NSLog(@"%ld",(long)path.section);
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

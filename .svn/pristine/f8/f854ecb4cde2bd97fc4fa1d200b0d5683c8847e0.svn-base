//
//  TCChooseAddressController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/18.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCChooseAddressController.h"
#import "TCChooseAdressTableCell.h"
#import "TCAddressViewController.h"

@interface TCChooseAddressController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, assign) CGFloat CellH;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation TCChooseAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = @[@"北京市通州区 新华大街人民商场万达广场各种商场一号楼一单元1702",@"北京市通州区 新华街道吉祥园中仓菜店",@"深圳市龙岗区 大浦街道便民要点对面301"];
    self.title = @"选择收货地址";
    
    self.view.backgroundColor = TCBgColor;
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - 48) style:(UITableViewStyleGrouped)];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.backgroundColor = TCBgColor;
    [self.view addSubview:self.mainTableView];
    
    UIView *addView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 48, WIDTH, 48)];
    addView.backgroundColor = TCUIColorFromRGB(0xF99E20);
    [self.view addSubview:addView];
   
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 88)/2, 16, 16, 16)];
    image.image = [UIImage imageNamed:@""];
    [addView addSubview:image];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + 8, 13, 64, 22)];
    textLabel.text = @"新增地址";
    textLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    textLabel.textColor = TCUIColorFromRGB(0xFFFFFF);
    textLabel.textAlignment = NSTextAlignmentLeft;
    [addView addSubview:textLabel];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getIntoAdd:)];
    
    [addView addGestureRecognizer:tap];
    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 8)];
        headerView.backgroundColor = TCBgColor;
        return headerView;
    }else if (section == self.dataArr.count - 1){
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 42)];
        headerView.backgroundColor = TCBgColor;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, WIDTH - 24, 18)];
        title.text = @"以下地址超出配送范围地址";
        title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        title.textColor = TCUIColorFromRGB(0x4C4C4C);
        title.textAlignment = NSTextAlignmentLeft;
        [headerView addSubview:title];
        return headerView;
    }else{
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 4)];
        headView.backgroundColor = TCBgColor;
        return headView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else if (section == self.dataArr.count - 1){
        return 42;
    }else{
        return 4;
    }
    return 4;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCChooseAdressTableCell *cell = [[TCChooseAdressTableCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.checkBtn.tag = 105;
    cell.addRessLabel.text = self.dataArr[indexPath.section];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.checkBtn.selected = YES;
        }
    }
    [cell.checkBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    if (indexPath.section == self.dataArr.count - 1) {
        cell.checkBtn.userInteractionEnabled = NO;
    }
    [cell.editBtn addTarget:self action:@selector(clickEdit:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.deleBtn addTarget:self action:@selector(clickDele:) forControlEvents:(UIControlEventTouchUpInside)];
    _CellH = cell.cellHeight;
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)clickBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _CellH;
}

-(void)clickEdit:(UIButton *)sender{
    TCChooseAdressTableCell *cell1 = (TCChooseAdressTableCell *)[[sender superview] superview];
    NSIndexPath *indexPath1 = [self.mainTableView indexPathForCell:cell1];
    NSLog(@"点击的是第%ld行修改按钮",indexPath1.section);
}
-(void)clickDele:(UIButton *)sender{
    TCChooseAdressTableCell *cell = (TCChooseAdressTableCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"收货地址删除后不可恢复,是否确认删除?" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"解除", nil];
    [alert show];
    
    NSLog(@"点击的是第%ld行删除按钮",indexPath.section);
}

-(void)getIntoAdd:(UIGestureRecognizer *)sender{
    TCAddressViewController *AddressVC = [[TCAddressViewController alloc]init];
    [self.navigationController pushViewController:AddressVC animated:YES];
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

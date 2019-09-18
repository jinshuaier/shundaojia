//
//  TCSupportViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/11/26.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCSupportViewController.h"
#import "TCSupportBankCell.h"
@interface TCSupportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation TCSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"支持银行";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:18],NSForegroundColorAttributeName:TCUIColorFromRGB(0x333333)}];
    
    self.view.backgroundColor = TCBgColor;
    [self creatUI];
    // Do any additional setup after loading the view.
}

-(void)creatUI{
    self.dataArr = @[@"1",@"1",@"1",@"1",@"1",@"1"];
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 12, WIDTH, 54*self.dataArr.count + 40)];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.scrollEnabled = NO;
    self.mainTableView.backgroundColor = TCBgColor;
    [self.view addSubview:self.mainTableView];
    
    //注册cell
    [self.mainTableView registerClass:[TCSupportBankCell class] forCellReuseIdentifier:@"cell"];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.qh_width, 0)];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    TCSupportBankCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TCSupportBankCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        
    }
    cell.bankLabel.text = @"中国工商银行储蓄卡";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

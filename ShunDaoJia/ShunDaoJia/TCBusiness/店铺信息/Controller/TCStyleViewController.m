//
//  TCStyleViewController.m
//  举报商家
//
//  Created by 吕松松 on 2017/12/7.
//  Copyright © 2017年 吕松松. All rights reserved.
//

#import "TCStyleViewController.h"
#import "TCStyleTableViewCell.h"
static NSString *mutaStr;
@interface TCStyleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray* dataArr;
@property (nonatomic, strong) NSMutableArray *idArr;
@property (nonatomic, strong) NSIndexPath *lastPath;

@end

@implementation TCStyleViewController

//导航栏出现
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报商家";
    self.view.backgroundColor = TCBgColor;
    self.dataArr = [NSMutableArray array];
    self.idArr = [NSMutableArray array];
    
    for (int i = 0; i < self.messArr.count; i ++) {
        [self.dataArr addObject:self.messArr[i][@"name"]];
        [self.idArr addObject:self.messArr[i][@"id"]];
    }
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT)];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.scrollEnabled = NO;
    _mainTableView.showsVerticalScrollIndicator = NO;//隐藏分割线
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = TCBgColor;
    AdjustsScrollViewInsetNever(self,self.mainTableView);
    [self.view addSubview:_mainTableView];
    // Do any additional setup after loading the view.
}

#pragma mark -- UITableViewDelegate
#pragma mark -- tableViewDelegateMethod
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;
}
//预防ios11错误
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
        headerView.backgroundColor = TCBgColor;
        return headerView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TCStyleTableViewCell *cell = [[TCStyleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.checkBtn.tag = indexPath.row;
    [cell.checkBtn addTarget:self action:@selector(clickCheck:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.titleLabel.text = self.dataArr[indexPath.row];
    if (indexPath.row < self.dataArr.count - 1) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, 51, WIDTH - 24, 1)];
        line.backgroundColor = TCUIColorFromRGB(0xEDEDED);
        [cell.contentView addSubview:line];
    }
    
    for (NSInteger i = 0; i < self.dataArr.count ; i++) {
        NSString *str = self.dataArr[i];
        if ([str isEqualToString:mutaStr]) {
            NSInteger rr = i;
            NSLog(@"第几个%ld",(long)i);
            if (indexPath.row == rr) {
                [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"商品选中框（黄）"] forState:UIControlStateNormal];
            }else{
                [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"商品选中框"] forState:UIControlStateNormal];
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)clickCheck:(UIButton *)sender{
    TCStyleTableViewCell *cell = (TCStyleTableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    NSLog(@"点击的是第%ld行按钮",indexPath.row);
    mutaStr = self.dataArr[indexPath.row];
    self.block(self.dataArr[indexPath.row]);
    self.blocks(self.self.idArr[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
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

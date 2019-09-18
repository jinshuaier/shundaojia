//
//  TCOrderFlowView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/5.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCOrderFlowView.h"
#import "TCOrderTrackingTableViewCell.h"

@implementation TCOrderFlowView 

- (instancetype)initWithFrame:(CGRect)frame andOrderId:(NSString *)orderID
{
    if (self = [super initWithFrame:frame]) {
        self.userDefault = [NSUserDefaults standardUserDefaults];
        [self createUI:orderID];
        self.dataArr = [NSMutableArray array];

    }
    return self;
}

//创建View
- (void)createUI:(NSString *)orderID {
    
    //请求接口
    [self quest:orderID];
    
    //背景颜色
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.backView.backgroundColor = [TCUIColorFromRGB(0x000000) colorWithAlphaComponent:0.6];
    [[UIApplication sharedApplication].keyWindow addSubview: _backView];
    
    //弹出的View
    _popView = [[UIView alloc] init];
    _popView.frame = CGRectMake(24, (HEIGHT - 320)/2, WIDTH - 24 * 2, 320);
    _popView.layer.cornerRadius = 8;
    _popView.layer.masksToBounds = YES;
    _popView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:_popView];
    
    //关闭按钮
    _deleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _deleBtn.frame = CGRectMake((WIDTH - 32)/2, CGRectGetMaxY(_popView.frame) + 24, 32, 32);
    [_deleBtn setBackgroundImage:[UIImage imageNamed:@"关闭弹窗叉号"] forState:(UIControlStateNormal)];
    [_deleBtn addTarget:self action:@selector(deleClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_backView addSubview:_deleBtn];
    
    //标题
    UILabel *titleState_Lable = [[UILabel alloc] init];
    titleState_Lable.frame = CGRectMake(24, 24, WIDTH/2, 16);
    titleState_Lable.text = @"售后跟踪";
    titleState_Lable.textColor = TCUIColorFromRGB(0x4C4C4C);
    titleState_Lable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [_popView addSubview:titleState_Lable];
    
    //查看详情按钮
    UIButton *look_btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    look_btn.frame = CGRectMake(WIDTH - 24 - 150, 25, 120, 14);
    [look_btn setTitle:@"查看订单详情" forState:(UIControlStateNormal)];
    [look_btn setImage:[UIImage imageNamed:@"进入小三角（灰）"] forState:(UIControlStateNormal)];
    look_btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [look_btn setTitleColor:TCUIColorFromRGB(0x999999) forState:(UIControlStateNormal)];
    [look_btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -look_btn.imageView.size.width - 8, 0, look_btn.imageView.size.width)];
    [look_btn setImageEdgeInsets:UIEdgeInsetsMake(0, look_btn.titleLabel.bounds.size.width, 0, -look_btn.titleLabel.bounds.size.width)];
    [look_btn addTarget:self action:@selector(lookBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [_popView addSubview:look_btn];
    
    //下划线
    UIView *line_view = [[UIView alloc] init];
    line_view.frame = CGRectMake(24, CGRectGetMaxY(titleState_Lable.frame) + 24, WIDTH - 48 - 48, 1);
    line_view.backgroundColor = TCUIColorFromRGB(0xEDEDED);
    [_popView addSubview:line_view];
    
    //创建tableView
    self.flowTableView = [[UITableView alloc] init];
    self.flowTableView.delegate = self;
    self.flowTableView.dataSource = self;
    self.flowTableView.frame = CGRectMake(0, CGRectGetMaxY(line_view.frame), WIDTH, 254 - 22);
    self.flowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_popView addSubview:self.flowTableView];
    
    //执行过度动画
    _popView.transform = CGAffineTransformTranslate(_popView.transform, 0, 320);
    [UIView animateWithDuration:0.3 animations:^{
        _popView.transform = CGAffineTransformIdentity;
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TCOrderTrackingTableViewCell *cell = [[TCOrderTrackingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" andDic:self.messDic andWuliu:@"2"];
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

//请求接口
- (void)quest:(NSString *)orderID {
    
    [self.dataArr removeAllObjects];
    NSString *timeStr = [TCGetTime getCurrentTime];
    
    NSString *midStr = [NSString stringWithFormat:@"%@",[self.userDefault valueForKey:@"userID"]];
    NSString *tokenStr = [NSString stringWithFormat:@"%@",[self.userDefault valueForKey:@"userToken"]];
    NSDictionary *dic = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"orderid":orderID};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"mid":midStr,@"token":tokenStr,@"timestamp":timeStr,@"orderid":orderID,@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102014"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        self.messDic = jsonDic[@"data"];
        NSArray *arr = jsonDic[@"data"][@"issueInfo"];
        for (int i = 0; i < arr.count; i++) {
            TCTrackModel *model = [TCTrackModel DiscountsInfoWithDictionary:arr[i] andwuliu:@"2"];
            [self.dataArr addObject:model];
        }

        [self.flowTableView reloadData];
    } failure:^(NSError *error) {
        nil;
    }];
}
//查看详情
- (void)lookBtn {
    if (self.buttonAction) {
        // 调用block传入参数
        self.buttonAction();
    }
    [UIView animateWithDuration:0.3 animations:^{
        _popView.transform = CGAffineTransformTranslate(_popView.transform, 0, 320);
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
        [self removeFromSuperview];
    }];
}

#pragma mark -- 取消
- (void)deleClick
{
    [UIView animateWithDuration:0.3 animations:^{
        _popView.transform = CGAffineTransformTranslate(_popView.transform, 0, 320);
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

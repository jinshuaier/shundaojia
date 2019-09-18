//
//  TCEvaluateViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/9.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCEvaluateViewController.h"
#import "CDZStarsControl.h"
#import "TCEvaluateTableViewCell.h"
#import "TCEvaluteModel.h"

@interface TCEvaluateViewController ()<CDZStarsControlDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *evaluateTable;
@property (nonatomic, strong) CDZStarsControl *starControl;
@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) UIView *SortView; //全部评价的标签
@property (nonatomic, strong) UIView *btnline_two;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIButton *selectBtn;//记录按钮
@property (nonatomic, strong) UIButton *lastBtn;//记录按钮
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSDictionary *messDic;
@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, strong) NSArray *tagArr; //便签
@end

@implementation TCEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    
    [self createUI];
    //添加刷新 后面这个是进去现请求一次为了标签不会每次都创建
    [self setupRefresh:@"0" andTagType:@"0"];

    // Do any additional setup after loading the view.
}

//添加刷新
- (void) setupRefresh:(NSString *)type andTagType:(NSString *)tagType{
    //下拉
    __block int  page = 1;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        page = 1;
        //刷新
        [self requestNews:type andTagType:tagType];
    }];
    //设置刷新标题
    [header setTitle:@"下拉刷新顺道嘉消息..." forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新顺道嘉消息..." forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新顺道嘉消息..." forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
    
    self.evaluateTable.mj_header = header;
    [header beginRefreshing];
    
    //上拉
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self requestNews:page andType:type];
    }];
    //设置上拉标题
    [footer setTitle:@"上拉加载更多顺道嘉消息" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载更多顺道嘉消息..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"无更多顺道嘉消息!" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    self.evaluateTable.mj_footer = footer;
}

//下拉请求
- (void)requestNews:(NSString *)type andTagType:(NSString *)tagType{
    [self.dataArr removeAllObjects];
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    
    NSDictionary *dic = @{@"type":type,@"page":@"1",@"timestamp":timeStr,@"shopid":self.shopID};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"type":type,@"page":@"1",@"timestamp":timeStr,@"shopid":self.shopID,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101006"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        
        for (NSDictionary *infoDic in jsonDic[@"data"][@"data"]) {
            TCEvaluteModel *model = [TCEvaluteModel EvaluteInfoWithDictionary:infoDic];
            [self.dataArr addObject:model];
        }
        
        self.messDic = jsonDic[@"data"];
        
        if ([tagType isEqualToString:@"0"]) {
            //好评
            NSString *allStr = [NSString stringWithFormat:@"全部（%@）",self.messDic[@"all"]];
            NSString *goodStr = [NSString stringWithFormat:@"好评（%@）",self.messDic[@"good"]];
            NSString *sgoodStr = [NSString stringWithFormat:@"服务好（%@）",self.messDic[@"sgood"]];
            NSString *badStr = [NSString stringWithFormat:@"差评（%@）",self.messDic[@"bad"]];
            
            self.tagArr = @[allStr,goodStr,sgoodStr,badStr];
            
            [self createView];
        }
        NSLog(@"%@",self.dataArr);
        
        [self.evaluateTable reloadData];
        [self.evaluateTable.mj_header endRefreshing];
    } failure:^(NSError *error) {
        nil;
    }];
    [self.evaluateTable.mj_footer resetNoMoreData];
}

//view
- (void)createView
{
    //头部view
    self.headView = [[UIView alloc] init];
    self.headView.frame = CGRectMake(0, 0, WIDTH, 8 + 118 + 4 + 42 + 100);
    self.headView.backgroundColor = [UIColor whiteColor];
    self.evaluateTable.tableHeaderView = self.headView;
    //背景灰
    UIView *garyView = [[UIView alloc] init];
    garyView.frame = CGRectMake(0, 0, WIDTH, 8);
    garyView.backgroundColor = TCBgColor;
    [self.headView addSubview:garyView];
    //评分View
    UIView *gradeView = [[UIView alloc] init];
    gradeView.frame = CGRectMake(0, CGRectGetMaxY(garyView.frame), WIDTH, 118);
    gradeView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.headView addSubview:gradeView];
    //综合评价
    UILabel *synthesizeLabel = [UILabel publicLab:self.messDic[@"rank"] textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Semibold" size:30 numberOfLines:0];
    synthesizeLabel.frame = CGRectMake(0, 27, 136, 34);
    [self.headView addSubview:synthesizeLabel];
    
    UILabel *dissynthesizeLabel = [UILabel publicLab:@"综合评价" textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentCenter fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    dissynthesizeLabel.frame = CGRectMake(0, CGRectGetMaxY(synthesizeLabel.frame) + 12, 136, 18);
    [self.headView addSubview:dissynthesizeLabel];
    
    //线
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(CGRectGetMaxX(dissynthesizeLabel.frame), 24, 1, 64);
    lineView.backgroundColor = TCLineColor;
    [self.headView addSubview:lineView];
    
    //服务
    for (int i = 0; i < 3; i ++) {
        NSArray *titleArr = @[@"商品评价",@"服务评价",@"物流评价"];
        UILabel *titleLabel = [UILabel publicLab:titleArr[i] textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:13 numberOfLines:0];
        titleLabel.frame = CGRectMake(21 + CGRectGetMaxX(lineView.frame), 24 + (18+8) * i, 52, 18);
        [self.headView addSubview:titleLabel];
        
        NSArray *starArr = @[self.messDic[@"goodsRank"],self.messDic[@"serviceRank"],self.messDic[@"deliverRank"]];
        self.starControl = [[CDZStarsControl alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 12, 27 + (12+14)*i, 84, 12) noramlStarImage:[UIImage imageNamed:@"大五角星（灰）"] highlightedStarImage:[UIImage imageNamed:@"大五角星（色）"]];
        self.starControl.delegate = self;
        self.starControl.allowFraction = YES;
        float score = [starArr[i] floatValue];
        self.starControl.score = score;
        [self.headView addSubview:self.starControl];
        
        UILabel *distitleLabel = [UILabel publicLab:starArr[i] textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:13 numberOfLines:0];
        distitleLabel.frame = CGRectMake(12 + CGRectGetMaxX(self.starControl.frame), 24 + (18+8) * i, WIDTH - (12 + CGRectGetMaxX(self.starControl.frame)), 18);
        [self.headView addSubview:distitleLabel];
    }
    //garyView
    UIView *garyView_two = [[UIView alloc] init];
    garyView_two.frame = CGRectMake(0, CGRectGetMaxY(dissynthesizeLabel.frame) + 27, WIDTH, 4);
    garyView_two.backgroundColor = TCBgColor;
    [self.headView addSubview:garyView_two];
    
    self.SortView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(garyView_two.frame), WIDTH, 0)];
    self.SortView.backgroundColor = [UIColor whiteColor];
    self.SortView.clipsToBounds = YES;
    [self.headView addSubview: self.SortView];
    //全部评价 的标签
    NSArray *secondArr = self.tagArr;
    for (int i = 0; i < secondArr.count; i++) {
        NSString *namestr = secondArr[i];
        static UIButton *searchrecordBtn = nil;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        CGRect newRect = [namestr boundingRectWithSize:CGSizeMake(WIDTH - 24, 32) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:button.titleLabel.font} context:nil];
        [button setTitleColor:TCUIColorFromRGB(0xF99E20) forState:UIControlStateSelected];
        [button setTitleColor:TCUIColorFromRGB(0x666666) forState:UIControlStateNormal];
        button.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
        button.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
        
        if (i == 0) {
            button.frame = CGRectMake(12, 12, newRect.size.width + 10, 32);
            button.selected = YES;
            self.selectedBtn = button;
            button.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.2];
            button.layer.borderColor = TCUIColorFromRGB(0xF99E20).CGColor;
        }else{
            CGFloat newwidth = WIDTH - 12 - CGRectGetMaxX(searchrecordBtn.frame) - 24;
            if (newwidth >= newRect.size.width) {
                button.frame = CGRectMake(CGRectGetMaxX(searchrecordBtn.frame) + 12, searchrecordBtn.frame.origin.y, newRect.size.width + 12, 32);
            }else{
                button.frame = CGRectMake(12, CGRectGetMaxY(searchrecordBtn.frame) + 12, newRect.size.width + 12, 32);
            }
            button.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
            button.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
        }
        button.tag = 1000 + i;
        [button setTitle:secondArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(recordBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
        button.layer.cornerRadius = 4;
        button.layer.borderWidth = 0.5;
        button.layer.masksToBounds = YES;
        //代表前一个按钮 用来记录前一个按钮的位置与大小
        searchrecordBtn = button;
        [self.SortView addSubview: button];
        
        if (i ==  secondArr.count - 1) {
            self.SortView.frame = CGRectMake(0, CGRectGetMaxY(garyView_two.frame), WIDTH, CGRectGetMaxY(button.frame) + 12);
            self.headView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(self.SortView.frame));
            self.lastBtn = button;
        }
    }
    
}
//上拉加载
- (void)requestNews:(int)page andType:(NSString *)type{
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    
    NSString *pageStr = [NSString stringWithFormat:@"%d",page];
    NSDictionary *dic = @{@"shopid":self.shopID,@"page":pageStr,@"timestamp":timeStr,@"type":type};
    NSLog(@"%@",dic);
    NSString *signStr = [TCServerSecret signStr:dic];
    
    NSDictionary *paramters = @{@"shopid":self.shopID,@"page":pageStr,@"timestamp":timeStr,@"type":type,@"sign":signStr};
    
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"101006"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        for (NSDictionary *infoDic in jsonDic[@"data"][@"data"]) {
            TCEvaluteModel *model = [TCEvaluteModel EvaluteInfoWithDictionary:infoDic];
            [self.dataArr addObject:model];
        }
        [self.evaluateTable.mj_footer endRefreshing];
        [self.evaluateTable reloadData];
    } failure:^(NSError *error) {
        nil;
        [self.evaluateTable.mj_footer endRefreshingWithNoMoreData];
    }];
}

//创建UI
- (void)createUI
{
    self.evaluateTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 44 - StatusBarAndNavigationBarHeight - TabbarSafeBottomMargin) style:(UITableViewStylePlain)];
    self.evaluateTable.delegate = self;
    self.evaluateTable.dataSource = self;
    self.evaluateTable.backgroundColor = TCBgColor;
    self.evaluateTable.tableFooterView = [[UIView alloc] init];
    self.evaluateTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: self.evaluateTable];
}

#pragma mark -- 搜索记录的点击事件
-(void)recordBtn:(UIButton *)sender
{
    _selectedBtn.selected = NO;
    _selectedBtn.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    _selectedBtn.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;

    sender.selected = !sender.selected;
    sender.backgroundColor = [TCUIColorFromRGB(0xF99E20) colorWithAlphaComponent:0.2];
    sender.layer.borderColor = TCUIColorFromRGB(0xF99E20).CGColor;
    self.selectedBtn = sender;
    
    if (sender.tag == 1000){
        [self setupRefresh:@"0" andTagType:@"1"];
        
    } else if (sender.tag == 1001){
        [self setupRefresh:@"1" andTagType:@"1"];
        
    } else if (sender.tag == 1002){
        [self setupRefresh:@"3" andTagType:@"1"];
        
    } else if (sender.tag == 1003){
        [self setupRefresh:@"2" andTagType:@"1"  ];
    }
}

- (void)typeSelect:(UIButton *)button {
    self.lastButton.selected = NO;
    button.selected = YES;
    self.lastButton = button;
    if (button.tag == 1000){
        self.SortView.hidden = NO;
        self.SortView.frame = CGRectMake(0, CGRectGetMaxY(self.btnline_two.frame), WIDTH, CGRectGetMaxY(self.lastBtn.frame) + 12);
        self.headView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(self.SortView.frame));
    } else if (button.tag == 1001){
        self.SortView.hidden = YES;
        self.SortView.frame = CGRectMake(0, CGRectGetMaxY(self.btnline_two.frame), WIDTH, 0);
        self.headView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(self.SortView.frame));
    }
    [self.evaluateTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TCEvaluateTableViewCell *cell = [[TCEvaluateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (self.dataArr.count != 0){
        TCEvaluteModel *model = self.dataArr[indexPath.section];
        cell.model = model;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCEvaluteModel *model = self.dataArr[indexPath.section];
    return model.cellHight;
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

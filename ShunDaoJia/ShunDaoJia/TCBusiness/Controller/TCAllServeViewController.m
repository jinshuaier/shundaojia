//
//  TCAllServeViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCAllServeViewController.h"
#import "TCAllServerLeftTableViewCell.h"
#import "TCAllServeRightCell.h"
#import "TCAllSerLeftModel.h"
#import "TCAllSerRightModel.h"
#import "TCShopMessageViewController.h"
#import "TCSearchController.h"

static NSString *const TCAllServeRightCellID = @"TCAllServeRightCell";

@interface TCAllServeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectView;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) NSMutableArray *rightDataArr;
@property (nonatomic, strong) NSMutableArray *dataLeftArr;
@property (nonatomic, assign) NSInteger  selectIndex;
@property (nonatomic, assign) BOOL isScrollDown;
@property (nonatomic, strong) NSString *goodsCatID;

@end

@implementation TCAllServeViewController

-(UITableView *)leftTableView{
    
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, 96, HEIGHT - StatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _leftTableView.tableFooterView = [[UIView alloc] init];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 46;
        _leftTableView.backgroundColor = TCBgColor;
        [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionNone];
        _leftTableView.hidden = YES;
    }
    return _leftTableView;
}

-(UICollectionView *)rightCollectView{
    
    if (!_rightCollectView) {
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _rightCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(96, StatusBarAndNavigationBarHeight, WIDTH - 96, self.view.bounds.size.height -StatusBarAndNavigationBarHeight) collectionViewLayout:self.flowLayout];
       
        self.flowLayout.itemSize = CGSizeMake(WIDTH - 96, 100);
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _rightCollectView.delegate = self;
        _rightCollectView.dataSource = self;
        
        [_rightCollectView registerClass:[TCAllServeRightCell class] forCellWithReuseIdentifier:TCAllServeRightCellID];
        _rightCollectView.backgroundColor = [UIColor whiteColor];
        __block int  page = 1;
        self.rightCollectView.wj_refreshHeader = [WJRefreshHeader refreshHeaderWithRefreshBlock:^{
            [self questData:self.goodsCatID];
            page = 1;
        }];
        _rightCollectView.mj_footer = [WJRefreshFooter refreshFooterWithRefreshBlock:^{
            NSLog(@"999");
            page ++;
            NSString *pageStr = [NSString stringWithFormat:@"%d",page];
            [self questData:self.goodsCatID AndPage:(NSString *)pageStr];
    
        }];
    }
    return _rightCollectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"全部服务";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataLeftArr = [NSMutableArray array];
    self.rightDataArr = [NSMutableArray array];
    self.navigationController.delegate = self;
    _selectIndex = 0;
    _isScrollDown = YES;
    
    /*  导航栏右边的搜索按钮 */
    [self setUpNavBtn];
    
    [ProgressHUD showHUDToView:self.view];
    
    //加载数据
    [self setUpData];
    [self.view addSubview:self.leftTableView];
//    [self.view addSubview:self.rightCollectView];

    // Do any additional setup after loading the view.
}

- (void)setUpNavBtn {
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame =CGRectMake(0, 0, 30, 44);
    [searchBtn setImage:[UIImage imageNamed:@"搜索图标"] forState:(UIControlStateNormal)];
    [searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barBut = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = barBut;
}

#pragma mark -- 加载数据
- (void)setUpData {
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"timestamp":timeStr,@"latitude":self.latitudeStr,@"longtitude":self.longtitudeStr,@"page":@"1"};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"timestamp":timeStr,@"latitude":self.latitudeStr,@"longtitude":self.longtitudeStr,@"page":@"1",@"sign":signStr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102032"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        [ProgressHUD hiddenHUD:self.view];
        if (jsonDic){
            NSArray *allCateArr = jsonDic[@"data"][@"cate"];
            for (NSDictionary *dict in allCateArr)
            {
                TCAllSerLeftModel *model = [TCAllSerLeftModel AllSerLeftInfoWithDictionary:dict];
                [self.dataLeftArr addObject:model];
            }
            self.leftTableView.hidden = NO;
            [self.leftTableView reloadData];
            
            //添加刷新 默认第一个啊
            NSString *goodsIDstr = [NSString stringWithFormat:@"%@",allCateArr[0][@"goodscateid"]];
            //传入shopID 和 分类的ID
            [self questData:goodsIDstr];
            self.goodsCatID = goodsIDstr;
            
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                            animated:YES
                                      scrollPosition:UITableViewScrollPositionNone];
        }
    } failure:^(NSError *error) {
        nil;
    }];
}

//添加刷新
- (void)questData:(NSString *)goodsIDstr {
    [self.rightDataArr removeAllObjects];
    self.leftTableView.userInteractionEnabled = NO;
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"timestamp":timeStr,@"latitude":self.latitudeStr,@"longtitude":self.longtitudeStr,@"page":@"1",@"goodscateid":goodsIDstr};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"timestamp":timeStr,@"latitude":self.latitudeStr,@"longtitude":self.longtitudeStr,@"page":@"1",@"sign":signStr,@"goodscateid":goodsIDstr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102032"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        if (jsonDic){
            
            NSArray *allRightArr = jsonDic[@"data"][@"goodsList"];
            for (NSDictionary *dict in allRightArr)
            {
                TCAllSerRightModel *model = [TCAllSerRightModel AllSerRightInfoWithDictionary:dict];
                [self.rightDataArr addObject:model];
            }
            [self.view addSubview:self.rightCollectView];
            self.leftTableView.userInteractionEnabled = YES;
            [self.rightCollectView reloadData];
            [self.rightCollectView.mj_header endRefreshing];

        }
    } failure:^(NSError *error) {
        nil;
    }];
}

- (void)questData:(NSString *)goodsIDstr AndPage:(NSString *)page
{
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"timestamp":timeStr,@"latitude":self.latitudeStr,@"longtitude":self.longtitudeStr,@"page":page,@"goodscateid":goodsIDstr};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"timestamp":timeStr,@"latitude":self.latitudeStr,@"longtitude":self.longtitudeStr,@"page":page,@"sign":signStr,@"goodscateid":goodsIDstr};
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102032"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        NSLog(@"%@,%@",jsonDic,jsonStr);
        if (jsonDic){
            
            NSArray *allRightArr = jsonDic[@"data"][@"goodsList"];
            for (NSDictionary *dict in allRightArr)
            {
                TCAllSerRightModel *model = [TCAllSerRightModel AllSerRightInfoWithDictionary:dict];
                [self.rightDataArr addObject:model];
            }
        
            [self.view addSubview:self.rightCollectView];
            [self.rightCollectView reloadData];
            [self.rightCollectView.mj_footer endRefreshing];

        }
    } failure:^(NSError *error) {
        nil;
    }];
}

#pragma mark UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataLeftArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectIndex = indexPath.row;
    TCAllServerLeftTableViewCell *cell = [[TCAllServerLeftTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if (self.dataLeftArr.count != 0) {
        TCAllSerLeftModel *model = self.dataLeftArr[indexPath.row];
        cell.model = model;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectIndex = indexPath.row;
    //刷新
    TCAllSerLeftModel *model = self.dataLeftArr[indexPath.row];
    self.goodsCatID = model.goodscateid;
    [self.rightCollectView.wj_refreshHeader beginRefreshing];
}

#pragma mark UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.rightDataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TCAllServeRightCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TCAllServeRightCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (self.rightDataArr.count != 0) {
        TCAllSerRightModel *model = self.rightDataArr[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeZero;
}


-(void)selectRowAtIndexPath:(NSInteger)index{
    
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TCAllSerRightModel *model = self.rightDataArr[indexPath.row];
    TCShopMessageViewController *shopMessageVC = [[TCShopMessageViewController alloc] init];
    shopMessageVC.shopID = model.shopid;
    shopMessageVC.goodsID = model.goodsid;
    shopMessageVC.goodCateID = model.goodscateid;
    [self.navigationController pushViewController:shopMessageVC animated:YES];
}

#pragma mark -- 搜索的点击事件
- (void)searchBtn:(UIButton *)sender
{
    TCSearchController *searchVC = [[TCSearchController alloc] init];
    searchVC.latStr = self.latitudeStr;
    searchVC.longStr = self.longtitudeStr;
    searchVC.isAllfuwu = NO;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = ![viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
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

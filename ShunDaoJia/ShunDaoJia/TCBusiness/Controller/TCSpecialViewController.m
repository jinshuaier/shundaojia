//
//  TCSpecialViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCSpecialViewController.h"
#import "TCSpecialCollectionCell.h"
#import "TCSpecialModel.h"
#import "TCShopMessageViewController.h"
#import "TCDayFootView.h"

//static NSString *const TCDayFootViewID = @"TCDayFootView";


@interface TCSpecialViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TCNoMessageView *nomessageView; //占位

@end

@implementation TCSpecialViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCBgColor;
    self.title = @"今日特价";
    self.navigationController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArray = [NSMutableArray array];
    
    [ProgressHUD showHUDToView:self.view];
    //加载数据
    [self setData];
    [self.view addSubview:self.collectionView];
    
    // Do any additional setup after loading the view.
}

#pragma mark - 创建collectionView并设置代理
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight) collectionViewLayout:flowLayout];
        _collectionView.hidden = YES;
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake(WIDTH - 20, 164);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 0;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 0;
        //定义每个UICollectionView 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);//上左下右
        
        //注册cell和ReusableView（相当于头部）
        [_collectionView registerClass:[TCSpecialCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        __block int  page = 1;
        _collectionView.wj_refreshHeader = [WJRefreshHeader refreshHeaderWithRefreshBlock:^{
            [self setData];
             page = 1;
        }];
        _collectionView.wj_refreshFooter = [WJRefreshFooter refreshFooterWithRefreshBlock:^{
            page ++;
            NSString *pageStr = [NSString stringWithFormat:@"%d",page];
            [self setData:(NSString *)pageStr];
        }];
    }
    return _collectionView;
}

//加载数据
- (void)setData {
    
    NSString *timeStr = [TCGetTime getCurrentTime];
    NSDictionary *dic = @{@"timestamp":timeStr,@"latitude":self.latitudeStr,@"longtitude":self.longtitudeStr};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"timestamp":timeStr,@"latitude":self.latitudeStr,@"longtitude":self.longtitudeStr,@"sign":signStr};
    NSLog(@" %@--",paramters);
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102031"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {
        [_dataArray removeAllObjects];
        if (jsonDic[@"data"]){
            _collectionView.hidden = NO;
            NSMutableArray *arr = jsonDic[@"data"];
            for (int i = 0; i < arr.count; i++) {
                TCSpecialModel *model = [TCSpecialModel SpecialInfoWithDictionary:arr[i]];
                [self.dataArray addObject:model];
            }
        } else {
            [TCProgressHUD showMessage:jsonDic[@"msg"]];
        }

        [ProgressHUD hiddenHUD:self.view];
        //刷新界面
        [self NeedResetNoView];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        nil;
    }];
    [self.collectionView.mj_header endRefreshing];
}

#pragma mark -- 没有商品的时候的占位图
- (void)NeedResetNoView
{
    if (self.dataArray.count >0) {
        [self.nomessageView removeFromSuperview];
    }else{
        if (self.nomessageView){
            [self.nomessageView removeFromSuperview];
            self.nomessageView = [[TCNoMessageView alloc] initWithFrame:CGRectMake(0, 42 + StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - 42 - StatusBarAndNavigationBarHeight) AndImage:@"暂无商品插图" AndLabel:@"暂无特价商品" andButton:nil];
            self.nomessageView.plButton.alpha = 0.0;
            [self.view addSubview:self.nomessageView];
            
        } else {
            self.nomessageView = [[TCNoMessageView alloc] initWithFrame:CGRectMake(0, 42 + StatusBarAndNavigationBarHeight, WIDTH, HEIGHT - 42 - StatusBarAndNavigationBarHeight) AndImage:@"暂无商品插图" AndLabel:@"暂无特价商品" andButton:nil];
            self.nomessageView.plButton.alpha = 0.0;
            [self.view addSubview:self.nomessageView];
        }
    }
}


- (void)setData:(NSString *)pageStr {
    NSString *timeStr = [TCGetTime getCurrentTime];
    
    NSDictionary *dic = @{@"timestamp":timeStr,@"latitude":self.latitudeStr,@"longtitude":self.longtitudeStr,@"page":pageStr};
    NSString *signStr = [TCServerSecret signStr:dic];
    NSDictionary *paramters = @{@"timestamp":timeStr,@"latitude":self.latitudeStr,@"longtitude":self.longtitudeStr,@"sign":signStr,@"page":pageStr};
    NSLog(@" %@--",paramters);
    [TCNetworking postWithTcUrlString:[TCServerSecret loginAndRegisterSecretOffline:@"102031"] paramter:paramters success:^(NSString *jsonStr, NSDictionary *jsonDic) {

        NSMutableArray *arr = jsonDic[@"data"];
        for (int i = 0; i < arr.count; i++) {
            TCSpecialModel *model = [TCSpecialModel SpecialInfoWithDictionary:arr[i]];
            [self.dataArray addObject:model];
        }
        
        //刷新界面
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        nil;
    }];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray count];
}

#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    TCSpecialCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (self.dataArray.count != 0){
        TCSpecialModel *model = self.dataArray[indexPath.row];
        cell.model = model;
    }
    [cell sizeToFit];
    return cell;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
   
    return CGSizeMake(WIDTH, 0);
}

#pragma mark UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择%ld",indexPath.item);
    TCShopMessageViewController *shopMessageVC = [[TCShopMessageViewController alloc] init];
    TCSpecialModel *model = self.dataArray[indexPath.row];
    shopMessageVC.shopID = model.shopID;
    shopMessageVC.goodsID = model.goodsID;
    shopMessageVC.goodCateID = model.goodscateID;
    [self.navigationController pushViewController:shopMessageVC animated:YES];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = ![viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

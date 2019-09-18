//
//  TCBusinessLicViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/7.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCBusinessLicViewController.h"
#import "HggBigImage.h"
#import "TCBusCollectionViewCell.h"

@interface TCBusinessLicViewController ()
@property (nonatomic, strong) UIImageView *image_one;
@property (nonatomic, strong) UILabel *titleLabel; //营业资质的标题
@property (nonatomic, strong) UIView *licView;
@end

@implementation TCBusinessLicViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营业资质";
    self.view.backgroundColor = TCBgColor;
    
    //营业执照的View
    self.licView = [[UIView alloc] init];
    self.licView.frame = CGRectMake(12, StatusBarAndNavigationBarHeight + 12, WIDTH - 24, 42);
    self.licView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.view addSubview:self.licView];
    
    //label
    self.titleLabel = [UILabel publicLab:@"商家营业资质" textColor:TCUIColorFromRGB(0x4C4C4C) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    self.titleLabel.frame = CGRectMake(12, 12, WIDTH - 24, 18);
    [self.licView addSubview:self.titleLabel];
    
    [self.view addSubview:self.collectionView];

    //获取网络上返回的资质图片
    _cellArray = [self.imageArr mutableCopy];
}

#pragma mark - 创建collectionView并设置代理
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(self.licView.frame), WIDTH - 24, HEIGHT - (CGRectGetMaxY(self.licView.frame) + 12)) collectionViewLayout:flowLayout];
        
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake((WIDTH- 12 * 5)/2, (WIDTH- 12 * 5)/2);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 12;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 12;
        //定义每个UICollectionView 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);//上左下右
        
        //注册cell和ReusableView（相当于头部）
        [_collectionView registerClass:[TCBusCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

#pragma mark - UICollectionView delegate dataSource
#pragma mark 定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_cellArray count];
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
    TCBusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:_cellArray[indexPath.item][@"src"]] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];

    return cell;
}

#pragma mark UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.image_one = [[UIImageView alloc] init];
     [self.image_one sd_setImageWithURL:[NSURL URLWithString:_cellArray[indexPath.item][@"src"]] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    
    NSLog(@"选择%ld",indexPath.item);
    [HggBigImage showImage:self.image_one];
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

//
//  TCAllclassViewController.m
//  ShunDaoJia
//
//  Created by 吕松松 on 2017/12/29.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCAllclassViewController.h"
#import "TCShopViewController.h"
#import "TCAllCollectionViewCell.h" //这边还是用collect 比较好，性能好

@interface TCAllclassViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *mainCollectionView;
}
@end

@implementation TCAllclassViewController

- (void)viewDidLoad {
    self.title = @"全部";
    [super viewDidLoad];
    self.view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = NO;

    //创建视图
//    [self creatUI];
    //创建collerView
    [self creatAllConect];
    
    // Do any additional setup after loading the view.
}

//创建collerView
- (void)creatAllConect
{
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake(90, 66);
    //2.初始化collectionView
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight + 16, WIDTH, HEIGHT - StatusBarAndNavigationBarHeight - 16) collectionViewLayout:layout];
    [self.view addSubview:mainCollectionView];
    mainCollectionView.backgroundColor = [UIColor clearColor];
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [mainCollectionView registerClass:[TCAllCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    //注册headerView 此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为reusableView
    [mainCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    //4.设置代理
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.cateArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCAllCollectionViewCell *cell = (TCAllCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [cell.topImage sd_setImageWithURL:[NSURL URLWithString:self.cateArr[indexPath.row][@"icon"]] placeholderImage:[UIImage imageNamed:@"商品详情页占位"]];
    cell.botlabel.text = self.cateArr[indexPath.row][@"name"];
    return cell;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 46 + 20);
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.1;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 16;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TCShopViewController *shopVC = [[TCShopViewController alloc] init];
    shopVC.isAllDian = YES;
    shopVC.TitleStr = self.cateArr[indexPath.row][@"name"];
    shopVC.typeStr = self.cateArr[indexPath.row][@"id"];
    shopVC.latStr = self.latStr;
    shopVC.longStr = self.longStr;
    [self.navigationController pushViewController:shopVC animated:YES];
}


//-(void)creatUI{
//    CGFloat width = (WIDTH - 75 *4 - 24)/3;
//    for (int i = 0; i < self.cateArr.count; i++) {
//
//        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        btn.frame = CGRectMake(12 + i%4*(75 + width), StatusBarAndNavigationBarHeight + 16 + i/4*(16 + 30), 75, 30);
//        btn.layer.borderColor = TCUIColorFromRGB(0xDEDEDE).CGColor;
//        btn.tag = 1000 + i;
//        btn.layer.borderWidth = 0.5;
//        btn.layer.masksToBounds = YES;
//        btn.layer.cornerRadius = 15;
//        [btn setTitle:[NSString stringWithFormat:@"%@",self.cateArr[i][@"name"]] forState:(UIControlStateNormal)];
//        [btn setTitleColor:TCUIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
//        [btn addTarget:self action:@selector(clickLabel:) forControlEvents:(UIControlEventTouchUpInside)];
//        [btn setBackgroundColor:TCUIColorFromRGB(0xFFFFFF)];
//        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
//        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [self.view addSubview:btn];
//    }
//}

//-(void)clickLabel:(UIButton *)sender{
//  //  NSLog(@"%@--%@",self.cateArr[sender.tag - 1000][@"name"],self.cateArr[sender.tag - 1000][@"id"]);
//    NSString *str = self.cateArr[sender.tag - 1000][@"id"];
//    TCShopViewController *shopVC = [[TCShopViewController alloc] init];
//    shopVC.isAllDian = YES;
//    shopVC.TitleStr = [NSString stringWithFormat:@"%@",self.cateArr[sender.tag - 1000][@"name"]];
//    shopVC.typeStr = str;
//    shopVC.latStr = self.latStr;
//    shopVC.longStr = self.longStr;
//    [self.navigationController pushViewController:shopVC animated:YES];
//
//}
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

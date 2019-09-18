//
//  TCNewActiveCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCNewActiveCell.h"
#import "TCImageFitCell.h"
#import "TCNewActiveLayout.h"

@interface TCNewActiveCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TCNewWelfareLayoutDelegate>

/* collectionView */
@property (strong , nonatomic) UICollectionView *collectionView;
@property (strong , nonatomic) NSArray *imageArr;

@end

static NSString *const TCImageFitCellID = @"TCImageFitCell";

@implementation TCNewActiveCell
#pragma mark - lazyload
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        TCNewActiveLayout *dcLayout = [TCNewActiveLayout new];
        dcLayout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:dcLayout];
        _collectionView.frame = self.bounds;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:[TCImageFitCell class] forCellWithReuseIdentifier:TCImageFitCellID];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"]; //注册头部
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterReusableView"]; //注册尾部
    }
    return _collectionView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpBase];
    }
    return self;
}


#pragma mark - initialize
- (void)setUpBase
{
    self.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = self.backgroundColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reve:) name:@"tupianchuanzhi" object:nil];
}

- (void)reve:(NSNotification *)userInfo {
    NSLog(@"%@",userInfo.userInfo);
    self.imageArr = @[userInfo.userInfo[@"imageDic"][@"one"],userInfo.userInfo[@"imageDic"][@"two"],userInfo.userInfo[@"imageDic"][@"three"]];
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TCImageFitCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TCImageFitCellID forIndexPath:indexPath];
    NSArray *images = self.imageArr;
    cell.handheldImage = images[indexPath.row];
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderReusableView" forIndexPath:indexPath];
        return headerView;
        
    } else if (kind == UICollectionElementKindSectionFooter) {
        
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterReusableView" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor clearColor];
        return footerView;
    }
    
    return [UICollectionReusableView new];
}


#pragma mark - item点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"第%zd个item",indexPath.row);
    if (self.ActiveAction) {
        // 调用block传入参数
        self.ActiveAction(indexPath.row);
    }
}


#pragma mark - DCItemSortLayoutDelegate
#pragma mark - 底部高度
-(CGFloat)dc_HeightOfSectionFooterForIndexPath:(NSIndexPath *)indexPath {
    return 0;
}
#pragma mark - 头部高度
-(CGFloat)dc_HeightOfSectionHeaderForIndexPath:(NSIndexPath *)indexPath {
    return 0;
}
@end

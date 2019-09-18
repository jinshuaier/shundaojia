//
//  TCBusinessLicViewController.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/7.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCBusinessLicViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *_cellArray;     //collectionView数据
}
@property (nonatomic, strong) NSArray *imageArr; //图片组合
@property (nonatomic, strong) UICollectionView *collectionView;

@end

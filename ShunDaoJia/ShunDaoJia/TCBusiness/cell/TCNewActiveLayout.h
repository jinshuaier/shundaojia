//
//  TCNewActiveLayout.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCNewWelfareLayoutDelegate <NSObject>

@optional;

/* 头部高度 */
-(CGFloat)dc_HeightOfSectionHeaderForIndexPath:(NSIndexPath *)indexPath;
/* 尾部高度 */
-(CGFloat)dc_HeightOfSectionFooterForIndexPath:(NSIndexPath *)indexPath;

@end

@interface TCNewActiveLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) id<TCNewWelfareLayoutDelegate>delegate;


@end

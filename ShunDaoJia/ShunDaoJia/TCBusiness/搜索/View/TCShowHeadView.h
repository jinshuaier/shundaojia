//
//  TCShowHeadView.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/6.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

//block点击事件
typedef void(^LunboClick)(NSInteger tagStr);

@interface TCShowHeadView : UICollectionReusableView

/* 轮播图数组 */
@property (copy , nonatomic)NSArray *imageGroupArray;
@property (nonatomic,copy) LunboClick LunboAction;

@end

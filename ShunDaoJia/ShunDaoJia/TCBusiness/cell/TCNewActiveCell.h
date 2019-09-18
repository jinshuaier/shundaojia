//
//  TCNewActiveCell.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

//block点击事件
typedef void(^ActiveClick)(NSInteger tagStr);

@interface TCNewActiveCell : UICollectionViewCell
@property (nonatomic,copy) ActiveClick ActiveAction;

@end

//
//  TCSearchView.h
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/25.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapActionBlock)(NSString *str);
@interface TCSearchView : UIView

@property (nonatomic, copy) TapActionBlock tapAction;
@property (nonatomic, assign) BOOL isShopGoodsSearch;

- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr;

@end

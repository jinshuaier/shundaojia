//
//  UIScrollView+WJRefresh.h
//  WJKit
//
//  Created by 琚冠辉 on 16/5/9.
//  Copyright © 2016年 网家科技有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJRefreshHeader.h"
#import "WJRefreshFooter.h"

@interface UIScrollView(WJRefresh)

@property (strong, nonatomic) WJRefreshHeader *wj_refreshHeader;
@property (strong, nonatomic) WJRefreshFooter *wj_refreshFooter;

@end

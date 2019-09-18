//
//  WJRefreshFooter.h
//  WJKit
//
//  Created by 琚冠辉 on 16/3/8.
//  Copyright © 2016年 网家科技有限责任公司. All rights reserved.
//

#import "MJRefreshBackFooter.h"

@interface WJRefreshFooter : MJRefreshBackFooter

+ (WJRefreshFooter *)refreshFooterWithRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@end

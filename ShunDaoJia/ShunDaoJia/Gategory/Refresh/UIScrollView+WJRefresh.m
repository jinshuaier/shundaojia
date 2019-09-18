//
//  UIScrollView+WJRefresh.m
//  WJKit
//
//  Created by 琚冠辉 on 16/5/9.
//  Copyright © 2016年 网家科技有限责任公司. All rights reserved.
//

#import "UIScrollView+WJRefresh.h"
#import "UIScrollView+MJRefresh.h"

@implementation UIScrollView(WJRefresh)

- (void)setWj_refreshHeader:(WJRefreshHeader *)wj_refreshHeader {
    self.mj_header = wj_refreshHeader;
}

- (WJRefreshHeader *)wj_refreshHeader {
    return (WJRefreshHeader *)self.mj_header;
}

- (void)setWj_refreshFooter:(WJRefreshFooter *)wj_refreshFooter {
    self.mj_footer = wj_refreshFooter;
}

- (WJRefreshFooter *)wj_refreshFooter {
    return (WJRefreshFooter *)self.mj_footer;
}

@end

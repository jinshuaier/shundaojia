//
//  WJRefreshFooter.m
//  WJKit
//
//  Created by 琚冠辉 on 16/3/8.
//  Copyright © 2016年 网家科技有限责任公司. All rights reserved.
//

#import "WJRefreshFooter.h"

@interface WJRefreshFooter()

@property (nonatomic, strong) UILabel *labelTitle;

@end

@implementation WJRefreshFooter

+ (WJRefreshFooter *)refreshFooterWithRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    WJRefreshFooter *refreshFooter = [[WJRefreshFooter alloc] init];
    if (refreshFooter) {
        refreshFooter.refreshingBlock = refreshingBlock;
    }
    return refreshFooter;
}

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc] initWithFrame:self.bounds];
        _labelTitle.font = [UIFont fontWithName:@"PingFang SC" size:12];
        _labelTitle.textColor = TMSColorFromRGB(0x666666);
        _labelTitle.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelTitle];
    }
    return _labelTitle;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            self.labelTitle.text = NSLocalizedString(@"上拉加载更多", nil);
            break;
        case MJRefreshStatePulling:
            self.labelTitle.text = NSLocalizedString(@"松开立即加载", nil);
            break;
        case MJRefreshStateRefreshing:
            self.labelTitle.text = NSLocalizedString(@"正在加载...", nil);
            break;
        case MJRefreshStateNoMoreData:
            self.labelTitle.text = NSLocalizedString(@"没有更多数据了", nil);
        default:
            break;
    }
}

@end

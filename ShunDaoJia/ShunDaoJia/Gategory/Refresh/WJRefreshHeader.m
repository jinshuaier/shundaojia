//
//  WJRefreshHeader.m
//  WJKit
//
//  Created by 琚冠辉 on 16/3/8.
//  Copyright © 2016年 网家科技有限责任公司. All rights reserved.
//

#import "WJRefreshHeader.h"


#define WJKIT_REFRESH_IMAGE_SIZE    CGSizeMake(20, 20)

@interface WJRefreshHeader()

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIImageView *viewRefresh;

@end

@implementation WJRefreshHeader

+ (WJRefreshHeader *)refreshHeaderWithRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    WJRefreshHeader *refreshHeader = [[WJRefreshHeader alloc] init];
    if (refreshHeader) {
        UIImage *image = [UIImage imageNamed:@"refresh_loading_black"];
        [refreshHeader setAnimationImage:image];
        refreshHeader.refreshingBlock = refreshingBlock;
    }
    return refreshHeader;
}

- (UIImageView *)viewRefresh {
    if (!_viewRefresh) {
        self.backgroundColor = [UIColor clearColor];
        const CGSize imageSize = WJKIT_REFRESH_IMAGE_SIZE;
        const CGFloat allWidth = CGRectGetWidth(self.bounds);
        const CGFloat allHeight = CGRectGetHeight(self.bounds);
        _viewRefresh = [[UIImageView alloc] initWithFrame:CGRectMake(roundf((allWidth - imageSize.width) / 2),
                                                                     roundf(allHeight / 2) - imageSize.height,
                                                                     imageSize.width,
                                                                     imageSize.height)];
        _viewRefresh.contentMode = UIViewContentModeScaleToFill;
        _viewRefresh.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _viewRefresh.animationDuration = 0.2;
        [self addSubview:_viewRefresh];
    }
    return _viewRefresh;
}

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        const CGFloat allWidth = CGRectGetWidth(self.bounds);
        const CGFloat allHeight = CGRectGetHeight(self.bounds);
        const CGFloat topMargin = roundf(allHeight / 2);
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, topMargin, allWidth, allHeight - topMargin)];
        _labelTitle.font = [UIFont fontWithName:@"PingFang SC" size:12];
        _labelTitle.textColor = TMSColorFromRGB(0x666666);
        _labelTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelTitle];
    }
    return _labelTitle;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    const CGSize imageSize = WJKIT_REFRESH_IMAGE_SIZE;
    const CGFloat allWidth = CGRectGetWidth(self.bounds);
    const CGFloat allHeight = CGRectGetHeight(self.bounds);
    
    self.viewRefresh.frame = CGRectMake(roundf((allWidth - imageSize.width) / 2),
                                        roundf(allHeight / 2) - imageSize.height,
                                        imageSize.width,
                                        imageSize.height);
    
    const CGFloat topMargin = roundf(allHeight / 2);
    self.labelTitle.frame = CGRectMake(0, topMargin, allWidth, allHeight - topMargin);
}

- (void)setAnimationImage:(UIImage *)animationImage {
    self.viewRefresh.image = animationImage;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            [self.viewRefresh stopAnimating];
            self.labelTitle.text = NSLocalizedString(@"下拉可以刷新", nil);
            break;
        case MJRefreshStatePulling:
            [self.viewRefresh stopAnimating];
            self.labelTitle.text = NSLocalizedString(@"松开立即刷新", nil);
            break;
        case MJRefreshStateRefreshing:
            self.labelTitle.text = NSLocalizedString(@"正在刷新...", nil);
            [self didAnimation];
            break;
        default:
            break;
    }
}

- (void)didAnimation {
    if ([self isRefreshing]) {
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:0.1
                         animations:^{
                             weakself.viewRefresh.transform = CGAffineTransformRotate(self.viewRefresh.transform, M_PI / 2);
                         }
                         completion:^(BOOL finished) {
                             [weakself didAnimation];
                         }];
    }
}

@end

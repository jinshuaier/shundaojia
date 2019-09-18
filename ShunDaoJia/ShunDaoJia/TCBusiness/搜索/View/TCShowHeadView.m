//
//  TCShowHeadView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/6.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCShowHeadView.h"
#import "SDCycleScrollView.h"

@interface TCShowHeadView ()<SDCycleScrollViewDelegate>

/*  轮播图 */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end


@implementation TCShowHeadView

//初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建View
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.backgroundColor = [UIColor whiteColor];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 0, WIDTH - 20, self.height) delegate:self placeholderImage:[UIImage imageNamed:@"首页banner占位图"]];
    _cycleScrollView.backgroundColor = [UIColor clearColor];
    _cycleScrollView.layer.cornerRadius = 6;
    _cycleScrollView.layer.masksToBounds = YES;
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.autoScrollTimeInterval = 5.0;
    [self addSubview:_cycleScrollView];
}

- (void)setImageGroupArray:(NSArray *)imageGroupArray
{
    _imageGroupArray = imageGroupArray;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"首页banner占位图"];
    if (imageGroupArray.count == 0) return;
    _cycleScrollView.imageURLStringsGroup = _imageGroupArray;
}

#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.LunboAction) {
        // 调用block传入参数
        self.LunboAction(index);
    }
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end

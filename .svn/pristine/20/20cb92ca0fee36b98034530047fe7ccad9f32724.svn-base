//
//  ZYYWheelView.m
//  CustomDemo
//
//  Created by zhngyy on 16/6/27.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import "ZYYWheelView.h"
#import "ZYYWheelScrollView.h"

@interface ZYYWheelView ()<ZYYWheelScrollViewDelegate>

@property (nonatomic,copy)ClickImageViewWithIndex clickBlcok;
@property (nonatomic,strong)ZYYWheelScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *imagess;
@end


@implementation ZYYWheelView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray placeholdName:(NSString *)placeholdName duration:(NSTimeInterval)duration scroller:(BOOL)scroll
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageArray = imageArray;
        _durationTime = duration;
        _placeholdName = placeholdName;
        _isScroll = scroll;
        
        [self creatSubViews];
    }
    return self;
}

-(void)setPlaceholdName:(NSString *)placeholdName
{
    _placeholdName = placeholdName;
    if(!_imageArray)
    {
        self.scrollView.placeholdeName = _placeholdName;
    }
    else
    {
        self.scrollView.placeholdeName = _placeholdName;
        self.scrollView.imageArray = _imageArray;
    }
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self creatSubViews];
}

-(void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    self.scrollView.imageArray = imageArray;
    self.pageControl.numberOfPages = imageArray.count;
}

-(void)setDurationTime:(NSTimeInterval)durationTime
{
    _durationTime = durationTime;
    self.scrollView.durationTimer = durationTime;
}
-(void)setIsScroll:(BOOL)isScroll{
    _isScroll = isScroll;
    self.scrollView.scrollEnabled = isScroll;
}
- (void)creatSubViews
{
    if (!_imagess) {
        _imagess = [[UIImageView alloc]init];
    }
    _imagess.frame = CGRectMake(0, 230, self.frame.size.width, 20);
    _imagess.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];
    [self addSubview:_imagess];
    [self addSubview:self.pageControl];
    self.scrollView.placeholdeName = _placeholdName;
    if(_imageArray.count == 1){
        self.pageControl.numberOfPages = 0;
    }else{
        self.pageControl.numberOfPages = _imageArray.count;
    }
    self.scrollView.imageArray = _imageArray;
    self.scrollView.durationTimer = _durationTime;
    self.scrollView.scrollEnabled = _isScroll;
}

-(UIPageControl *)pageControl
{
    if(!_pageControl)
    {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 170, self.frame.size.width, 20)];
        
        
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;

}



#pragma mark - 设置pagecontrol的整体颜色
- (void)setPageControlTinColor:(UIColor *)pageControlTinColor
{
    self.pageControl.pageIndicatorTintColor = pageControlTinColor;
}

#pragma mark - 设置pagecontrol当前的颜色
-(void)setCurrentPageControlTinColor:(UIColor *)currentPageControlTinColor
{
    self.pageControl.currentPageIndicatorTintColor = currentPageControlTinColor;
}

-(ZYYWheelScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [[ZYYWheelScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 360)];
        _scrollView.zyyDelegate = self;
        _scrollView.showsVerticalScrollIndicator = FALSE;
        _scrollView.showsHorizontalScrollIndicator = FALSE;

    }
    return _scrollView;
}

#pragma mark - zyyScrollView代理
-(void)clickWithCurrentIndex:(NSInteger)index
{
    if(_clickBlcok)
    {
        _clickBlcok(index);
    }
}

#pragma mark - 点击imageView的回调block
-(void)clickImageViewWithIndex:(ClickImageViewWithIndex)block
{
    if(block)
    {
        _clickBlcok = block;
    }
}

- (void)scrollToIndex:(NSInteger)index
{
    if(!_imageArray)
    {
        return;
    }
    [self.scrollView scrollToCurrentIndex:index];
}

#pragma mark - 不用点击获取当前页
-(void)getcurrentIndex:(NSInteger)index
{
    self.pageControl.currentPage = index;
}

-(void)dealloc
{
    self.scrollView = nil;
    self.pageControl = nil;
    self.clickBlcok = nil;
}
@end

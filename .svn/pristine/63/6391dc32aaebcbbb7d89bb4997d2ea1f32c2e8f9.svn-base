//
//  ZYYWheelScrollView.m
//  CustomDemo
//
//  Created by zhngyy on 16/6/27.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import "ZYYWheelScrollView.h"
typedef NS_ENUM(NSUInteger, ImageSourceType)
{
    ImageSource_LocalImage_StringName = 1, //本地图片
    
    ImageSource_WebImageLink_StringURL,    //网络图片地址（不是URL类）

    ImageSource_WebImageLink_URL,          //网络图片URL类的地址
    
    ImageSource_Image,                     //image类的图片
};

@interface ZYYWheelScrollView()
//第一个imageView
@property (nonatomic,strong)ZYYImageView *leftImageView;
//第二个imageView
@property (nonatomic,strong)ZYYImageView *middleImageView;
//第三个imageView
@property (nonatomic,strong)ZYYImageView *rightImageView;


@end

@implementation ZYYWheelScrollView
{
    CGRect _currentFrame;
    ImageSourceType _sourceType;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithScrollView:frame];
    }
    return self;
}


- (void)awakeFromNib
{
    [self initWithScrollView:self.frame];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initWithScrollView:frame];
}

-(void)initWithScrollView:(CGRect)frame
{
    _durationTimer = 2.0;
    self.delegate =self;
    self.contentSize = CGSizeMake(3*self.frame.size.width,self.frame.size.height);
    [self resetScrollContentofSet];
    self.pagingEnabled = YES;
    [self addSubview:self.leftImageView];
    [self addSubview:self.middleImageView];
    [self addSubview:self.rightImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}


#pragma mark - 图片点击的回调方法
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if([self.zyyDelegate respondsToSelector:@selector(clickWithCurrentIndex:)])
    {
        [self.zyyDelegate clickWithCurrentIndex:_currentIndex];
    }
}

#pragma mark - 获取图片资源数组
-(void)setImageArray:(NSArray *)imageArray
{
    if(!imageArray)
    {
        return;
    }
    _imageArray = imageArray;
    for(id data in imageArray)
    {
        if([data isKindOfClass:[NSString class]])
        {
            NSString *str = (NSString *)data;
            if([str hasPrefix:@"http://"]||[str hasPrefix:@"https://"])
            {
                _sourceType = ImageSource_WebImageLink_StringURL;
            }
            else
            {
                _sourceType = ImageSource_LocalImage_StringName;
            }
            break;
        }
        else if ([data isKindOfClass:[UIImage class]])
        {
            _sourceType = ImageSource_Image;
            break;
        }
        else if([data isKindOfClass:[NSURL class]])
        {
            _sourceType = ImageSource_WebImageLink_URL;
            break;
        }
        else
        {
            NSAssert(1 == 1, @"类型不正确");
        }
    }
    [self reloadImageData];
}

#pragma mark - 刷新数据的方法
- (void)reloadImageData
{
    if (_currentIndex >= (NSInteger)self.imageArray.count)
    {
        _currentIndex = 0;
    }
    if (_currentIndex < 0)
    {
        _currentIndex = (int)self.imageArray.count - 1;
    }
    NSInteger left = _currentIndex - 1;
    if (left < 0)
    {
        left = (NSInteger)self.imageArray.count - 1;
    }
    NSInteger right = _currentIndex + 1;
    if (right > self.imageArray.count - 1)
    {
        right = 0;
    }
    id leftImage     = [self.imageArray objectAtIndex:left];
    id middleImage   = [self.imageArray objectAtIndex:_currentIndex];
    id rightImage    = [self.imageArray objectAtIndex:right];
    switch (_sourceType) {
        case ImageSource_WebImageLink_URL:
        {
            self.leftImageView.webImageURL = leftImage;
            self.middleImageView.localImageName = middleImage;
            self.rightImageView.localImageName = rightImage;
        }
        break;
        case ImageSource_Image:
        {
            self.leftImageView.image = leftImage;
            self.middleImageView.image = middleImage;
            self.rightImageView.image = rightImage;
        }
        break;
        case ImageSource_LocalImage_StringName:
        {
            self.leftImageView.localImageName = leftImage;
            self.middleImageView.localImageName = middleImage;
            self.rightImageView.localImageName = rightImage;
        }
        break;
        case ImageSource_WebImageLink_StringURL:
        {
            self.leftImageView.webImageURLString = leftImage;
            self.middleImageView.webImageURLString = middleImage;
            self.rightImageView.webImageURLString = rightImage;
        }
        break;
        default:
            break;
    }
    if(self.zyyDelegate && [self.zyyDelegate respondsToSelector:@selector(getcurrentIndex:)])
    {
        [self.zyyDelegate getcurrentIndex:_currentIndex];
    }
}


-(void)setIsCustomPlay:(BOOL)isCustomPlay
{
    if(!isCustomPlay)
    {
        [self.timerManager stopTimer];
        _durationTimer = 0;
    }
    else
    {
        [self.timerManager startTimerWithdelayTime:_durationTimer];
    }
}

-(void)setDurationTimer:(NSTimeInterval)durationTimer
{
    _durationTimer = durationTimer;
    if(durationTimer>0)
    {
        [self.timerManager startTimerWithdelayTime:_durationTimer];
    }
}

- (void)setDelayDurationTimer:(NSTimeInterval)delayDurationTimer
{
    _delayDurationTimer = delayDurationTimer;
    if(delayDurationTimer>0)
    {
        [self.timerManager startTimerWithdelayTime:delayDurationTimer];
    }
}

-(void)setPlaceholdeName:(NSString *)placeholdeName
{
    _placeholdeName = placeholdeName;
    if(_sourceType == ImageSource_WebImageLink_URL||_sourceType == ImageSource_WebImageLink_StringURL)
    {
        self.leftImageView.webImagePlacehold = _placeholdeName;
        self.middleImageView.webImagePlacehold = _placeholdeName;
        self.rightImageView.webImagePlacehold = _placeholdeName;
    }
}

#pragma mark - 滚动到指定的页面
-(void)scrollToCurrentIndex:(NSInteger)index
{
    _currentIndex = index;
    [self reloadImageData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.contentOffset.x<=0)
    {
        [self resetScrollContentofSet];
        _currentIndex--;
    }
    else if (self.contentOffset.x>=self.frame.size.width*2)
    {
        _currentIndex++;
        [self resetScrollContentofSet];
    }
    [self reloadImageData];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timerManager stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==YES)
    {
        [self.timerManager startTimerWithdelayTime:_durationTimer];
    }
}

#pragma mark - 为了模拟滚动的动画效果
- (void)updateScrollViewMove
{
    [self setContentOffset:CGPointMake(self.frame.size.width*2, 0) animated:YES];
}

#pragma mark - 重置ScrollView的contentofset到第二张
-(void)resetScrollContentofSet
{
    [self scrollRectToVisible:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];
}


//左边视图
-(ZYYImageView *)leftImageView
{
    if(!_leftImageView)
    {
        _leftImageView = [[ZYYImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _leftImageView;
}

//中间视图
-(ZYYImageView *)middleImageView
{
    if(!_middleImageView)
    {
        _middleImageView = [[ZYYImageView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _middleImageView;
}

//右边视图
-(ZYYImageView *)rightImageView
{
    if(!_rightImageView)
    {
        _rightImageView = [[ZYYImageView alloc]initWithFrame:CGRectMake(2*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _rightImageView;
}

//时间管理器
-(ZYYTimerManager *)timerManager
{
    if(!_timerManager)
    {
        _timerManager = [[ZYYTimerManager alloc]init];
        __weak ZYYWheelScrollView *sself = self;
        [_timerManager timeBlockAction:^(NSTimer *time) {
            if(sself.isDecelerating||sself.isDragging)
            {
                return ;
            }
            [sself updateScrollViewMove];
        }];
    }
    return _timerManager;
}

@end

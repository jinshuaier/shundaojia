//
//  ZYYImageView.m
//  CustomDemo
//
//  Created by zhngyy on 16/7/12.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import "ZYYImageView.h"

@interface ZYYImageView ()
@property (nonatomic,strong)UILabel *titleLable;
@property (nonatomic,strong)UIImageView *imageView;
@end

@implementation ZYYImageView
{

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initSubViews];
}

- (void)initSubViews
{
    [self addSubview:self.imageView];
}

-(instancetype)initWithFrame:(CGRect)frame
                       image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.imageView.image  = image;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
                    imageURL:(NSURL *)imageURL
               placeholdName:(NSString *)placeholdName
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
      //  [self.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:placeholdName]];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
          imageWithLocalName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.imageView.image = [UIImage imageNamed:imageName];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
          imageWithURLString:(NSString *)imageName
               placeholdName:(NSString *)placeImageName
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
      //  [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:placeImageName]];
    }
    return self;
}

-(UIImageView *)imageView
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    }
    return _imageView;
}

-(void)setLocalImageName:(NSString *)localImageName
{
    self.imageView.image = [UIImage imageNamed:localImageName];
}

- (void)setImage:(UIImage *)image
{
    self.image = image;
}

- (void)setWebImageURL:(NSURL *)webImageURL
{
  //  [self.imageView sd_setImageWithURL:webImageURL placeholderImage:[UIImage imageNamed:_webImagePlacehold]];
}

- (void)setWebImageURLString:(NSString *)webImageURLString
{
   // [self.imageView sd_setImageWithURL:[NSURL URLWithString:webImageURLString] placeholderImage:[UIImage imageNamed:_webImagePlacehold]];
}

- (void)setWebImagePlacehold:(NSString *)webImagePlacehold
{
    _webImagePlacehold = webImagePlacehold;
}
@end

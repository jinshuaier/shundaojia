//
//  TCImageFitCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2018/6/7.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "TCImageFitCell.h"

@interface TCImageFitCell ()

/* 图片 */
@property (strong , nonatomic)UIImageView *handheldImageView;

@end


@implementation TCImageFitCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    _handheldImageView = [[UIImageView alloc] init];
    _handheldImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_handheldImageView];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_handheldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - Setter Getter Methods
- (void)setHandheldImage:(NSString *)handheldImage
{
    _handheldImage = handheldImage;
    
    [_handheldImageView sd_setImageWithURL:[NSURL URLWithString:handheldImage] placeholderImage:[UIImage imageNamed:@"首页banner占位图"]];
}
@end

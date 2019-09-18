//
//  TCFirstStartViewController.m
//  顺道嘉(新)
//
//  Created by 某某 on 16/9/24.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "TCFirstStartViewController.h"
#import "TCTabBarController.h"
#import "TCLoginViewController.h"

@interface TCFirstStartViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIScrollView *sview;
@property (nonatomic, strong) UIPageControl *pagecontrol;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation TCFirstStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArray = @[@"快速上门", @"轻松创收", @"安全无忧"];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    [self createImage];
}

//创建启动图
- (void)createImage{
    _sview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _sview.contentSize = CGSizeMake(WIDTH * 3, HEIGHT);
    _sview.pagingEnabled = YES;
    _sview.bounces = NO;
    _sview.showsHorizontalScrollIndicator = NO;
    _sview.showsVerticalScrollIndicator = NO;
    _sview.delegate = self;
    [self.view addSubview:_sview];
    //创建image
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(i * WIDTH, 0, WIDTH, HEIGHT)];
        imageview.image = [UIImage imageNamed:self.imageArray[i]];
        imageview.userInteractionEnabled = YES;
        [_sview addSubview:imageview];
        if (i == 2) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
            [imageview addGestureRecognizer:tap];
        }
    }
}

- (void)tap{
    TCLoginViewController *vc=[[TCLoginViewController alloc]init];
    vc.isFirst = YES;
    [[[UIApplication sharedApplication] delegate] window]. rootViewController = vc;
}

@end

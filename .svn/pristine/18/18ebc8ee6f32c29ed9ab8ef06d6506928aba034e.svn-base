//
//  JXGuideFigureShowVC.m
//  JXLeadImagesTool
//
//  Created by 张明辉 on 16/6/7.
//  Copyright © 2016年 jesse. All rights reserved.
//

#import "TCGuideFigureShowVC.h"
#import "TCGuideFigureTool.h"

@interface JXGuideFigureShowVC ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIPageControl *pageControl;
@end

@implementation JXGuideFigureShowVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置界面
    [self setupView];
}
- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake(self.images.count * SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    for (int i = 0; i < self.images.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [btn setBackgroundImage:[UIImage imageNamed:self.images[i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:self.images[i]] forState:UIControlStateHighlighted];
        if (i == self.images.count - 1) {
            UITapGestureRecognizer *tapBtn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBtn)];
            btn.userInteractionEnabled = YES;
            [btn addGestureRecognizer:tapBtn];
            
            //        [scrollView addSubview:btn];
            //        [scrollView addSubview:({
            //            self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            self.btn.frame = CGRectMake(WIDHT *i, 0, WIDHT, HEIGHT);
            //            [self.btn setImage:[UIImage imageNamed:self.images[i]] forState:UIControlStateNormal];
            //            self.btn;
            //        })];
            //        if(i == self.images.count - 1){
            //            [self.btn addSubview:({
            //                UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
            //                [btn setTitle:@"点击进入" forState:(UIControlStateNormal)];
            //                btn.frame = CGRectMake(WIDHT * i, HEIGHT - 60, 100, 40);
            //                btn.center = CGPointMake(WIDHT/2, HEIGHT - 60);
            //                [btn setBackgroundColor:[UIColor lightGrayColor]];
            //                [btn addTarget:self action:@selector(clickLastBtn) forControlEvents:(UIControlEventTouchUpInside)];
            //                btn;
            //            })];
            //        }
        }
        [scrollView addSubview:btn];
    }
}
- (void)tapBtn
{
    if (self.clickLastPage) {
        self.clickLastPage();
    }
}


#pragma mark - scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    self.pageControl.currentPage = page;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

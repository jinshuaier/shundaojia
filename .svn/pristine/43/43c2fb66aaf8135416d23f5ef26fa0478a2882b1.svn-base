//
//  TCHomeMenuCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/10/10.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//
#define TAG 1000 //tag值

#import "TCHomeMenuCell.h"
#import "TCMenuBtnView.h"

#import "UIMarqueeBarView.h"
#import "AutoScrollLabel.h"

@interface TCHomeMenuCell()<UIScrollViewDelegate>
{
    UIView *_backView;
    UIView *_BtnView;
    
   // UIPageControl *_pageControl;
}
@property (nonatomic, strong) UIView *baView;

@end

@implementation TCHomeMenuCell

+(instancetype)cellWithTableView:(UITableView *)tableView menuArray:(NSMutableArray *)menuArray {
    static NSString *cellID = @"tangshuoqweqwqeqeqe";
    TCHomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil) {
        cell = [[TCHomeMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID menuArray:menuArray];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSArray *)menuArray{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 130)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backView];

        //btn集合
        _BtnView = [[UIView alloc] init];
        _BtnView.frame = CGRectMake(0,0, WIDTH, 104);
        [_backView addSubview:_BtnView];
        
       
        
        //
        for(int i = 0; i < 4; i++) {
            if(i < 4) {
                
                NSArray *imageArr = @[@"超市图标",@"鲜花图标",@"水站图标",@"全部图标"];
                NSArray *titleArr = @[@"超市",@"鲜花",@"水站",@"全部"];
                CGRect frame = CGRectMake(i*WIDTH/4, 0, WIDTH/4, 98);
                NSString *title = titleArr[i];
                NSString *imagestr = imageArr[i];
                TCMenuBtnView *btnView = [[TCMenuBtnView alloc]initWithFrame:frame title:title imagestr:imagestr];
                btnView.tag = TAG + i;
                [_BtnView addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
                [btnView addGestureRecognizer:tap];
                
            } else if (i < 8) {
                
                CGRect frame = CGRectMake((i-4)*WIDTH/4, 104, WIDTH/4, 98);
                NSString *title = [menuArray[i] objectForKey:@"title"];
                NSString *imagestr = [menuArray[i] objectForKey:@"image"];
                TCMenuBtnView *btnView = [[TCMenuBtnView alloc]initWithFrame:frame title:title imagestr:imagestr];
                btnView.tag = TAG + i;
                [_BtnView addSubview:btnView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
                [btnView addGestureRecognizer:tap];
            }
        }
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_BtnView.frame), WIDTH, 32)];
        backView.backgroundColor = TCBgColor;
        self.baView = backView;
        [_backView addSubview:backView];
        self.paoma = [[LMJScrollTextView alloc] initWithFrame:CGRectMake(40,0, WIDTH - 80, 32) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
        self.paoma.backgroundColor = TCUIColorFromRGB(0xFFF9ED);
//        [backView addSubview:self.paoma];
        
        //图片
        self.paomaImage = [[UIImageView alloc] init];
        self.paomaImage.frame = CGRectMake(16, 8, 17, 16);
        self.paomaImage.image = [UIImage imageNamed:@"首页消息icon"];
//        [backView addSubview:self.paomaImage];
        
        //跑马灯
        [self.paoma startScrollWithText:@"<<<向左连续滚动字符串|向左连续滚动字符串|向左连续滚动字符串" textColor:TCUIColorFromRGB(0x666666) font:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
        UIButton *deleBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.paoma.frame) + 8, 8, 16, 16)];
        [deleBtn setBackgroundImage:[UIImage imageNamed:@"关闭消息按钮"] forState:(UIControlStateNormal)];
        [deleBtn addTarget:self action:@selector(clickdele:) forControlEvents:(UIControlEventTouchUpInside)];
      //  [backView addSubview:deleBtn];
        
//        self.garyView = [[UIView alloc] init];
//        self.garyView.backgroundColor = [UIColor redColor];
//        self.garyView.frame = CGRectMake(0, CGRectGetMaxY(_backView.frame), WIDTH, 1);
//        if (self.baView.hidden == YES) {
//            self.garyView.frame = CGRectMake(0, CGRectGetMaxY(_BtnView.frame), WIDTH, 1);
//        }
//        [self addSubview:self.garyView];
       
        
//        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.qh_width/2-10, 160, 0, 20)];
//        _pageControl.currentPage = 0;
//        _pageControl.numberOfPages = 2;
//        //        self.backgroundColor = [UIColor redColor];
//        [self addSubview:_pageControl];
//      //  [_pageControl setCurrentPageIndicatorTintColor:navigationBarColor];
//        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        
    }
    return self;
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat scrollViewW = scrollView.frame.size.width;
//    CGFloat x = scrollView.contentOffset.x;
   // int page = (x + scrollViewW/2)/scrollViewW;
   // _pageControl.currentPage = page;
}

-(void)clickdele:(UIButton *)sender{
    self.baView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(upDate)]) {
        [self.delegate  upDate];
    }
}

-(void)Clicktap:(UITapGestureRecognizer *)sender{
    
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSInteger index = singleTap.view.tag;
    
    //如果myButtonWillTap被实现啦，此时我们就实现myButtonWillTapf方法
    if ([self.delegate respondsToSelector:@selector(sendValue:)]) {
        [self.delegate  sendValue:index];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

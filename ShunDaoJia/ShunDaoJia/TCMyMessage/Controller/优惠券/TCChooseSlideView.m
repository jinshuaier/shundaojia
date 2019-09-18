//
//  TCChooseSlideView.h
//
//  Created by Macx on 17/11/29.
//  Copyright © 2017年 北京同创共享网络科技有限公司. All rights reserved.
//

#import "TCChooseSlideView.h"

@implementation TCChooseSlideView
-(void)setNameWithArray:(NSArray *)chooseSliderArray{
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    _chooseSliderArray = chooseSliderArray;
    
    //间隔
    CGFloat SPACE = (self.frame.size.width)/[_chooseSliderArray count];
    for(int i = 0;i<[chooseSliderArray count];i++){

        UIButton *sliderBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        sliderBtn.frame = CGRectMake(SPACE*i, 0, SPACE, self.frame.size.height);
        [sliderBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:UIControlStateNormal];
        sliderBtn.tag = i;
        if (sliderBtn.tag == 0) {
            //设置默认被选中按钮
            sliderBtn.selected = YES;
            [sliderBtn setTitleColor:TCUIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        }
        [sliderBtn setTitle:chooseSliderArray[i] forState:(UIControlStateNormal)];
        //按钮在正常状态下为灰色
//        [sliderBtn setTitleColor:TCUIColorFromRGB(0x4C4C4C) forState:(UIControlStateNormal)];
        sliderBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        //按钮的点击事件
        [sliderBtn addTarget:self action:@selector(sliderBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:sliderBtn];
    }
    
    //标识当被选中的下划线
    UIView *selectedLine = [[UIView alloc]initWithFrame:CGRectMake((WIDTH/2 - 20)/2, self.frame.size.height-4, 20, 4)];
    selectedLine.tag = 1000;
    selectedLine.backgroundColor = TCUIColorFromRGB(0xF99E20);
    [self addSubview:selectedLine];
}
#pragma mark -- 滑动按钮的点击事件
-(void)sliderBtn:(UIButton *)sender{
    for(UIView *subView in self.subviews){
        if([subView isKindOfClass:[UIButton class]]){
            UIButton *subBtn = (UIButton *)subView;
            if(subBtn.tag == sender.tag){
                subBtn.selected = YES;
                [subBtn setTitleColor:TCUIColorFromRGB(0x333333) forState:UIControlStateNormal];
            }else{
                subBtn.selected = NO;
                [subBtn setTitleColor:TCUIColorFromRGB(0x666666) forState:UIControlStateNormal];
            }
        }
    }
    //计算每个按钮的间隔
    CGFloat SPACE = (self.frame.size.width)/[_chooseSliderArray count];
    UIView *selectedView = [self viewWithTag:1000];
    [UIView animateWithDuration:0.2f animations:^{
        CGRect selectedFrame = selectedView.frame;
        selectedFrame.origin.x = sender.tag *SPACE + (WIDTH/2 - 32)/2;
        selectedView.frame = selectedFrame;
    }];
    if([self.sliderDelegate respondsToSelector:@selector(_getTag:)]){
        [self.sliderDelegate _getTag:sender.tag];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



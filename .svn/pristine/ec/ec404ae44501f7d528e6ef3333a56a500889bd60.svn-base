//
//  TCChooseSlideView.h
//
//  Created by Macx on 17/11/29.
//  Copyright © 2017年 北京同创共享网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCChooseSlideProtocol <NSObject>

@required
-(void)_getTag:(NSInteger)tag;

@end
@interface TCChooseSlideView : UIView
{
//获得当前的组名
NSArray *_chooseSliderArray;
}
//设置滑动名的方法
-(void)setNameWithArray:(NSArray *)chooseSliderArray;
//协议代理
@property(nonatomic,assign)id<TCChooseSlideProtocol>sliderDelegate;
@end

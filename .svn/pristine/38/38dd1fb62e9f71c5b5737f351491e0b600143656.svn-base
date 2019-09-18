//
//  TCShareView.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/6.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

static TCShareView *shareview = nil;

@interface TCShareView ()
@property (nonatomic, strong) NSDictionary *mes;
@end

@implementation TCShareView


+(id)ShowTheViewOfShareAndShowMes:(NSDictionary *)Mes andShareSuccess:(ShareSuccess)success andShareFailure:(ShareFailure)failure andShareCancel:(ShareCancel)cancel{
    if (shareview == nil) {
        shareview = [[TCShareView alloc]initWithMes:Mes];
    }
    return shareview;
}
-(id)initWithMes:(NSDictionary *)mes{
    if (self = [super init]) {
        [self creat:mes];
    }
    return self;
}

-(void)creat:(NSDictionary *)mes{
    
    _mes = mes;
    //灰色背景
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [TCUIColorFromRGB(0x000000) colorWithAlphaComponent:0.6];
    self.backView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview: self.backView];
    //加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.backView addGestureRecognizer:tap];
    
    //底部的View
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - (48 + 116), WIDTH, 48 + 116)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview: self.bottomView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.bottomView.frame.size.height - 48, WIDTH, 48)];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:TCUIColorFromRGB(0x999999) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [btn addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview: btn];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bottomView.frame.size.height - btn.frame.size.height, WIDTH, 1)];
    lineLabel.backgroundColor = TCLineColor;
    [self.bottomView addSubview: lineLabel];
    
    [self shareScrollView];
    
    //执行过度动画
    self.bottomView.transform = CGAffineTransformTranslate(self.bottomView.transform, 0, 48 + 116);
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
    }];
}

//分享scrollview
- (void)shareScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.bottomView.frame.size.height - 48)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.bottomView addSubview: _scrollView];
    NSArray *titlearr = @[@"微信", @"朋友圈", @"QQ", @"QQ空间", @"微博"];
    NSArray *imArr = @[@"微信图标", @"微信朋友圈图标",@"QQ图标", @"QQ空间图标",@"微博"];
    for (int i = 0; i < titlearr.count; i++) {
        UIView *vie = [[UIView alloc]initWithFrame:CGRectMake((WIDTH / titlearr.count + 1) * i, 0 , WIDTH / titlearr.count, _scrollView.frame.size.height)];
        vie.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taps:)];
        [vie addGestureRecognizer:tap];
        [_scrollView addSubview: vie];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(vie.frame.size.width / 2 - (vie.frame.size.width - 24) / 2, 24 , vie.frame.size.width - 24 , vie.frame.size.width - 24)];
        imageview.layer.cornerRadius  = (vie.frame.size.width - 24) / 2.0;
        imageview.layer.masksToBounds = YES;
        imageview.image = [UIImage imageNamed:imArr[i]];
        [vie addSubview: imageview];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageview.frame) + 8, vie.frame.size.width, 16)];
        lb.text = [NSString stringWithFormat:@"%@",  titlearr[i]];
        lb.textColor = TCUIColorFromRGB(0x666666);
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [vie addSubview: lb];
    }
    _scrollView.contentSize = CGSizeMake(WIDTH, self.bottomView.frame.size.height - 48 - 1);
}

#pragma mark -- 取消按钮的点击事件
- (void)miss {
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.transform = CGAffineTransformTranslate(self.bottomView.transform, 0, 48 + 116);
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        _backView = nil;
        [self removeFromSuperview];
        [TCProgressHUD dismiss];
        shareview = nil;
    }];
}

#pragma mark -- 手势点击事件
- (void)tap
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.transform = CGAffineTransformTranslate(self.bottomView.transform, 0, 48 + 116);
    } completion:^(BOOL finished) {
       [_backView removeFromSuperview];
        _backView = nil;
         [self removeFromSuperview];
        shareview = nil;
    }];
}

//点击的分享
- (void)taps:(UITapGestureRecognizer *)tap{
    NSLog(@"点击了%ld", tap.view.tag);
    if (tap.view.tag == 0) {//微信分享
        [self ShareBackView:SSDKPlatformSubTypeWechatSession];
    }else if (tap.view.tag == 1){//微信朋友圈
        [self ShareBackView:SSDKPlatformSubTypeWechatTimeline];
    }else if (tap.view.tag == 2){//qq
        [self ShareBackView:SSDKPlatformSubTypeQQFriend];
    }else if (tap.view.tag == 3){//qq空间
        [self ShareBackView:SSDKPlatformSubTypeQZone];
    }else if (tap.view.tag == 4){//新浪微博
        [self ShareBackView:SSDKPlatformTypeSinaWeibo];
    }
}

- (void)ShareBackView:(SSDKPlatformType)type{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    /* 打开客户端 */
    [shareParams SSDKEnableUseClientShare];
    NSString *urls = [NSString stringWithFormat:@"%@", _mes[@"url"]];
//    NSString * urlStr = [urls stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url1 = [NSURL URLWithString:urls];
    
    [shareParams SSDKSetupShareParamsByText:_mes[@"content"]
                                     images:_mes[@"pic"]
                                        url:url1
                                      title:_mes[@"title"]
                                       type:SSDKContentTypeAuto];
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateBegin:{
                break;
            }
            case SSDKResponseStateSuccess:{
                [TCProgressHUD showMessage:@"分享成功"];
                [self miss];
                break;
            }
            case SSDKResponseStateFail:{
//                [TCProgressHUD showMessage:@"分享失败"];
                [self miss];

                break;
            }
            case SSDKResponseStateCancel:{
//                [TCProgressHUD showMessage:@"分享失败"];
                [self miss];

                break;
            }
            default:
                break;
        }
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

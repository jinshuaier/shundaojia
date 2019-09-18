//
//  TCProgressHUD.m
//  顺道嘉商家版
//
//  Created by 胡高广 on 2017/5/24.
//  Copyright © 2017年 北京同创共享网络科技有限公司. All rights reserved.
//

#import "TCProgressHUD.h"
#define KPLabelMaxW 240.0f
#define KPLabelMaxH 300.0f
#define KDefaultDuration 2.0f
#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height

@interface TCProgressHUD ()

@property (nonatomic, strong) UIWindow *pWindow;
@property (nonatomic, weak) UILabel *pLabel;
@property (nonatomic, weak) UIImageView *pImageView;
@property (nonatomic, weak) UIView *backView;

@end
@implementation TCProgressHUD
static TCProgressHUD * Hud = nil;

+ (TCProgressHUD *)sharedView
{
    static TCProgressHUD *sharedView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedView = [[TCProgressHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    
    return sharedView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

+ (void)show
{
    [[TCProgressHUD sharedView] showWithMessage:nil duration:KDefaultDuration pushing:NO];
}

+ (void)showWhilePushing
{
    [[TCProgressHUD sharedView] showWithMessage:nil duration:KDefaultDuration pushing:YES];
}

+ (void)showWhilePushing:(BOOL)pushing
{
    [[TCProgressHUD sharedView] showWithMessage:nil duration:KDefaultDuration pushing:pushing];
}

+ (void)showMessage:(NSString *)message
{
    [[TCProgressHUD sharedView] showWithMessage:message duration:KDefaultDuration pushing:nil];
}

+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    [[TCProgressHUD sharedView] showWithMessage:message duration:duration pushing:nil];
}

+ (void)dismiss
{
    [[TCProgressHUD sharedView] dismiss];
}

- (void)showWithMessage:(NSString *)message duration:(NSTimeInterval)duration pushing:(BOOL)pushing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.superview) [self.pWindow addSubview:self];
        [self.pWindow makeKeyAndVisible];
        if (message) {
            if (_pImageView) {
                _pImageView.hidden = YES;
                [self stopLoadingAnimation];
            }
            
            self.pLabel.text = message;
            CGSize stringSize = [message boundingRectWithSize:CGSizeMake(KPLabelMaxW, KPLabelMaxH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_pLabel.font} context:nil].size;
            
            _pLabel.frame = CGRectMake(24, 24, stringSize.width, stringSize.height);
            _backView.frame = CGRectMake((KMainW - stringSize.width) * 0.5 - 24, (KMainH - stringSize.height) * 0.5 - 32, stringSize.width + 48, stringSize.height + 48);
            
            [UIView animateWithDuration:0.2f animations:^{
                _backView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((duration - 0.4) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.2f animations:^{
                        _backView.alpha = 0.0f;
                    } completion:^(BOOL finished) {
                        [self dismiss];
                    }];
                });
            }];
            
        }else {
            self.pImageView.hidden = NO;
            
            CGFloat imgViewW = pushing ? 200 : 60;
            _pImageView.backgroundColor = pushing ? [UIColor clearColor] : [[UIColor blackColor] colorWithAlphaComponent:0.7f];
            _pImageView.frame = CGRectMake((KMainW - imgViewW) * 0.5, (KMainH - imgViewW) * 0.5, imgViewW, imgViewW);
            
            if (pushing) {
                [self startPushingLoadingAnimation];
            }else {
                [self startLoadingAnimation];
            }
        }
    });
}

//转圈加载动画
- (void)startLoadingAnimation
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 8; i++) {
        NSString *imageName = [NSString stringWithFormat:@"com_loading%02d", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        [array addObject:image];
    }
    
    [_pImageView setAnimationImages:array];
    [_pImageView setAnimationDuration:0.6f];
    [_pImageView startAnimating];
}

//空页面加载动画
- (void)startPushingLoadingAnimation
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_img%02d.jpg", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        [array addObject:image];
    }
    
    [_pImageView setAnimationImages:array];
    [_pImageView setAnimationDuration:0.4f];
    [_pImageView startAnimating];
}

- (void)stopLoadingAnimation
{
    [_pImageView stopAnimating];
    [_pImageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:0];
}

- (void)dismiss
{
    [self stopLoadingAnimation];
    
    NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
    [windows removeObject:_pWindow];
    _pWindow = nil;
}

- (UIWindow *)pWindow
{
    if (!_pWindow) {
        _pWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    return _pWindow;
}

- (UILabel *)pLabel
{
    if (!_pLabel) {
        UILabel *pLabel = [[UILabel alloc] init];
        pLabel.textColor = [UIColor whiteColor];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textAlignment = NSTextAlignmentLeft;
        pLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        pLabel.numberOfLines = 0;
        [self.backView addSubview:pLabel];
        _pLabel = pLabel;
    }
    
    return _pLabel;
}

- (UIView *)backView
{
    if (!_backView) {
        UIView *backView = [[UIView alloc] init];
        backView.alpha = 0.f;
        backView.backgroundColor = [TCUIColorFromRGB(0x000000) colorWithAlphaComponent:0.7f];
        backView.layer.cornerRadius = 8;
        backView.layer.masksToBounds = YES;
        [self addSubview:backView];
        _backView = backView;
    }
    
    return _backView;
}

- (UIImageView *)pImageView
{
    if (!_pImageView) {
        UIImageView *pImageView = [[UIImageView alloc] init];
        pImageView.hidden = YES;
        pImageView.layer.cornerRadius = 3.f;
        pImageView.layer.masksToBounds = YES;
        [self addSubview:pImageView];
        _pImageView = pImageView;
    }
    
    return _pImageView;
}

//收藏
+(void)showWithImage:(UIImage *)image Text:(NSString *)text WithDurations:(CGFloat)duration
{
    //添加背景
    TCProgressHUD * custom = [[TCProgressHUD alloc]init];
    custom.frame = CGRectMake((WIDTH - 144)/2, (HEIGHT - 110)/2, 144, 110);
    custom.backgroundColor = [TCUIColorFromRGB(0x000000) colorWithAlphaComponent:0.8];
    custom.layer.cornerRadius = 8;
    custom.layer.masksToBounds = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:custom];
    
    UIImageView *images = [[UIImageView alloc] init];
    images.image = image;
    images.frame = CGRectMake(61 , 24, 22, 22);
    [custom addSubview:images];
    
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, CGRectGetMaxY(images.frame) + 24,144, 16);
    label.text = text;
    [label setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = TCUIColorFromRGB(0xFFFFFF);
    [custom addSubview:label];
    //视图消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [custom removeFromSuperview];

        [UIView animateWithDuration:0.3 animations:^{

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                custom.transform = CGAffineTransformScale(custom.transform, 1.05, 1.05);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    custom.transform = CGAffineTransformScale(custom.transform, 0.01, 0.01);
                } completion:^(BOOL finished) {
                    custom.alpha= 0;

                }];
            }];
        }];
    });

    
    
}

@end
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


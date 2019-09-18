//
//  TCLocation.m
//  顺道嘉(新)
//
//  Created by 某某 on 16/9/24.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "TCLocation.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "TCShowView.h"

static TCLocation *location = nil;
@interface TCLocation ()<AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) NSUserDefaults *userdefaults;
@end

@implementation TCLocation

- (id)init{
    if (self = [super init]) {
        _userdefaults = [NSUserDefaults standardUserDefaults];
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            //不允许定位
            [TCShowView showView:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } andfailure:^{
                nil;
            }];
        }else{
            //自动定位
            _locationManager = [[AMapLocationManager alloc]init];
            _locationManager.delegate = self;
            
            if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                
                //当应用在使用时可以使用定位服务(仅限于应用在前台使用时授权,一旦程  序到后台就停止定位)
                
                NSLog(@"哈哈哈");
            }
           
            [self zidong];
        }
    }
    return self;
}

- (void)getadds:(addBlock)blocks andMayBeError:(errorBlock)errorblock{
    self.addblock = blocks;
    self.errorblock = errorblock;
}

//自动定位
- (void)zidong{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"round" object:nil];
    //一次定位 精度10米
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //定位超时
    _locationManager.locationTimeout = 2;
    //逆地理超时
    _locationManager.reGeocodeTimeout = 12;
    //得到数据
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
                [TCProgressHUD showMessage:@"定位失败，请检查网络!"];
            }
            _errorblock();//失败block
            if (error.code == AMapLocationErrorLocateFailed) {
                return ;
            }
        }
        NSLog(@"location:  lat%f  lon%f", location.coordinate.latitude, location.coordinate.longitude);
        if (regeocode){
            NSLog(@"reGeocode:%@   \n位置%@", regeocode, regeocode.formattedAddress);
            //持久化定位地点
            [_userdefaults setValue:regeocode.formattedAddress forKey:@"currentAdd"];
            //持久化城市  先判断是否存在城市city  不存在则选择直辖市province（省）
            if (regeocode.city == nil) {
                if (![regeocode.province isKindOfClass:[NSNull class]]) {
                    [_userdefaults setValue:regeocode.province forKey:@"currentCity"];
                }
            }else{
                if (regeocode.city != nil) {
                    [_userdefaults setValue:regeocode.city forKey:@"currentCity"];
                }
            }
            
            //持久化经纬度
            NSString *lat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
            NSString *lon = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
            [_userdefaults setValue:lat forKey:@"latitude"];
            [_userdefaults setValue:lon forKey:@"longitude"];
            //持久化区域
            if (regeocode.neighborhood != nil) {
                [_userdefaults setValue:regeocode.neighborhood forKey:@"currentNei"];
                //将当前地址传回首页
                _addblock(regeocode.neighborhood);
            }else{
                [_userdefaults setValue:regeocode.formattedAddress forKey:@"currentNei"];
                //将当前地址传回首页
                _addblock(regeocode.formattedAddress);
            }
            
            if (self.ishomePage == NO) {
                //让刷新图标停止转动  同时可以作为定位成功的通知 要求首页刷新数据
                [[NSNotificationCenter defaultCenter]postNotificationName:@"stop" object:nil userInfo:@{@"key":@"1"}];
            } else {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"stop" object:nil userInfo:@{@"key":@"0"}];
            }
        }

    }];
}

@end

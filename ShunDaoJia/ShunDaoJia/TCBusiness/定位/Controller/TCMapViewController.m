 //
//  TCMapViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/11/30.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCMapViewController.h"
#import "TCSearchMapViewController.h"
#import "TCLocation.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "TCNearAddInfo.h"


@interface TCMapViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,UITextFieldDelegate>
{
    BOOL isFirstLocated;//第一次定位标记
}
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton; //自定义大头针
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAUserLocation *userLocation;
@property (nonatomic, strong) TCLocation *location;
@property (nonatomic, strong) UILabel *labelLocation; //位置
@property (nonatomic, strong) UITextField *disField; //详细位置
@property (nonatomic, strong) NSString *disStr;
@property (nonatomic, strong) TCNearAddInfo *model;
@property (strong, nonatomic) AMapSearchAPI *searchAPI;//搜索API
@property (nonatomic, strong) AMapPOI *selectedPoi;
@property (nonatomic, strong) NSString *latStr;
@property (nonatomic, strong) NSString *longStr;


@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TCMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地址";
    self.view.backgroundColor = TCBgColor;
    self.dataArray = [NSMutableArray array];
    isFirstLocated = YES;
    //创建搜索按钮
    [self setUpSearchView];
    //初始化地图
    [self initMapView];
    [self initCenterMarker];
    [self initSearch];
}

- (void)setUpSearchView {
    //新增地址
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"首页搜索图标"] forState:(UIControlStateNormal)];
    rightBtn.frame = CGRectMake(WIDTH - 12 - 24, 10 + StatusBarHeight, 24, 24);
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)initCenterMarker {
    //自定义的大头针
    UIImageView *pointImage = [[UIImageView alloc] init];
    pointImage.frame = CGRectMake((WIDTH - 15)/2, (self.view.frame.size.height - 24)/2, 15, 24);
    pointImage.image = [UIImage imageNamed:@"地图上搜索的位置图标"];
    [self.view addSubview:pointImage];
}

//创建地图
- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        self.mapView.delegate = self;
        self.mapView.zoomLevel = 16;
        self.mapView.showsCompass = NO; // 是否显示指南针
        self.mapView.showsScale = NO; // 是否显示比例尺
        self.mapView.showsUserLocation = YES;// 是否显示用户位置
        //范围圈自定义
        self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
        //去掉logo的图标
        [self deleLogo];
        //添加地图的信息
        [self createView];
        //初始化大头针
        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
        [_mapView addAnnotation:self.pointAnnotaiton];
        [self.view addSubview:self.mapView];
    }
}

- (void)initSearch {
    self.searchAPI = [[AMapSearchAPI alloc] init];
    self.searchAPI.delegate = self;
}

#pragma mark - MAMapViewDelegate
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    //首次定位
    if (updatingLocation && isFirstLocated == YES) {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        [self startSearch]; //开始搜索
        isFirstLocated = NO;
    }
}

// 搜索逆向地理编码-AMapGeoPoint
- (void)searchReGeocodeWithAMapGeoPoint:(AMapGeoPoint *)location{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = location;
    // 返回扩展信息
    regeo.requireExtension = YES;
    [self.searchAPI AMapReGoecodeSearch:regeo];
}
//搜索中心点坐标周围的POI-AMapGeoPoint
- (void)searchPoiByAMapGeoPoint:(AMapGeoPoint *)location{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = location;
    // 搜索半径
    request.radius = 1000;
    // 搜索结果排序
    request.sortrule = 1;
    
    [self.searchAPI AMapPOIAroundSearch:request];
}

//地图移动
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (isFirstLocated == NO) {
        [self startSearch];
    }
}

- (void)startSearch {
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
    [self searchReGeocodeWithAMapGeoPoint:point];
    [self searchPoiByAMapGeoPoint:point];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        // 去掉逆地理编码结果的省份和城市
        NSString *address = response.regeocode.formattedAddress;
        AMapAddressComponent *component = response.regeocode.addressComponent;
        address = [address stringByReplacingOccurrencesOfString:component.province withString:@""];
        address = [address stringByReplacingOccurrencesOfString:component.city withString:@""];
        // 将逆地理编码结果保存到数组第一个位置，并作为选中的POI点
        _selectedPoi = [[AMapPOI alloc] init];
        _selectedPoi.name = response.regeocode.addressComponent.streetNumber.street;
        _selectedPoi.address = response.regeocode.formattedAddress;
        _selectedPoi.location = request.location;
        [self.dataArray setObject:_selectedPoi atIndexedSubscript:0];
        NSLog(@"_selectedPoi.name:%@",_selectedPoi.name);
        
        self.disField.text = address;
        NSLog(@"_selectedPoi.name--:%@",address);
        self.longStr = [NSString stringWithFormat:@"%f", _selectedPoi.location.longitude];
        self.latStr = [NSString stringWithFormat:@"%f",_selectedPoi.location.latitude];
        self.labelLocation.text = component.city;
    }
}

//POI搜索回调的方法
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    //保留数组中的第一位数据
    if (self.dataArray.count > 1) {
        [self.dataArray removeObjectsInRange:NSMakeRange(1, self.dataArray.count-1)];
    }
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj.name);
        [self.dataArray addObject:obj];
    }];
}
//添加地图的信息View
- (void)createView {
    
    //确定的按钮
    UIButton *okBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    okBtn.frame = CGRectMake(12, HEIGHT - 12 - 48 - TabbarSafeBottomMargin, WIDTH - 24, 48);
    okBtn.backgroundColor = TCUIColorFromRGB(0xF99E20);
    [okBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = 4;
    [okBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    okBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    [okBtn addTarget:self action:@selector(ok:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mapView addSubview:okBtn];
    
    //添加View
    UIView *locationView = [[UIView alloc] init];
    locationView.frame = CGRectMake(12, okBtn.frame.origin.y - 12 - 52 - 50, WIDTH - 24, 52 + 50);
    locationView.backgroundColor = [UIColor whiteColor];
    locationView.layer.masksToBounds = YES;
    locationView.layer.cornerRadius = 4;
    [self.mapView addSubview:locationView];
    
    //小View
    UIView *dingweiView = [[UIView alloc] init];
    dingweiView.frame = CGRectMake(0, 0, WIDTH - 24, 52);
    [locationView addSubview:dingweiView];
    
    //添加图标、文字、图片、输入框
    UIImageView *imageLocation = [[UIImageView alloc] init];
    imageLocation.image = [UIImage imageNamed:@"位置图标(面)"];
    imageLocation.frame = CGRectMake(12, 17, 15, 18);
    [dingweiView addSubview:imageLocation];
    
    self.labelLocation = [[UILabel alloc] init];
    self.labelLocation.frame = CGRectMake(CGRectGetMaxX(imageLocation.frame) + 8, 0, WIDTH - 24 - 12 - 12 - CGRectGetMaxX(imageLocation.frame) - 13, 52);
    self.labelLocation.text = @"";
    self.labelLocation.textAlignment = NSTextAlignmentLeft;
    self.labelLocation.textColor = TCUIColorFromRGB(0x333333);
    self.labelLocation.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    [dingweiView addSubview:self.labelLocation];
    
    UIImageView *intImage = [[UIImageView alloc] init];
    intImage.image = [UIImage imageNamed:@"进入小三角（灰）"];
    intImage.frame = CGRectMake(WIDTH - 24 - 12 - 6, (52 - 6)/2, 6, 8);
    [dingweiView addSubview:intImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [dingweiView addGestureRecognizer:tap];
    
    //细线
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, CGRectGetMaxY(dingweiView.frame), WIDTH - 24, 1);
    lineView.backgroundColor = TCLineColor;
    [dingweiView addSubview:lineView];
    
    //详细的地址
    self.disField = [[UITextField alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(lineView.frame), WIDTH - 12 - 12 - 24, 50)];
    self.disField.textAlignment = NSTextAlignmentLeft;
    [self.disField setEnabled:NO];
    self.disField.delegate = self;
    self.disField.borderStyle = UITextBorderStyleNone;
    self.disField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.disField.textColor = TCUIColorFromRGB(0x666666);
    [locationView addSubview:self.disField];
    
    UIButton *locationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    locationBtn.frame = CGRectMake(WIDTH - 12 - 36, locationView.frame.origin.y - 16 - 36, 36, 36);
    [locationBtn setImage:[UIImage imageNamed:@"定位（地图）"] forState:(UIControlStateNormal)];
    [locationBtn addTarget:self action:@selector(locationBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mapView addSubview:locationBtn];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout   = NO;
        annotationView.animatesDrop     = NO;
        annotationView.draggable        = NO;
        annotationView.image            = [UIImage imageNamed:@"地图上搜索的位置图标"];
        return annotationView;
    }
    
    return nil;
}

//去掉高德logo图标
- (void)deleLogo
{
    [self.mapView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            
            UIImageView * logoM = obj;
            
            logoM.layer.contents = (__bridge id)[UIImage imageNamed:@""].CGImage;
        }
    }];
}

//范围圈的回调函数
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    
    if(overlay == mapView.userLocationAccuracyCircle)
        {
            MACircle *accuracyCircleView = (MACircle *)overlay  ;
            MACircleRenderer *circleRend = [[MACircleRenderer alloc] initWithCircle:accuracyCircleView];
            circleRend.alpha = 0.3;
            //  填充颜色
            circleRend.fillColor = [TCUIColorFromRGB(0xFF4C79) colorWithAlphaComponent:0.2];
            //  边框颜色
            circleRend.strokeColor = TCUIColorFromRGB(0xFF4C79);
            return circleRend;
    }
    return nil;
}

#pragma mark -- 手势点击事件
- (void)tap
{
    NSLog(@"地图商圈");
    TCSearchMapViewController *searchMapVC = [[TCSearchMapViewController alloc] init];
    searchMapVC.adressArr = self.dataArray;
    searchMapVC.addressBlock = ^(AMapPOI *model) {
        self.labelLocation.text = model.address;
        self.disField.text = model.name;
        self.latStr = [NSString stringWithFormat:@"%f", model.location.latitude];
        self.longStr = [NSString stringWithFormat:@"%f", model.location.longitude];
    };
    searchMapVC.addressNearAddInfoBlock = ^(TCNearAddInfo *model) {
        self.labelLocation.text = model.address;
        self.disField.text = model.name;
        self.latStr = model.latitude;
        self.longStr = model.longitude;
    };
    [self.navigationController pushViewController:searchMapVC animated:YES];
}
#pragma mark -- 确定的按钮
- (void)ok:(UIButton *)sender
{
    NSLog(@"确定的按钮");
    NSString *address = [NSString stringWithFormat:@"%@%@",self.labelLocation.text,self.disField.text];
    if (self.labelLocation.text.length == 0 || self.disField.text.length == 0) {
        [TCProgressHUD showMessage:@"地址选择中..."];
    } else {
        self.diBlock(address, self.latStr, self.longStr);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 搜索
- (void)clickRightBtn
{
    NSLog(@"搜索");
    TCSearchMapViewController *searchMapVC = [[TCSearchMapViewController alloc] init];
    searchMapVC.adressArr = self.dataArray;
    [self.navigationController pushViewController:searchMapVC animated:YES];
}
#pragma mark -- 重新定位按钮的点击事件
- (void)locationBtn:(UIButton *)sender
{
    [self.mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.disField resignFirstResponder];
    //结束编辑时整个试图返回原位
    [self.disField resignFirstResponder];
    [UIView beginAnimations:@"down" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT );
    [UIView commitAnimations];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //开始编辑时使整个视图整体向上移
    [UIView beginAnimations:@"up" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.view.frame = CGRectMake(0, -300, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
    return YES;
}
#pragma mark -- 点击return 下滑
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    //结束编辑时整个试图返回原位
    [textField resignFirstResponder];
    [UIView beginAnimations:@"down" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.view.frame = CGRectMake(0, StatusBarAndNavigationBarHeight, WIDTH, HEIGHT );
    [UIView commitAnimations];
    
    return YES;
}

@end

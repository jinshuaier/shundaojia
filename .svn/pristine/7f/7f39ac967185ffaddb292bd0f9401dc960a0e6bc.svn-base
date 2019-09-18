//
//  TCBussPlaceViewController.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/7.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCBussPlaceViewController.h"

@interface TCBussPlaceViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>
@property (nonatomic, strong) MAMapView *mapView; //地图
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton; //自定义大头针
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) MAUserLocation *userLocation;
@property (nonatomic, assign) float level;

@end

@implementation TCBussPlaceViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家位置";
    
    self.view.backgroundColor = TCBgColor;
    self.level = 16.1;
    //创建Map地图
    [self initMapView];
    // Do any additional setup after loading the view.
}
//创建地图
- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        self.mapView.delegate = self;
        CLLocationDegrees latitude = [self.latStr floatValue];
        CLLocationDegrees longitude = [self.longStr floatValue];
        
        //范围圈自定义
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude,longitude);
        
//        self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
//        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动，并将定位点设置成地图中心点。
        [_mapView setZoomLevel:self.level animated:YES];
        [self.view addSubview:self.mapView];
//
        //去掉logo的图标
        [self deleLogo];

        //添加地图的信息
        [self createView];
//
        //初始化大头针
        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
        self.pointAnnotaiton.coordinate = coordinate;
        [_mapView addAnnotation:self.pointAnnotaiton];
        
        //很重要
        [_mapView setRegion:MACoordinateRegionMakeWithDistance(coordinate, 100, 100)];
    }
}
//#pragma mark - MAMapViewDelegate
//-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
//{
//    NSLog(@"latitude : %f , longitude : %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//}
//添加地图的信息View
- (void)createView {
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(WIDTH - 12 - 105, HEIGHT - 40 - 36, 105, 36);
    view.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    view.layer.cornerRadius = 4;
    view.layer.masksToBounds = YES;
    [self.mapView addSubview:view];
    
    //放大的按钮
    UIButton *bigBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    bigBtn.frame = CGRectMake(0, 0, 105/2, 36);
    [bigBtn setImage:[UIImage imageNamed:@"放大(店铺位置)"] forState:(UIControlStateNormal)];
    [bigBtn addTarget:self action:@selector(bigBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:bigBtn];
    
    //竖线
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(CGRectGetMaxX(bigBtn.frame), 8, 1, 20);
    lineView.backgroundColor = TCUIColorFromRGB(0xDEDEDE);
    [view addSubview:lineView];
    
    //放小
    UIButton *smallBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    smallBtn.frame = CGRectMake(CGRectGetMaxX(lineView.frame), 0, 105/2, 36);
    [smallBtn setImage:[UIImage imageNamed:@"缩小"] forState:(UIControlStateNormal)];
    [smallBtn addTarget:self action:@selector(smallBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:smallBtn];
}

#pragma mark - MAMapView Delegate

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
        annotationView.canShowCallout   = YES;
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

#pragma mark -- 地图放大图标
- (void)bigBtn
{
    self.level += 1;
    NSLog(@"地图放大");
    [_mapView setZoomLevel:self.level animated:YES];
}
#pragma mark -- 地图放小的图标
- (void)smallBtn
{
    self.level -= 1;
    NSLog(@"地图放小");
    [_mapView setZoomLevel:self.level animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

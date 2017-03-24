//
//  TrackViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/22.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "TrackViewController.h"

@interface TrackViewController () <MAMapViewDelegate>

@end

@implementation TrackViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"追踪";
        UIImage *i = [UIImage imageNamed:@"Track_BarItem.png"];
        self.tabBarItem.image = i;
        
        self.navigationItem.title = @"追踪";
        
        // 导航栏左侧button为选择pigeon和其对应device
        UIButton *pickButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [pickButton addTarget:self action:@selector(selector) forControlEvents:UIControlEventTouchUpInside];
        [pickButton setImage:[UIImage imageNamed:@"Track_List.png"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:pickButton];
        
        // 导航栏右侧button为系统自带add button
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(selector)];
        self.navigationItem.rightBarButtonItem = bbi;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMapProperty];
    self.mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    
    
    // 需要实现<MAMapViewDelegate>协议中的回调方法
    CLLocationCoordinate2D commoPolylineCoords[2];
    //            commoPolylineCoord[0].latitude = lati0;
    //            commoPolylineCoord[0].longitude = longi0;
    //
    //            commoPolylineCoord[1].latitude = lati1;
    //            commoPolylineCoord[1].longitude = longi1;
    
    commoPolylineCoords[0].latitude = 31.317987; // 苏州
    commoPolylineCoords[0].longitude = 120.619907;
    
    commoPolylineCoords[1].latitude = 31.249162; // 上海
    commoPolylineCoords[1].longitude = 121.487899;
    
    // 构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commoPolylineCoords count:2];
    [_mapView addOverlay:commonPolyline];
    
    [self unixTimeStampTransferToDateString:1490183105];
    [self dataFromWeb];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupMapProperty
{
    // 初始化地图
    _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    // 设置指南针位置
//    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 65);
//    // 设置比例尺控件
//    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 70);
    // 设置地图缩放级别 [3-19]
//    [_mapView setZoomLevel:14.0 animated:YES];
    // 缩放手势开启
    _mapView.zoomEnabled = YES;
    // 拖动手势开启
    _mapView.scrollEnabled = YES;
    // 进入地图就显示定位小蓝点
    _mapView.showsUserLocation = YES;
    // 地图跟着位置移动
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];

}

# pragma mark - unix时间戳转换为时间字符串
// 输入unix时间戳对象，返回日期字符串对象
- (NSString *)unixTimeStampTransferToDateString:(NSTimeInterval)timeInterval
{
    // 设置日期显示格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    // 时间戳timeInterval转换成日期对象
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    // 日期对象返回日期字符串
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSLog(@"dateStr:%@",dateStr);
    return dateStr;
}

#pragma mark - 网络请求
- (void)dataFromWeb
{
    NSString *urlStr = @"http://b.hitgk.com:31567/users/query?id=2017002";
//    NSString *urlStr = @"http://b.hitgk.com:31567/users/query";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
//    //使用POST方法
//    req.HTTPMethod = @"POST";
//    //POST参数
//    NSString *param = @"2017002";
//    //POST请求参数的拼接
//    NSString *postParam = [NSString stringWithFormat:@"id=%@",param];
//    //进行格式转换
//    NSData *postData = [postParam dataUsingEncoding:NSUTF8StringEncoding];
//    //POST请求参数使用如下方法进行赋值
//    req.HTTPBody = postData;
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // delegate设置为nil，因为session对象并不需要实现委托方法
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"datastr:%@",dataStr);
//        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"解析jsonData:%@",jsonData);
        
        id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([obj isKindOfClass:[NSArray class]]) {
            NSDictionary *dataDic0 = [(NSArray *)obj objectAtIndex:0];
            NSString* lon0 = [(NSDictionary*)dataDic0 objectForKey:@"latitude"];
            NSString* lat0 = [(NSDictionary*)dataDic0 objectForKey:@"longitude"];
            double longi0 = [lon0 doubleValue];
            double lati0 = [lat0 doubleValue];
            NSLog(@"longi0:%f",longi0);
            NSLog(@"lati0:%f",lati0);

            NSDictionary *dataDic1 = [(NSArray *)obj objectAtIndex:1];
            NSString* lon1 = [(NSDictionary*)dataDic1 objectForKey:@"latitude"];
            NSString* lat1 = [(NSDictionary*)dataDic1 objectForKey:@"longitude"];
            double longi1 = [lon1 doubleValue];
            double lati1 = [lat1 doubleValue];
            NSLog(@"longi1:%f",longi1);
            NSLog(@"lati1:%f",lati1);
            
//            CLLocationCoordinate2D commoPolylineCoord[2];
////            commoPolylineCoord[0].latitude = lati0;
////            commoPolylineCoord[0].longitude = longi0;
////            
////            commoPolylineCoord[1].latitude = lati1;
////            commoPolylineCoord[1].longitude = longi1;
//            
//            commoPolylineCoord[0].latitude = 39.92;
//            commoPolylineCoord[0].longitude = 116.39;
//            
//            commoPolylineCoord[1].latitude = 27.69;
//            commoPolylineCoord[1].longitude = 106.93;
//            
//            // 构造折线对象
//            MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commoPolylineCoord count:2];
//            [_mapView addOverlay:commonPolyline];

        }
        

    }];
    [dataTask resume];
}


# pragma mark - <MAMapViewDelegate>
// 实现代理方法，得把自己设置成代理啊！self.mapView.delegate = self
// 回调函数，设置折线的样式
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc]initWithPolyline:overlay];
        
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:126/255.0 green:216/255.0 blue:64/255.0 alpha:0.8];
        polylineRenderer.lineJoin = kCGLineJoinRound;
        polylineRenderer.lineCap = kCGLineCapRound;
        
        return polylineRenderer;
    }
    return  nil;
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

//
//  TrackViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/22.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "TrackViewController.h"
#import "FFDropDownMenuView.h"
#import "addDeviceViewController.h"
#import "AddPigeonViewController.h"
#import "PickDevicePigeonViewController.h"
#import "PigeonDetailViewController.h"
#import "UIView+Toast.h"

/** 坐标转换需要用到的头文件 **/
#import <AMapFoundationKit/AMapFoundationKit.h>

#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height
#define JrouteColor [UIColor colorWithRed:242/255.0 green:108/255.0 blue:99/255.0 alpha:0.8]


@interface TrackViewController () <MAMapViewDelegate>

/** 右侧下拉菜单 **/
@property (nonatomic, strong) FFDropDownMenuView *dropdownMenu;

/** 存储起点，终点 **/
@property (nonatomic, strong) NSMutableArray *startAndEndAnnotation;
@property (nonatomic, strong) MAPointAnnotation *startAnnotaion;
@property (nonatomic, strong) MAPointAnnotation *endAnnotaion;

/** 显示手机定位btn **/
@property (nonatomic, weak) IBOutlet UIButton *phoneLocBtn;

/** 显示信鸽最后定位btn **/
@property (nonatomic, weak) IBOutlet UIButton *pigeonLastLocBtn;
@property (nonatomic, weak) IBOutlet UIButton *infoBtn;


@end

@implementation TrackViewController

NSString *pigeonName;
static NSString *devNum;

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
        [pickButton addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [pickButton setImage:[UIImage imageNamed:@"Track_List.png"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:pickButton];
        
        // 导航栏右侧button为系统自带add button
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showDropDownMenu)];
        self.navigationItem.rightBarButtonItem = bbi;
        // 定义子vc返回按键
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.backBarButtonItem = backItem;
        
        [self initShowPhoneLocationButton];
        [self initShowPigeonLastLocationBtn];
        [self initShowInformationBtn];
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initShowPhoneLocationButton
{
    UIButton *phoneLocBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneLocBtn.frame = CGRectMake(JScreenWidth - 50, 64+30 , 40, 40);
//    phoneLocBtn.backgroundColor = [UIColor colorWithRed:116/255.0 green:168/255.0 blue:42/255.0 alpha:1.0];
    [phoneLocBtn setImage:[UIImage imageNamed:@"Track_ShowLocBtn.png"] forState:UIControlStateNormal];
    [phoneLocBtn addTarget:self action:@selector(showPhoneLocation:) forControlEvents:UIControlEventTouchUpInside];
    self.phoneLocBtn = phoneLocBtn;
    [self.view addSubview:self.phoneLocBtn];

}

- (void)initShowPigeonLastLocationBtn
{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(CGRectGetMinX(self.phoneLocBtn.frame), CGRectGetMaxY(self.phoneLocBtn.frame)+10 , 40, 40);
//    Btn.frame = CGRectMake(10, JScreenHeight*5/6 , 40, 40);
//    Btn.backgroundColor = [UIColor colorWithRed:116/255.0 green:168/255.0 blue:42/255.0 alpha:1.0];
    [Btn setImage:[UIImage imageNamed:@"Track_LastLocBtn"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(showPigeonLastLoc) forControlEvents:UIControlEventTouchUpInside];
    self.pigeonLastLocBtn = Btn;
    [self.view addSubview:self.pigeonLastLocBtn];
}

- (void)initShowInformationBtn
{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(CGRectGetMinX(self.phoneLocBtn.frame), CGRectGetMaxY(self.pigeonLastLocBtn.frame)+10 , 40, 40);
    //    Btn.backgroundColor = [UIColor colorWithRed:116/255.0 green:168/255.0 blue:42/255.0 alpha:1.0];
    [Btn setImage:[UIImage imageNamed:@"Track_InfoBtn"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(showInformation) forControlEvents:UIControlEventTouchUpInside];
    self.infoBtn = Btn;
    [self.view addSubview:self.infoBtn];
}

- (void)showPhoneLocation:(id)sender
{
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)showPigeonLastLoc
{
    // 设置地图中心点为信鸽最后一点
    _mapView.centerCoordinate = self.endAnnotaion.coordinate;

}

- (void)showInformation
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self dataFromWeb];
    
    [self setupMapProperty];
    [self setupDropDownMenu];
    self.mapView.delegate = self;
    [self.view addSubview:_mapView];

    
    [self unixTimeStampTransferToDateString:1490183105];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"信鸽名字：%@ 设备号:%@",pigeonName, devNum);
    if (devNum == nil || devNum == NULL)
    {
        NSLog(@"无所选的设备号");
        CGPoint point = CGPointMake(JScreenWidth/2, 100);
        NSValue *value = [NSValue valueWithCGPoint:point];
        [self.view makeToast:@"请在左上角选择待查设备号" duration:3.0 position:value];
    }
    
    NSLog(@"接收网络数据devNum是：%@",devNum);
    if (devNum != NULL) {
        CGPoint point = CGPointMake(JScreenWidth/2, 100);
        NSValue *value = [NSValue valueWithCGPoint:point];
        [self.view makeToast:[NSString stringWithFormat:@"设备号：%@ 鸽名：%@", devNum, pigeonName] duration:5.0 position:value];
    }
    
    [self.mapView removeOverlays:_mapView.overlays];
    [self.mapView removeAnnotations:_mapView.annotations];
    
    [self dataFromWeb];
}

- (void)setupMapProperty
{
    // 初始化地图
    _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    // 设置指南针位置
//    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 65);
//    // 设置比例尺控件
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 70);
    // 设置地图缩放级别 [3-19]
//    [_mapView setZoomLevel:14.0 animated:YES];
    // 缩放手势开启
    _mapView.zoomEnabled = YES;
    // 拖动手势开启
    _mapView.scrollEnabled = YES;
    // 进入地图就显示定位小蓝点
    _mapView.showsUserLocation = YES;
    // 地图跟着位置移动
//    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];

}

- (void)leftItemClicked:(id)sender
{
    PickDevicePigeonViewController *pdpvc = [[PickDevicePigeonViewController alloc]init];
    pdpvc.view.backgroundColor = [UIColor whiteColor];
    pdpvc.valueBlock = ^(NSString* nameTxt, NSString* devTxt){
        pigeonName = nameTxt;
        devNum = devTxt;
        
        NSLog(@"---信鸽名字：%@ 设备号:%@",pigeonName, devNum);
    };
    [self.navigationController pushViewController:pdpvc animated:YES];
}

#pragma mark - 导航栏右侧下拉菜单
/**初始化下拉菜单**/
- (void)setupDropDownMenu {
    NSArray *modelsArray = [self getMenuModelsArray];
    self.dropdownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelsArray menuWidth:FFDefaultFloat eachItemHeight:FFDefaultFloat menuRightMargin:FFDefaultFloat triangleRightMargin:FFDefaultFloat];
    self.dropdownMenu.menuAnimateType = FFDropDownMenuViewAnimateType_ScaleBasedMiddle;
}

- (NSArray *)getMenuModelsArray {
    __weak typeof(self) weakSelf = self;
    // 菜单模型0
    FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"添加设备" menuItemIconName:@"Track_AddDevice" menuBlock:^{
        addDeviceViewController *advc = [[addDeviceViewController alloc]init];
        advc.view.backgroundColor = [UIColor whiteColor];
        [weakSelf.navigationController pushViewController:advc animated:YES];
    }];
    // 菜单模型1
    FFDropDownMenuModel *menuModel1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"添加信鸽" menuItemIconName:@"Track_AddPigeon" menuBlock:^{
        AddPigeonViewController *apvc = [[AddPigeonViewController alloc]init];
        apvc.view.backgroundColor = [UIColor whiteColor];
        [weakSelf.navigationController pushViewController:apvc animated:YES];
//        PigeonDetailViewController *pdvc = [[PigeonDetailViewController alloc]init];
//        pdvc.view.backgroundColor = [UIColor whiteColor];
//        [weakSelf.navigationController pushViewController:pdvc animated:YES];

        
    }];
    
    NSArray *menuModelArr = @[menuModel0, menuModel1];
    return menuModelArr;
}

/** 显示下拉菜单 **/
- (void)showDropDownMenu {
    [self.dropdownMenu showMenu];
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

    NSString *urlStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/trace/query?sbid=2017006&data=20170401"];
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
        NSLog(@"response:%@",response);
        
        if (data==nil) {
            NSLog(@"没有返回的data数据");
        } else {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            
            if ([obj isKindOfClass:[NSArray class]]) {
                
                [self initStartAndEndAnnotation];
                
                long objCount = [(NSArray*)obj count];
                
                // 服务器上的坐标为GPS坐标
                CLLocationCoordinate2D commoPolylineCoordGPS[objCount];
                //GPS坐标转换成高德坐标系
                CLLocationCoordinate2D commoPolylineCoord[objCount];
                
                CLLocationDegrees minLat = 90.0;
                CLLocationDegrees maxLat = -90.0;
                CLLocationDegrees minLon = 180.0;
                CLLocationDegrees maxLon = -180.0;
                
                for (int i = 0; i < objCount; i++) {
                    NSDictionary *locationDic = [(NSArray *)obj objectAtIndex:i];
                    NSString *lat = [(NSDictionary *)locationDic objectForKey:@"latitude"];
                    double lati = [lat doubleValue];
                    NSString *lon = [(NSDictionary *)locationDic objectForKey:@"longitude"];
                    double longi = [lon doubleValue];
                    
                    commoPolylineCoordGPS[i].latitude = lati;
                    commoPolylineCoordGPS[i].longitude = longi;
                
                    AMapCoordinateType type = AMapCoordinateTypeGPS;
                    commoPolylineCoord[i] = AMapCoordinateConvert(commoPolylineCoordGPS[i],type);
                    
                    minLat = MIN(minLat, commoPolylineCoord[i].latitude);
                    maxLat = MAX(maxLat, commoPolylineCoord[i].latitude);
                    minLon = MIN(minLon, commoPolylineCoord[i].longitude);
                    maxLon = MAX(maxLon, commoPolylineCoord[i].longitude);

                    // 起点坐标
                    self.startAnnotaion.coordinate = CLLocationCoordinate2DMake(commoPolylineCoord[0].latitude, commoPolylineCoord[0].longitude);
                    self.startAnnotaion.title = @"起点";

                    // 终点坐标
                    self.endAnnotaion.coordinate = CLLocationCoordinate2DMake(commoPolylineCoord[objCount-1].latitude, commoPolylineCoord[objCount-1].longitude);
                    self.endAnnotaion.title = @"终点";

                    [self.startAndEndAnnotation addObject:self.endAnnotaion];
                    [self.startAndEndAnnotation addObject:self.startAnnotaion];
                }
                
                CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake((minLat + maxLat) * 0.5f, (minLon + maxLon) * 0.5f);
                MACoordinateSpan viewSapn;
                viewSapn.latitudeDelta = (maxLat - minLat) * 3;
                viewSapn.longitudeDelta = (maxLon - minLon) * 3;
                MACoordinateRegion viewRegion;
                viewRegion.center = centerCoord;
                viewRegion.span = viewSapn;
                
                [_mapView setRegion:viewRegion];
                // 构造折线对象
                MAPolyline *Polyline = [MAPolyline polylineWithCoordinates:commoPolylineCoord count:[(NSArray*)obj count]];
                [_mapView addOverlay:Polyline];
                [_mapView addAnnotations:self.startAndEndAnnotation];
                
            }
        }
        
    }];
    [dataTask resume];
}

- (void)initStartAndEndAnnotation
{
    _startAnnotaion = [[MAPointAnnotation alloc]init];
    _endAnnotaion = [[MAPointAnnotation alloc]init];
    
    _startAndEndAnnotation = [NSMutableArray array];
}


# pragma mark - <MAMapViewDelegate>
/* 设置地图annotation的样式*/
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
        }
        annotationView.canShowCallout = YES;
//        annotationView.animatesDrop = YES;
        annotationView.pinColor = [self.startAndEndAnnotation indexOfObject:annotation];  // 0：红色  1：绿色  2：紫色
        return annotationView;
    }
    return nil;
    
}




// 实现代理方法，得把自己设置成代理啊！self.mapView.delegate = self
// 回调函数，设置折线的样式
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc]initWithPolyline:overlay];
        
        polylineRenderer.lineWidth = 5.f;
        polylineRenderer.strokeColor = JrouteColor;
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

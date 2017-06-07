//
//  TrackViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/22.
//  Copyright © 2017年 sibet. All rights reserved.
//

/* 缩放地图使其适应polylines的展示. */
//[self.mapView showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge) animated:YES];

#import "TrackViewController.h"
#import "FFDropDownMenuView.h"
#import "addDeviceViewController.h"
#import "AddPigeonViewController.h"
#import "PickDevicePigeonViewController.h"
#import "PigeonDetailViewController.h"
#import "UIView+Toast.h"
#import "AddWebDeviceViewController.h"
#import "InitRouteViewController.h"
#import "JPOISearchView.h"

/** 坐标转换需要用到的头文件 **/
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "AMapTipAnnotation.h"

#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height
#define JrouteColor [UIColor colorWithRed:9/255.0 green:231/255.0 blue:51/255.0 alpha:0.9]
#define JbtnColor [UIColor colorWithRed:97/255.0 green:144/255.0 blue:213/255.0 alpha:0.7]

static const NSString *StartTitle = @"起点";
static const NSString *EndTitle = @"最新位置";

@interface TrackViewController () <MAMapViewDelegate>
{
    MAPointAnnotation *startAnnotaion;
    MAPointAnnotation *endAnnotaion;
    MAPointAnnotation *realTimeAnnotaion;
    
    AMapTipAnnotation *routeStartAnno;
    AMapTipAnnotation *routeEndAnno;
}

/** 右侧选择下拉菜单 **/
@property (nonatomic, strong) FFDropDownMenuView *dropdownMenu;
/** 右侧选择下拉菜单 **/
@property (nonatomic, strong) FFDropDownMenuView *infoDropdownMenu;
/** 显示手机定位btn **/
@property (nonatomic, weak) IBOutlet UIButton *routeBtn;

@property (nonatomic, strong) NSMutableArray *startAndEndAnnotation;

/** 显示信鸽最后定位btn **/
@property (nonatomic, weak) IBOutlet UIButton *pigeonLastLocBtn;
@property (nonatomic, weak) IBOutlet UIButton *infoBtn;

@property (nonatomic) NSTimeInterval realtimeITVL;
@property (nonatomic) NSString* realTime;
@property (nonatomic) NSString* devPower;
@property (nonatomic) NSString* sigStrength;

@end

@implementation TrackViewController

dispatch_queue_t global_queue;

CLLocationCoordinate2D commoPolylineCoord0;
NSTimer *timer;
NSRunLoop *loop;
static NSString *pigeonName;
static NSString *devNum;
static bool isOffLine = true;
static bool pathZoom = true;
static bool firstShowPath = true;
static bool getHistoryLocs = YES;
NSMutableArray *entityLocations;


static NSString *annoImage;
// 存储查询历史点最后一点的经纬度数据，进行实时查询loop后endAnnotation存不下来
double endLati;
double endLongi;
// 存储起点的经纬度数据
double startLati;
double startLongi;
// 存储经纬度最大最小点数据
double RminLat;
double RmaxLat;
double RminLon;
double RmaxLon;



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
        
        [self initRouteButton];
        [self initShowPigeonLastLocationBtn];
        [self initShowInformationBtn];
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initRouteButton
{
    UIButton *routeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    routeBtn.frame = CGRectMake(JScreenWidth - 50, 64+30 , 40, 40);
    routeBtn.backgroundColor = JbtnColor;
    [routeBtn setImage:[UIImage imageNamed:@"Track_routeBtn"] forState:UIControlStateNormal];
    [routeBtn addTarget:self action:@selector(showInitRouteVC) forControlEvents:UIControlEventTouchUpInside];
    _routeBtn = routeBtn;
    [self.view addSubview:self.routeBtn];

}

- (void)initShowPigeonLastLocationBtn
{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(CGRectGetMinX(self.routeBtn.frame), CGRectGetMaxY(self.routeBtn.frame)+10 , 40, 40);
    Btn.backgroundColor = JbtnColor;
    [Btn setImage:[UIImage imageNamed:@"Track_LastLocBtn"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(showPigeonLastLoc) forControlEvents:UIControlEventTouchUpInside];
    self.pigeonLastLocBtn = Btn;
    [self.view addSubview:self.pigeonLastLocBtn];
}

- (void)initShowInformationBtn
{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(CGRectGetMinX(self.routeBtn.frame), CGRectGetMaxY(self.pigeonLastLocBtn.frame)+10 , 40, 40);
    Btn.backgroundColor = JbtnColor;
    [Btn setImage:[UIImage imageNamed:@"Track_InfoBtn"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(showInfoDropDownMenu) forControlEvents:UIControlEventTouchUpInside];
    self.infoBtn = Btn;
    [self.view addSubview:self.infoBtn];
}

- (void)showInitRouteVC
{
    InitRouteViewController *irvc = [[InitRouteViewController alloc]init];
    irvc.view.backgroundColor = [UIColor whiteColor];
    irvc.tipsBlock = ^(AMapTip *tip0, AMapTip *tip1) {
        routeStartAnno = [[AMapTipAnnotation alloc] initWithMapTip:tip0];
        routeStartAnno.customTitle = @"路径起点";
        routeEndAnno = [[AMapTipAnnotation alloc] initWithMapTip:tip1];
        routeEndAnno.customTitle = @"路径终点";
    };
    irvc.routeStartTip = [routeStartAnno tip];
    irvc.routeEndTip = [routeEndAnno tip];
    irvc.routeStartView.textField.text = [routeStartAnno title];
    irvc.routeEndView.textField.text = [routeEndAnno title];
    [self.navigationController pushViewController:irvc animated:YES];
}

- (void)showPhoneLocation:(id)sender
{
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)showPigeonLastLoc
{
    if (!startAnnotaion) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无追踪信鸽" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        /** 点击时或者出现最后一点的位置，或者出现全部路线区域**/
        pathZoom = !pathZoom;
        // 设置地图中心点为信鸽最后一点
        if (pathZoom) {
            CLLocationDegrees minLat = MIN(RminLat, endLati);
            CLLocationDegrees maxLat = MAX(RmaxLat, endLati);
            CLLocationDegrees minLon = MIN(RminLon, endLongi);
            CLLocationDegrees maxLon = MAX(RmaxLon, endLongi);
            // 设置viewRegion区域
            CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake((minLat + maxLat) * 0.5f, (minLon + maxLon) * 0.5f);
            MACoordinateSpan viewSapn;
            MACoordinateRegion viewRegion;
            viewSapn.latitudeDelta = (maxLat - minLat) * 3;
            viewSapn.longitudeDelta = (maxLon - minLon) * 3;
            viewRegion.center = centerCoord;
            viewRegion.span = viewSapn;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView setRegion:viewRegion];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _mapView.zoomLevel = 14;
                _mapView.centerCoordinate = CLLocationCoordinate2DMake(endLati, endLongi);
            });
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [self setupMapProperty];
    self.mapView.delegate = self;
    [self.view addSubview:_mapView];
    [self setupDropDownMenu];
//    [self initStartAndEndAnnotation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    getHistoryLocs = YES;
    [self trackBegin];
    dispatch_async(dispatch_get_main_queue(), ^{
        AMapTip *tip0 = [routeStartAnno tip];
        AMapTip *tip1 = [routeEndAnno tip];
        if (tip0) {
            [self.mapView addAnnotation:routeStartAnno];
        }
        if (tip1)
        {
            [self.mapView addAnnotation:routeEndAnno];
        }
        if (!realTimeAnnotaion) {
            [self.mapView showAnnotations:self.mapView.annotations edgePadding:UIEdgeInsetsMake(40, 40, 40, 80) animated:YES];
        }
        else {
            return;
        }
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView removeAnnotations:self.mapView.annotations];
        [_mapView removeOverlays:self.mapView.overlays];
    });
    _mapView.delegate = nil;
    [timer invalidate];
}

- (void)setupMapProperty
{
    // 初始化地图
    NSLog(@"setUpMapProperty");
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
    // 拖动手势开启s
    _mapView.scrollEnabled = YES;
    // 进入地图就显示定位小蓝点
    _mapView.showsUserLocation = YES;
    // 地图跟着位置移动
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];

}

- (void)leftItemClicked:(id)sender
{
    PickDevicePigeonViewController *pdpvc = [[PickDevicePigeonViewController alloc]init];
    pdpvc.view.backgroundColor = [UIColor whiteColor];
    pdpvc.valueBlock = ^(NSString* nameTxt, NSString* devTxt){
        pigeonName = nameTxt;
        devNum = devTxt;
    };
    [self.navigationController pushViewController:pdpvc animated:YES];
}

#pragma mark - 导航栏右侧下拉菜单
/**初始化下拉菜单**/
- (void)setupDropDownMenu {
    NSArray *modelsArray = [self getMenuModelsArray];
        // 通过改变menuRightMargin 和 triangleRightMargin来改变下拉菜单的位置
    self.dropdownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelsArray menuWidth:FFDefaultFloat eachItemHeight:FFDefaultFloat menuRightMargin:FFDefaultFloat triangleRightMargin:FFDefaultFloat triangleY:64];
}

- (void)setupDetailDropDownMenu {
    NSArray *infoModelsArr = [self getInfoModelsArr];
    self.infoDropdownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:infoModelsArr menuWidth:135 eachItemHeight:40 menuRightMargin:10 triangleRightMargin:20 triangleY:CGRectGetMaxY(self.infoBtn.frame)];
}

- (NSArray *)getMenuModelsArray {
    __weak typeof(self) weakSelf = self;
    // 菜单模型0
    FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"添加设备" menuItemIconName:@"Track_AddDevice" menuBlock:^{
//        AddWebDeviceViewController *awdvc = [[AddWebDeviceViewController alloc]init];
//        awdvc.view.backgroundColor = [UIColor whiteColor];
        
        addDeviceViewController *advc = [[addDeviceViewController alloc]init];
        advc.view.backgroundColor = [UIColor whiteColor];
        [weakSelf.navigationController pushViewController:advc animated:YES];
    }];
    // 菜单模型1
    FFDropDownMenuModel *menuModel1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"添加信鸽" menuItemIconName:@"Track_AddPigeon" menuBlock:^{
        AddPigeonViewController *apvc = [[AddPigeonViewController alloc]init];
        apvc.view.backgroundColor = [UIColor whiteColor];
        [weakSelf.navigationController pushViewController:apvc animated:YES];
    }];
    
    NSArray *menuModelArr = @[menuModel0, menuModel1];
    return menuModelArr;
}

- (NSArray*)getInfoModelsArr {
    /*** 身份环号信息 ***/
    NSString *ringNumStr = [[NSString alloc]init];
    if (pigeonName) {
        ringNumStr = pigeonName;
    } else
    {
        ringNumStr = @"无环号信息";
    }
    FFDropDownMenuModel *infoMenuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:ringNumStr menuItemIconName:@"Track_DetaiInfo_Pigeon" menuBlock:nil];
    /*** 设备号信息 ***/
    NSString *devNumInfo = [[NSString alloc]init];
    if (devNum) {
        devNumInfo = devNum;
    } else
    {
        devNumInfo = @"无设备信息";
    }
    FFDropDownMenuModel *infoMenuModel1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:devNumInfo menuItemIconName:@"Track_DetaiInfo_deviceNum" menuBlock:nil];
    /*** 电量信息 ***/
    NSString *batteryInfo = [[NSString alloc]init];
    if (_devPower) {
        NSString *percent = @"%";
        batteryInfo = [NSString stringWithFormat:@"电量:  %@%@",self.devPower,percent];
    } else {
        batteryInfo = @"无电量信息";
    }
    FFDropDownMenuModel *infoMenuModel2 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:batteryInfo menuItemIconName:@"Track_DetaiInfo_Battery" menuBlock:nil];
    
    NSString *signalInfo = [[NSString alloc]init];
    if (_sigStrength) {
        NSString *signalStr = [self sigStrengthTranslate:_sigStrength];
        signalInfo = [NSString stringWithFormat:@"信号:  %@",signalStr];
    } else {
        signalInfo = @"无信号信息";
    }
    FFDropDownMenuModel *infoMenuModel3 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:signalInfo menuItemIconName:@"Track_DetaiInfo_Signal" menuBlock:nil];
    NSArray *infoMenuModelArr = @[infoMenuModel0, infoMenuModel1, infoMenuModel2, infoMenuModel3];
    return infoMenuModelArr;
}

- (NSString *)sigStrengthTranslate:(NSString *)sigStr
{
    NSString *signalStrength = [[NSString alloc]init];
    int sigStrength = [sigStr intValue];
    // 信号：1-31， 15-20:弱； 20-25:正常； 26-31:强
    if (sigStrength < 20) {
        signalStrength = @"弱";
    } else if (sigStrength <26)
    {
        signalStrength = @"正常";
    }else {
        signalStrength = @"强";
    }
    return signalStrength;
}

/** 显示选择下拉菜单 **/
- (void)showDropDownMenu {
    [self.dropdownMenu showMenu];
}
// ** 显示信息下拉菜单 **//
- (void)showInfoDropDownMenu
{
    [self setupDetailDropDownMenu];

    [self.infoDropdownMenu showMenu];
}

# pragma mark - unix时间戳转换为时间字符串
// 输入unix时间戳对象，返回日期字符串对象
- (NSString *)unixTimeStampTransferToDateString:(NSTimeInterval)timeInterval
{
    // 设置日期显示格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    dateFormatter.dateFormat = @"YYYYMMdd";
    // 时间戳timeInterval转换成日期对象
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    // 日期对象返回日期字符串
    NSString *dateStr = [dateFormatter stringFromDate:date];
    NSLog(@"日期:%@",dateStr);
    return dateStr;
}

#pragma mark - 网络请求


- (void)outOfWebServiceAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络请求失败" message:@"请检查您的网络状况" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    [timer invalidate];
}

- (void)emptyWebDataAlert
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView addAnnotation:routeStartAnno];
        [self.mapView addAnnotation:routeEndAnno];
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
//        [self.mapView showAnnotations:self.mapView.annotations edgePadding:UIEdgeInsetsMake(40, 40, 40, 80) animated:YES];
    });
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无追踪信息" message:@"所选设备不存在" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        devNum = nil;
        _devPower = nil;
        _sigStrength = nil;
        startAnnotaion = nil;
        endAnnotaion = nil;
        if (realTimeAnnotaion!=nil) {
            realTimeAnnotaion = nil;
        }
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    [timer invalidate];
}

- (void)getRealTimeData
{
    NSString *urlStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/trace/queryNew?sbid=%@",devNum];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // delegate设置为nil，因为session对象并不需要实现委托方法
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSLog(@"response:%@",response);
        if (data==nil) {
            // 网络状况不佳
            [self outOfWebServiceAlert];
        }
        else {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                // 所选设备不存在
                [self emptyWebDataAlert];
            }
            else if ([obj isKindOfClass:[NSArray class]]) {
                // 所选设备存在，实时查询存在结果，实例化各坐标对象
                [self initStartAndEndAnnotation];
                // 获取查询信息
                NSDictionary *infoDic = [(NSArray *)obj objectAtIndex:0];
                // 提取时间信息
                NSNumber *realTInterval = [(NSDictionary*)infoDic objectForKey:@"timein"];
                _realtimeITVL = [realTInterval doubleValue];
                _realTime = [self unixTimeStampTransferToDateString:_realtimeITVL];
                // 如果超过5min没有发数据，弹出通知提醒
                isOffLine = [self isOutoffLine:self.realtimeITVL];

                //提取电量／信号信息
                NSString* realTPower = [(NSDictionary*)infoDic objectForKey:@"power"];
                _devPower = realTPower;
                NSString* realTSignalStrength = [(NSDictionary*)infoDic objectForKey:@"sig"];
                _sigStrength = realTSignalStrength;
                // 获取实时经纬度信息
                NSNumber *lat = [(NSDictionary *)infoDic objectForKey:@"latitude"];
                double lati = [lat doubleValue];
                NSNumber *lon = [(NSDictionary *)infoDic objectForKey:@"longitude"];
                double longi = [lon doubleValue];
                // 服务器上的坐标为GPS坐标
                CLLocationCoordinate2D commoPolylineCoordGPS;
                commoPolylineCoordGPS.latitude = lati;
                commoPolylineCoordGPS.longitude = longi;
                //GPS坐标转换成高德坐标系
                CLLocationCoordinate2D commoPolylineCoord;
                AMapCoordinateType type = AMapCoordinateTypeGPS;
                commoPolylineCoord = AMapCoordinateConvert(commoPolylineCoordGPS,type);
                // 实时点坐标
                //  有时候程序运行到这里会崩溃，Thread 20: EXC_BAD_ACCESS
                realTimeAnnotaion.coordinate = CLLocationCoordinate2DMake(commoPolylineCoord.latitude, commoPolylineCoord.longitude);
                realTimeAnnotaion.title = @"最新位置";
                
                if (!isOffLine) {
                    if (getHistoryLocs == YES) {
                        [self getHistoryLocation:self.realTime];
                        getHistoryLocs = NO;
                    }
                    return;
                }
            }
        }
    }];
    [dataTask resume];
}

- (void)getHistoryLocation:(NSString *)time
{
    NSString *urlStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/trace/query?sbid=%@&data=%@",devNum,time];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // delegate设置为nil，因为session对象并不需要实现委托方法
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"response:%@",response);
        if (data==nil) {
            // 网络状况不佳
            [self outOfWebServiceAlert];
        }
        else {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
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
                NSNumber *lat = [(NSDictionary *)locationDic objectForKey:@"latitude"];
                double lati = [lat doubleValue];
                NSNumber *lon = [(NSDictionary *)locationDic objectForKey:@"longitude"];
                double longi = [lon doubleValue];
                    
                commoPolylineCoordGPS[i].latitude = lati;
                commoPolylineCoordGPS[i].longitude = longi;
                AMapCoordinateType type = AMapCoordinateTypeGPS;
                commoPolylineCoord[i] = AMapCoordinateConvert(commoPolylineCoordGPS[i],type);
                
                minLat = MIN(minLat, commoPolylineCoord[i].latitude);
                maxLat = MAX(maxLat, commoPolylineCoord[i].latitude);
                minLon = MIN(minLon, commoPolylineCoord[i].longitude);
                maxLon = MAX(maxLon, commoPolylineCoord[i].longitude);
            }
            RminLat = minLat;
            RmaxLat = maxLat;
            RminLon = minLon;
            RmaxLon = maxLon;
            
            startLati = commoPolylineCoord[0].latitude;
            startLongi = commoPolylineCoord[0].longitude;
            endLati = commoPolylineCoord[objCount-1].latitude;
            endLongi = commoPolylineCoord[objCount-1].longitude;
            // 起点坐标
            startAnnotaion.coordinate = CLLocationCoordinate2DMake(startLati, startLongi);
            startAnnotaion.title = (NSString*)StartTitle;

             // 终点坐标
            endAnnotaion.coordinate = CLLocationCoordinate2DMake(endLati, endLongi);
            endAnnotaion.title = (NSString*)EndTitle;

            // 构造折线对象
            MAPolyline *Polyline = [MAPolyline polylineWithCoordinates:commoPolylineCoord count:[(NSArray*)obj count]];
            pathZoom = false;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeAnnotations:self.mapView.annotations];
                [_mapView removeOverlays:self.mapView.overlays];
                if (firstShowPath) {
                    _mapView.zoomLevel = 13;
                    firstShowPath = false;
                }
                [_mapView addAnnotation:routeStartAnno];
                [_mapView addAnnotation:routeEndAnno];
                [_mapView addAnnotation:startAnnotaion];
                [_mapView addAnnotation:endAnnotaion];
                [_mapView setCenterCoordinate:endAnnotaion.coordinate animated:YES];
                [_mapView addOverlay:Polyline];
            });
        }
    }];
    [dataTask resume];
}

- (void)updateLoop {
    loop = [NSRunLoop currentRunLoop];
    timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:8 target:self selector:@selector(updateAnnotationsAndOverlay) userInfo:nil repeats:YES];
    [loop addTimer:timer forMode:NSDefaultRunLoopMode];
}

//- (void)addAnnotationsAndOverlay
//{
//    NSLog(@"历史轨迹点数量：%lu",(unsigned long)entityLocations.count);
//    NSUInteger locationsCount = [entityLocations count];
//    CLLocationCoordinate2D commoPolylineCoord[locationsCount];
//
//    for (int i=0; i < locationsCount; i++) {
//        NSArray *locArr = [[NSArray alloc]init];
//        locArr = entityLocations[i];
//        NSString *latiStr = [locArr objectAtIndex:0];
//        double latitude = [latiStr doubleValue];
//        NSString *longiStr = [locArr objectAtIndex:1];
//        double longitude = [longiStr doubleValue];
//        commoPolylineCoord[i].latitude = latitude;
//        commoPolylineCoord[i].longitude = longitude;
//        // 起点坐标
//        startAnnotaion.coordinate = CLLocationCoordinate2DMake(commoPolylineCoord[0].latitude, commoPolylineCoord[0].longitude);
//        startAnnotaion.title = @"起点";
//    }
//    // 终点坐标
//    endAnnotaion.coordinate = [self getNewEndAnnotationFrom:entityLocations];
//    lat0 = endAnnotaion.coordinate.latitude;
//    long0 = endAnnotaion.coordinate.longitude;
//    NSLog(@"终点的经纬度：%f,%f",endAnnotaion.coordinate.latitude, endAnnotaion.coordinate.longitude);
//    // 构造折线对象
//    MAPolyline *Polyline = [MAPolyline polylineWithCoordinates:commoPolylineCoord count:locationsCount];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_mapView removeAnnotations:self.mapView.annotations];
//        [_mapView removeOverlays:self.mapView.overlays];
//        if (firstShowPath) {
//            _mapView.zoomLevel = 13;
//            firstShowPath = false;
//        }
//        [_mapView setCenterCoordinate:endAnnotaion.coordinate animated:YES];
//        [_mapView addOverlay:Polyline];
//        [_mapView addAnnotation:startAnnotaion];
//        [_mapView addAnnotation:endAnnotaion];
//    });
//}

//- (CLLocationCoordinate2D)getNewEndAnnotationFrom:(NSMutableArray*)entityLocations
//{
//    NSUInteger locationsCount = [entityLocations count];
//    CLLocationCoordinate2D commoPolylineCoord[locationsCount];
//    for (int i=0; i < locationsCount; i++) {
//        NSArray *locArr = [[NSArray alloc]init];
//        locArr = entityLocations[i];
//        NSString *latiStr = [locArr objectAtIndex:0];
//        double latitude = [latiStr doubleValue];
//        NSString *longiStr = [locArr objectAtIndex:1];
//        double longitude = [longiStr doubleValue];
//        commoPolylineCoord[i].latitude = latitude;
//        commoPolylineCoord[i].longitude = longitude;
//    }
//    CLLocationCoordinate2D newEndAnnotation = CLLocationCoordinate2DMake(commoPolylineCoord[locationsCount-1].latitude, commoPolylineCoord[locationsCount-1].longitude);
//    return newEndAnnotation;
//}

- (void)updateAnnotationsAndOverlay
{
//    dispatch_async(dispatch_get_main_queue(), ^{
////        [_mapView removeAnnotations:self.mapView.annotations];
//    });
    [self getRealTimeData];
    double lat1 = realTimeAnnotaion.coordinate.latitude;
    double long1 = realTimeAnnotaion.coordinate.longitude;
    // 如果坐标点改变了，更新视图
    if (lat1!=endLati || long1!=endLongi) {
        NSLog(@"实时点的经纬度：%f,%f",realTimeAnnotaion.coordinate.latitude, realTimeAnnotaion.coordinate.longitude);
        // 如果最新点数据更新，画最后一段折线，更新终点annotation
        CLLocationCoordinate2D polyLine[2];
        polyLine[0].latitude = endLati;
        polyLine[0].longitude = endLongi;
        polyLine[1].latitude = lat1;
        polyLine[1].longitude = long1;
        MAPolyline *line = [MAPolyline polylineWithCoordinates:polyLine count:2];
        endLati = lat1;
        endLongi = long1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mapView addOverlay:line];
        });
    }

    startAnnotaion.coordinate = CLLocationCoordinate2DMake(startLati, startLongi);
    startAnnotaion.title = (NSString*)StartTitle;
    endAnnotaion.coordinate = CLLocationCoordinate2DMake(endLati, endLongi);
    endAnnotaion.title = (NSString*)EndTitle;

    dispatch_async(dispatch_get_main_queue(), ^{
        [_mapView removeAnnotations:self.mapView.annotations];
        [_mapView addAnnotation:routeStartAnno];
        [_mapView addAnnotation:routeEndAnno];
        [self.mapView addAnnotation:startAnnotaion];
        [self.mapView addAnnotation:endAnnotaion];
//        [self.mapView setCenterCoordinate:realTimeAnnotaion.coordinate];
    });
}

- (void)trackBegin
{
    if (!devNum.length){
        CGPoint point = CGPointMake(JScreenWidth/2, 84);
        NSValue *value = [NSValue valueWithCGPoint:point];
        [self.view makeToast:@"请在左上角选择待查设备号" duration:3.0 position:value];
    }
    else {
        dispatch_async(global_queue, ^{
            [self getRealTimeData];
        });
        loop = [NSRunLoop currentRunLoop];
        timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:8 target:self selector:@selector(updateAnnotationsAndOverlay) userInfo:nil repeats:YES];
        [loop addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

- (BOOL)isOutoffLine:(NSTimeInterval)timeInterval
{
    NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval dateNowInterval = [dateNow timeIntervalSince1970];
    double intervalMinus = dateNowInterval - timeInterval;
    // 取绝对值
    double absoluteMinus = fabs(intervalMinus);
    NSLog(@"absoluteMinus:%f",absoluteMinus);
    // 如果超过5min中时间信息没有更新，则弹出设备目前不在线或者已掉线提示
    if (absoluteMinus > 300) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView removeOverlays:self.mapView.overlays];
            [self.mapView addAnnotation:routeStartAnno];
            [self.mapView addAnnotation:routeEndAnno];
            _mapView.showsUserLocation = YES;
            [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        });
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备当前不在线" message:@"超过5min没有更新位置点" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            devNum = nil;
            _devPower = nil;
            _sigStrength = nil;
            startAnnotaion = nil;
            endAnnotaion = nil;
            if (realTimeAnnotaion!=nil) {
                realTimeAnnotaion = nil;
            }
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        [timer invalidate];
        return YES;
    }
    else {
        return NO;
    }
}

/*************************************************************/

- (void)startTrack
{
    if (!pigeonName.length){
        CGPoint point = CGPointMake(JScreenWidth/2, 84);
        NSValue *value = [NSValue valueWithCGPoint:point];
        [self.view makeToast:@"请在左上角选择待查信鸽" duration:3.0 position:value];
    }
    else {
        dispatch_async(global_queue, ^{
            [self dataFromWeb];
            [self realTimeDataFromWeb];
            [self getRealTimeData];
        });
        loop = [NSRunLoop currentRunLoop];
        timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:8 target:self selector:@selector(realTimeDataFromWeb) userInfo:nil repeats:YES];
        [loop addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)dataFromWeb
{

    NSString *urlStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/trace/query?sbid=%@&data=20170417",devNum];
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
        NSLog(@"response:%@",response);
        if (data==nil) {
            // 网络状况不佳
            [self outOfWebServiceAlert];
        }
        else {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            NSLog(@"id obj:%@",obj);
            if ([obj isKindOfClass:[NSDictionary class]]) {
                // 无追踪信息
                [self emptyWebDataAlert];
            }
            else if ([obj isKindOfClass:[NSArray class]]) {
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
                    NSNumber *lat = [(NSDictionary *)locationDic objectForKey:@"latitude"];
                    double lati = [lat doubleValue];
                    NSNumber *lon = [(NSDictionary *)locationDic objectForKey:@"longitude"];
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
                    startAnnotaion.coordinate = CLLocationCoordinate2DMake(commoPolylineCoord[0].latitude, commoPolylineCoord[0].longitude);
                    startAnnotaion.title = @"起点";
                    // 终点坐标
                    endAnnotaion.coordinate = CLLocationCoordinate2DMake(commoPolylineCoord[objCount-1].latitude, commoPolylineCoord[objCount-1].longitude);
                    endAnnotaion.title = @"最新位置";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.startAndEndAnnotation addObject:endAnnotaion];
                        [self.startAndEndAnnotation addObject:startAnnotaion];
                    });
                }
                // 构造折线对象
                MAPolyline *Polyline = [MAPolyline polylineWithCoordinates:commoPolylineCoord count:[(NSArray*)obj count]];
                pathZoom = false;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mapView removeAnnotations:self.mapView.annotations];
                    [_mapView removeOverlays:self.mapView.overlays];
                    if (firstShowPath) {
                        _mapView.zoomLevel = 13;
                        firstShowPath = false;
                        pathZoom = false;
                    }
                    [_mapView setCenterCoordinate:endAnnotaion.coordinate animated:YES];
                    [_mapView addOverlay:Polyline];
                    [_mapView addAnnotations:self.startAndEndAnnotation];
                });
            }
        }
        
    }];
    [dataTask resume];
}

/*** 查询实时轨迹点，经纬度／信号／电量 ***/
- (void)realTimeDataFromWeb
{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/trace/queryNew?sbid=%@",devNum];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // delegate设置为nil，因为session对象并不需要实现委托方法
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"response:%@",response);
        if (data==nil) {
            // 网络状况不佳
            [self outOfWebServiceAlert];
        }
        else {
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //            NSLog(@"id obj:%@",obj);
            if ([obj isKindOfClass:[NSDictionary class]]) {
                // 无追踪信息
                [self emptyWebDataAlert];
            }
            else if ([obj isKindOfClass:[NSArray class]]) {
                [self initStartAndEndAnnotation];
                // 服务器上的坐标为GPS坐标
                CLLocationCoordinate2D commoPolylineCoordGPS;
                //GPS坐标转换成高德坐标系
                CLLocationCoordinate2D commoPolylineCoord;
                NSDictionary *infoDic = [(NSArray *)obj objectAtIndex:0];
                NSNumber *lat = [(NSDictionary *)infoDic objectForKey:@"latitude"];
                double lati = [lat doubleValue];
                NSNumber *lon = [(NSDictionary *)infoDic objectForKey:@"longitude"];
                double longi = [lon doubleValue];
                //提取电量／信号信息
                NSString* realTPower = [(NSDictionary*)infoDic objectForKey:@"power"];
                _devPower = realTPower;
                NSString* realTSignalStrength = [(NSDictionary*)infoDic objectForKey:@"sig"];
                _sigStrength = realTSignalStrength;
                
                commoPolylineCoordGPS.latitude = lati;
                commoPolylineCoordGPS.longitude = longi;
                AMapCoordinateType type = AMapCoordinateTypeGPS;
                commoPolylineCoord = AMapCoordinateConvert(commoPolylineCoordGPS,type);
                    
                // 起点坐标
                realTimeAnnotaion.coordinate = CLLocationCoordinate2DMake(commoPolylineCoord.latitude, commoPolylineCoord.longitude);
                realTimeAnnotaion.title = @"最新位置";

                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mapView removeAnnotations:self.mapView.annotations];
                    [_mapView removeOverlays:self.mapView.overlays];
                    if (firstShowPath) {
                        _mapView.zoomLevel = 13;
                        firstShowPath = false;
                    }
                    [_mapView setCenterCoordinate:realTimeAnnotaion.coordinate animated:YES];
                    [_mapView addAnnotation:realTimeAnnotaion];
                });
            }
        }
        
    }];
    [dataTask resume];
}

- (void)initStartAndEndAnnotation
{
    startAnnotaion = [[MAPointAnnotation alloc]init];
    endAnnotaion = [[MAPointAnnotation alloc]init];
    realTimeAnnotaion = [[MAPointAnnotation alloc]init];
    
    _startAndEndAnnotation = [NSMutableArray array];
    entityLocations = [[NSMutableArray alloc]init];
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
        if ([[annotation title] isEqualToString:(NSString*)EndTitle]) {
            annotationView.animatesDrop = YES;
            annotationView.pinColor = 2;
        }
        else if ([[annotation title] isEqualToString:(NSString*)StartTitle]) {
            annotationView.pinColor = 1;
        }
//        annotationView.pinColor = [self.startAndEndAnnotation indexOfObject:annotation];  // 0：红色  1：绿色  2：紫色
        return annotationView;
    }
    else if ([annotation isKindOfClass:[AMapTipAnnotation class]])
    {
        static NSString *tipIdentifier = @"tipIdentifier";
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:tipIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:tipIdentifier];
        }
        poiAnnotationView.canShowCallout = YES;
        if ([[(AMapTipAnnotation*)annotation customTitle] isEqualToString:(NSString*)@"路径起点"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"Track_routeStart"];
        }
        else if ([[(AMapTipAnnotation*)annotation customTitle] isEqualToString:(NSString*)@"路径终点"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"Track_routeEnd"];
        }
        poiAnnotationView.centerOffset = CGPointMake(0, -(poiAnnotationView.frame.size.height * 0.5));
        return poiAnnotationView;
    }
    return nil;
}

- (void)addStartAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
//    annoImage = @"Track_startImage";
    MAPointAnnotation *Annotation = [[MAPointAnnotation alloc]init];
    Annotation.coordinate = coordinate;
    Annotation.title = @"起点";
    [self.mapView addAnnotation:Annotation];
}
- (void)addEndAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate
{
//    annoImage = @"Track_endImage";
    MAPointAnnotation *Annotation = [[MAPointAnnotation alloc]init];
    Annotation.coordinate = coordinate;
    Annotation.title = @"终点";
    [self.mapView addAnnotation:Annotation];
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

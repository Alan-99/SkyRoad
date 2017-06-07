//
//  InitRouteViewController.h
//  SkyRoad
//
//  Created by alan on 2017/5/9.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@class JPOISearchView;

typedef void (^returnAMapTipsBlock)(AMapTip *tip0, AMapTip *tip1);

@interface InitRouteViewController : UIViewController

@property (nonatomic, strong) returnAMapTipsBlock tipsBlock;

@property (nonatomic, strong) JPOISearchView *routeStartView;
@property (nonatomic, strong) JPOISearchView *routeEndView;

@property (nonatomic, strong) AMapTip *routeStartTip;
@property (nonatomic, strong) AMapTip *routeEndTip;
@end

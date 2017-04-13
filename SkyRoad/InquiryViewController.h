//
//  InquiryViewController.h
//  SkyRoad
//
//  Created by alan on 17/3/22.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <MAMapKit/MAMapKit.h>

@class FSCalendar;

@interface InquiryViewController : UIViewController

// calendar属性必须设置为weak！！！！
@property (weak, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) MAMapView *mapView;

// 创建事件属性
//@property (strong, nonatomic) NSArray<EKEvent*> *events;

- (IBAction)showCalendarDate:(id)sender;


@end

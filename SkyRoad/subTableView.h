//
//  subTableView.h
//  SkyRoad
//
//  Created by alan on 2017/4/11.
//  Copyright © 2017年 sibet. All rights reserved.
//


/*
 
 没有调通啊！！！！！
 
 */

#import <UIKit/UIKit.h>

@interface subTableView : UITableView

@property (nonatomic ,strong) NSArray *cells;
@property (nonatomic,strong) NSIndexPath *lastPath;

@property (nonatomic, copy) NSString *cellChosen;


- (void)initCellsWithArr:(NSMutableArray*)arr;


@end

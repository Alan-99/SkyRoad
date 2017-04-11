//
//  subTableView.m
//  SkyRoad
//
//  Created by alan on 2017/4/11.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "subTableView.h"

@interface subTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation subTableView


- (instancetype)init
{
    self = [super init];
    if(self) {
        
//        [_pigeonTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];

    }
    return self;
}

- (void)initCellsWithArr:(NSMutableArray*)arr
{
    _cells = @[@"小红", @"小兰", @"小绿", @"小黄", @"小紫", @"小赤"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cells.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";

//    [self registerClass:[UITableViewCell self] forCellReuseIdentifier:cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text = self.cells[indexPath.row];
        
        NSInteger row = [indexPath row];
        NSInteger oldRow = [_lastPath row];
        if (row == oldRow && self.lastPath!=nil) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    _cellChosen = [self.cells objectAtIndex:indexPath.row];
    
    int newRow = (int)[indexPath row];
    int oldRow = (_lastPath!=nil)?(int)[_lastPath row]:-1;
    if (newRow != oldRow) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        _lastPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

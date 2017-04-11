//
//  ItemStore.m
//  SkyRoad
//
//  Created by alan on 17/3/29.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "ItemStore.h"
#import "Item.h"


@interface ItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation ItemStore

+ (instancetype)sharedStore
{
    static ItemStore *sharedStore = nil;
    if(!sharedStore){
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[ItemStore sharedStore" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (Item *)createItem
{
    // 在这里添加新对象！！！
    Item *newItem = [[Item alloc] init];
    return newItem;
}

// 覆盖allItems的取方法
- (NSMutableArray *)allItems
{
    return self.privateItems;
}

- (void)removeItem:(Item *)item
{
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    // 得到要移动的对象的指针，以便稍后能将其插入新的位置
    Item *item = self.privateItems[fromIndex];
    // 将item从allItems数组中移除
    [self.privateItems removeObjectAtIndex:fromIndex];
    // 根据新的索引位置，将item插回allItems数组
    [self.privateItems insertObject:item atIndex:toIndex];
}



@end

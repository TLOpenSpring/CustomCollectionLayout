//
//  ViewDataSource.m
//  CustomCollectionLayout
//
//  Created by Andrew on 16/4/25.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "ViewDataSource.h"
#import "SampleCalendarEvent.h"
#import "CalendarEvent.h"

@interface ViewDataSource()

@property (nonatomic,strong)NSMutableArray *events;

@end

@implementation ViewDataSource

-(id)init{
    self=[super init];
    if(self){
        _events=[[NSMutableArray alloc]init];
        
        [self generateSampleData];
    }
    return self;
}

- (void)generateSampleData
{
    for (NSUInteger idx = 0; idx < 20; idx++) {
        SampleCalendarEvent *event = [SampleCalendarEvent randomEvent];
        [self.events addObject:event];
    }
}

#pragma mark UICollectionDataSource

-(id<CalendarEvent>) eventAtIndexPath:(NSIndexPath *)indexPath{
    return self.events[indexPath.item];
}
- (NSArray *)indexPathsOfEventsBetweenMinDayIndex:(NSInteger)minDayIndex maxDayIndex:(NSInteger)maxDayIndex minStartHour:(NSInteger)minStartHour maxStartHour:(NSInteger)maxStartHour{
    
    NSMutableArray *indexPaths=[[NSMutableArray alloc]init];
    
    [self.events enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj day]>= minDayIndex && [obj day] <= maxDayIndex && [obj startHour]>=minStartHour && [obj startHour] <= maxStartHour){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
            [indexPaths addObject:indexPath];
        }
    }];
    return indexPaths;
}

#pragma mark UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.events.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id<CalendarEvent> event = self.events[indexPath.item];
    
    CalendarEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CALENDARCELL forIndexPath:indexPath];
    
    if (self.configureCellBlock){
        self.configureCellBlock(cell,indexPath,event);
    }
    
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HeaderView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADERVIEW forIndexPath:indexPath];
    
    if(self.configureHeaderBlock){
        self.configureHeaderBlock(header,kind,indexPath);
    }
    
    return header;
}
@end








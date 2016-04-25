//
//  ViewDataSource.h
//  CustomCollectionLayout
//
//  Created by Andrew on 16/4/25.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarEvent.h"
#import "CalendarEventCell.h"
#import "HeaderView.h"
#import "GlobalConfig.h"

typedef void(^ConfigureCellBlock)(CalendarEventCell *cell,NSIndexPath *indexPath,id<CalendarEvent> event);


typedef void(^ConfigureHeaderBlock)(HeaderView *header,NSString *kind,NSIndexPath*indexPath);

@interface ViewDataSource : NSObject<UICollectionViewDataSource>

@property (copy,nonatomic)ConfigureCellBlock  configureCellBlock;
@property (copy,nonatomic)ConfigureHeaderBlock configureHeaderBlock;

-(id<CalendarEvent>) eventAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)indexPathsOfEventsBetweenMinDayIndex:(NSInteger)minDayIndex maxDayIndex:(NSInteger)maxDayIndex minStartHour:(NSInteger)minStartHour maxStartHour:(NSInteger)maxStartHour;

@end

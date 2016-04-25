//
//  CustomLayout.m
//  CustomCollectionLayout
//
//  Created by Andrew on 16/4/24.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "CustomLayout.h"

#import "ViewDataSource.h"
#import "CalendarEvent.h"
#import "GlobalConfig.h"

static const NSUInteger DaysPerWeek = 7;
static const NSUInteger HoursPerDay = 24;
static const CGFloat HorizontalSpacing = 10;
static const CGFloat HeightPerHour = 50;
static const CGFloat DayHeaderHeight = 40;
static const CGFloat HourHeaderWidth = 100;
@implementation CustomLayout
/**
 *  由于 collection view 对它的 content 并不知情，所以布局首先要提供的信息就是滚动区域大小，这样 collection view 才能正确的管理滚动。布局对象必须在此时计算它内容的总大小，包括 supplementary views 和 decoration views
 *
 *  @return 该方法的返回值决定UICollectionView所包含控件的大小
 */

-(CGSize)collectionViewContentSize {
    //水平方向上不支持滚动
    CGFloat contentWidth = self.collectionView.bounds.size.width;
    
    //Scroll vertically to display a full day
    CGFloat contentHeight = DayHeaderHeight+(HeightPerHour*HoursPerDay);
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
    
    return contentSize;
}
// 该方法返回的UICollectionViewLayoutAttributes控制指定单元格的大小和位置
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    // Cells
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    // Supplementary views
    NSArray *dayHeaderViewIndexPaths = [self indexPathsOfDayHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in dayHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:DAYHEADERVIEW atIndexPath:indexPath];
        if(attributes){
            [layoutAttributes addObject:attributes];
        }
    }
    NSArray *hourHeaderViewIndexPaths = [self indexPathsOfHourHeaderViewsInRect:rect];
    for (NSIndexPath *indexPath in hourHeaderViewIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:HOURHEADERVIEW atIndexPath:indexPath];
        if(attributes){
            [layoutAttributes addObject:attributes];
        }
    }
    
    return layoutAttributes;
}




#pragma mark
#pragma mark Helpers
/**
 *  返回cell的配置
 *
 *  @param rect <#rect description#>
 *
 *  @return <#return value description#>
 */
-(NSArray *)indexPathsOfItemsInRect:(CGRect)rect{
    if(CGRectGetMinY(rect)>DayHeaderHeight){
        return [ NSArray array];
    }
    
    NSInteger minVisibleDay = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxVisibleDay = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    
    NSInteger minVisibleHouse =[self hourIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxVisibleHouse =[self hourIndexFromYCoordinate:CGRectGetMaxY(rect)];
    
    ViewDataSource *source = self.collectionView.dataSource;
    if(!source){
        return nil;
    }
    NSArray *indexPaths = [source indexPathsOfEventsBetweenMinDayIndex:minVisibleDay maxDayIndex:maxVisibleDay minStartHour:minVisibleHouse maxStartHour:maxVisibleHouse];
    return indexPaths;
}

/**
 *  返回DayHeader配置
 *
 *  @param rect 在指定的矩形中
 *
 *  @return <#return value description#>
 */
-(NSArray *)indexPathsOfDayHeaderViewsInRect:(CGRect)rect{
    if(CGRectGetMinY(rect)>DayHeaderHeight){
        return [NSArray array];
    }
    NSInteger maxDayIndex = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    NSInteger minDayIndex = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    
    NSMutableArray *indexPaths= [NSMutableArray array];
    for (NSInteger idx=minDayIndex;idx<= maxDayIndex; idx++) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

/**
 *  返回HourHeader配置
 *
 *  @param rect 在指定的矩形中
 *
 *  @return 返回小时（24）的indexPaths
 */
- (NSArray *)indexPathsOfHourHeaderViewsInRect:(CGRect)rect
{
    if (CGRectGetMinX(rect) > HourHeaderWidth) {
        return [NSArray array];
    }
    
    NSInteger minHourIndex = [self hourIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxHourIndex = [self hourIndexFromYCoordinate:CGRectGetMaxY(rect)];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSInteger idx = minHourIndex; idx <= maxHourIndex; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}


/**
 *  计算出在第几天的坐标值
 *
 *  @param xPostion x轴的坐标值
 *
 *  @return 在坐标轴上显示第几天
 */
-(NSInteger)dayIndexFromXCoordinate:(CGFloat)xPostion{
    CGFloat contentWidth = [self collectionViewContentSize].width-HourHeaderWidth;
    CGFloat widthPerDay = contentWidth/DaysPerWeek;
    
    NSInteger maxPosition = (xPostion-HourHeaderWidth)/widthPerDay;
    NSInteger dayIndex = MAX(0, maxPosition);
    
    return dayIndex;
    
}
/**
 *  计算出小时在Y坐标轴上的位置
 *
 *  @param yPosition y坐标轴
 *
 *  @return
 */
-(NSInteger)hourIndexFromYCoordinate:(CGFloat)yPosition{
    NSInteger position=(yPosition - DayHeaderHeight)/HeightPerHour;
    NSInteger houseIndex =MAX(0, position);
    return houseIndex;
}

/**
 *  为每一个indexpath配置属性，比如frame,center,alpha,transform3D，bounds等
 *
 *  @param indexPath 索引
 *
 *  @return UICollectionViewLayoutAttributes
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ViewDataSource *dataSource = self.collectionView.dataSource;
    id<CalendarEvent> event = [dataSource eventAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame=[self frameForEvent:event];
    return attributes;
}


-(CGRect) frameForEvent:(id<CalendarEvent>)event{
    CGFloat totalWidth = [self collectionViewContentSize].width - HourHeaderWidth;
    CGFloat widthPerDay = totalWidth / DaysPerWeek;
    
    CGRect frame = CGRectZero;
    frame.origin.x=HourHeaderWidth+widthPerDay*event.day;
    
    frame.origin.y=DayHeaderHeight+HeightPerHour*event.startHour;
    frame.size.width=widthPerDay;
    frame.size.height=event.durationInHours * HeightPerHour;
    
    frame=CGRectInset(frame, HorizontalSpacing/2, 0);
    
    return frame;
}





@end







//
//  ViewController.m
//  CustomCollectionLayout
//
//  Created by Andrew on 16/4/24.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "ViewController.h"
#import "HeaderView.h"
#import "ViewDataSource.h"
#import "CustomLayout.h"
#import "GlobalConfig.h"
#import "CalendarEventCell.h"
@interface ViewController ()

@property (nonatomic,strong)ViewDataSource *dataSource;
@property (nonatomic,strong)CustomLayout *customLayout;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.collectionView.backgroundColor=[UIColor whiteColor];
   
    [self initView];
    
}



-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
         NSLog(@"initWithCoder初始化了");
        _customLayout=[[CustomLayout alloc]init];
        _dataSource=[[ViewDataSource alloc]init];
        
        self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,SCREENT_WIDTH , SCREENT_HEIGHT) collectionViewLayout:_customLayout];
        self.collectionView.dataSource=_dataSource;
        [self.collectionView registerClass:[CalendarEventCell class] forCellWithReuseIdentifier:CALENDARCELL];
        
        [self.collectionView registerClass:[HeaderView class] forSupplementaryViewOfKind:DAYHEADERVIEW withReuseIdentifier:HEADERVIEW];
        
        [self.collectionView registerClass:[HeaderView class]forSupplementaryViewOfKind:HOURHEADERVIEW withReuseIdentifier:HEADERVIEW];
    }
    return self;
}


-(void)initView{
    
   
    
    ViewDataSource *dataSource=(ViewDataSource*)self.collectionView.dataSource;
    dataSource.configureCellBlock=^(CalendarEventCell *cell,NSIndexPath *indexPath,id<CalendarEvent> event){
        cell.titleLb.text=event.title;
    };
    
    dataSource.configureHeaderBlock=^(HeaderView *header,NSString *kind,NSIndexPath*indexPath){
        if([kind isEqualToString:DAYHEADERVIEW]){
            header.titleLb.text=[NSString stringWithFormat:@"Day %ld", indexPath.item + 1];
        }else if([kind isEqualToString:HOURHEADERVIEW]){
            header.titleLb.text=[NSString stringWithFormat:@"%2ld:00",indexPath.item+1];
        }
    };
    
}



@end

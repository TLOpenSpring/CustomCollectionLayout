//
//  CalendarEventCell.m
//  CustomCollectionLayout
//
//  Created by Andrew on 16/4/25.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "CalendarEventCell.h"

@implementation CalendarEventCell

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        
        self.titleLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 25)];
        self.titleLb.font=[UIFont systemFontOfSize:11];
        self.titleLb.backgroundColor=[UIColor yellowColor];
        [self addSubview:_titleLb];
        
        self.layer.cornerRadius = 10;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0.7 alpha:1] CGColor];
    }
    return self;
}

@end

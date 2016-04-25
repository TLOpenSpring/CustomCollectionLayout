//
//  HeaderView.m
//  CustomCollectionLayout
//
//  Created by Andrew on 16/4/25.
//  Copyright © 2016年 Andrew. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        _titleLb=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        _titleLb.backgroundColor=[UIColor yellowColor];
        [self addSubview:_titleLb];
    }
    return self;
}


@end

//
//  WSView.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 7/31/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSView.h"

@implementation WSView

@synthesize time;
@synthesize temperature;
@synthesize weatherImage;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)addTapRecognizer
{
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    [self addGestureRecognizer:tapRecognizer];
}
-(void)onTap
{
    [delegate pushDayViewWithTag:self.tag];
}

@end

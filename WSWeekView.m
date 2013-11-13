//
//  WSWeekView.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 7/31/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSWeekView.h"

@implementation WSWeekView

@synthesize weekDayLabel;

@synthesize maxTempLabel,minTempLabel;

@synthesize weatherImage;

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

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
    [delegate pushOnView:self.tag];
}
- (void)drawRect:(CGRect)rect
{
    float borderSize = 0.5f;
    
    //draw the bottom border
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0.0f, self.frame.size.height - borderSize, self.frame.size.width, borderSize));

}

@end

//
//  WSWeatherCell.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/7/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSWeatherCell.h"

@implementation WSWeatherCell

@synthesize deleteButton;
@synthesize delegate;
@synthesize icon;
@synthesize cityLabel;
@synthesize row;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}
+(WSWeatherCell*)cell
{

   WSWeatherCell *cell= [[[NSBundle mainBundle]loadNibNamed:@"WSWeatherCell" owner:self options:nil]objectAtIndex:0];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    
    return cell;
}
-(void)showButton
{
    self.deleteButton.hidden=NO;
}
-(void)hideButton
{
    [self.deleteButton setHidden:YES];
}
-(void)setRecognizer
{
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
    [self.contentView addGestureRecognizer:longPress];
}
-(IBAction)buttonPush:(id)sender
{
    [delegate deleteCellWithTag:self];
}
-(void)longTap:(UILongPressGestureRecognizer*)recognizer
{
    [delegate longTapCellWithTag:self.tag];
}
@end

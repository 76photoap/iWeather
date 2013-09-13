//
//  WSWeatherCell.h
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/7/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <UIKit/UIKit.h>
//---------------------------------------------------------------------------------------------------
@class  WSWeatherCell;
@protocol cellProtocol <NSObject>

@optional
-(void)deleteCellWithTag:(WSWeatherCell*)cell;
-(void)longTapCellWithTag:(NSInteger)tag;

@end
//----------------------------------------------------------------------------------------------------
@interface WSWeatherCell : UITableViewCell

@property(nonatomic)IBOutlet UIButton *deleteButton;

@property(nonatomic)IBOutlet UIImageView *icon;

@property(nonatomic)IBOutlet UILabel *cityLabel;

@property(nonatomic,weak)id<cellProtocol> delegate;

@property(nonatomic,assign)NSUInteger row;

+(WSWeatherCell*)cell;

-(void)showButton;
-(void)hideButton;

-(IBAction)buttonPush:(id)sender;

-(void)longTap:(UILongPressGestureRecognizer*)recognizer;
-(void)setRecognizer;

@end

//
//  WSWeekView.h
//  WeatherService
//
//  Created by Cornholio Zozobra on 7/31/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <UIKit/UIKit.h>
//--------------------------------------------------------------------------------------------------
@protocol WSWeekProtocol

@required
-(void)pushOnView:(NSUInteger)number;

@end
//--------------------------------------------------------------------------------------------------
@interface WSWeekView : UIView

@property(nonatomic,retain)IBOutlet UILabel *weekDayLabel;

@property(nonatomic,retain)IBOutlet UILabel *maxTempLabel;

@property(nonatomic,retain)IBOutlet UILabel *minTempLabel;

@property(nonatomic,retain)IBOutlet UIImageView *weatherImage;

@property(nonatomic,weak)id<WSWeekProtocol> delegate;

-(void)addTapRecognizer;
-(void)onTap;

@end

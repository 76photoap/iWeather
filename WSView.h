//
//  WSView.h
//  WeatherService
//
//  Created by Cornholio Zozobra on 7/31/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <UIKit/UIKit.h>
//------------------------------------------------------------------------------------------------
@protocol WSViewProtocol<NSObject>

@required
-(void)pushDayViewWithTag:(NSInteger)tag;

@end
//-------------------------------------------------------------------------------------------------
@interface WSView : UIView

@property(nonatomic,retain)IBOutlet UILabel *time;

@property(nonatomic,retain)IBOutlet UILabel *temperature;

@property(nonatomic,retain)IBOutlet UIImageView *weatherImage;

@property(nonatomic,weak)id<WSViewProtocol> delegate;

-(void)addTapRecognizer;

-(void)onTap;

@end 

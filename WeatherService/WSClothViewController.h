//
//  WSClothViewController.h
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/5/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WSClothView.h"
#import "UIView+BundleLoad.h"

typedef enum{left,center,right} viewDirection;

@interface WSClothViewController : UIViewController
{
    
@private
    int currentIndex;
    BOOL isSwipe;
    
}
@property(nonatomic)IBOutlet UILabel *labelStyle;
@property(nonatomic)IBOutlet UIButton *leftButton;
@property(nonatomic)IBOutlet UIButton *rightButton;

@property(nonatomic)NSArray *styleArray;

@property(nonatomic)WSWeatherAlgorithm *algorithm;

@property(nonatomic)WSClothView *centerView;
@property(nonatomic)WSClothView *hideView;

-(void)didSwipe:(UISwipeGestureRecognizer*)swipe;

-(IBAction)didTapLeft:(id)sender;
-(IBAction)didTapRight:(id)sender;
-(IBAction)backToWeather:(id)sender;

-(void)onLeft;
-(void)onRight;

-(WSClothView*)createClothView:(viewDirection)direction;
-(CGRect)createFrame:(viewDirection)direction;

-(void)addRecognizers;
-(void)setEnabledButtons;
@end

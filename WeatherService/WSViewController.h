//
//  WSViewController.h
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/1/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>
#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocation.h>

#import "UIView+BundleLoad.h"
#import "NSDate+NSharpDate.h"

#import "WSView.h"
#import "WSWeekView.h"
#import "WSClothViewController.h"
#import "WSCitySearchControllerViewController.h"
#import "WSWeatherAlgorithm.h"
#import "WSUpdateView.h"
#import "WSDownload.h"
#import "WSAnimation.h"

@interface WSViewController : UIViewController<CLLocationManagerDelegate,NSURLConnectionDataDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,WSViewProtocol,WSWeekProtocol,WSDownloadProtocol>
{   
@private
    
    NSString *currentCity;
    NSString *currentCountry;
    NSString *cityID;

    NSURLConnection *activeConnection;
    
    CGPoint firstPoint;
    CGRect selfOrigFrame;
    
    BOOL isNotFound;

}

@property(nonatomic)IBOutlet UILabel *labelCity;

@property(nonatomic)IBOutlet UILabel *labelDate;

@property(nonatomic)IBOutlet UILabel *labelTemperature;

@property(nonatomic)IBOutlet UILabel *labelTempFlik;

@property(nonatomic)IBOutlet UILabel *labelWet;

@property(nonatomic)IBOutlet UILabel *labelWind;

@property(nonatomic)IBOutlet UILabel *labelPressure;

@property(nonatomic)IBOutlet UILabel *labelTempIcon;

@property(nonatomic)IBOutlet UIImageView *weatherImage;

@property(nonatomic) IBOutlet UIImageView *backGround;


@property(nonatomic)IBOutlet UIImageView *imageLine;

@property(nonatomic)IBOutlet UIImageView *imageWind;

@property(nonatomic)IBOutlet UIImageView *imageWet;

@property(nonatomic)UIImageView *notFoundImage;

@property(nonatomic)CLLocationManager *GPS;

@property(nonatomic)NSMutableArray *viewArray;

@property(nonatomic)NSMutableArray *weekViewArray;

@property(nonatomic)CLLocation *curentLocation;

@property(nonatomic)NSMutableData *xmlData;

@property(nonatomic)NSMutableArray *forecastArray;

@property(nonatomic)NSDictionary *forecast;

@property(nonatomic)NSUInteger numberDay;

@property(nonatomic)BOOL isScroll;

@property(nonatomic)BOOL isUpdate;

@property(nonatomic)NSString *connectionName;

@property(nonatomic,strong)WSUpdateView *updateView;

@property(nonatomic)IBOutlet UIButton *arrowButton;
@property(nonatomic)IBOutlet UIButton *plusButton;
@property(nonatomic)IBOutlet UIButton *menuButton;


-(IBAction)backButtonPush:(id)sender;
-(IBAction)openCityList:(id)sender;
-(IBAction)findByGPS:(id)sender;

-(void)GPSOn;

-(NSString*)generateGoogleAddress;
-(NSString*)generateSearchAddress;
-(NSString*)generateForecastAddress:(NSString*)IDs;

-(void)downloadXML:(NSString*)address withConnectionName:(NSString*)name;
-(void)parseAndAddForecast;
-(void)downloadAllForecasts;

-(void)updateWeather;
-(void)setInterface;
-(void)setDayViews;
-(void)setWeekViews;
-(void)setNotFound;

-(void)setIphone5Design;

-(void)setPanRecognizer;

-(NSString*)backgroundFromWeather:(NSString*)weather;
-(void)showNotFound;

-(void)highlightViewAtIndex:(NSUInteger)index;
-(void)unhihtlightView;

-(void)setWeather;
-(void)setCurrentWeather;
-(void)setForecastWeather;
-(void)changeBackgroundWithImage:(UIImage*)image;

-(NSUInteger)setDayWeather:(NSUInteger)dayNumber;
-(void)setWeekWeather:(NSUInteger)index;

-(void)getCityAndCountryName;
-(void)getCityID;

-(void)onPan:(UIPanGestureRecognizer*)panRecognizer;

-(void)viewWillRestore;
-(void)viewDidRestore;

@end

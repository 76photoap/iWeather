//
//  WSSettings.h
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/6/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define kCity   @"city"
#define kCountry @"country"
#define kID @"ID"
#define kSex @"sex"
#define kStyleIndex @"styleIndex"
#define kIndex  @"index"
#define kFirst @"first"
#define kFirstWeather @"firstWeather"
#define kDelete @"delete"
#define kUpdate @"update"

#define DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]

@interface WSSettings : NSObject

@property(nonatomic)NSUserDefaults *userDefault;
@property(nonatomic)NSMutableArray *cityArray;
@property(nonatomic)NSMutableArray *forecastArray;
@property(nonatomic)BOOL update;

+(WSSettings*)sharedSettings;

-(NSArray*)styleArray;

-(BOOL)addObject:(NSDictionary*)dictionary;
-(void)deleteCityAtIndex:(NSUInteger)index;

-(void)saveForecast;
+(void)openForecast;

-(NSArray*)citiesArray;
-(NSArray*)countriesArray;

-(NSMutableArray*)arrayForKey:(NSString*)key;


-(NSString*)currentCity;
-(NSString*)currentCityID;

-(NSString*)currentSex;
-(void)setCurrentSex:(NSString*)sex;

-(NSUInteger)currentStyle;
-(void)setCurrentStyle:(NSUInteger)styleIndex;

-(NSUInteger)currentIndex;
-(void)setCurrentIndex:(NSUInteger)index;

-(BOOL)isFirst;
-(void)setNoFirst;

-(BOOL)isFirstWeather;
-(void)setNoFirstWeather;

-(BOOL)isIphone5;

- (void)roundView:(UIView*)view
     borderRadius:(CGFloat)radius
      borderWidth:(CGFloat)border
            color:(UIColor*)color;
@end

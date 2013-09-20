//
//  WSWeatherAlgorithm.h
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/9/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Official @"Официальный"
#define Free @"Свободный"
#define EveryDay  @"Повседневно-деловой"

#define kPictureName @"picture"
#define kClothName @"name"

typedef enum{WSManSexMan,WSManSexWomen}WSManSex;
typedef enum{WSWeatherTypeSun,WSWeatherTypeRain,WSWeatherTypeNone}WSWeatherType;

@interface WSWeatherAlgorithm : NSObject


@property(nonatomic)CGFloat coefficient;

@property(nonatomic)NSInteger temperature;

@property(nonatomic)NSUInteger humidity;

@property(nonatomic)NSUInteger wind;

@property(nonatomic)NSUInteger cloud;

@property(nonatomic)WSWeatherType sex;

@property(nonatomic)WSWeatherType weatherType;

@property(nonatomic)NSString *style;


@property(nonatomic)NSMutableArray *head;

@property(nonatomic)NSMutableArray *body;

@property(nonatomic)NSMutableArray *legs;

@property(nonatomic)NSMutableArray *foot;

-(CGFloat)influentHumidity;
-(CGFloat)influentWind;
-(CGFloat)influentSun;

-(void)calculateCoefficient;
-(void)calculateDress;
-(void)calculateDressWithStyle:(NSString*)clothStyle;

-(void)manOfficial;
-(void)manFree;
-(void)manEveryday;

-(void)womanOfficial;
-(void)womanFree;
-(void)womanEveryday;

@end

//
//  WSSettings.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/6/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSSettings.h"

#define forecastPlist @"forecast.plist"
#define cityPlist @"Cities.plist"

@implementation WSSettings

@synthesize cityArray;
@synthesize forecastArray;
@synthesize userDefault;
@synthesize update;
//----------------------------------------------------------------------------------------
WSSettings *settings=NULL;

+(WSSettings*)sharedSettings
{
    if (settings==NULL)
    {
        settings=[[WSSettings alloc]init];
        
        [self openForecast];
        
        settings.userDefault=[NSUserDefaults standardUserDefaults];
        
        settings.update=YES;

    }

    return settings;
}
//--------------------------------------------------------------------------------------------
-(NSArray*)styleArray
{
    NSString *plistName=@"Style.plist";
    
    NSString *arrayPath=[[NSBundle mainBundle]pathForResource:plistName ofType:nil];
    
    return [NSArray arrayWithContentsOfFile:arrayPath];
}
//---------------------------------------------------------------------------------------------
-(BOOL)addObject:(NSDictionary*)dictionary
{
    NSUInteger index;
    
    if((index=[self.cityArray indexOfObject:dictionary])==NSNotFound)
    {
        [self.cityArray insertObject:dictionary atIndex:0];
        [self setCurrentIndex:0];
        
        return YES;
    }
    else
    {
        [self setCurrentIndex:index];
        
        return NO;
    }
}
-(void)deleteCityAtIndex:(NSUInteger)index
{
    [self.cityArray removeObjectAtIndex:index];
}
//=================================================================================================
-(void)saveForecast
{
    NSString *plistCity=cityPlist;
    NSString *arrayDirectoryPath=[DOCUMENT stringByAppendingPathComponent:plistCity];
    [self.cityArray writeToFile:arrayDirectoryPath atomically:YES];
    
    NSString *plistForecast=forecastPlist;
    NSString *forecastDirectoryPath=[DOCUMENT stringByAppendingPathComponent:plistForecast];
    [self.forecastArray writeToFile:forecastDirectoryPath atomically:YES];    
}
+(void)openForecast
{
    NSString *plistName=cityPlist;
    NSString *arrayPath=[DOCUMENT stringByAppendingPathComponent:plistName];
    settings.cityArray=[[NSArray arrayWithContentsOfFile:arrayPath]mutableCopy];
    
    if(settings.cityArray==nil)
    {
        settings.cityArray=[NSMutableArray array];
        settings.forecastArray=[NSMutableArray array];
        
        return;
    }
    
    NSString *plistForecast=forecastPlist;
    NSString *forecastPath=[DOCUMENT stringByAppendingPathComponent:plistForecast];
    settings.forecastArray=[[NSArray arrayWithContentsOfFile:forecastPath]mutableCopy];
}
//------------------------------------------------------------------------------------------------
-(NSArray*)citiesArray
{
    return [self arrayForKey:kCity];
}
-(NSArray*)countriesArray
{
    return [self arrayForKey:kCountry];
}
-(NSMutableArray*)arrayForKey:(NSString*)key
{
    NSMutableArray *array=[NSMutableArray array];
    
    for(int i=0;i<[self.cityArray count];i++)
    {
        NSDictionary *dictionary=[self.cityArray objectAtIndex:i];
        [array addObject:[dictionary objectForKey:key]];
    }
    return array;
}

//-----------------------------------------------------------------------------------------------------
-(NSString*)currentCity
{
    NSUInteger index=[self currentIndex];
    return [[self.cityArray objectAtIndex:index]objectForKey:kCity];
}

-(NSString*)currentCityID
{
    NSUInteger index=[self currentIndex];
    return [[self.cityArray objectAtIndex:index]objectForKey:kID];
}
//----------------------------------------------------------------------------------------------------
-(NSString*)currentSex
{
    NSString *sex=[self.userDefault objectForKey:kSex];
    if(sex==nil)
    {
        return @"Man";
    }
    return sex;
}
-(void)setCurrentSex:(NSString*)sex
{
    [self.userDefault setObject:sex forKey:kSex];
    
    [self.userDefault synchronize];
}
//----------------------------------------------------------------------------------------------------
-(NSUInteger)currentStyle
{
    return [self.userDefault integerForKey:kStyleIndex];
}
-(void)setCurrentStyle:(NSUInteger)styleIndex
{
    [self.userDefault setInteger:styleIndex forKey:kStyleIndex];
    
    [self.userDefault synchronize];
}
//----------------------------------------------------------------------------------------------------
-(NSUInteger)currentIndex
{
    return [self.userDefault integerForKey:kIndex];
}
-(void)setCurrentIndex:(NSUInteger)index
{
    [self.userDefault setInteger:index forKey:kIndex];
    
    [self.userDefault synchronize];
}
//----------------------------------------------------------------------------------------------------
-(BOOL)isFirst
{
    if([self.userDefault objectForKey:kFirst]==nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void)setNoFirst
{
    [self.userDefault setBool:NO forKey:kFirst];
}
//-------------------------------------------------------------------------------------------------------
-(BOOL)isFirstWeather
{
    if([self.userDefault objectForKey:kFirstWeather]==nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void)setNoFirstWeather
{
    [self.userDefault setBool:NO forKey:kFirstWeather];
}
//-------------------------------------------------------------------------------------------------------
-(BOOL)isIphone5
{
    CGRect frame=[[UIScreen mainScreen]bounds];
    
    if(frame.size.height>480)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void)setVER1:(NSUInteger)ver1
{
    [self.userDefault setInteger:ver1 forKey:kVER1];
    [self.userDefault synchronize];
}
-(NSUInteger)VER1
{
    return [self.userDefault integerForKey:kVER1];
}
-(void)setVER2:(NSUInteger)ver2
{
    [self.userDefault setInteger:ver2 forKey:kVER2];
    [self.userDefault synchronize];
}
-(NSUInteger)VER2
{
    return [self.userDefault integerForKey:kVER2];
}
//--------------------------------------------------------------------------------------------------------
- (void)roundView:(UIView*)view
     borderRadius:(CGFloat)radius
      borderWidth:(CGFloat)border
            color:(UIColor*)color
{
    CALayer *layer = [view layer];
    layer.masksToBounds = YES;
    layer.cornerRadius = radius;
    layer.borderWidth = border;
    layer.borderColor = color.CGColor;
}
@end

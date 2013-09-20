//
//  WSWeatherAlgorithm.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/9/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.

#import "WSWeatherAlgorithm.h"

@implementation WSWeatherAlgorithm

@synthesize coefficient;
@synthesize temperature;
@synthesize wind;
@synthesize humidity;
@synthesize cloud;
@synthesize sex;
@synthesize style;

@synthesize head;
@synthesize body;
@synthesize legs;
@synthesize foot;

-(CGFloat)humidityCoefficient
{
    if(self.humidity<30)return 0;
    
    if(self.humidity<40)return 1.0f;
    
    if(self.humidity<55)return 1.5f;
    
    return (CGFloat)(self.humidity/10)-3;
}
-(CGFloat)influentHumidity
{
    if(self.temperature<4.5)
    {
        return ([self humidityCoefficient])*(-1);
    }
    if(self.temperature>17.5)
    {
        return [self humidityCoefficient];
    }
    return 0;
}
-(CGFloat)influentWind
{
    if(self.temperature<13.5)return self.wind;
    
    if(self.temperature>19.5)return self.wind*0.5f;
    
    return self.wind*0.75f;
    
}
-(CGFloat)influentCloud
{
    if(self.cloud<30)return 1.0f;
    
    if(self.cloud<67)return 0;
    
    return -1.0f;
}
-(CGFloat)influentSun
{
    if(self.temperature>=-4.5 && self.temperature<=9.5)
    {
        return [self influentCloud];
    }
    
    return 0;
}
-(void)calculateCoefficient
{
    coefficient=ceilf(self.temperature+[self influentHumidity]-[self influentWind]+[self influentSun]);
}
//===============================================================================================
-(void)calculateDress
{
    
    [self calculateCoefficient];
    
    if(self.sex==WSManSexMan)
    {
        if([self.style isEqualToString:Official])
        {
            [self manOfficial];
        }
        if([self.style isEqualToString:Free])
        {
            [self manFree];
        }
        if([self.style isEqualToString:EveryDay])
        {
            [self manEveryday];
        }
    }
    else
    {
        if([self.style isEqualToString:Official])
        {
            [self womanOfficial];
        }
        if([self.style isEqualToString:Free])
        {
            [self womanFree];
        }
        if([self.style isEqualToString:EveryDay])
        {
            [self womanEveryday];
        }
    }
}
-(void)calculateDressWithStyle:(NSString*)clothStyle
{
    self.style=clothStyle;
    [self calculateDress];
}
//================================================================================================
-(void)addWithName:(NSString*)name toArray:(NSMutableArray*)dress
{
    NSMutableDictionary *clothDictionary=[NSMutableDictionary dictionary];
    
    [clothDictionary setObject:name forKey:kClothName];
    
    if(self.sex==WSManSexMan)
    {
        name=[NSString stringWithFormat:@"%@_man",name];
    }
    else
    {
        name=[NSString stringWithFormat:@"%@_woman",name];
    }
    name=[name stringByReplacingOccurrencesOfString:@" " withString:@"_"];

    NSString *imageName=[NSString stringWithFormat:@"%@.png",name];
    
    [clothDictionary setObject:imageName forKey:kPictureName];
    
    [dress addObject:clothDictionary];
}
-(void)manOfficial
{
    NSMutableArray *dress=[NSMutableArray array];
    
//head
    if(coefficient<-7.5)
    {
        [self addWithName:@"Шарф" toArray:dress];
        [self addWithName:@"Шапка" toArray:dress];
    }
    else if(coefficient<5.5)
         {
             [self addWithName:@"Кепка" toArray:dress];
         }
         else
         {
             [self addWithName:@"Шляпа" toArray:dress];
         }
    
    self.head=[dress copy];
    [dress removeAllObjects];
    
//body
    if(coefficient<23.5)
    {
        [self addWithName:@"Рубашка с дл.рукавом" toArray:dress];
    }
    else
    {
        [self addWithName:@"Рубашка с кор.рукавом" toArray:dress];
    }
    if(coefficient>-3.5 && coefficient<15.5)
    {
        [self addWithName:@"Легкая кофта" toArray:dress];
    }
    if((coefficient>15.5 && coefficient<21.5) || (coefficient>-9.5 && coefficient<-3.5))
    {
        [self addWithName:@"Пиджак" toArray:dress];
    }
    if(coefficient<-9.5)
    {
        [self addWithName:@"Свитер" toArray:dress];
    }
    if(coefficient>4.5 && coefficient<13.5)
    {
        [self addWithName:@"Ветровка" toArray:dress];
    }
    if(coefficient>-6.5 && coefficient<4.5)
    {
        [self addWithName:@"Пальто" toArray:dress];
    }
    if(coefficient<-6.5)
    {
        [self addWithName:@"Пуховик" toArray:dress];
    }
    
    self.body=[dress copy];
    [dress removeAllObjects];
//legs
    
    if(coefficient<2.5)
    {
        [self addWithName:@"Подштанники" toArray:dress];
    }
    [self addWithName:@"Брюки" toArray:dress];
    
    self.legs=[dress copy];
    [dress removeAllObjects];
//foot
    if(coefficient<-4.5)
    {
       [self addWithName:@"Зимние ботинки" toArray:dress];
    }
    else if(coefficient<6.5)
         {
            [self addWithName:@"Ботинки" toArray:dress];
         }
         else
         {
            [self addWithName:@"Туфли" toArray:dress];
         }
    self.foot=[dress copy];
    dress=nil;
    
}
//-----------------------------------------------------------------------------------------------
-(void)manFree
{
    NSMutableArray *dress=[NSMutableArray array];
    
//head
    if(coefficient<-7.5)
    {
        [self addWithName:@"Шарф" toArray:dress];
        [self addWithName:@"Шапка" toArray:dress];
    }
    else if(coefficient<8.5)
    {
        [self addWithName:@"Легкая шапка" toArray:dress];
    }
    else
    {
        [self addWithName:@"Бейсболка" toArray:dress];
    }
    
    self.head=[dress copy];
    [dress removeAllObjects];
    
//body
    
    [self addWithName:@"Футболка" toArray:dress];
    
    if(coefficient>-9.5 && coefficient<15.5)
    {
        [self addWithName:@"Толстовка" toArray:dress];
    }
    if(coefficient>15.5 && coefficient<21.5)
    {
        [self addWithName:@"Ветровка" toArray:dress];
    }
    if(coefficient>-3.5 && coefficient<9.5)
    {
        [self addWithName:@"Куртка" toArray:dress];
    }
    if(coefficient<-9.5)
    {
        [self addWithName:@"Свитер" toArray:dress];
    }
    if(coefficient<-3.5)
    {
        [self addWithName:@"Пуховик" toArray:dress];
    }
    
    self.body=[dress copy];
    [dress removeAllObjects];
//legs
    if(coefficient<-1.5)
    {
        [self addWithName:@"Подштанники" toArray:dress];
    }
    if(coefficient<23.5)
    {
        [self addWithName:@"Джинсы" toArray:dress];
    }
    else
    {
        [self addWithName:@"Шорты" toArray:dress];
    }
    
    self.legs=[dress copy];
    [dress removeAllObjects];
//foot
    if(coefficient<-4.5)
    {
        [self addWithName:@"Зимние ботинки" toArray:dress];
    }
    else if(coefficient<9.5)
         {
             [self addWithName:@"Ботинки" toArray:dress];
         }
         else if(coefficient<23.5)
              {
                [self addWithName:@"Кеды" toArray:dress];
              }
              else
              {
                   [self addWithName:@"Сандали" toArray:dress];
              }
    self.foot=[dress copy];
    dress=nil;
}
//-------------------------------------------------------------------------------------------------
-(void)manEveryday
{
    NSMutableArray *dress=[NSMutableArray array];
    
//head
    if(coefficient<-7.5)
    {
        [self addWithName:@"Шарф" toArray:dress];
        [self addWithName:@"Шапка" toArray:dress];
    }
    else if(coefficient<9.5)
    {
        [self addWithName:@"Кепка" toArray:dress];
    }
    else
    {
        [self addWithName:@"Шляпа" toArray:dress];
    }
    
    self.head=[dress copy];
    [dress removeAllObjects];
    
//body
    if(coefficient<23.5)
    {
        [self addWithName:@"Рубашка с дл.рукавом" toArray:dress];
    }
    else
    {
        [self addWithName:@"Футболка Поло" toArray:dress];
    }
    if(coefficient>-3.5 && coefficient<15.5)
    {
        [self addWithName:@"Легкая кофта" toArray:dress];
    }
    if((coefficient>15.5 && coefficient<21.5) || (coefficient>-9.5 && coefficient<-3.5))
    {
        [self addWithName:@"Пиджак" toArray:dress];
    }
    if(coefficient<-9.5)
    {
        [self addWithName:@"Свитер" toArray:dress];
    }
    if(coefficient>4.5 && coefficient<13.5)
    {
        [self addWithName:@"Ветровка" toArray:dress];
    }
    if(coefficient>-6.5 && coefficient<4.5)
    {
        [self addWithName:@"Пальто" toArray:dress];
    }
    if(coefficient<-6.5)
    {
        [self addWithName:@"Пуховик" toArray:dress];
    }
    
    self.body=[dress copy];
    [dress removeAllObjects];
//legs
    if(coefficient<2.5)
    {
        [self addWithName:@"Подштанники" toArray:dress];
    }
    if(coefficient<15.5)
    {
        [self addWithName:@"Джинсы" toArray:dress];
    }
    else
    {
        [self addWithName:@"Брюки" toArray:dress];
    }

    
    self.legs=[dress copy];
    [dress removeAllObjects];
//foot
    if(coefficient<-4.5)
    {
        [self addWithName:@"Зимние ботинки" toArray:dress];
    }
    else if(coefficient<6.5)
         {
             [self addWithName:@"Ботинки" toArray:dress];
         }
         else if(coefficient<15.5)
              {
                 [self addWithName:@"Туфли" toArray:dress];
              }
              else
              {
                 [self addWithName:@"Мокасины" toArray:dress];
              }
    self.foot=[dress copy];
    dress=nil;
}
//===============================================================================================
-(void)womanOfficial
{
    NSMutableArray *dress=[NSMutableArray array];
    
//head
    
    if(coefficient<-7.5)
    {
        [self addWithName:@"Шарф" toArray:dress];
        [self addWithName:@"Шапка" toArray:dress];
    }
    else if(coefficient<4.5)
    {
        [self addWithName:@"Шапка" toArray:dress];
    }
    else
    {
        [self addWithName:@"Платок" toArray:dress];
    }
    
    self.head=[dress copy];
    [dress removeAllObjects];
    
//body
    if(coefficient<23.5)
    {
        [self addWithName:@"Блуза с дл.рукавом" toArray:dress];
    }
    else
    {
        [self addWithName:@"Блуза" toArray:dress];
    }
    if(coefficient<19.5)
    {
        [self addWithName:@"Пиджак" toArray:dress];
    }
    if(coefficient>8.5 && coefficient<15.5)
    {
        [self addWithName:@"Полупальто" toArray:dress];
    }
    if(coefficient>-7.5 && coefficient<8.5)
    {
        [self addWithName:@"Пальто" toArray:dress];
    }
    if(coefficient<-7.5)
    {
        [self addWithName:@"Шуба" toArray:dress];
    }
    
    self.body=[dress copy];
    [dress removeAllObjects];
    
//legs
    if(coefficient<7.5)
    {
        [self addWithName:@"Колготки" toArray:dress];
        [self addWithName:@"Брюки" toArray:dress];
    }
    else
    {
        [self addWithName:@"Чулки" toArray:dress];
        [self addWithName:@"Юбка" toArray:dress];
    }
    
    self.legs=[dress copy];
    [dress removeAllObjects];
//foot
    if(coefficient<-3.5)
    {
        [self addWithName:@"Зимние сапоги" toArray:dress];
    }
    else if(coefficient<5.5)
         {
            [self addWithName:@"Сапоги" toArray:dress];
         }
         else if(coefficient<14.5)
              {
                [self addWithName:@"Ботильоны" toArray:dress];
              }
              else
              {
                [self addWithName:@"Туфли" toArray:dress];
              }
    
    self.foot=[dress copy];
    dress=nil;
}
//-----------------------------------------------------------------------------------------------
-(void)womanFree
{
    NSMutableArray *dress=[NSMutableArray array];
    
//head
    if(coefficient<-7.5)
    {
        [self addWithName:@"Шарф" toArray:dress];
        [self addWithName:@"Шапка" toArray:dress];
    }
    else if(coefficient<6.5)
         {
            if(rand()%100<50)
            {
                [self addWithName:@"Легкая шапка" toArray:dress];
            }
            else
            {
                [self addWithName:@"Наушники" toArray:dress];
            }

         }
         else
         {
            [self addWithName:@"Бейсболка" toArray:dress];
         }
    
    self.head=[dress copy];
    [dress removeAllObjects];
    
//body
    if(coefficient<23.5)
    {
        [self addWithName:@"Футболка с дл.рукавом" toArray:dress];
    }
    else
    {
        [self addWithName:@"Футболка" toArray:dress];
    }
    if((coefficient>15.5 && coefficient<19.5) || (coefficient>-4.5 && coefficient<9.5))
    {
        [self addWithName:@"Толстовка" toArray:dress];
    }
    if(coefficient<-4.5)
    {
        [self addWithName:@"Свитер" toArray:dress];
    }
    if(coefficient>9.5 && coefficient<15.5)
    {
        [self addWithName:@"Ветровка" toArray:dress];
    }
    if(coefficient>-4.5 && coefficient<9.5)
    {
        [self addWithName:@"Куртка" toArray:dress];
    }
    if(coefficient<-4.5)
    {
        [self addWithName:@"Пуховик" toArray:dress];
    }
    
    self.body=[dress copy];
    [dress removeAllObjects];
//legs
    if(coefficient<3)
    {
        [self addWithName:@"Колготки" toArray:dress];
    }
    if(coefficient<23.5)
    {
        [self addWithName:@"Джинсы" toArray:dress];
    }
    else
    {
        if(rand()%100<50)
        {
            [self addWithName:@"Шорты" toArray:dress];
        }
        else
        {
            [self addWithName:@"Юбка" toArray:dress];
        }
    }


    
    self.legs=[dress copy];
    [dress removeAllObjects];
//foot
    if(coefficient<-3.5)
    {
        [self addWithName:@"Зимние ботинки" toArray:dress];
    }
    else if(coefficient<10.5)
         {
                [self addWithName:@"Ботинки" toArray:dress];
         }
         else if(coefficient<23.5)
              {
                 [self addWithName:@"Кеды" toArray:dress];
              }
              else
              {
                 [self addWithName:@"Сандали" toArray:dress];
              }
    self.foot=[dress copy];
    dress=nil;
}
//-----------------------------------------------------------------------------------------------
-(void)womanEveryday
{
    NSMutableArray *dress=[NSMutableArray array];
    
//head
    
    if(coefficient<-7.5)
    {
        [self addWithName:@"Шарф" toArray:dress];
        [self addWithName:@"Шапка" toArray:dress];
    }
    else if(coefficient<4.5)
    {
        [self addWithName:@"Шапка" toArray:dress];
    }
    else
    {
        [self addWithName:@"Платок" toArray:dress];
    }
    
    self.head=[dress copy];
    [dress removeAllObjects];
    
//body
    
    [self addWithName:@"Платье" toArray:dress];
    
    if(coefficient>14.5 && coefficient<19.5)
    {
        [self addWithName:@"Пиджак" toArray:dress];
    }
    if(coefficient>8.5 && coefficient<15.5)
    {
        [self addWithName:@"Полупальто" toArray:dress];
    }
    if(coefficient>-3.5 && coefficient<8.5)
    {
        [self addWithName:@"Пальто" toArray:dress];
    }
    if(coefficient<-3.5)
    {
        [self addWithName:@"Шуба" toArray:dress];
    }
    
    self.body=[dress copy];
    [dress removeAllObjects];
    
//legs
    if(coefficient<15.5)
    {
        [self addWithName:@"Колготки" toArray:dress];
    }
    else
    {
        [self addWithName:@"Чулки" toArray:dress];
    }
    
    self.legs=[dress copy];
    [dress removeAllObjects];
//foot
    if(coefficient<-3.5)
    {
        [self addWithName:@"Зимние сапоги" toArray:dress];
    }
    else if(coefficient<5.5)
         {
            [self addWithName:@"Сапоги" toArray:dress];
         }
         else if(coefficient<14.5)
              {
                [self addWithName:@"Ботильоны" toArray:dress];
              }
              else
              {
                [self addWithName:@"Туфли" toArray:dress];
              }
    
    self.foot=[dress copy];
    dress=nil;
    
}
//==============================================================================================
@end

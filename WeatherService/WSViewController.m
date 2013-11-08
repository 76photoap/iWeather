//
//  WSViewController.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/1/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSViewController.h"

@interface WSViewController ()

#define getForecast @"getForecast"
#define getLocation @"getLocation"
#define getCities @"getCities"

#define UnicodeIcon @"\u00B0"

#define updateFrame CGRectMake(0, -400 , 320, 400)

#define viewCount 4
#define weekViewCount 5

#define dayWidth 60
#define dayOffset 10
#define dayStep 80
#define dayCoordinateY 204
#define dayOriginOffset 65

#define weekHeight 32
#define weekWidth 300
#define weekStep 35
#define weekCoordinateX 10
#define weekCoordinateY 276
#define weekOffset 0
#define weekOriginOffset 80

@end
//-------------------------------------------------------------------------------------------------
@implementation WSViewController

@synthesize labelCity;
@synthesize labelDate;
@synthesize labelPressure;
@synthesize labelTemperature;
@synthesize labelTempFlik;
@synthesize labelWet;
@synthesize labelWind;
@synthesize labelTempIcon;

@synthesize weatherImage;
@synthesize imageLine;
@synthesize imageWet;
@synthesize imageWind;

@synthesize backGround;

@synthesize notFoundImage;

@synthesize viewArray;
@synthesize weekViewArray;
@synthesize GPS;
@synthesize curentLocation;
@synthesize xmlData;
@synthesize forecastArray;
@synthesize forecast;
@synthesize numberDay;
@synthesize isScroll;
@synthesize isUpdate;
@synthesize connectionName;
@synthesize updateView;
//------------------------------------------------------------------------------------------
- (MFSideMenuContainerViewController *)menuContainerViewController
{
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}
//-------------------------------------------------------------------------------------------
-(void)updateWeather
{
    if([[WSSettings sharedSettings]isFirstWeather])
    {
        [self GPSOn];
        
        [[WSSettings sharedSettings]setNoFirstWeather];
    }
    else
    {
        [self downloadAllForecasts];
    }
    
    [[self menuContainerViewController]setPanMode:MFSideMenuPanModeDefault];
    
    [[[self menuContainerViewController]leftMenuViewController]viewWillAppear:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[self menuContainerViewController]setPanMode:MFSideMenuPanModeDefault];
}
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    self.forecastArray=[NSMutableArray array];
    
    [self setInterface];
    
    [self updateWeather];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)shift
{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        CGFloat topBarOffset =20;
        
        NSMutableArray *newViews=[NSMutableArray array];
        
        for(int i=1;i<[self.view.subviews count];i++)
        {
            UIView *view=[self.view.subviews objectAtIndex:i];
            
            if(view.tag!=-1)
            {
                [view removeFromSuperview];
                
                CGRect frame=view.frame;
                frame.origin.y+=(topBarOffset/2);
                view.frame=frame;
                
                [newViews addObject:view];
                
                i--;
            }
        }
        for(int i=0;i<[newViews count];i++)
        {
            [self.view addSubview:[newViews objectAtIndex:i]];
        }
    }
}
//===========================================================================================================
-(void)setInterface
{
    [self setPanRecognizer];
    
    [self setDayViews];
    
    [self setWeekViews];
    
    [self shift];
    
    [self setNotFound];
    
    
	[self highlightViewAtIndex:0];
    
    if([[WSSettings sharedSettings]isIphone5])
    {
        [self setIphone5Design];
    }
    
    self.labelTempIcon.text=UnicodeIcon;
    
    [self createUpdateView];
}
-(void)setPanRecognizer
{
    UIPanGestureRecognizer *panRecognizer=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPan:)];
    
    [panRecognizer setMaximumNumberOfTouches:1];
    
    [self.view addGestureRecognizer:panRecognizer];
}
-(void)setDayViews
{
    viewArray=[NSMutableArray array];
    
    NSUInteger offset=0;
    
    if([[WSSettings sharedSettings]isIphone5])
    {
        offset=dayOriginOffset;
    }
    
    for(int i=0;i<viewCount;i++)
    {
        WSView *view=[WSView viewFromNib];
        
        [view setFrame:CGRectMake((dayOffset+dayStep*i),dayCoordinateY+offset,dayWidth,dayWidth)];
        
        [view addTapRecognizer];
        
        [view setDelegate:self];

        
        NSString *day;
        switch (i)
        {
            case 0:day=@"НОЧЬ";break;
                
            case 1:day=@"УТРО";break;
                
            case 2:day=@"ДЕНЬ";break;
                
            case 3:day=@"ВЕЧЕР";break;
        }
        view.time.text=day;
        
        
        [view setBackgroundColor:[UIColor clearColor]];
        
        [[WSSettings sharedSettings]roundView:view borderRadius:30.0f borderWidth:0.5f color:[UIColor whiteColor]];
        
        
        [self.view insertSubview:view atIndex:[self.view.subviews count]-8];
        
        [viewArray addObject:view];
    }
}
-(void)setWeekViews
{
    weekViewArray=[NSMutableArray array];
    
    NSUInteger offset=0,originOffset=0;
    if([[WSSettings sharedSettings]isIphone5])
    {
        offset=weekOffset;
        originOffset=weekOriginOffset;
    }
    
    for(int i=0;i<weekViewCount;i++)
    {
        WSWeekView *weekView=[WSWeekView viewFromNib];
        
        [weekView setFrame:CGRectMake(weekCoordinateX,weekCoordinateY+originOffset+(weekStep+offset)*i, weekWidth, weekHeight)];
        
        [weekView addTapRecognizer];
        
        [weekView setDelegate:self];
        
        [weekView setTag:i];
        
        if(!i)
        {
            weekView.weekDayLabel.text=@"Сегодня";
        }
        
        
        [[WSSettings sharedSettings]roundView:weekView borderRadius:15.0 borderWidth:0.0 color:nil];
        
        weekView.backgroundColor=[UIColor clearColor];
        
        [self.view insertSubview:weekView atIndex:[self.view.subviews count]-8];
        
        [weekViewArray addObject:weekView];
    }
}
-(void)setNotFound
{
    self.notFoundImage=[[UIImageView alloc]init];
    
    self.notFoundImage.frame=[[UIScreen mainScreen]bounds];
    
    self.notFoundImage.tag=-1;
    
    NSString *imageName=@"NotFound.png";
    
    if([[WSSettings sharedSettings]isIphone5])
    {
        imageName=[NSString stringWithFormat:@"5%@",imageName];
    }
    
    self.notFoundImage.image=[UIImage imageNamed:imageName];
    
    self.notFoundImage.alpha=1.0f;
    isNotFound=YES;
    
    [self.view insertSubview:self.notFoundImage atIndex:[self.view.subviews count]-3];
}

-(void)showNotFound
{
    if(isNotFound)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0f];
        
        self.notFoundImage.alpha=0.0f;
        
        [UIView commitAnimations];

        isNotFound=NO;
        
    }
    else
    {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0f];

        
        self.notFoundImage.alpha=1.0f;
        
        [UIView commitAnimations];
        
        isNotFound=YES;
        
    }
}
-(void)setIphone5Design
{
    CGRect frame=self.labelCity.frame;
    
    frame.origin.x=0;
    frame.origin.y+=30;
    frame.size.width=[[UIScreen mainScreen]bounds].size.width;
    
    self.labelCity.frame=frame;
    
    
    
    frame=self.labelDate.frame;
    
    frame.origin.y+=25;
    
    self.labelDate.frame=frame;
    
    
    
    frame=self.labelTemperature.frame;
    
    frame.origin.y+=40;
    
    self.labelTemperature.frame=frame;
    
    
    
    frame=self.labelTempIcon.frame;
    
    frame.origin.y+=40;
    
    self.labelTempIcon.frame=frame;
    
    
    
    frame=self.weatherImage.frame;
    
    frame.origin.y+=40;
    
    self.weatherImage.frame=frame;
    
    
    
    frame=self.labelTempFlik.frame;
    
    frame.origin.y+=52;
    
    self.labelTempFlik.frame=frame;
    
    
    
    frame=self.labelPressure.frame;
    
    frame.origin.y+=50;
    
    self.labelPressure.frame=frame;
    
    
    
    frame=self.labelWind.frame;
    
    frame.origin.y+=50;
    
    self.labelWind.frame=frame;
    
    
    
    frame=self.labelWet.frame;
    
    frame.origin.y+=50;
    
    self.labelWet.frame=frame;
    
    
    
    frame=self.imageLine.frame;
    
    frame.origin.y+=63;
    
    self.imageLine.frame=frame;
    
    
    
    frame=self.imageWind.frame;
    
    frame.origin.y+=50;
    
    self.imageWind.frame=frame;
    
    
    frame=self.imageWet.frame;
    
    frame.origin.y+=50;
    
    self.imageWet.frame=frame;
}
//===========================================================================================================
-(IBAction)backButtonPush:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}
-(IBAction)openCityList:(id)sender
{
    if(self.connectionName==nil)
    {
        WSCitySearchControllerViewController *cityController=[[WSCitySearchControllerViewController alloc]initWithNibName:@"WSCitySearchControllerViewController" bundle:nil];
        
        [self.navigationController pushViewController:cityController animated:YES];
        
        [[self menuContainerViewController]setPanMode:MFSideMenuPanModeNone];
    }
}
-(IBAction)findByGPS:(id)sender
{
    [self GPSOn];
}
//===========================================================================================================
-(void)GPSOn
{
    self.GPS = [CLLocationManager new];
    
    GPS.delegate = self;
    GPS.desiredAccuracy = kCLLocationAccuracyBest;
    
    [GPS startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)locationManager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;
{
    self.curentLocation=newLocation;
    
    [GPS stopUpdatingLocation];
    
    self.GPS=nil;

    [self downloadXML:[self generateGoogleAddress] withConnectionName:getLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Ошибка" message:@"Невозможно получить GPS координаты. Пожалуйста, попробуйте позже" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];

    [self.GPS stopUpdatingLocation];
    
    self.GPS=nil;
}
//===========================================================================================================
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==activeConnection)
    {
        [self.xmlData appendData:data];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection!=activeConnection || connection==nil)
    {
        return;
    }
    
    if([self.connectionName isEqualToString:getForecast])
    {
        [self parseAndAddForecast];
        
        self.connectionName=nil;
        
        if(self.isScroll)
        {
            [self viewWillRestore];
        }
        return;
    }
    if([self.connectionName isEqualToString:getLocation])
    {
        [self getCityAndCountryName];
        return;
    }
    if([self.connectionName isEqualToString:getCities])
    {
        [self getCityID];
        
        return;
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [activeConnection cancel];
    activeConnection=nil;
    self.connectionName=nil;
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Ошибка" message:@"Пожалуйста, проверьте ваше интернет соединение" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alertView show];
    
    if(self.isScroll)
    {
        [self viewWillRestore];
    }
}
//===========================================================================================================
-(void)downloadXML:(NSString *)address withConnectionName:(NSString *)name
{
    NSURL *url=[NSURL URLWithString:address];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    activeConnection=[NSURLConnection connectionWithRequest:request delegate:self];
    
    if(activeConnection)
    {
        self.xmlData=[NSMutableData data];
        
        self.connectionName=name;
    }
}
-(void)parseAndAddForecast
{
    NSError *error=nil;
    NSMutableDictionary *forecastDict=[[XMLReader dictionaryForXMLData:self.xmlData error:&error]mutableCopy];
    [forecastDict setObject:[NSDate date] forKey:kUpdate];
    
    NSUInteger index=[[WSSettings sharedSettings]currentIndex];
    
    
    if(isUpdate)
    {
        [self.forecastArray replaceObjectAtIndex:index withObject:forecastDict];
    }
    else
    {
        [self.forecastArray insertObject:forecastDict atIndex:index];
    }
    
    [WSSettings sharedSettings].forecastArray=[self.forecastArray copy];
    
    [[[self menuContainerViewController]leftMenuViewController]viewWillAppear:NO];
    
    [self setWeather];
}

-(void)downloadAllForecasts
{
    WSDownload *download=[[WSDownload alloc]initWithArray:[[WSSettings sharedSettings]cityArray]];
    
    [download setDelegate:self];
    
    [download beginDownload];
}

-(void)downloadFinished:(NSArray *)xmlArray withSuccess:(BOOL)isSuccess
{
    if(isSuccess)
    {
        for(NSData *data in xmlArray)
        {
            NSError *error=nil;
            NSMutableDictionary *dictionary=[[XMLReader dictionaryForXMLData:data error:&error]mutableCopy];
            
            [dictionary setObject:[NSDate date] forKey:kUpdate];
            
            [self.forecastArray addObject:dictionary];
        }
        
        [[[self menuContainerViewController]leftMenuViewController]viewWillAppear:NO];
        
        [self setWeather];
    }
    else
    {
        self.forecastArray=[[WSSettings sharedSettings]forecastArray];
        
        if([self.forecastArray count])
        {
            [self setWeather];
        }
    }
}
//===========================================================================================================
-(NSString*)generateSearchAddress
{
    NSString *address=[NSString stringWithFormat:@"http://xml.weather.co.ua/1.2/city/?search=%@&lang=ru",currentCity];
    
    address=[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return address;
}
-(NSString*)generateGoogleAddress
{
    return [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/xml?latlng=%f,%f&sensor=true&language=ru",curentLocation.coordinate.latitude,curentLocation.coordinate.longitude];
}
-(NSString*)generateForecastAddress:(NSString*)IDs
{
    return [NSString stringWithFormat:@"http://xml.weather.co.ua/1.2/forecast/%@?dayf=5&lang=ru",IDs];
}
//=============================================================================================
-(void)setWeather
{
    if([self.forecastArray count]==0)
    {
        return;
    }
    else if(isNotFound)
    {
         [self showNotFound];
    }

    
    NSUInteger index=[[WSSettings sharedSettings]currentIndex];
    self.forecast=[self.forecastArray objectAtIndex:index];
    
    
    [self unhihtlightView];
    [self highlightViewAtIndex:0];
    
    [self setCurrentWeather];
    
    if(isNotFound==NO)
    {
        [self setForecastWeather];
    }
}
-(void)setCurrentWeather
{
    self.labelCity.text=[[WSSettings sharedSettings]currentCity];
    
    [self setCurrentDate];
    
    if([[[[self.forecast objectForKey:@"forecast"]objectForKey:@"current"]allKeys]count]==1)
    {
        [self weatherFromForecast];
    }
    else
    {
        [self weatherFromCurrent];
    }
}
-(void)setCurrentDate
{
    NSDateFormatter *formatter=[NSDateFormatter new];
    [formatter setDateFormat:@"E, d MMM"];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"ru_RU"]];
    self.labelDate.text=[[formatter stringFromDate:[NSDate date]]capitalizedString];
}
-(void)weatherFromCurrent
{
    NSDictionary *currentWeather=[[self.forecast objectForKey:@"forecast"]objectForKey:@"current"];
    
    NSString *index=[[currentWeather objectForKey:@"p"]objectForKey:@"text"];
    self.labelPressure.text=[NSString stringWithFormat:@"%@ мм рт.ст.",index];
    
    index=[[currentWeather objectForKey:@"w"]objectForKey:@"text"];
    self.labelWind.text=[NSString stringWithFormat:@"%@ м/с",index];
    
    index=[[currentWeather objectForKey:@"h"]objectForKey:@"text"];
    self.labelWet.text=[NSString stringWithFormat:@"%@%c",index,'%'];
    
    index=[[currentWeather objectForKey:@"t"]objectForKey:@"text"];
    self.labelTemperature.text=[NSString stringWithFormat:@"%@",[index stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+"]]];
    
    index=[[currentWeather objectForKey:@"t_flik"]objectForKey:@"text"];
    self.labelTempFlik.text=[NSString stringWithFormat:@"Ощущается как %@\u00B0",[index stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+"]]];
    
    NSUInteger degree=[[[currentWeather objectForKey:@"w_rumb"]objectForKey:@"text"]integerValue];
    index=[self windFromDegree:degree];
    self.imageWind.image=[UIImage imageNamed:index];
    
    index=[[currentWeather objectForKey:@"pict"]objectForKey:@"text"];
    index=[index stringByReplacingOccurrencesOfString:@"gif" withString:@"png"];
    
    NSDateFormatter *formatter=[NSDateFormatter new];
    [formatter setDateFormat:@"HH"];
    NSUInteger hour=[[formatter stringFromDate:[NSDate date]]integerValue];
    
    if(hour<9 && hour>21 && [index isEqualToString:@"_0_sun.png"])
    {
        index=@"_0_moon.png";
    }
    if(hour>=9 && hour<=21 && [index isEqualToString:@"_0_moon.png"])
    {
        index=@"_0_sun.png";
    }
    if(hour<9 && hour>21 && [index isEqualToString:@"_1_sun_cl.png"])
    {
        index=@"_1_moon_cl.png";
    }
    if(hour>=9 && hour<=21 && [index isEqualToString:@"_1_moon_cl.png"])
    {
        index=@"_1_sun_cl.png";
    }
    
    index=[NSString stringWithFormat:@"big%@",index];
    self.weatherImage.image=[UIImage imageNamed:index];
    
    [self changeBackgroundWithImage:[UIImage imageNamed:[self backgroundFromWeather:index]]];

}
-(void)weatherFromForecast
{
    if([[[[self.forecast objectForKey:@"forecast"]objectForKey:@"forecast"]objectForKey:@"day"] isKindOfClass:[NSDictionary class]])
    {
        [self showNotFound];
        return;
    }
    
    NSDictionary *dayDictionary=[[[[self.forecast objectForKey:@"forecast"]objectForKey:@"forecast"]objectForKey:@"day"]objectAtIndex:0];
    
    
    NSString *index=[[dayDictionary objectForKey:@"pict"]objectForKey:@"text"];
    index=[index stringByReplacingOccurrencesOfString:@"gif" withString:@"png"];
    
    NSDateFormatter *formatter=[NSDateFormatter new];
    [formatter setDateFormat:@"HH"];
    NSUInteger hour=[[formatter stringFromDate:[NSDate date]]integerValue];
    
    if(hour<9 && hour>21 && [index isEqualToString:@"_0_sun.png"])
    {
       index=@"_0_moon.png";
    }
    if(hour>=9 && hour<=21 && [index isEqualToString:@"_0_moon.png"])
    {
        index=@"_0_sun.png";
    }
    if(hour<9 && hour>21 && [index isEqualToString:@"_1_sun_cl.png"])
    {
        index=@"_1_moon_cl.png";
    }
    if(hour>=9 && hour<=21 && [index isEqualToString:@"_1_moon_cl.png"])
    {
        index=@"_1_sun_cl.png";
    }
    index=[NSString stringWithFormat:@"big%@",index];
    self.weatherImage.image=[UIImage imageNamed:index];
    
    
    [self changeBackgroundWithImage:[UIImage imageNamed:[self backgroundFromWeather:index]]];
    
    
    NSDictionary *dictionary=[dayDictionary objectForKey:@"t"];
    index=[[dictionary objectForKey:@"min"]objectForKey:@"text"];
    self.labelTemperature.text=[NSString stringWithFormat:@"%@",index];
    
    self.labelTempFlik.text=[NSString stringWithFormat:@"Ощущается как %@\u00B0",index];
    
    index=[[[dayDictionary objectForKey:@"p"]objectForKey:@"max"]objectForKey:@"text"];
    self.labelPressure.text=[NSString stringWithFormat:@"%@ мм рт ст",index];
    
    index=[[[dayDictionary objectForKey:@"wind"]objectForKey:@"max"]objectForKey:@"text"];
    self.labelWind.text=[NSString stringWithFormat:@"%@ м/с",index];
    
    NSUInteger degree=[[[[dayDictionary objectForKey:@"wind"] objectForKey:@"rumb"]objectForKey:@"text"]integerValue];
    index=[self windFromDegree:degree];
    self.imageWind.image=[UIImage imageNamed:index];
    
    index=[[[dayDictionary objectForKey:@"hmid"]objectForKey:@"max"]objectForKey:@"text"];
    self.labelWet.text=[NSString stringWithFormat:@"%@%c",index,'%'];

}

-(void)setForecastWeather
{
    int index=[self setDayWeather:0];
    
    [self setWeekWeather:index];
}
-(NSUInteger)setDayWeather:(NSUInteger)numDay
{
    
    NSArray *dayArray=[[[self.forecast objectForKey:@"forecast"]objectForKey:@"forecast"]objectForKey:@"day"];
    
    NSInteger i=0,zone=0,tag;
    
    if(!numDay)
    {        
        zone=[self getDifferentZones];
    }
    else
    {
        i=[self findFirstIndex:dayArray skipDay:numDay];
    }

    for(int j=0;j<viewCount;j++)
    {
        WSView *view=[viewArray objectAtIndex:j];
                
        NSString *pictName,*temperature;
        
        if(i>=[dayArray count])
        {
            //view.temperature.textAlignment=NSTextAlignmentCenter;
            
            temperature=@"-";
            tag=-1;
        }
        else
        {
            NSInteger hour=[[[dayArray objectAtIndex:i]objectForKey:@"hour"]integerValue];
            
            if(!numDay && 3+j*6<(hour+zone))
            {
                //view.temperature.textAlignment=NSTextAlignmentCenter;
                
                temperature=@"-";
                tag=-1;
            }
            else
            {
                //view.temperature.textAlignment=NSTextAlignmentLeft;
                
                pictName=[[[dayArray objectAtIndex:i]objectForKey:@"pict"]objectForKey:@"text"];
                pictName=[pictName stringByReplacingOccurrencesOfString:@"gif" withString:@"png"];
                
                if([pictName isEqualToString:@"_0_sun.png"] && (!j || j==3))
                {
                    pictName=@"_0_moon.png";
                }
                else if([pictName isEqualToString:@"_0_moon.png"] && (j==1 || j==2))
                {
                    pictName=@"_0_sun.png";
                }
                
                if([pictName isEqualToString:@"_1_sun_cl.png"] && (!j || j==3))
                {
                    pictName=@"_1_moon_cl.png";
                }
                else if([pictName isEqualToString:@"_1_moon_cl.png"] && (j==1 || j==2))
                {
                    pictName=@"_1_sun_cl.png";
                }
                
                
                NSDictionary *temperatureDictionary=[[dayArray objectAtIndex:i]objectForKey:@"t"];
                
                int minTemp=[[[temperatureDictionary objectForKey:@"min"]objectForKey:@"text"]integerValue];
                int maxTemp=[[[temperatureDictionary objectForKey:@"max"]objectForKey:@"text"]integerValue];
                
                temperature=[NSString stringWithFormat:@"%d\u00B0",(maxTemp+minTemp)/2];
                
                tag=i++;
            }

        }
               
        view.temperature.text=temperature;
       // view.temperature.textAlignment=NSTextAlignmentCenter;
        
        view.weatherImage.image=[UIImage imageNamed:pictName];
        
        view.tag=tag;
        
        
        [viewArray replaceObjectAtIndex:j withObject:view];
    }
    
    self.numberDay=numDay;

    return i;
}
-(void)setWeekWeather:(NSUInteger)index
{
    NSArray *dayArray=[[[self.forecast objectForKey:@"forecast"]objectForKey:@"forecast"]objectForKey:@"day"];
    
    NSString *formatter;
    NSDateFormatter *dateFormater=[NSDateFormatter new];
    NSLocale *locale=[[NSLocale alloc]initWithLocaleIdentifier:@"ru_RU"];
    [dateFormater setLocale:locale];
    [dateFormater setDateFormat:@"EEEE"];
    
    for(int i=1;i<weekViewCount;i++)
    {
        
        WSWeekView *weekView=[weekViewArray objectAtIndex:i];

        
        formatter=[dateFormater stringFromDate:[[NSDate date]newDateByAddingDays:i]];
        weekView.weekDayLabel.text=[formatter capitalizedString];
        
        
        NSString *pictName=[[[dayArray objectAtIndex:index+2]objectForKey:@"pict"]objectForKey:@"text"];
        pictName=[pictName stringByReplacingOccurrencesOfString:@"gif" withString:@"png"];
        
        if([pictName isEqualToString:@"_0_moon.png"])
        {
            pictName=@"_0_sun.png";
        }
        
        if([pictName isEqualToString:@"_1_moon_cl.png"])
        {
            pictName=@"_1_sun_cl.png";
        }
        
        weekView.weatherImage.image=[UIImage imageNamed:pictName];
        
        
        NSDictionary *temperatureDictionary=[[dayArray objectAtIndex:index+2]objectForKey:@"t"];
        
        NSInteger maxTemperatureDay=[[[temperatureDictionary objectForKey:@"max"]objectForKey:@"text"]integerValue];
        NSInteger minTemperatureDay=[[[temperatureDictionary objectForKey:@"min"]objectForKey:@"text"]integerValue];
        
        temperatureDictionary=[[dayArray objectAtIndex:index+1]objectForKey:@"t"];
        
        NSInteger maxTemperatureMor=[[[temperatureDictionary objectForKey:@"max"]objectForKey:@"text"]integerValue];
        NSInteger minTemperatureMor=[[[temperatureDictionary objectForKey:@"min"]objectForKey:@"text"]integerValue];
        
        temperatureDictionary=[[dayArray objectAtIndex:index+3]objectForKey:@"t"];
        
        NSInteger maxEve=[[[temperatureDictionary objectForKey:@"max"]objectForKey:@"text"]integerValue];
        NSInteger minEve=[[[temperatureDictionary objectForKey:@"min"]objectForKey:@"text"]integerValue];
        
        weekView.maxTempLabel.text=[NSString stringWithFormat:@"%d\u00B0",((maxTemperatureDay+minTemperatureDay)/2+(maxTemperatureMor+minTemperatureMor)/2)/2];
        weekView.minTempLabel.text=[NSString stringWithFormat:@"%d\u00B0",(maxEve+minEve)/2];
        
        
        [weekViewArray replaceObjectAtIndex:i withObject:weekView];
        
        index+=4;
        
    }
}
-(NSInteger)getDifferentZones
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"ZZZ"];
    
    NSString *strApiZone=[[self.forecast objectForKey:@"forecast"]objectForKey:@"last_updated"];
    
    NSInteger apiZone=[[strApiZone substringFromIndex:[strApiZone length]-5]integerValue]/100;
    
    NSInteger zone=[[dateFormatter stringFromDate:[NSDate date]]integerValue]/100;
    
    return zone-apiZone;
}
-(NSInteger)findFirstIndex:(NSArray*)dayArray skipDay:(NSInteger)numDay;
{
    NSInteger i,index=[[WSSettings sharedSettings]currentIndex];
    
    NSDictionary *dayForecast=[self.forecastArray objectAtIndex:index];
    
    NSDateFormatter *dateFormater=[NSDateFormatter new];
    
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    
    NSString *nextDate=[dateFormater stringFromDate:[[dayForecast objectForKey:kUpdate] newDateByAddingDays:numDay]];
    
    for (i=0;i<[dayArray count];i++)
    {
        NSDictionary *dict=[dayArray objectAtIndex:i];
        
        if([[dict objectForKey:@"date"]isEqualToString:nextDate])
        {
            break;
        }
        
    }
    
    return i;
}
-(NSString*)backgroundFromWeather:(NSString *)weather
{
    NSString *background;
    
    if([weather isEqualToString:@"big_0_sun.png"] || [weather isEqualToString:@"big_0_moon.png"])
    {
        background= @"day_clear.png";
    }
    
    if([weather isEqualToString:@"big_1_sun_cl.png"] || [weather isEqualToString:@"big_1_moon_cl.png"])
    {
        background= @"day_cloudy.png";
    }
    if([weather isEqualToString:@"big_2_cloudy.png"] || [weather isEqualToString:@"big_3_pasmurno.png"])
    {
        background= @"day_cloudy.png";
    }
    if([weather isEqualToString:@"big_4_short_rain.png"] || [weather isEqualToString:@"big_5_rain.png"] || [weather isEqualToString:@"big_6_lightning.png"])
    {
        background= @"day_rain.png";
    }
    
    if([weather isEqualToString:@"big_7_hail.png"] || [weather isEqualToString:@"big_8_rain_snow.png"] || [weather isEqualToString:@"big_9_snow.png"] || [weather isEqualToString:@"big_10_heavy_snow.png"])
    {
        background= @"day_snow.png";
    }
    
    NSDateFormatter *formatter=[NSDateFormatter new];
    
    [formatter setDateFormat:@"HH"];
    
    NSUInteger hour=[[formatter stringFromDate:[NSDate date]] integerValue];
    
    if(hour>=9 && hour<21)
    {
        ;
    }
    else
    {
        background=[background substringWithRange:NSMakeRange(3, [background length]-3)];
        background=[NSString stringWithFormat:@"night%@",background];
    }
    
    if([[WSSettings sharedSettings]isIphone5])
    {
        background=[NSString stringWithFormat:@"5%@",background];
    }
    
    return background;
}
-(NSString*)windFromDegree:(NSUInteger)degree
{
    if(degree>=23 && degree<68)
    {
        return @"NE.png";
    }
    if(degree>=68 && degree<113)
    {
        return @"E.png";
    }
    if(degree>=113 && degree<158)
    {
        return @"SE.png";
    }
    if(degree>=158 && degree<203)
    {
        return @"S.png";
    }
    if(degree>=203 && degree<248)
    {
        return @"SW.png";
    }
    if(degree>=248 && degree<293)
    {
        return @"W.png";
    }
    if(degree>=293 && degree<338)
    {
        return @"E.png";
    }
    return @"N.png";
    
}
//======================================================================================================
-(void)highlightViewAtIndex:(NSUInteger)index
{
    WSWeekView *view=(WSWeekView*)weekViewArray[index];
    
    [view.weekDayLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    
    //[view setBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:0.3f]];
}
-(void)unhihtlightView
{
    WSWeekView *view=(WSWeekView*)weekViewArray[self.numberDay];
    
    [view.weekDayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
    
    //[view setBackgroundColor:[UIColor clearColor]];
}
//========================================================================================================
-(void)changeBackgroundWithImage:(UIImage*)image;
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame=self.backGround.frame;
    WSAnimation *animation = [[WSAnimation alloc] init];
    
    [animation startAnimationWithParent:self forReplaceViewWithName:@"backGround" toView:imageView];

}
//=======================================================================================================
-(void)pushOnView:(NSUInteger)number
{
   
    [self unhihtlightView];
    
    [self highlightViewAtIndex:number];
    
    [self setDayWeather:number];
    
}
-(void)pushDayViewWithTag:(NSInteger)tag
{
    if(tag<0 || isNotFound)
    {
        return;
    }
    
//    [self unhihtlightView];
//    [self setDayWeather:0];
//    [self highlightViewAtIndex:0];
    
    [[self menuContainerViewController]setPanMode:MFSideMenuPanModeNone];
    
    
    WSClothViewController *clothController=[[WSClothViewController alloc]initWithNibName:@"WSClothViewController" bundle:nil];
    
    clothController.algorithm=[self collectDataForAlgorithm:tag];
    
    [self.navigationController pushViewController:clothController animated:YES];
    
}
//==========================================================================================================
-(void)getCityAndCountryName
{
    NSError *error;
    NSDictionary *dictionary=[XMLReader dictionaryForXMLData:self.xmlData error:&error];
    
    NSArray *addressComponentArray;
    
    if([[[dictionary objectForKey:@"GeocodeResponse"]objectForKey:@"result"] isKindOfClass:[NSArray class]])
    {
        addressComponentArray=[[[[dictionary objectForKey:@"GeocodeResponse"]objectForKey:@"result"]objectAtIndex:0]objectForKey:@"address_component"];
    }
    else
    {
        addressComponentArray=[[[dictionary objectForKey:@"GeocodeResponse"]objectForKey:@"result"]objectForKey:@"address_component"];
    }
    
    BOOL isFind=NO;
    
    for(int i=0;i<[addressComponentArray count];i++)
    {
        NSDictionary *dictionary=[addressComponentArray objectAtIndex:i];
        if([[dictionary objectForKey:@"type"]  isKindOfClass:[NSArray class]])
        {
            NSString *type=[[[dictionary objectForKey:@"type"]objectAtIndex:0]objectForKey:@"text"];
            if(isFind==NO)
            {
                if ([type isEqualToString:@"locality"])
                {
                    currentCity=[[dictionary objectForKey:@"long_name"]objectForKey:@"text"];
                    isFind=YES;
                }
            }
            else
            {
                if ([type isEqualToString:@"country"])
                {
                    currentCountry=[[dictionary objectForKey:@"long_name"]objectForKey:@"text"];
                    break;
                }
            }

        }
    }
    [self downloadXML:[self generateSearchAddress] withConnectionName:getCities];
}
-(void)getCityID
{
    NSError *error;
    NSDictionary *dictionary=[XMLReader dictionaryForXMLData:self.xmlData error:&error];
    
    BOOL isFind=NO,isNoOne=NO;
    
    NSMutableDictionary *mutDictionary=[NSMutableDictionary dictionary];
    
    if([[[dictionary objectForKey:@"city"]objectForKey:@"city"] isKindOfClass:[NSArray class]])
    {
        NSArray *city=[[dictionary objectForKey:@"city"]objectForKey:@"city"];
        
        for(int i=0;i<[city count];i++)
        {
            
            NSDictionary *dict=[city objectAtIndex:i];
            
            if([[[dict objectForKey:@"name"]objectForKey:@"text"]isEqualToString:currentCity] && [[[dict objectForKey:@"country"]objectForKey:@"text"]isEqualToString:currentCountry])
            {
                if(isFind)
                {
                    isNoOne=YES;
                    break;
                }
                
                [mutDictionary setObject:currentCity forKey:kCity];
                [mutDictionary setObject:currentCountry forKey:kCountry];
                [mutDictionary setObject:[dict objectForKey:@"id"] forKey:kID];
                
                isFind=YES;
            }
        }

    }
    else
    {
        NSDictionary *city=[[dictionary objectForKey:@"city"]objectForKey:@"city"];
        
        if([[[city objectForKey:@"name"]objectForKey:@"text"]isEqualToString:currentCity] && [[[city objectForKey:@"country"]objectForKey:@"text"]isEqualToString:currentCountry])
        {
            [mutDictionary setObject:currentCity forKey:kCity];
            [mutDictionary setObject:currentCountry forKey:kCountry];
            [mutDictionary setObject:[city objectForKey:@"id"] forKey:kID];
            
            isFind=YES;
        }
    }
    if(isFind==NO)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Ошибка" message:@"По вашему адресу не найдено городов. Пожалуйста выберите необходимый город вручную" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setTag:2];
        [alert show];
        
        self.connectionName=nil;
        
        return;
    }
    if(isNoOne)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Ошибка" message:@"По вашему адресу найдено несколько городов. Пожалуйста выберите необходимый" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setTag:1];
        [alert show];
        
        self.connectionName=nil;
        
        return;
        
    }
    
    
    NSString *IDs=[mutDictionary objectForKey:kID];
    
    [[WSSettings sharedSettings]addObject:mutDictionary];
    
    [self downloadXML:[self generateForecastAddress:IDs] withConnectionName:getForecast];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    WSCitySearchControllerViewController *searchController=[[WSCitySearchControllerViewController alloc]initWithNibName:@"WSCitySearchControllerViewController" bundle:nil];
    
    if(alertView.tag==1)
    {
        searchController.willSearch=currentCity;
        
        searchController.countryFilter=currentCountry;
    }
    
    [[self menuContainerViewController]setPanMode:MFSideMenuPanModeNone];
    
    [self.navigationController pushViewController:searchController animated:YES];
}
//===========================================================================================================
-(void)onPan:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint translation=[panRecognizer translationInView:self.view];

    if([[self menuContainerViewController]panDirection]==MFSideMenuPanDirectionRight ||isNotFound)
    {
        return;
    }

    if([panRecognizer state]==UIGestureRecognizerStateBegan && self.isUpdate==NO)
    {
        if(self.isScroll==NO && translation.y>0)
        {
            [[self menuContainerViewController]setPanMode:MFSideMenuPanModeNone];
            
            [[self menuContainerViewController]setMenuState:MFSideMenuStateClosed];
            
            [[[self menuContainerViewController]leftMenuViewController]view].hidden=YES;
            
            [self setUpdateTime];
            
            selfOrigFrame=[self.view frame];
            self.isScroll=YES;
        }
        return;
    }
    if([panRecognizer state]==UIGestureRecognizerStateChanged)
    {
        if(self.isScroll && self.isUpdate==NO)
        {
            [self setScrollOffsetWithTranslation:translation];
        }
    }
    if([panRecognizer state]==UIGestureRecognizerStateEnded)
    {
        if(self.isScroll && self.isUpdate==NO)
        {
            CGRect frame=[self.view frame];
            
            self.isUpdate=YES;
            
            if(frame.origin.y>100)
            {
                [self createCloseAnimation];
            }
            else
            {
                [self viewWillRestore];
            }
        }
        return;
    }
}
-(void)createUpdateView
{
    self.updateView=[[[NSBundle mainBundle]loadNibNamed:@"WSUpdateView" owner:self options:nil]lastObject];
    
    [[[self menuContainerViewController] view] addSubview:updateView];
    
    [[[self menuContainerViewController] view] sendSubviewToBack:updateView];
    
}
-(void)setUpdateTime
{
    NSDateFormatter *formatter=[NSDateFormatter new];
    
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"ru_RU"]];
    
    [formatter setDateFormat:@"d MMMM HH:mm"];
    
    NSUInteger index=[[WSSettings sharedSettings]currentIndex];
    NSMutableDictionary *currentForecast=[self.forecastArray objectAtIndex:index];
    NSDate *date=[currentForecast objectForKey:kUpdate];
    
    self.updateView.updateTime.text=[NSString stringWithFormat:@"Обновлено %@",[formatter stringFromDate:date]];
}
-(void)setScrollOffsetWithTranslation:(CGPoint)translation
{
    CGRect frame=selfOrigFrame;
    frame.origin.y+=(translation.y/2);
    [self.view setFrame:frame];
    
    frame=updateFrame;
    frame.origin.y=self.view.frame.origin.y-400;
    [updateView setFrame:frame];
}
-(void)createCloseAnimation
{
    CGRect frame=[self.view frame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(updateDidStop)];
    
    frame.origin.y=100;
    [self.view setFrame:frame];
    
    frame=updateFrame;
    frame.origin.y=-300;
    
    [updateView setFrame:frame];
    
    [UIView commitAnimations];
}
-(void)updateDidStop
{
    NSString *ID=[[WSSettings sharedSettings]currentCityID];
    NSString *url=[self generateForecastAddress:ID];
    [self downloadXML:url withConnectionName:getForecast];
}
-(void)viewWillRestore
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(viewDidRestore)];
    
    self.view.frame=[[UIScreen mainScreen]bounds];
    [updateView setFrame:updateFrame];
    
    [UIView commitAnimations];
    
}
-(void)viewDidRestore
{
    self.isScroll=NO;
    self.isUpdate=NO;
    
    [[self menuContainerViewController]setPanMode:MFSideMenuPanModeDefault];
    
}
//============================================================================================================
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.isUpdate || isNotFound)
    {
        return;
    }
    
    UITouch *touch=[[[event allTouches]allObjects]objectAtIndex:0];
    if([[[[touch view]class]description] isEqualToString:@"UIView"])
    {
        CGPoint location=[touch locationInView:[touch view]];
        UIView *view=[viewArray objectAtIndex:0];
        if(location.y>view.frame.origin.y)
        {
            return;
        }
        
        if(!self.numberDay)
        {
            [[self menuContainerViewController]setPanMode:MFSideMenuPanModeNone];
            
            
            WSClothViewController *clothController=[[WSClothViewController alloc]initWithNibName:@"WSClothViewController" bundle:nil];
            
            clothController.algorithm=[self collectDataForAlgorithm:-1];
            
            [self.navigationController pushViewController:clothController animated:YES];
            
        }
        
        [self unhihtlightView];
        [self highlightViewAtIndex:0];
        [self setDayWeather:0];
    }
}
//=======================================================================================================
-(WSWeatherAlgorithm*)collectDataForAlgorithm:(NSInteger)dayNumber
{
    WSWeatherAlgorithm *algorithm=[WSWeatherAlgorithm new];

    NSString *pictName;
    
    if(dayNumber<0 && [[[[self.forecast objectForKey:@"forecast"]objectForKey:@"current"]allKeys]count]!=1)
    {
        NSDictionary *currentWeather=[[self.forecast objectForKey:@"forecast"]objectForKey:@"current"];
        
        algorithm.temperature=[[[currentWeather objectForKey:@"t"]objectForKey:@"text"]integerValue];
        algorithm.wind=[[[currentWeather objectForKey:@"w"]objectForKey:@"text"]integerValue];
        algorithm.humidity=[[[currentWeather objectForKey:@"h"]objectForKey:@"text"]integerValue];
        algorithm.cloud=[[[currentWeather objectForKey:@"cloud"]objectForKey:@"text"]integerValue];
        pictName=[[currentWeather objectForKey:@"pict"]objectForKey:@"text"];
    }
    else
    {
        if(dayNumber<0)dayNumber++;
        
        NSDictionary *dayDictionary=[[[[self.forecast objectForKey:@"forecast"]objectForKey:@"forecast"]objectForKey:@"day"]objectAtIndex:dayNumber];
        
        algorithm.temperature=[[[[dayDictionary objectForKey:@"t"]objectForKey:@"max"]objectForKey:@"text"]integerValue];
        algorithm.humidity=[[[[dayDictionary objectForKey:@"hmid"]objectForKey:@"max"]objectForKey:@"text"]integerValue];
        algorithm.wind=[[[[dayDictionary objectForKey:@"wind"]objectForKey:@"max"]objectForKey:@"text"]integerValue];
        algorithm.cloud=[[[dayDictionary objectForKey:@"cloud"]objectForKey:@"text"]integerValue];
        pictName=[[dayDictionary objectForKey:@"pict"]objectForKey:@"text"];
    }

    if([[[WSSettings sharedSettings]currentSex]isEqualToString:@"Man"])
    {
        algorithm.sex=WSManSexMan;
    }
    else
    {
        algorithm.sex=WSManSexWomen;
    }
    
    int styleIndex=[[WSSettings sharedSettings]currentStyle];
    algorithm.style=[[[WSSettings sharedSettings]styleArray]objectAtIndex:styleIndex];
    
    NSDateFormatter *formatter=[NSDateFormatter new];
    [formatter setDateFormat:@"HH"];
    NSUInteger hour=[[formatter stringFromDate:[NSDate date]]integerValue];
    
    if([pictName isEqualToString:@"_0_sun.gif"] || ([pictName isEqualToString:@"_0_moon.gif"] && (hour>=9 && hour<=21)))
    {
        algorithm.weatherType=WSWeatherTypeSun;
    }
    else if([pictName rangeOfString:@"rain"].location!=NSNotFound || [pictName rangeOfString:@"lightning"].location!=NSNotFound)
         {
             algorithm.weatherType=WSWeatherTypeRain;
         }
         else
         {
             algorithm.weatherType=WSWeatherTypeNone;
         }
    
    return algorithm;
}
@end

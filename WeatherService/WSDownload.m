//
//  WSDownload.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/28/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSDownload.h"

@implementation WSDownload

-(WSDownload*)initWithArray:(NSArray *)forecast
{
    self=[super init];
    if(self)
    {
        self.forecasts=forecast;
        self.downloadForecast=[NSMutableArray array];
    }
    return self;
}

-(void)beginDownload
{
    [self setConnection];
}
-(void)setConnection
{
    if(currentIndex+1 <=[self.forecasts count])
    {
        NSString *IDs=[[self.forecasts objectAtIndex:currentIndex++]objectForKey:kID];
        
        NSString *address=[NSString stringWithFormat:@"http://xml.weather.co.ua/1.2/forecast/%@?dayf=5&lang=ru",IDs];
        
        NSURL *url=[NSURL URLWithString:address];
        
        NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        NSURLConnection *activeConnection=[NSURLConnection connectionWithRequest:request delegate:self];
        
        if(activeConnection)
        {
            xmlData=[NSMutableData data];
        }
    }
    else
    {
        [self.delegate downloadFinished:self.downloadForecast withSuccess:YES];
        return;
    }


}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate downloadFinished:nil withSuccess:NO];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.downloadForecast addObject:xmlData];
    
    [self setConnection];
}

@end

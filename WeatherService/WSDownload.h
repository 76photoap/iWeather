//
//  WSDownload.h
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/28/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WSDownloadProtocol <NSObject>

@optional

-(void)downloadFinished:(NSArray*)xmlArray withSuccess:(BOOL)isSuccess;

@end
//----------------------------------------------
@interface WSDownload : NSObject<NSURLConnectionDataDelegate>
{
    @private
    
    NSMutableData *xmlData;
    NSUInteger currentIndex;
}

@property(nonatomic)NSArray *forecasts;
@property(nonatomic)NSMutableArray *downloadForecast;
@property(nonatomic,weak)id<WSDownloadProtocol> delegate;

-(WSDownload*)initWithArray:(NSArray*)forecast;
-(void)beginDownload;
-(void)setConnection;

@end

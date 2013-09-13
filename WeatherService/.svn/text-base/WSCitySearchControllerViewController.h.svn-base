//
//  WSCitySearchControllerViewController.h
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/5/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLReader.h"
#import "MFSideMenuContainerViewController.h"

@interface WSCitySearchControllerViewController : UIViewController<UITableViewDataSource,NSURLConnectionDataDelegate,UISearchBarDelegate>
{
    NSMutableData *documentXML;
    
    NSMutableArray *cities;
    NSMutableArray *countries;
    NSMutableArray *IDs;
    
    NSURLConnection *activeConnection;
}

@property(nonatomic)IBOutlet UITableView *mainTable;

@property(nonatomic)IBOutlet UITextField *backgroundField;

@property(nonatomic)IBOutlet UITextField *textField;

@property(nonatomic)IBOutlet UIButton *cancelButton;

@property(nonatomic)NSString *willSearch;

@property(nonatomic)NSString *countryFilter;

-(IBAction)textChange:(id)sender;
-(IBAction)bactToWeather:(id)sender;

-(void)downloadXML:(NSString*)address;
-(void)parse;
-(void)downloadForecast:(NSString*)ID;

-(void)setField;
-(void)setButton;

@end

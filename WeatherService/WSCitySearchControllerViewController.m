//
//  WSCitySearchControllerViewController.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/5/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSCitySearchControllerViewController.h"

@interface WSCitySearchControllerViewController ()

@end

@implementation WSCitySearchControllerViewController

@synthesize mainTable;
@synthesize textField;
@synthesize backgroundField;
@synthesize cancelButton;

@synthesize willSearch;
@synthesize countryFilter;
//----------------------------------------------------------------------------------------------------
-(MFSideMenuContainerViewController*)menuContainerViewController
{
    return (MFSideMenuContainerViewController*)self.navigationController.parentViewController;
}
//----------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setField];
    [self setButton];
    
}
-(void)setField
{
    backgroundField.borderStyle = UITextBorderStyleNone;
    backgroundField.layer.borderWidth = 1.f;
    backgroundField.layer.borderColor = [UIColor colorWithRed:195.0f/255.0f green:195.0f/255.0f blue:195.0f/255.0f alpha:1.0f].CGColor;
    backgroundField.layer.cornerRadius = 14.0f;
    backgroundField.background = nil;
    backgroundField.backgroundColor = [UIColor whiteColor];
    backgroundField.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
}
-(void)setButton
{
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [UIColor colorWithRed:195/255.0f green:195/255.0f blue:195/255.0f alpha:1.0f].CGColor;
    cancelButton.layer.cornerRadius = 6.0f;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[WSSettings sharedSettings]shiftView:self.view withOffset:5.0f];
    
    [self.textField becomeFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.textField setText:self.willSearch];
    
    [self textChange:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//---------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"CellIdentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    }
    
    int indexs=indexPath.row;
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@, %@",[cities objectAtIndex:indexs],[countries objectAtIndex:indexs]];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
    
    [dictionary setObject:[cities objectAtIndex:indexPath.row] forKey:kCity];
    [dictionary setObject:[countries objectAtIndex:indexPath.row] forKey:kCountry];
    [dictionary setObject:[IDs objectAtIndex:indexPath.row] forKey:kID];
     
    [[WSSettings sharedSettings]addObject:dictionary];
    
    
    [self downloadForecast:[dictionary objectForKey:kID]];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.textField resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)downloadForecast:(NSString*)ID
{
    WSViewController *controller=(WSViewController*)[self.navigationController.viewControllers objectAtIndex:0];
    
    NSString *urlAddress=[controller generateForecastAddress:ID];
    
    [controller downloadXML:urlAddress withConnectionName:@"getForecast"];
    
}
//---------------------------------------------------------------------------------
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection != activeConnection) return;
    
    [documentXML appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection != activeConnection) return;
    
    [self parse];
    
    [self.mainTable reloadData];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    cities=countries=nil;
    
    [self.mainTable reloadData];
    
    [activeConnection cancel];
}
//---------------------------------------------------------------------------------------------------
-(void)downloadXML:(NSString *)address
{
    cities=countries=nil;
    
    [self.mainTable reloadData];
    
    
    
    NSString *htmlAddress=[NSString stringWithFormat:@"http://xml.weather.co.ua/1.2/city/?search=%@&lang=ru",address];
    htmlAddress=[htmlAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[NSURL URLWithString:htmlAddress ];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    
    [activeConnection cancel];
    
    activeConnection=[NSURLConnection connectionWithRequest:request delegate:self];
    
    if(activeConnection)
    {
        documentXML=[NSMutableData data];
    }
}
-(void)parse
{
    NSError *error;
    NSDictionary *dictionary=[XMLReader dictionaryForXMLData:documentXML error:&error];
    
    cities=[NSMutableArray array];
    countries=[NSMutableArray array];
    IDs=[NSMutableArray array];
    
    if([[[dictionary objectForKey:@"city"]objectForKey:@"city"] isKindOfClass:[NSArray class]]==NO)
    {
        NSDictionary *cityDictionary=[[dictionary objectForKey:@"city"]objectForKey:@"city"];
        
        if([cityDictionary objectForKey:@"id"]==nil)
        {
            return;
        }
        
        if(!self.countryFilter || [[[cityDictionary objectForKey:@"country"]objectForKey:@"text"] isEqualToString:countryFilter])
        {
            [cities addObject:[[cityDictionary objectForKey:@"name"]objectForKey:@"text"]];
            [countries addObject:[[cityDictionary objectForKey:@"country"]objectForKey:@"text"]];
            [IDs addObject:[cityDictionary objectForKey:@"id"]];
        }
    }
    else
    {
        NSArray *cityArray=[[dictionary objectForKey:@"city"]objectForKey:@"city"];
        
        for(int i=0;i<[cityArray count];i++)
        {
            NSDictionary *cityDictionary=[cityArray objectAtIndex:i];
            
            if(!self.countryFilter || [[[cityDictionary objectForKey:@"country"]objectForKey:@"text"] isEqualToString:countryFilter])
            {
                [cities addObject:[[cityDictionary objectForKey:@"name"]objectForKey:@"text"]];
                [countries addObject:[[cityDictionary objectForKey:@"country"]objectForKey:@"text"]];
                [IDs addObject:[cityDictionary objectForKey:@"id"]];
            }
        }
    }
}
//--------------------------------------------------------------------------------------------
-(IBAction)textChange:(id)sender
{
    if([self.textField.text length]<3)
    {
        cities=countries=nil;
        
        [mainTable reloadData];
    }
    else
    {
        [self downloadXML:self.textField.text];
    }
}
-(IBAction)bactToWeather:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//--------------------------------------------------------------------------------------------
@end

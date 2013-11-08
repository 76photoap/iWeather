//
//  WSMenuViewController.m
//  iWeather
//
//  Created by Cornholio Zozobra on 7/31/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSMenuViewController.h"

#define headerRect CGRectMake(0,0,320,35)
#define path  @"MenuList.plist"

@interface WSMenuViewController ()

@end
//-------------------------------------------------------------------------------------------------
@implementation WSMenuViewController

@synthesize table;
@synthesize tableItems;
@synthesize cities;
@synthesize prepareDelete;
@synthesize containerController;
//-------------------------------------------------------------------------------------------------
- (UINavigationController *)navigationController:(UIViewController*)controller
{
    return [[UINavigationController alloc]initWithRootViewController:controller];
}
//-------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        NSString *bundlePath=[[NSBundle mainBundle]pathForResource:path ofType:nil];
        self.tableItems=[NSArray arrayWithContentsOfFile:bundlePath];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.cities=[[WSSettings sharedSettings]citiesArray];
    
    self.prepareDelete=NO;
    
    [self.table reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    self.table.tableHeaderView=[[UIView alloc]initWithFrame:headerRect];
    
    self.table.backgroundColor =[UIColor clearColor];
    self.table.opaque = NO;
    self.table.backgroundView = nil;
    
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//---------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableItems count]+[self.cities count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"CellIdentifier";
    
    WSWeatherCell *cell=(WSWeatherCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell==nil)
    {
        cell=[WSWeatherCell cell];
        
        cell.delegate=self;
        
        [cell setRecognizer];
        
        if(prepareDelete)
        {
           cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        else
        {
            cell.selectionStyle=UITableViewCellSelectionStyleGray;
        }
        
    }
    if(indexPath.row<2)
    {
        cell.cityLabel.text=[NSString stringWithFormat:@"     %@",[self.tableItems objectAtIndex:indexPath.row]];
        
        cell.tag=-indexPath.row-1;
        
        if(!indexPath.row)
        {
            cell.icon.image=[UIImage imageNamed:@"_0_sun.png"];
        }
        else
        {
            cell.icon.image=[UIImage imageNamed:@"City.png"];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
    }
    else
    {
        
        if([self.cities count]+2<=indexPath.row)
        {
            cell.tag=-(indexPath.row-[self.cities count])-1;
            
            if(cell.tag==-3)
            {
                cell.icon.image=[UIImage imageNamed:@"Setting.png"];
                
                cell.cityLabel.text=[NSString stringWithFormat:@"     %@",[self.tableItems objectAtIndex:indexPath.row-[self.cities count]]];
            }
            else
            {
                cell.cityLabel.text=[self.tableItems objectAtIndex:indexPath.row-[self.cities count]];
            }
            
            
        }
        else
        {
            CGRect frame=cell.cityLabel.frame;
            
            frame.origin.x-=1;
            
            cell.cityLabel.frame=frame;
            
            cell.cityLabel.text=[NSString stringWithFormat:@"      %@",[self.cities objectAtIndex:indexPath.row-2]];
            
            cell.cityLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
            
            cell.tag=indexPath.row-2;
            
            if(cell.tag==[[WSSettings sharedSettings]currentIndex])
            {
                cell.icon.image=[UIImage imageNamed:@"Select2.png"];
            }

            if(self.prepareDelete)
            {
                [cell showButton];
            }
            else
            {
                [cell hideButton];
            }
            
        }
        
    }
    
    cell.row=indexPath.row;
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.prepareDelete)
    {
        self.prepareDelete=NO;
        
        [self.table reloadData];
    }
    else
    {
        if([[[self.containerController centerViewController]topViewController]isKindOfClass:[WSViewController class]])
        {
            centralController=(WSViewController*)[[self.containerController centerViewController]topViewController];
        }
        
        WSWeatherCell *cell=(WSWeatherCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        if(cell.tag>=0)
        {
            [self openCityWithTag:cell.tag];
        }
        else
        {
            [self openControllerWithTag:cell.tag];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
//-----------------------------------------------------------------------------------------------
-(void)openCityWithTag:(NSInteger)tag
{
    [[WSSettings sharedSettings]setCurrentIndex:tag];
    
    [centralController setWeather];
    
    [self openWeather];
    
    [self.table reloadData];
}
-(void)openControllerWithTag:(NSInteger)tag
{
    switch (tag)
    {
        case -1:[self openWeather];break;
        case -3:[self openProfileController];break;
        case -4:[self openApreciateApp];break;
        case -5:[self openSendReview];break;
        case -6:[self openConditionSugestions];break;
        case -7:[self openAboutApplication];break;
    }
}
//-----------------------------------------------------------------------------------------------
-(void)openWeather
{
    if(centralController==nil)
    {
        centralController=[[WSViewController alloc]initWithNibName:@"WSViewController" bundle:nil];
    }
    
    UINavigationController *navigation=[[UINavigationController alloc]initWithRootViewController:centralController];
    
    self.containerController.centerViewController=navigation;
    
    [self.containerController toggleLeftSideMenuCompletion:^{}];
}
//---------------------------------------------------------------------------------------------
-(void)openProfileController
{
    WSProfileViewController *profileController=[[WSProfileViewController alloc]initWithNibName:@"WSProfileViewController" bundle:nil];
    
    UINavigationController *controller=[[UINavigationController alloc]initWithRootViewController:profileController];
    
    self.containerController.centerViewController=controller;
    [self.containerController toggleLeftSideMenuCompletion:^{}];
}
//----------------------------------------------------------------------------------------------
-(void)openApreciateApp
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/po-pogode/id721180090?l=ru&ls=1&mt=8"]];
}
//-----------------------------------------------------------------------------------------------
-(void)openSendReview
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailController=[[MFMailComposeViewController alloc]init];
        mailController.mailComposeDelegate=self;
        
        [mailController setSubject:@"Отзыв о приложении"];
        [mailController setToRecipients:[NSArray arrayWithObject:@"dev.po.pogode@gmail.com"]];
        
        [self presentModalViewController:mailController animated:YES];
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Ошибка" message:@"Не могу отправить сообщение,e-mail не настроен" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}
//------------------------------------------------------------------------------------------------
-(void)openConditionSugestions
{
    WSConditionSuggestionController *conditionController=[[WSConditionSuggestionController alloc]initWithNibName:@"WSConditionSuggestionController" bundle:nil];
    UINavigationController *controller=[[UINavigationController alloc]initWithRootViewController:conditionController];
    
    self.containerController.centerViewController=controller;
    [self.containerController toggleLeftSideMenuCompletion:^{}];
}
//------------------------------------------------------------------------------------------------
-(void)openAboutApplication
{
    WSAboutViewController *aboutController=[[WSAboutViewController alloc]initWithNibName:@"WSAboutViewController" bundle:nil];
    UINavigationController *controller=[[UINavigationController alloc]initWithRootViewController:aboutController];
    
    self.containerController.centerViewController=controller;
    
    [self.containerController toggleLeftSideMenuCompletion:^{}];
}
//--------------------------------------------------------------------------------------------
-(void)longTapCellWithTag:(NSInteger)tag
{
    if([[[self.containerController centerViewController]topViewController]isKindOfClass:[WSViewController class]])
    {
        centralController=(WSViewController*)[[self.containerController centerViewController]topViewController];
    }
    if(tag>=0)
    {
        self.prepareDelete=YES;
        
        [self.table reloadData];
    }
}
-(void)deleteCellWithTag:(WSWeatherCell*)cell
{
    [self deleteCityAtIndex:cell.tag];
    
    self.cities=[[WSSettings sharedSettings]citiesArray];
    
    [self animateDeleteCell:cell];

    [self calculateIndex:cell.tag];
    
    [centralController setWeather];
    
    [self isCitiesEmpty];
    
    [self.table performSelector:@selector(reloadData) withObject:nil afterDelay:1.0f];
}
//------------------------------------------------------------------------------------------
-(void)deleteCityAtIndex:(NSUInteger)index
{
    [[WSSettings sharedSettings]deleteCityAtIndex:index];
    
    [centralController.forecastArray removeObjectAtIndex:index];
    
    [WSSettings sharedSettings].forecastArray=[centralController.forecastArray copy];
}
-(void)animateDeleteCell:(WSWeatherCell*)cell
{
    cell.deleteButton.hidden=YES;
    
    
    NSIndexPath *indexPath= [NSIndexPath indexPathForRow:cell.row inSection:0];
    
    
    [self.table beginUpdates];
    
    [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.table endUpdates];
}
-(void)calculateIndex:(NSUInteger)index
{
    if([self.cities count]==index)
    {
        index=0;
    }
    
    [[WSSettings sharedSettings]setCurrentIndex:index];
}
-(void)isCitiesEmpty
{
    if([self.cities count]==0)
    {
        [centralController showNotFound];
        
        self.prepareDelete=NO;
    }
}
//-----------------------------------------------------------------------------------------------
@end

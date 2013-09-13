//
//  WSProfileViewController.m
//  iWeather
//
//  Created by Cornholio Zozobra on 8/1/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSProfileViewController.h"

@interface WSProfileViewController ()

@end
//--------------------------------------------------------------------------------------------------
@implementation WSProfileViewController

@synthesize mainTable;
@synthesize stylePicker;
@synthesize styleArray,sexArray;
//--------------------------------------------------------------------------------------------------
-(MFSideMenuContainerViewController*)menuContainerViewController
{
    return (MFSideMenuContainerViewController*)self.navigationController.parentViewController;
}
//--------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [self initialize];
    
    [self addRecognizerOnView:self.view cancel:NO];
    
    [self setPickerPosition];
    
    [self setPickerValue];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//-----------------------------------------------------------------------------------------------
-(void)initialize
{
    self.styleArray=[[WSSettings sharedSettings]styleArray];
    self.sexArray=[NSArray arrayWithObjects:@"Мужской",@"Женский", nil];
}
-(void)addRecognizerOnView:(UIView*)view cancel:(BOOL)cancel
{
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    tapRecognizer.cancelsTouchesInView=cancel;
    [view addGestureRecognizer:tapRecognizer];
}
-(void)setPickerPosition
{
    CGRect bounds= self.stylePicker.frame;
    bounds.origin.y=[[UIScreen mainScreen]bounds].size.height;
    self.stylePicker.frame=bounds;
}
-(void)setPickerValue
{
    NSUInteger index=[[WSSettings sharedSettings]currentStyle];
    [self.stylePicker selectRow:index inComponent:0 animated:NO];
}
//-----------------------------------------------------------------------------------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.styleArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    return [self.styleArray objectAtIndex:row];

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[WSSettings sharedSettings]setCurrentStyle:row];
    
    
    NSIndexPath *cellPath=[NSIndexPath indexPathForRow:0 inSection:1];
    
    UITableViewCell *cell=[self.mainTable cellForRowAtIndexPath:cellPath];
    
    NSUInteger index=[self.stylePicker selectedRowInComponent:0];
    
    cell.detailTextLabel.text=[self.styleArray objectAtIndex:index];
}
//------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!section)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"CellIdentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        
        cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
        
        cell.detailTextLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
        
        cell.textLabel.backgroundColor=[UIColor clearColor];
        
    }
    
    if(!indexPath.section)
    {
        cell.textLabel.text=[self.sexArray objectAtIndex:indexPath.row];
        
        if(([[[WSSettings sharedSettings]currentSex]isEqualToString:@"Man"] && !indexPath.row) || ([[[WSSettings sharedSettings]currentSex]isEqualToString:@"Woman"] && indexPath.row))
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    else
    {
        cell.textLabel.text=@"Стиль одежды";
        
        int index=[self.stylePicker selectedRowInComponent:0];
        
        cell.detailTextLabel.text=[self.styleArray objectAtIndex:index];
    }
    
    if(isPickerShow)
    {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    else
    {
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!indexPath.section)
    {
        if(!indexPath.row) //убираем галку
        {
            [[WSSettings sharedSettings]setCurrentSex:@"Man"];
            
            NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:indexPath.section];
            
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:index];
            
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        else
        {
            [[WSSettings sharedSettings]setCurrentSex:@"Woman"];
            
            NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
            
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:index];
            
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        
        
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];//ставим галку
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
        
        NSIndexPath *cellPath=[NSIndexPath indexPathForRow:0 inSection:1];
        
        cell=[self.mainTable cellForRowAtIndexPath:cellPath];
        
        cell.detailTextLabel.text=[self.styleArray objectAtIndex:0];
        

        [[WSSettings sharedSettings]setCurrentStyle:0];
        
        [self.stylePicker selectRow:0 inComponent:0 animated:YES];
    }
    else
    {
        [self addRecognizerOnView:self.stylePicker cancel:NO];
        
        [self showPicker];
        
        isPickerShow=YES;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!section)
    {
        return 100.0f;
    }
    else
    {
        return 10.0f;
    }
}
//----------------------------------------------------------------------------------------------
-(void)tapView:(UITapGestureRecognizer*)tapRecognizer;
{
    if([tapRecognizer.view isKindOfClass:[UIPickerView class]])
    {
        CGPoint location=[tapRecognizer locationInView:self.stylePicker];
        
        CGRect frame=self.stylePicker.frame;
        
        if(frame.size.height/2-20<location.y && location.y<frame.size.height/2+20)
        {
            [self showPicker];
            
            isPickerShow=NO;
        }
    }
    else if(isPickerShow)
    {
        [self.mainTable removeGestureRecognizer:tapRecognizer];
        
        [self.mainTable reloadData];
        
        
        [self showPicker];
        
        isPickerShow=NO;
    }
    
}
-(IBAction)back:(id)sender
{
    if(self.stylePicker.tag==1)
    {
        [self showPicker];
    }
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}
//---------------------------------------------------------------------------------------------------
-(void)showPicker
{
    if([self.stylePicker tag]==0)
    {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        
        
        CGRect bounds= self.stylePicker.frame;
        
        bounds.origin.y=[[UIScreen mainScreen]bounds].size.height-self.stylePicker.frame.size.height-20;
        
        self.stylePicker.frame=bounds;
        
        
        [UIView commitAnimations];
        
        [self.stylePicker setTag:1];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        
        
        CGRect bounds= self.stylePicker.frame;
        
        bounds.origin.y=[[UIScreen mainScreen]bounds].size.height;
        
        self.stylePicker.frame=bounds;
        
        
        [UIView commitAnimations];
        
        [self.stylePicker setTag:0];
    }
}
//---------------------------------------------------------------------------------------------------
@end

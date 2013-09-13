//
//  WSProfileViewController.h
//  iWeather
//
//  Created by Cornholio Zozobra on 8/1/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuContainerViewController.h"

@interface WSProfileViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL isPickerShow;
}

@property(nonatomic)IBOutlet UITableView *mainTable;

@property(nonatomic)IBOutlet UIPickerView *stylePicker;

@property(nonatomic)NSArray *styleArray;

@property(nonatomic)NSArray *sexArray;

-(MFSideMenuContainerViewController*)menuContainerViewController;

-(IBAction)back:(id)sender;

-(void)tapView:(UITapGestureRecognizer*)tapRecognizer;

-(void)showPicker;

@end

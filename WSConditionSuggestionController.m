//
//  WSConditionSuggestionController.m
//  iWeather
//
//  Created by Cornholio Zozobra on 8/1/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "WSConditionSuggestionController.h"

@interface WSConditionSuggestionController ()

@end
//-------------------------------------------------------------------------------------------------
@implementation WSConditionSuggestionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [[WSSettings sharedSettings]setNoFirst];
    [[WSSettings sharedSettings] shiftView:self.view withOffset:0.0f];
    
    self.textView.textAlignment=NSTextAlignmentJustified;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//-------------------------------------------------------------------------------------------------
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}
//-------------------------------------------------------------------------------------------------
-(IBAction)backToMenu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}
@end

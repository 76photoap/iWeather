//
//  WSAboutViewController.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/5/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSAboutViewController.h"

@interface WSAboutViewController ()

@end
//-----------------------------------------------------------------------------------------------------
@implementation WSAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [[WSSettings sharedSettings] shiftView:self.view withOffset:0.0f];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//-------------------------------------------------------------------------------------------------------
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}
//-------------------------------------------------------------------------------------------------------
-(IBAction)backToMenu:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
}

-(IBAction)openStoneLab
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.stone-labs.com"]];
}
-(IBAction)openWeatherService
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://weather.co.ua"]];
}

@end

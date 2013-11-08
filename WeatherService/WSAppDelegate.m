//
//  WSAppDelegate.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/1/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSAppDelegate.h"

#import "WSViewController.h"

#import "WSConditionSuggestionController.h"

#import "WSMenuViewController.h"

#import "MFSideMenuContainerViewController.h"


@implementation WSAppDelegate

- (WSViewController *)viewController
{
    return [[WSViewController alloc] initWithNibName:@"WSViewController" bundle:nil];
}
-(WSConditionSuggestionController*)conditionController
{
    return [[WSConditionSuggestionController alloc]initWithNibName:@"WSConditionSuggestionController" bundle:nil];
}
- (UINavigationController *)navigationController {
    
    if([[WSSettings sharedSettings]isFirst])
    {
        return [[UINavigationController alloc]
                initWithRootViewController:[self conditionController]];
    }
    else
    {
        return [[UINavigationController alloc]
                initWithRootViewController:[self viewController]];
        
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    WSMenuViewController *leftMenuViewController = [[WSMenuViewController alloc] initWithNibName:@"WSMenuViewController" bundle:nil];
    
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[self navigationController]
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:nil];
    
    leftMenuViewController.containerController=container;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.rootViewController = container;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[WSSettings sharedSettings]saveForecast];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    MFSideMenuContainerViewController *sideController=(MFSideMenuContainerViewController*)self.window.rootViewController;
    
    if([[[sideController centerViewController]topViewController]isKindOfClass:[WSViewController class]])
    {
        WSViewController *controler=(WSViewController*)[[sideController centerViewController]topViewController];
        
        [controler performSelector:@selector(setWeather) withObject:nil afterDelay:2.0f];
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[WSSettings sharedSettings]saveForecast];
}
@end

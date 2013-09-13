//
//  WSAppDelegate.h
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/1/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSViewController;

@interface WSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) WSViewController *viewController;

@end

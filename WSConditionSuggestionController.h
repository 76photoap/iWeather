//
//  WSConditionSuggestionController.h
//  iWeather
//
//  Created by Cornholio Zozobra on 8/1/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuContainerViewController.h"

@interface WSConditionSuggestionController : UIViewController

@property(nonatomic)IBOutlet UITextView *textView;

- (MFSideMenuContainerViewController *)menuContainerViewController;

-(IBAction)backToMenu:(id)sender;

@end

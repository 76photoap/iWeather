//
//  WSMenuViewController.h
//  iWeather
//
//  Created by Cornholio Zozobra on 7/31/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MFSideMenuContainerViewController.h"
#import "WSViewController.h"
#import "WSProfileViewController.h"
#import "WSConditionSuggestionController.h"
#import "WSAboutViewController.h"
#import "WSWeatherCell.h"

//----------------------------------------------------------------------------------------------
@interface WSMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,cellProtocol>

{
    WSViewController *centralController;
}
@property(nonatomic)MFSideMenuContainerViewController *containerController;

@property(nonatomic)IBOutlet UITableView *table;

@property(nonatomic)NSArray *tableItems;

@property(nonatomic)NSArray *cities;

@property(nonatomic)BOOL prepareDelete;

-(void)openWeather;
-(void)openProfileController;
-(void)openApreciateApp;
-(void)openSendReview;
-(void)openConditionSugestions;
-(void)openAboutApplication;

@end

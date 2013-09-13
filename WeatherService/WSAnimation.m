//
//  WSAnimation.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/29/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSAnimation.h"

@implementation WSAnimation

-(void)startAnimationWithParent:(UIViewController *)parentViewController forReplaceViewWithName:(NSString *)name toView:(UIView *)view
{
    _parentViewController = parentViewController;
    
    NSString* getSelectorName = name;
    NSString* firstNameSymbol = [[name substringToIndex:1] uppercaseString];
    
    NSString* setSelectorName = [name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstNameSymbol];
    setSelectorName = [NSString stringWithFormat:@"set%@:", setSelectorName];
    
    [NSString stringWithFormat:@"%@", name];
    
    _activeView = view;
    _removeView = [_parentViewController performSelector:NSSelectorFromString(getSelectorName)];
    [_parentViewController performSelector:NSSelectorFromString(setSelectorName) withObject:_activeView];
    
    [_parentViewController.view insertSubview:_activeView belowSubview:_removeView];
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:3.0f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
     _removeView.alpha=0.0f;
    
    [UIView commitAnimations];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [_removeView removeFromSuperview];
}

@end

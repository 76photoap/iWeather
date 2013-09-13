//
//  WSAnimation.h
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/29/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSAnimation : NSObject

@property(nonatomic)UIViewController *parentViewController;

@property(nonatomic)UIView *activeView;
@property(nonatomic)UIView *removeView;

-(void)startAnimationWithParent:(UIViewController*)parentViewController forReplaceViewWithName:(NSString*) name toView:(UIView*) view;
-(void)animationDidStop:(NSString*) animationID finished:(NSNumber*)finished context:(void*) context;
@end

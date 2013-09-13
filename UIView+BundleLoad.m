//
//  UIView+BundleLoad.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 7/31/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "UIView+BundleLoad.h"
#import <objc/runtime.h>

@implementation UIView (BundleLoad)

+(id) viewFromNib
{
    Class class = [self class];
    
    NSString* className = [NSString stringWithUTF8String:class_getName(class)];
    
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    
    return [objects objectAtIndex:0];
}

@end

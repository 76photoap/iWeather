//
//  WSClothView.h
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/14/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSWeatherAlgorithm.h"

typedef enum 
{
    WSClothViewBodyPartHead,
    WSClothViewBodyPartBody,
    WSClothViewBodyPartLeg,
    WSClothViewBodyPartFoot
}WSClothViewBodyPart;

@interface WSClothView : UIView
{
    NSArray *arrayCloth;
    CGFloat prevHeight;
}
@property(nonatomic)IBOutlet UILabel *labelStyle;
@property(nonatomic)WSWeatherAlgorithm *algorithm;

-(void)setCloth;

@end

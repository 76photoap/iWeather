//
//  WSClothView.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/14/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSClothView.h"


#define pHeadHeight 40
#define pHeadWidth 48
#define pHeadOffsetX 95
#define pHeadOffsetY 20
#define pHeadResize 20
#define pHead5Offset 8

#define pBodyHeight 85
#define pBodyWidth  78
#define pBodyOffsetX 95
#define pBodyOffsetY 80
#define pBodyResize 40
#define pBodyCoef pBodyWidth/pBodyHeight
#define pBody5Offset 30

#define pLegHeight 91
#define pLegWidth  69
#define pLegOffsetX 95
#define pLegOffsetY 170
#define pLegResize 45
#define pLegCoef pLegWidth/pLegHeight
#define pLeg5Offset 48

#define pFootHeight 55
#define pFootWidth 53
#define pFootOffsetX 95
#define pFootOffsetY 274
#define pFoot5Offset 63



#define lHeadHeight 15
#define lHeadWidth 95
#define lHeadOffsetX 225
#define lHeadOffsetY 45
#define lHead5Offset 10


#define lBodyHeightB 28
#define lBodyHeightS 15
#define lBodyWidth 95
#define lBodyOffsetX 225
#define lBodyOffsetY 125
#define lBodyMargin 10
#define lBody5Offset 26

#define lLegHeight 20
#define lLegWidth 95
#define lLegOffsetX 225
#define lLegOffsetY 220
#define lLeg5Offset 45

#define lFootHeight 20
#define lFootWidth 95
#define lFootOffsetX 225
#define lFootOffsetY 300
#define lFoot5Offset 60

@implementation WSClothView

@synthesize labelStyle;
@synthesize algorithm;

-(NSMutableArray*)reverseArray:(NSMutableArray*)array
{
    NSMutableArray *mutableArray=[array mutableCopy];
    for(int i=0;i<[mutableArray count]/2;i++)
    {
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:([array count]-i-1)];
    }
    return mutableArray;
}
//=================================================================================================
-(void)setCloth
{
    arrayCloth=[NSArray arrayWithObjects:@"Блуза с дл.рукавом",@"Футболка с дл.рукавом",@"Рубашка с кор.рукавом",@"Рубашка с дл.рукавом",nil];
    
    self.algorithm.head=[self reverseArray:self.algorithm.head];
    self.algorithm.body=[self reverseArray:self.algorithm.body];
    self.algorithm.legs=[self reverseArray:self.algorithm.legs];
    self.algorithm.foot=[self reverseArray:self.algorithm.foot];
    
    for(int i=0;i<[self.algorithm.head count];i++)
    {
        NSDictionary *dictionary=[algorithm.head objectAtIndex:i];
        
        [self setClothWith:WSClothViewBodyPartHead andImageName:[dictionary objectForKey:kPictureName] andNumber:i];
        
        [self setLabelWithPart:WSClothViewBodyPartHead andName:[dictionary objectForKey:kClothName] andNumber:i];
        
    }
    for(int i=0;i<[self.algorithm.body count];i++)
    {
        NSDictionary *dictionary=[algorithm.body objectAtIndex:i];
        
        [self setClothWith:WSClothViewBodyPartBody andImageName:[dictionary objectForKey:kPictureName] andNumber:i];
        
        [self setLabelWithPart:WSClothViewBodyPartBody andName:[dictionary objectForKey:kClothName] andNumber:i];
    
    }
    for(int i=0;i<[self.algorithm.legs count];i++)
    {
        NSDictionary *dictionary=[algorithm.legs objectAtIndex:i];
        
        [self setClothWith:WSClothViewBodyPartLeg andImageName:[dictionary objectForKey:kPictureName] andNumber:i];
        
        [self setLabelWithPart:WSClothViewBodyPartLeg andName:[dictionary objectForKey:kClothName] andNumber:i];
    
    }
    for(int i=0;i<[self.algorithm.foot count];i++)
    {
        NSDictionary *dictionary=[algorithm.foot objectAtIndex:i];
        
        [self setClothWith:WSClothViewBodyPartFoot andImageName:[dictionary objectForKey:kPictureName] andNumber:i];
        
        [self setLabelWithPart:WSClothViewBodyPartFoot andName:[dictionary objectForKey:kClothName] andNumber:i];
    
    }
    
    switch (self.algorithm.weatherType)
    {
        case WSWeatherTypeSun:self.labelStyle.text=@"Возьмите солнечные очки, сегодня яркое солнце";break;
        case WSWeatherTypeRain:self.labelStyle.text=@"Не забудьте взять зонт, ожидается дождик";break;
        case WSWeatherTypeNone:self.labelStyle.text=@"";break;
    }

}
//--------------------------------------------------------------------------------------------------
-(void)setLabelWithPart:(WSClothViewBodyPart)bodyPart andName:(NSString*)name andNumber:(NSUInteger)number
{
    CGRect frame;
    CGFloat height,offset;
    
    switch(bodyPart)
    {
        case WSClothViewBodyPartHead:
            
            if([[WSSettings sharedSettings]isIphone5])
            {
                offset=lHead5Offset;
            }
            else
            {
                offset=0;
            }
            
            frame=CGRectMake(lHeadOffsetX,0,lHeadWidth,lHeadHeight);
            
            frame.origin.y=[self calculatePointForLabel:bodyPart]+lHeadHeight*number+offset;
            
            break;
            
        case WSClothViewBodyPartBody:
            
            if([[WSSettings sharedSettings]isIphone5])
            {
                offset=lBody5Offset;
            }
            else
            {
                offset=0;
            }
            
            if([arrayCloth indexOfObject:name]!=NSNotFound)
            {
                height=lBodyHeightB;
                
            }
            else
            {
                height=lBodyHeightS;
            }
            
            frame=CGRectMake(lBodyOffsetX,0,lBodyWidth,height);
            
            if(!prevHeight)
            {
                prevHeight=[self calculatePointForLabel:bodyPart]+height*number;
                
                frame.origin.y=prevHeight;
                
                prevHeight-=lBodyMargin;
            }
            else
            {
                frame.origin.y=prevHeight+lBodyMargin;
            }
            
            prevHeight+=(height+lBodyMargin);
            
            frame.origin.y+=offset;
            
            break;

        case WSClothViewBodyPartLeg:
            
            if([[WSSettings sharedSettings]isIphone5])
            {
                offset=lLeg5Offset;
            }
            else
            {
                offset=0;
            }
            
            frame=CGRectMake(lLegOffsetX,0,lLegWidth,lLegHeight);
            
            frame.origin.y=[self calculatePointForLabel:bodyPart]+lLegHeight*number+offset;
            
            break;
        case WSClothViewBodyPartFoot:
            
            if([[WSSettings sharedSettings]isIphone5])
            {
                offset=lFoot5Offset;
            }
            else
            {
                offset=0;
            }
            
            frame=CGRectMake(lFootOffsetX,0,lFootWidth,lFootHeight);
            
            frame.origin.y=[self calculatePointForLabel:bodyPart]+lFootHeight*number+offset;
            
            break;
    }
    
    UILabel *label=[[UILabel alloc]init];
    
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]];
     
    [label setTextColor:[UIColor colorWithRed:98.0f/255 green:98.0f/255 blue:98.0f/255 alpha:1.0F]];
    
    [label setBackgroundColor:[UIColor clearColor]];
    
    [label setNumberOfLines:3];
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0f)
    {
        frame.size.height+=10;
    }
    
    [label setFrame:frame];
    
    [label setText:name];
    
    [self addSubview:label];
}
-(CGFloat)calculatePointForLabel:(WSClothViewBodyPart)bodyPart
{
    CGFloat y = 0.0;
    NSUInteger count;
    
    switch(bodyPart)
    {
        case WSClothViewBodyPartHead:
            
            y=lHeadOffsetY;
            
            count=[self.algorithm.head count];
            
            y-=(((CGFloat)lHeadHeight*count)/2);
            
            break;
            
        case WSClothViewBodyPartBody:
            
            y=lBodyOffsetY;
            
            count=[self.algorithm.body count];
            
            CGFloat commonHeight=0;
            for(int i=0;i<count;i++)
            {
                NSString *name=[[self.algorithm.body objectAtIndex:i]objectForKey:kClothName];
                
                if([arrayCloth indexOfObject:name]==NSNotFound)
                {
                    commonHeight+=lBodyHeightS;
                }
                else
                {
                    commonHeight+=lBodyHeightB;
                }
                
                commonHeight+=lBodyMargin;
            }
            
            y-=(commonHeight/2);
            
            break;
            
        case WSClothViewBodyPartLeg:
            
            y=lLegOffsetY;
            
            count=[self.algorithm.legs count];
            
            y-=(((CGFloat)lLegHeight*count)/2);
            
            break;
            
        case WSClothViewBodyPartFoot:
            
            y=lFootOffsetY;
            
            count=[self.algorithm.foot count];
            
            y-=(((CGFloat)lFootHeight*count)/2);
            
            break;
    }
    
    return y;
}
//================================================================================================
-(void)setClothWith:(WSClothViewBodyPart)bodyPart andImageName:(NSString*)name andNumber:(NSUInteger)number
{
    CGRect frame;
    CGFloat offset;
    switch(bodyPart)
    {
        case WSClothViewBodyPartHead:
            
            if([[WSSettings sharedSettings]isIphone5])
            {
                offset=pHead5Offset;
            }
            else
            {
                offset=0;
            }
            
            frame=CGRectMake(0,pHeadOffsetY+offset, pHeadWidth,pHeadHeight);
            
            frame.origin.x=[self calculatePointForPicture:WSClothViewBodyPartHead]+(pHeadWidth-pHeadResize)*number;

            break;
            
        case WSClothViewBodyPartBody:
            
            if([[WSSettings sharedSettings]isIphone5])
            {
                offset=pBody5Offset;
            }
            else
            {
                offset=0;
            }
            
            frame=CGRectMake(0, pBodyOffsetY+offset,pBodyWidth,pBodyHeight);
            
            frame.origin.x=[self calculatePointForPicture:WSClothViewBodyPartBody]+(pBodyWidth-pBodyResize)*number;
            
            break;
            
        case WSClothViewBodyPartLeg:
            
            if([[WSSettings sharedSettings]isIphone5])
            {
                offset=pLeg5Offset;
            }
            else
            {
                offset=0;
            }
            
            frame=CGRectMake(0, pLegOffsetY+offset,pLegWidth,pLegHeight);
            
            frame.origin.x=[self calculatePointForPicture:WSClothViewBodyPartLeg]+(CGFloat)(pLegWidth-pLegResize)*number;
            
            break;
        case WSClothViewBodyPartFoot:
            
            if([[WSSettings sharedSettings]isIphone5])
            {
                offset=pFoot5Offset;
            }
            else
            {
                offset=0;
            }
            
            frame=CGRectMake(0,pFootOffsetY+offset, pFootWidth,pFootHeight);
            
            frame.origin.x=[self calculatePointForPicture:WSClothViewBodyPartFoot];
            
            break;
    }
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    imageView.image=[UIImage imageNamed:name];
    
    [self addSubview:imageView];
}
-(CGFloat)calculatePointForPicture:(WSClothViewBodyPart)bodyPart
{
    CGFloat x = 0.0,width;
    NSUInteger count;
    switch(bodyPart)
    {
        case WSClothViewBodyPartHead:
            
            x=pHeadOffsetX;
            
            count=[self.algorithm.head count];
            
            width=(CGFloat)pHeadWidth*count;
            width-=(pHeadResize*(count-1));
            
            x-=(width/2);
            
            break;
            
        case WSClothViewBodyPartBody:
            
            x=pBodyOffsetX;
            
            count=[self.algorithm.body count];
            
            width=(CGFloat)pBodyWidth*count;
            width-=(pBodyResize*(count-1));
            
            x-=(width/2);
            
            break;
            
        case WSClothViewBodyPartLeg:
            
            x=pLegOffsetX;
            
            count=[self.algorithm.legs count];
            
            width=(CGFloat)pLegWidth*count;
            width-=(pLegResize*(count-1));
            
            x-=(width/2);
            
            break;
            
        case WSClothViewBodyPartFoot:
            
            x=pFootOffsetX;
            
            count=[self.algorithm.foot count];
            
            x-=(((CGFloat)pFootWidth*count)/2);
            
            break;
    }

    return x;
}
//================================================================================================
@end

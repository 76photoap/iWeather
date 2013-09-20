//
//  WSClothViewController.m
//  WeatherService
//
//  Created by Cornholio Zozobra on 8/5/13.
//  Copyright (c) 2013 Cornholio Zozobra. All rights reserved.
//

#import "WSClothViewController.h"

@interface WSClothViewController ()

#define viewHeight 365
#define viewHeight5 455
#define viewOffset 90

@end

@implementation WSClothViewController

@synthesize styleArray;
@synthesize centerView,hideView;
@synthesize algorithm;
@synthesize labelStyle;
@synthesize leftButton;
@synthesize rightButton;
//-------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialize];
    
    [self.algorithm calculateDress];
    
    [self addInterface];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//--------------------------------------------------------------------------------------------
-(void)initialize
{
    self.styleArray=[[WSSettings sharedSettings]styleArray];
    currentIndex=[[WSSettings sharedSettings]currentStyle];
}
-(void)addRecognizers
{
    UISwipeGestureRecognizer *leftSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    
    leftSwipe.direction=UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:leftSwipe];
    
    
    
    UISwipeGestureRecognizer *rightSwipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    
    rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipe];
}
-(void)addInterface
{
    self.labelStyle.text=[self.styleArray objectAtIndex:currentIndex];
    
    [self addRecognizers];
    
    self.centerView=[self createClothView:center];
    
    [self setEnabledButtons];
}
//--------------------------------------------------------------------------------------------
-(void)didSwipe:(UISwipeGestureRecognizer *)swipe
{
    if(swipe.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        [self onRight];
    }
    else
    {
        [self onLeft];
    }
}
//--------------------------------------------------------
-(IBAction)didTapLeft:(id)sender
{
    [self onLeft];
}
-(IBAction)didTapRight:(id)sender
{
    [self onRight];
}
-(IBAction)backToWeather:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//---------------------------------------------------------
-(void)onLeft
{
    if(currentIndex>=1  && isSwipe==NO)
    {
        [self.labelStyle setText:[self.styleArray objectAtIndex:--currentIndex]];
        
        [self.algorithm calculateDressWithStyle:[self.styleArray objectAtIndex:currentIndex]];
        
        self.hideView=[self createClothView:left];
        
        [self animationOnDorection:right];
        
        [self setEnabledButtons];
    }
}
-(void)onRight
{
    if(currentIndex+1<[self.styleArray count] && isSwipe==NO)
    {
        [self.labelStyle setText:[self.styleArray objectAtIndex:++currentIndex]];
        
        [self.algorithm calculateDressWithStyle:[self.styleArray objectAtIndex:currentIndex]];
        
        self.hideView=[self createClothView:right];
        
        [self animationOnDorection:left];
        
        [self setEnabledButtons];
    }
}
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    self.centerView=self.hideView;
    
    self.hideView=nil;
    
    isSwipe=NO;
}
-(void)animationOnDorection:(viewDirection)direction
{
    isSwipe=YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    [self.centerView setFrame:[self createFrame:direction]];
    [self.hideView setFrame:[self createFrame:center]];
    
    
    [UIView commitAnimations];
}
//---------------------------------------------------------
-(WSClothView*)createClothView:(viewDirection)direction
{
    WSClothView *clothView=[WSClothView viewFromNib];
    
    CGRect rect=[self createFrame:direction];
    [clothView setFrame:rect];
    
    
    clothView.algorithm=self.algorithm;
    [clothView setCloth];
    
    
    [self.view addSubview:clothView];
    
    return clothView;
}
-(CGRect)createFrame:(viewDirection)direction
{
    CGRect rect=[[UIScreen mainScreen]bounds];
    
    if([[WSSettings sharedSettings]isIphone5])
    {
        rect.size.height=viewHeight5;
    }
    else
    {
        rect.size.height=viewHeight;
    }
    
    rect.origin.y+=viewOffset;
    
    switch(direction)
    {
        case left:rect.origin.x-=rect.size.width;break;
            
        case right:rect.origin.x+=rect.size.width;break;
            
        case center:;break;
    }
    
    return rect;
    
}
//---------------------------------------------------------
-(void)setEnabledButtons
{
    if(currentIndex==0)
    {
        leftButton.hidden=YES;
    }
    else
    {
        leftButton.hidden =NO;
    }
    
    if(currentIndex==[self.styleArray count]-1)
    {
        rightButton.hidden=YES;
    }
    else
    {
        rightButton.hidden=NO;
    }
}

@end


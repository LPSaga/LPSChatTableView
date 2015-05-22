//
//  LPSVoiceRecoderHUD.m
//  LPSChatTableView
//
//  Created by liupei on 15/5/22.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "LPSVoiceRecoderHUD.h"

@interface LPSVoiceRecoderHUD (){
    NSTimer *myTimer;
    int angle;
    
    UILabel *centerLabel;
    UIImageView *edgeImageView;
}

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

@end

@implementation LPSVoiceRecoderHUD
@synthesize overlayWindow;

+ (LPSVoiceRecoderHUD*)sharedView {
    static dispatch_once_t once;
    static LPSVoiceRecoderHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[LPSVoiceRecoderHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        sharedView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    });
    return sharedView;
}

+ (void)show {
    [[LPSVoiceRecoderHUD sharedView] show];
}

- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [self.overlayWindow addSubview:self];
        
        if (!centerLabel){
            centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
            centerLabel.backgroundColor = [UIColor clearColor];
        }

        if (!edgeImageView)
            edgeImageView = [[UIImageView alloc]init];
        

        
        centerLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2);
        centerLabel.text = @"0";
        centerLabel.textAlignment = NSTextAlignmentCenter;
        centerLabel.font = [UIFont systemFontOfSize:30];
        centerLabel.textColor = [UIColor yellowColor];
        
        
        edgeImageView.frame = CGRectMake(0, 0, 89, 129);
        edgeImageView.image = [UIImage imageNamed:@"icon_microphone"];
        edgeImageView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2,[[UIScreen mainScreen] bounds].size.height/2 -80);
        [self addSubview:edgeImageView];
        [self addSubview:centerLabel];
        
        if (myTimer)
            [myTimer invalidate];
        myTimer = nil;
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                   target:self
                                                 selector:@selector(startAnimation)
                                                 userInfo:nil
                                                  repeats:YES];
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished){
                         }];
        [self setNeedsDisplay];
    });
}

-(void) startAnimation
{
    angle -= 3;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.09];
    UIView.AnimationRepeatAutoreverses = YES;
    edgeImageView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    float second = [centerLabel.text floatValue];
    if (second >= 50.0f) {
        centerLabel.textColor = [UIColor redColor];
    }else{
        centerLabel.textColor = [UIColor yellowColor];
    }
    centerLabel.text = [NSString stringWithFormat:@"%.1f",second+0.1];
    [UIView commitAnimations];
}

+ (void)changeSubTitle:(NSString *)str
{
    [[LPSVoiceRecoderHUD sharedView] setState:str];
}

- (void)setState:(NSString *)str
{

}

+ (void)dismissWithSuccess:(NSString *)str {
    [[LPSVoiceRecoderHUD sharedView] dismiss:str];
}

+ (void)dismissWithError:(NSString *)str {
    [[LPSVoiceRecoderHUD sharedView] dismiss:str];
}

- (void)dismiss:(NSString *)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [myTimer invalidate];
        myTimer = nil;

        
        centerLabel.text = state;
        centerLabel.textColor = [UIColor whiteColor];
        
        CGFloat timeLonger;
        if ([state isEqualToString:@"TooShort"]) {
            timeLonger = 1;
        }else{
            timeLonger = 0.6;
        }
        [UIView animateWithDuration:timeLonger
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if(self.alpha == 0) {
                                 [centerLabel removeFromSuperview];
                                 centerLabel = nil;
                                 [edgeImageView removeFromSuperview];
                                 edgeImageView = nil;
                                 
                                 NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                                 [windows removeObject:overlayWindow];
                                 overlayWindow = nil;
                                 
                                 [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                     if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                         [window makeKeyWindow];
                                         *stop = YES;
                                     }
                                 }];
                             }
                         }];
    });
}

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.userInteractionEnabled = NO;
        [overlayWindow makeKeyAndVisible];
    }
    return overlayWindow;
}


@end

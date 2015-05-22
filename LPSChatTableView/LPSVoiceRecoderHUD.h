//
//  LPSVoiceRecoderHUD.h
//  LPSChatTableView
//
//  Created by liupei on 15/5/22.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPSVoiceRecoderHUD : UIView

+ (void)show;

+ (void)dismissWithSuccess:(NSString *)str;

+ (void)dismissWithError:(NSString *)str;

+ (void)changeSubTitle:(NSString *)str;

@end

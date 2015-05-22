//
//  LPSInputFunctionView.h
//  LPSChatTableView
//
//  Created by liupei on 15/5/20.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPSInputFunctionView;

@protocol LPSInputFunctionViewDelegate <NSObject>

// text
- (void)LPSInputFunctionView:(LPSInputFunctionView *)funcView sendMessage:(NSString *)message;

// image
- (void)LPSInputFunctionView:(LPSInputFunctionView *)funcView sendPicture:(UIImage *)image;

// audio
- (void)LPSInputFunctionView:(LPSInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSTimeInterval)second;

@end

@interface LPSInputFunctionView : UIView<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) UIViewController *superVC;

@property (nonatomic, assign) id<LPSInputFunctionViewDelegate>delegate;

@property (nonatomic, retain) UIButton *chatBtn;

@property (nonatomic, retain) UIButton *otherBtn;

@property (nonatomic, retain) UITextView *textInput;

@property (nonatomic, retain) UIButton *voiceRecordBtn;


- (id)initWithSuperVC:(UIViewController *)superVC;

@end

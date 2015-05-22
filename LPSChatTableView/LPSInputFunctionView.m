//
//  LPSInputFunctionView.m
//  LPSChatTableView
//
//  Created by liupei on 15/5/20.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "LPSInputFunctionView.h"
#import "RecordAudio.h"
#import "LPSVoiceRecoderHUD.h"

@interface LPSInputFunctionView ()
{
    //view
    BOOL isBottomView;
    UIView *BottomView;
    
    //audio
    RecordAudio *recordAudio;
    BOOL isbeginVoiceRecord;
    NSData *voiceData;
    NSInteger playTime;
    NSTimer *playTimer;
}

@end

@implementation LPSInputFunctionView

@synthesize textInput,otherBtn,chatBtn,voiceRecordBtn;

- (id)initWithSuperVC:(UIViewController *)superVC
{
    self.superVC = superVC;
    
    CGRect frame = CGRectMake(0, Main_Screen_Height-44, Main_Screen_Width, 44);
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addBottomView];
        [self addToolView];
    }
    return self;
}

- (void)addBottomView{
    //底端视图
    isBottomView = NO;
    BottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height-100, Main_Screen_Width, 100)];
    BottomView.hidden = YES;
    [BottomView setBackgroundColor:[UIColor colorWithRed:248 green:248 blue:248 alpha:1]];
    [self.superVC.view addSubview:BottomView];
    
    UIImageView * picView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_photo.png"]];
    picView.frame = CGRectMake(10, 10, 60, 60);
    picView.userInteractionEnabled = YES;
    [BottomView addSubview:picView];
    UITapGestureRecognizer *picTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getPhotoImg)];
    picTap.numberOfTapsRequired = 1;
    [picView addGestureRecognizer:picTap];
    UILabel *picLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 60, 20)];
    picLabel.text = @"照片";
    picLabel.textColor = [UIColor lightGrayColor];
    picLabel.textAlignment = 1;
    [BottomView addSubview:picLabel];
    
    UIImageView * cameraView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_cineme.png"]];
    cameraView.frame = CGRectMake(80, 10, 60, 60);
    cameraView.userInteractionEnabled = YES;
    [BottomView addSubview:cameraView];
    UITapGestureRecognizer *carmeraTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getCameraImg)];
    carmeraTap.numberOfTapsRequired = 1;
    [cameraView addGestureRecognizer:carmeraTap];
    UILabel *carmeraLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 75, 60, 20)];
    carmeraLabel.text = @"拍摄";
    carmeraLabel.textColor = [UIColor lightGrayColor];
    carmeraLabel.textAlignment = 1;
    [BottomView addSubview:carmeraLabel];
}

- (void)addToolView{
    [self setBackgroundColor:[UIColor colorWithRed: 229.0/255 green: 229.0/255 blue: 229.0/255 alpha: 1.0]];

    recordAudio = [RecordAudio sharedInstance];
    
    //添加按钮
    otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBtn.frame = CGRectMake(Main_Screen_Width-40, 5, 30, 30);
    [otherBtn setBackgroundImage:[UIImage imageNamed:@"icone_tianjia.png"] forState:UIControlStateNormal];
    [otherBtn addTarget:self action:@selector(otherAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:otherBtn];
    
    //输入框
    textInput = [[UITextView alloc] initWithFrame:CGRectMake(45, 5, Main_Screen_Width-2*45, 30)];
    textInput.delegate = self;
    textInput.returnKeyType = UIReturnKeySend;
    textInput.layer.cornerRadius = 4;
    textInput.layer.masksToBounds = YES;
    textInput.layer.borderWidth = 1;
    textInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    [self addSubview:textInput];
    
    //语音/输入
    chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chatBtn.frame = CGRectMake(5, 5, 30, 30);
    [chatBtn setBackgroundImage:[UIImage imageNamed:@"icone-_say"] forState:UIControlStateNormal];
    [chatBtn addTarget:self action:@selector(chatAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chatBtn];
    isbeginVoiceRecord = NO;

    //语音录入键
    voiceRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceRecordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [voiceRecordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    voiceRecordBtn.frame = CGRectMake(50, 5, Main_Screen_Width-50*2, 30);
    voiceRecordBtn.hidden = YES;
    [voiceRecordBtn setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:UIControlStateNormal];
    [voiceRecordBtn setBackgroundImage:[UIImage imageNamed:@"icon_bg_say"] forState:UIControlStateNormal];
    [voiceRecordBtn setBackgroundImage:[UIImage imageNamed:@"icon_bg_say_choose"] forState:UIControlStateHighlighted];
    [voiceRecordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [voiceRecordBtn setTitle:@"松开停止" forState:UIControlStateHighlighted];
    [voiceRecordBtn addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
    [voiceRecordBtn addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
//    [voiceRecordBtn addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
//    [voiceRecordBtn addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
//    [voiceRecordBtn addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [self addSubview:voiceRecordBtn];
}

#pragma mark - Picture
- (void)getCameraImg
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.superVC presentViewController:picker animated:YES completion:^{}];
}

- (void)getPhotoImg
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.superVC presentViewController:picker animated:YES completion:^{
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.superVC dismissViewControllerAnimated:YES completion:^{
        [self.delegate LPSInputFunctionView:self sendPicture:editImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - VoiceRecord-TextInput
- (void)chatAction:(id)sender {
    voiceRecordBtn.hidden = !voiceRecordBtn.hidden;
    
    textInput.hidden  = !textInput.hidden;
    
    isbeginVoiceRecord = !isbeginVoiceRecord;
    
    if (isbeginVoiceRecord) {
        [chatBtn setBackgroundImage:[UIImage imageNamed:@"icone-_words"] forState:UIControlStateNormal];
        
        [textInput resignFirstResponder];
        
        [self hideenBottomView];
        
        isBottomView = YES;
    }else{
        [chatBtn setBackgroundImage:[UIImage imageNamed:@"icone-_say"] forState:UIControlStateNormal];

        [textInput becomeFirstResponder];
        
        isBottomView = NO;
    }

}

#pragma mark - BottomView
- (void)otherAction:(id)sender {
    [textInput resignFirstResponder];
    
    isBottomView = !isBottomView;

    if (isBottomView) {
        [self showBottomView];
    }else{
        [self hideenBottomView];
    }
    
}

- (void)hideenBottomView{
    CGRect  frame  = CGRectMake(0, Main_Screen_Height-44, Main_Screen_Width, 44);
    self.frame = frame;
    BottomView.hidden = YES;
}

- (void)showBottomView{
    CGRect  frame  = CGRectMake(0, Main_Screen_Height-44-100, Main_Screen_Width, 44);
    self.frame = frame;
    BottomView.hidden = NO;
}

#pragma mark - RecordVoice
- (void)beginRecordVoice:(id)sender{
    [recordAudio stopPlay];
    [recordAudio startRecord];

    [LPSVoiceRecoderHUD show];
}

- (void)endRecordVoice:(id)sender{
    NSURL *url = [recordAudio stopRecord];
    if (url != nil) {
        [LPSVoiceRecoderHUD dismissWithSuccess:@"Success"];

        voiceData = [NSData dataWithData:EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16)];
        NSTimeInterval timeInterval = [RecordAudio getAudioTime:voiceData];
        [self.delegate LPSInputFunctionView:self sendVoice:voiceData time:timeInterval];
        
    }
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (textInput.text.length > 0) {
            [self.delegate LPSInputFunctionView:self sendMessage:textInput.text];
        }
        return NO;
    }
    return YES;
}

@end

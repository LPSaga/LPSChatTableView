//
//  LPSAudioPlayer.m
//  LPSChatTableView
//
//  Created by liupei on 15/5/21.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "LPSAudioPlayer.h"
#import "RecordAudio.h"

@interface LPSAudioPlayer ()<RecordAudioDelegate>{
    RecordAudio *recordAudio;
}

@end

@implementation LPSAudioPlayer

+ (LPSAudioPlayer *)sharedInstance
{
    static LPSAudioPlayer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - RecordAudio Delegate
- (void)RecordStatus:(int)status {
    if (status==0){
        NSLog(@"播放中");
    }
    else if(status==1){
        [self.delegate LPSAVAudioPlayerDidFinishPlay];
    }
    else if(status==2){
        [self stopSound];
        NSLog(@"播放出错");
    }
}

#pragma mark - Audio Play
-(void)playSongWithUrl:(NSString *)songUrl
{
    dispatch_async(dispatch_queue_create("playSoundFromUrl", NULL), ^{
        [self.delegate LPSAVAudioPlayerBeiginLoadVoice];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:songUrl]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playSoundWithData:data];
        });
    });
}

-(void)playSongWithData:(NSData *)songData
{
    [self setupPlaySound];
    [self playSoundWithData:songData];
}

- (void)stopSound{
    [recordAudio stopPlay];
}

-(void)playSoundWithData:(NSData *)soundData{
    recordAudio = [RecordAudio sharedInstance];
    recordAudio.delegate = self;
    [recordAudio play:soundData];
    [self.delegate LPSAVAudioPlayerBeiginPlay];
}

-(void)setupPlaySound{
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
}

- (void)applicationWillResignActive:(UIApplication *)application{
    [self.delegate LPSAVAudioPlayerDidFinishPlay];
}

@end

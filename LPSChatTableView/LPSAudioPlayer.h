//
//  LPSAudioPlayer.h
//  LPSChatTableView
//
//  Created by liupei on 15/5/21.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol LPSAudioPlayerDelegate <NSObject>

- (void)LPSAVAudioPlayerBeiginLoadVoice;
- (void)LPSAVAudioPlayerBeiginPlay;
- (void)LPSAVAudioPlayerDidFinishPlay;

@end

@interface LPSAudioPlayer : NSObject

@property (nonatomic, assign)id <LPSAudioPlayerDelegate>delegate;


+ (LPSAudioPlayer *)sharedInstance;

-(void)playSongWithUrl:(NSString *)songUrl;

-(void)playSongWithData:(NSData *)songData;

- (void)stopSound;

@end




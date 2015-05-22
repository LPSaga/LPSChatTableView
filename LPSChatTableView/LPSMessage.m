//
//  LPSMessage.m
//  LPSChatTableView
//
//  Created by liupei on 15/5/21.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "LPSMessage.h"
#import "NSDate+Utils.h"

@implementation LPSMessage

- (void)setWithDict:(NSDictionary *)dict{
    
    self.strIcon = dict[@"strIcon"];
    self.strName = dict[@"strName"];
    self.strId = dict[@"strId"];
    self.strTime = dict[@"strTime"];
    self.from = [dict[@"from"] intValue];
    
    switch ([dict[@"type"] integerValue]) {
            
        case 0:
            self.type = LPSMessageTypeText;
            self.strContent = dict[@"strContent"];
            break;
            
        case 1:
            self.type = LPSMessageTypePicture;
            self.picture = dict[@"picture"];
            break;
            
        case 2:
            self.type = LPSMessageTypeVoice;
            self.voice = dict[@"voice"];
            self.strVoiceTime = dict[@"strVoiceTime"];
            break;
            
        default:
            break;
    }
}

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end
{
    if (!start) {
        self.showDateLabel = YES;
        return;
    }
    
    NSString *subStart = [start substringWithRange:NSMakeRange(0, 19)];
    NSDate *startDate = [NSDate dateFromString:subStart withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *subEnd = [end substringWithRange:NSMakeRange(0, 19)];
    NSDate *endDate = [NSDate dateFromString:subEnd withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
    
    //相距10分钟显示时间Label
    if (fabs (timeInterval) > 10*60) {
        self.showDateLabel = YES;
    }else{
        self.showDateLabel = NO;
    }
    
}

@end

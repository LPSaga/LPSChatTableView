//
//  ChatModel.m
//  LPSChatTableView
//
//  Created by liupei on 15/5/21.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "ChatModel.h"
#import "LPSMessage.h"
#import "LPSMessageFrame.h"

static NSString *previousTime = nil;

@implementation ChatModel
- (void)getDataSource{
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObjectsFromArray:[self additems:10]];
}

- (void)addFromMeWithDict:(NSDictionary *)dic{
    LPSMessageFrame *messageFrame = [[LPSMessageFrame alloc]init];
    LPSMessage*message = [[LPSMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = @"http://pica.nipic.com/2007-11-09/2007119124513598_2.jpg";
    [dataDic setObject:@(LPSMessageFromMe) forKey:@"from"];
    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
    [dataDic setObject:@"lee" forKey:@"strName"];
    [dataDic setObject:URLStr forKey:@"strIcon"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];

}

- (NSArray *)additems:(NSInteger)number
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (int i=0; i<number; i++) {
        
        NSDictionary *dataDic = [self getDic];
        LPSMessageFrame *messageFrame = [[LPSMessageFrame alloc]init];
        LPSMessage *message = [[LPSMessage alloc] init];
        [message setWithDict:dataDic];
        [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        
        if (message.showDateLabel) {
            previousTime = dataDic[@"strTime"];
        }
        [result addObject:messageFrame];
    }
    return result;
    
}

- (NSDictionary *)getDic
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    int randomNum = arc4random()%5;
    if (randomNum == LPSMessageTypePicture) {
        [dictionary setObject:[UIImage imageNamed:@"Image_Loding.jpg"] forKey:@"picture"];
    }else{
        randomNum = LPSMessageTypeText;
        [dictionary setObject:@"这是一个向往和平的语录。" forKey:@"strContent"];
    }
    NSDate *date = [[NSDate date]dateByAddingTimeInterval:arc4random()%1000 ];
    [dictionary setObject:@(LPSMessageFromOther) forKey:@"from"];
    [dictionary setObject:@(randomNum) forKey:@"type"];
    [dictionary setObject:[date description] forKey:@"strTime"];
    [dictionary setObject:@"luo" forKey:@"strName"];
    [dictionary setObject:@"http://pic.nipic.com/2007-11-09/200711912453162_2.jpg" forKey:@"strIcon"];
    
    return dictionary;
}

@end

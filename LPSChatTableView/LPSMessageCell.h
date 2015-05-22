//
//  LPSMessageCell.h
//  LPSChatTableView
//
//  Created by liupei on 15/5/21.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPSMessageContent.h"

@class LPSMessageFrame;
@class LPSMessageCell;

@protocol LPSMessageCellDelegate <NSObject>
@optional

- (void)headImageDidClick:(LPSMessageCell *)cell userId:(NSString *)userId;

@end

@interface LPSMessageCell : UITableViewCell

@property (nonatomic, retain)UILabel *labelTime;
@property (nonatomic, retain)UILabel *labelNum;
@property (nonatomic, retain)UIButton *btnHeadImage;

@property (nonatomic, retain)LPSMessageContent *btnContent;

@property (nonatomic, retain)LPSMessageFrame *messageFrame;

@property (nonatomic, assign)id<LPSMessageCellDelegate>delegate;

@end

//
//  ChatModel.h
//  LPSChatTableView
//
//  Created by liupei on 15/5/21.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)getDataSource;

- (void)addFromMeWithDict:(NSDictionary *)dic;

@end

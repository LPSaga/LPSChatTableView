//
//  ViewController.m
//  LPSChatTableView
//
//  Created by liupei on 15/5/20.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "ViewController.h"
#import "LPSInputFunctionView.h"
#import "LPSMessageCell.h"
#import "LPSMessage.h"
#import "LPSMessageFrame.h"

#import "ChatModel.h"

@interface ViewController ()<LPSInputFunctionViewDelegate,UITableViewDataSource,UITableViewDelegate,LPSMessageCellDelegate>
{
    LPSInputFunctionView *InputFView;
}


@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) ChatModel *chatModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideenKeyboard)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.chatTableView addGestureRecognizer:tap];
    
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.dataSource = [NSMutableArray array];
    [self.chatModel getDataSource];
    
    InputFView = [[LPSInputFunctionView alloc]initWithSuperVC:self];
    InputFView.delegate = self;
    [self.view addSubview:InputFView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - touch
- (void)hideenKeyboard{
    [InputFView.textInput resignFirstResponder];
}

#pragma mark - keyboard
-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (notification.name == UIKeyboardWillShowNotification) {
        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
    }else{
        self.bottomConstraint.constant = 40;
    }
    
    [self.view layoutIfNeeded];
    
    CGRect newFrame = InputFView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    InputFView.frame = newFrame;
    
    [UIView commitAnimations];
    
}

- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - LPSInputFunctionViewDelegate
// text
- (void)LPSInputFunctionView:(LPSInputFunctionView *)funcView sendMessage:(NSString *)message{
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(LPSMessageTypeText)};
    funcView.textInput.text = @"";
    [self dealTheFunctionData:dic];

}

// image
- (void)LPSInputFunctionView:(LPSInputFunctionView *)funcView sendPicture:(UIImage *)image{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(LPSMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

// audio
- (void)LPSInputFunctionView:(LPSInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSTimeInterval)second{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(LPSMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self.chatModel addFromMeWithDict:dic];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark - tableView delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPSMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[LPSMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - Cell Delegate
- (void)headImageDidClick:(LPSMessageCell *)cell userId:(NSString *)userId{
    
}

@end

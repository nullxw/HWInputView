//
//  HWInputToolBar.m
//  iPhone
//
//  Created by 马洪伟 on 14-5-21.
//  Copyright (c) 2014年 Fn. All rights reserved.
//

#import "HWInputToolBar.h"

@interface HWInputToolBar()
{
    /**原始frame*/
    CGRect originalFrame;
    /**输入框*/
    HWTextView *textView;
    
    UIButton *pressToVoiceButton;
    
    /** 按钮的当前状态 0正常 1选中 */
    int emojiButtonState;
}
@end

@implementation HWInputToolBar

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 320, kInputToolBarHeight)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /// 输入框
        textView = [[HWTextView alloc]initWithFrame:CGRectMake(35, 5, 220, kInputToolBarHeight-10)];
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        textView.delegate = self;
        [self addSubview:textView];
        
        /// 语音输入按钮
        pressToVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pressToVoiceButton.backgroundColor = [UIColor lightGrayColor];
        pressToVoiceButton.hidden = YES;
        pressToVoiceButton.frame = textView.frame;
        pressToVoiceButton.layer.masksToBounds = YES;
        pressToVoiceButton.layer.cornerRadius = 15.0f;
        pressToVoiceButton.layer.borderColor = [UIColor whiteColor].CGColor;
        pressToVoiceButton.layer.borderWidth = 1.0f;
        [pressToVoiceButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [pressToVoiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [pressToVoiceButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
        pressToVoiceButton.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:14.0f];
        
        [pressToVoiceButton addTarget:self action:@selector(pressToVoiceButtonActionEnd:) forControlEvents:UIControlEventTouchUpInside];
        [pressToVoiceButton addTarget:self action:@selector(pressToVoiceButtonActionCancel:) forControlEvents:UIControlEventTouchDragExit];
        [pressToVoiceButton addTarget:self action:@selector(pressToVoiceButtonAction:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:pressToVoiceButton];
        
        /// 语音
        UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceButton.frame = CGRectMake(2, 5, 30, 30);
        voiceButton.tag = 101;
        [voiceButton addTarget:self action:@selector(voiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        voiceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [voiceButton setBackgroundImage:[UIImage imageNamed:@"inputToolBarVoice"] forState:UIControlStateNormal];
        [voiceButton setBackgroundImage:[UIImage imageNamed:@"inputToolBarVoice_HL"] forState:UIControlStateHighlighted];
        [self addSubview:voiceButton];
        
        /// 表情
        UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        emojiButton.frame = CGRectMake(255, 5, 30, 30);
        emojiButtonState = 0;
        [emojiButton addTarget:self action:@selector(emojiButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        emojiButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [emojiButton setBackgroundImage:[UIImage imageNamed:@"inputToolBarEmoji"] forState:UIControlStateNormal];
        [emojiButton setBackgroundImage:[UIImage imageNamed:@"inputToolBarEmoji_HL"] forState:UIControlStateHighlighted];
        [self addSubview:emojiButton];
        
        /// 更多附件
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame = CGRectMake(288, 5, 30, 30);
        [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        addButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [addButton setBackgroundImage:[UIImage imageNamed:@"inputToolBarAdd"] forState:UIControlStateNormal];
        [addButton setBackgroundImage:[UIImage imageNamed:@"inputToolBarAdd_HL"] forState:UIControlStateHighlighted];
        [self addSubview:addButton];
    }
    return self;
}

- (BOOL)becomeFirstResponder
{
    return [textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [textView resignFirstResponder];
}

#pragma mark - UIButton Action
- (void)voiceButtonAction:(UIButton *)button
{
    if (pressToVoiceButton.hidden) {
        [self endEditing:YES];
        pressToVoiceButton.hidden = NO;
        [button setBackgroundImage:[UIImage imageNamed:@"inputToolBarText"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"inputToolBarText_HL"] forState:UIControlStateHighlighted];
        if ([_delegate respondsToSelector:@selector(inputToolBarDidChangeHeight:)]) {
            [_delegate inputToolBarDidChangeHeight:kInputToolBarHeight];
        }
    }
    else{
        pressToVoiceButton.hidden = YES;
        [button setBackgroundImage:[UIImage imageNamed:@"inputToolBarVoice"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"inputToolBarVoice_HL"] forState:UIControlStateHighlighted];
        [textView autoresizingTextView];
    }
    
}
- (void)emojiButtonAction:(UIButton *)button
{
    if (pressToVoiceButton.hidden == NO) {
        [self voiceButtonAction:(UIButton *)[self viewWithTag:101]];
    }
    if ([_delegate respondsToSelector:@selector(emojiButtonClick)]) {
        [_delegate emojiButtonClick];
    }
}
- (void)addButtonAction:(UIButton *)button
{
    if (pressToVoiceButton.hidden == NO) {
        [self voiceButtonAction:(UIButton *)[self viewWithTag:101]];
    }
    if ([_delegate respondsToSelector:@selector(addButtonClick)]) {
        [_delegate addButtonClick];
    }
}
/*!
    按住录音,开始录音
 */
- (void)pressToVoiceButtonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(recordBegin)]) {
        [_delegate recordBegin];
    }
}
/*!
    录音结束,准备发送
 */
- (void)pressToVoiceButtonActionEnd:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(recordEnd)]) {
        [_delegate recordEnd];
    }
}
/*!
    录音取消,取消发送
 */
- (void)pressToVoiceButtonActionCancel:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(recordCancel)]) {
        [_delegate recordCancel];
    }
}

#pragma mark - HWTextView
- (void)textViewDidChangeHeight:(float)height
{
    if ([_delegate respondsToSelector:@selector(inputToolBarDidChangeHeight:)]) {
        [_delegate inputToolBarDidChangeHeight:height];
    }
}

- (void)sendText:(NSString *)text
{
    if ([_delegate respondsToSelector:@selector(sendText:)]) {
        [_delegate sendText:text];
    }
}


@end

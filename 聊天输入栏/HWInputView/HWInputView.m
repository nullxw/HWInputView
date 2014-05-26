//
//  HWInputView.m
//  iPhone
//
//  Created by 马洪伟 on 14-5-16.
//  Copyright (c) 2014年 Fn. All rights reserved.
//

#import "HWInputView.h"

@interface HWInputView()
{
    HWInputToolBar *inputToolBar;
    HWEmojiBoardView *emojiBoardView;
    
    /// 原始 frame
    CGRect originalFrame;
    /// 可变 frame
    CGRect theFrame;
    /// 键盘高度
    float keyBoardHeight;
    
    /// 是否需要通知高度的改变
    float currentHeight;
}
/// 视图是否显示
@property (assign, nonatomic)BOOL keyBoardIsShow;
@property (assign, nonatomic)BOOL emojiBoardIsShow;
@property (assign, nonatomic)BOOL addBoardIsShow;
@end

@implementation HWInputView

- (id)initWithFrame:(CGRect)frame
{
    theFrame = originalFrame = frame;
    currentHeight = theFrame.size.height;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        inputToolBar = [[HWInputToolBar alloc]init];
        inputToolBar.delegate = self;
        inputToolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:inputToolBar];
        
        emojiBoardView = [[HWEmojiBoardView alloc]initWithFrame:CGRectMake(0, inputToolBar.frame.size.height, 320, kEmojiBoardViewHeight)];
        emojiBoardView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        emojiBoardView.hidden = YES;
        emojiBoardView.backgroundColor = [UIColor redColor];
        [self addSubview:emojiBoardView];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyBoardWillShow:(NSNotification *)notification
{
    _keyBoardIsShow = YES;
    keyBoardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y-keyBoardHeight-theFrame.size.height+originalFrame.size.height, originalFrame.size.width, theFrame.size.height);
        theFrame = self.frame;
        [self didChangeHeight];
    }];
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    _keyBoardIsShow = NO;
    keyBoardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(theFrame.origin.x, theFrame.origin.y+keyBoardHeight, theFrame.size.width, theFrame.size.height);
        theFrame = self.frame;
        keyBoardHeight = 0;
        [self didChangeHeight];
    }];
}

#pragma mark - 通知代理改变高度(frame)
/*!
 *  通知代理改变高度(frame)
 */
- (void)didChangeHeight
{
    float height = theFrame.size.height;
    
    if (_keyBoardIsShow) {
        height += keyBoardHeight;
    }
    if (_emojiBoardIsShow) {
        height += kEmojiBoardViewHeight;
    }
    
    if (currentHeight == height) {
        return;
    }
    currentHeight = height;
    if ([_delegate respondsToSelector:@selector(inputViewDidChangeHeight:)]) {
        [_delegate inputViewDidChangeHeight:height];
    }
}

#pragma mark - HWInputToolBar
- (void)inputToolBarDidChangeHeight:(float)height
{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y-keyBoardHeight-(height-kInputToolBarHeight), originalFrame.size.width, height);
        theFrame = self.frame;
        [self didChangeHeight];
    }];
}

- (void)sendText:(NSString *)text
{
    if ([_delegate respondsToSelector:@selector(sendText:)]) {
        [_delegate sendText:text];
    }
}
/*!
    隐藏或显示表情面板
 */
- (void)emojiButtonClick
{
    if (_emojiBoardIsShow) {
        self.emojiBoardIsShow = NO;
        [inputToolBar becomeFirstResponder];
    }
    else{
        [inputToolBar resignFirstResponder];
        self.emojiBoardIsShow = YES;
    }
    [self didChangeHeight];
}
/*!
    隐藏或显示附件面板
 */
- (void)addButtonClick
{
    
}

#pragma mark - 设置各个面板的显示与隐藏
- (void)setEmojiBoardIsShow:(BOOL)emojiBoardIsShow
{
    _emojiBoardIsShow = emojiBoardIsShow;
    [UIView animateWithDuration:0.25 animations:^{
        if (emojiBoardIsShow) {
            emojiBoardView.hidden = NO;
            self.transform = CGAffineTransformMakeTranslation(0, -kEmojiBoardViewHeight);
        }
        else{
            emojiBoardView.hidden = YES;
            self.transform = CGAffineTransformIdentity;
        }
        theFrame = self.frame;
        [self didChangeHeight];
    }];
}

#pragma mark - 录音
/*!
    录音开始
 */
- (void)recordBegin
{
    NSLog(@"recordBegin");
}
/*!
    录音结束
 */
- (void)recordEnd
{
    NSLog(@"recordEnd");
}
/*!
    录音取消
 */
- (void)recordCancel
{
    NSLog(@"recordCancel");
}

@end

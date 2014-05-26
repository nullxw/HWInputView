//
//  HWTextView.m
//  iPhone
//
//  Created by 马洪伟 on 14-5-19.
//  Copyright (c) 2014年 Fn. All rights reserved.
//

#import "HWTextView.h"
#import <CoreText/CoreText.h>

@interface HWTextView()
{
    float currentHeight;
    int _maxNumberOfLines;
    UITextView *_textView;
}
@end

@implementation HWTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 0.5f;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height/2;
        currentHeight = frame.size.height-10;
        _maxNumberOfLines = 3;
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(7, 3, frame.size.width-14, frame.size.height-10)];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.returnKeyType = UIReturnKeySend;
        [self addSubview:_textView];
    }
    return self;
}

- (BOOL)becomeFirstResponder
{
    return [_textView becomeFirstResponder];
}
- (BOOL)resignFirstResponder
{
    return [_textView resignFirstResponder];
}

#pragma mark - UITextView
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self send];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self autoresizingTextView];
}

#pragma mark - 发送触发
- (void)send
{
    if ([_delegate respondsToSelector:@selector(sendText:)]) {
        [_delegate sendText:_textView.text];
        _textView.text = @"";
        [self autoresizingTextView];
    }
}

#pragma mark - 自动适应输入框的高度
/*!
    自动适应输入框的高度
 */
- (void)autoresizingTextView
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.maximumLineHeight = 20.0f;
    paragraphStyle.minimumLineHeight = 20.0f;
    paragraphStyle.lineHeightMultiple = 20.0f;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSString *string = _textView.text;
//    if (string == nil || [string isEqualToString:@""]) {
//        return;
//    }
    NSDictionary *ats = @{
                          NSFontAttributeName : [UIFont fontWithName:@"Courier" size:13.0f],
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:string attributes:ats];
    
#pragma mark 初始化 framesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedText);
    
#pragma mark 文本实际的宽高
    CFRange range;
	CGSize constraint = CGSizeMake(_textView.frame.size.width-10, 1000);
    CGSize optimumSize;
	optimumSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, constraint, &range);
    
    CFRelease(framesetter);

    currentHeight = optimumSize.height;
    if (currentHeight == 0) {
        currentHeight = 20;
    }
    if (currentHeight > _maxNumberOfLines*20) {
        currentHeight = _maxNumberOfLines*20;
    }
    if ([self.delegate respondsToSelector:@selector(textViewDidChangeHeight:)]) {
        [self.delegate textViewDidChangeHeight:currentHeight+20];
    }
    _textView.attributedText = attributedText;
}

@end

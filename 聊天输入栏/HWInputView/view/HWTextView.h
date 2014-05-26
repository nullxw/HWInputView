//
//  HWTextView.h
//  iPhone
//
//  Created by 马洪伟 on 14-5-19.
//  Copyright (c) 2014年 Fn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWTextViewDelegate <UITextViewDelegate>
@required
- (void)textViewDidChangeHeight:(float)height;
- (void)sendText:(NSString *)text;
@end

/*!
    输入框
 */
@interface HWTextView : UIView<UITextViewDelegate>
@property (assign, nonatomic) id<HWTextViewDelegate> delegate;

/*!
    自动适应输入框的高度
 */
- (void)autoresizingTextView;
@end

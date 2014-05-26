//
//  HWInputToolBar.h
//  iPhone
//
//  Created by 马洪伟 on 14-5-21.
//  Copyright (c) 2014年 Fn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWTextView.h"

#define kInputToolBarHeight 40

@protocol HWInputToolBarDelegate <NSObject>
@required
- (void)inputToolBarDidChangeHeight:(float)height;
- (void)sendText:(NSString *)text;

/*!
    隐藏或显示表情面板
 */
- (void)emojiButtonClick;
/*!
    隐藏或显示附件面板
 */
- (void)addButtonClick;
/*!
    录音开始
 */
- (void)recordBegin;
/*!
    录音结束
 */
- (void)recordEnd;
/*!
    录音取消
 */
- (void)recordCancel;
@end
/*!
    输入栏
 */
@interface HWInputToolBar : UIView<HWTextViewDelegate>
@property (assign, nonatomic) id<HWInputToolBarDelegate> delegate;
@end

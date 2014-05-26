//
//  HWInputView.h
//  iPhone
//
//  Created by 马洪伟 on 14-5-16.
//  Copyright (c) 2014年 Fn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWInputToolBar.h"
#import "HWEmojiBoardView.h"

@protocol HWInputViewDelegate <NSObject>
@required
/*!
 *  HWInpuView可见区域的高度
 *  根据返回的高度值可判断inputView在当前viewController中的原点位置
 *  因为此高度是相对于屏幕(viewController)底部而言的
 */
- (void)inputViewDidChangeHeight:(float)height;
- (void)sendText:(NSString *)text;
@end

/*!
    输入面板
 */
@interface HWInputView : UIView<HWInputToolBarDelegate>
@property (assign, nonatomic) id<HWInputViewDelegate> delegate;
@end

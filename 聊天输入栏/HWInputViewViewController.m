//
//  HWInputViewViewController.m
//  iPhone
//
//  Created by 马洪伟 on 14-5-19.
//  Copyright (c) 2014年 Fn. All rights reserved.
//

#import "HWInputViewViewController.h"

@interface HWInputViewViewController ()
{
    HWInputView *inputView;
}
@end

@implementation HWInputViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    inputView = [[HWInputView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-kInputToolBarHeight, 320, kInputToolBarHeight)];
    inputView.delegate = self;
    [self.view addSubview:inputView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)inputViewDidChangeHeight:(float)height
{
    NSLog(@"inputViewDidChangeHeight:%0.2f",height);
}
- (void)sendText:(NSString *)text
{
    NSLog(@"sendText:%@",text);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end

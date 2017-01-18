//
//  TransferSpeedImageScrollView.m
//  pptshell
//
//  Created by richsjeson on 17/1/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TransferSpeedImageScrollView.h"

@interface  TransferSpeedImageScrollView(){
    
    NSInteger ScreenWidth;
    NSInteger ScreenHeight;
    NSInteger dictCount;
    NSInteger lastScreenWidth;
    NSInteger lastScreenHeight;
}
@end

@implementation TransferSpeedImageScrollView


- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger) count{
    if(self ==[super  initWithFrame:frame]){
        //注册广播监听
        ScreenWidth=[[UIScreen mainScreen] bounds].size.width;
        ScreenHeight=[[UIScreen mainScreen] bounds].size.height;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        dictCount=count;
    }
    return self;
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    ScreenWidth=[[UIScreen mainScreen] bounds].size.width;
    ScreenHeight=[[UIScreen mainScreen] bounds].size.height;
    //横屏操作
    self.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.contentSize=CGSizeMake(ScreenWidth*dictCount, ScreenHeight);
    if(_scrollDelegate != nil){
        [_scrollDelegate setImageOrientation:self.frame];
    }
    
}




-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
